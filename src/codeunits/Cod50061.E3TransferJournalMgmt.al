
codeunit 50061 "E3 Transfer Journal Mgmt."
{
    Permissions =
        tabledata "E3 Transfer Header" = rm,
        tabledata "E3 Transfer Line" = r,
        tabledata "Item Journal Line" = rim,
        tabledata "Item Ledger Entry" = r,
        tabledata "Reservation Entry" = rim;

    trigger OnRun()
    begin
        ProcessPendingTransferJournals();
    end;

    procedure CreateItemReclassificationJournal(DocumentNo: Code[20])
    var
        TransferHeader: Record "E3 Transfer Header";
        TransferLine: Record "E3 Transfer Line";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        Item: Record Item;
        LineNo: Integer;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        if DocumentNo = '' then
            Error('Document No. must not be blank.');

        // Find the transfer header by Document Number.
        TransferHeader.Reset();
        TransferHeader.SetRange("Document Number", DocumentNo);

        if not TransferHeader.FindFirst() then
            Error('Transfer Header with Document No. %1 does not exist.', DocumentNo);

        if TransferHeader."Is Created" then
            Error(
                'Item Reclassification Journal has already been created for Document No. %1.',
                DocumentNo);

        // Get journal template and batch from setup where Type = Reclass.
        GetReclassJournalSetup(HISIntegrationSetupLine, JournalTemplateName, JournalBatchName);

        if not ItemJournalTemplate.Get(JournalTemplateName) then
            Error('Item Journal Template %1 does not exist.', JournalTemplateName);

        if not ItemJournalBatch.Get(JournalTemplateName, JournalBatchName)
        then
            Error(
                'Item Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        // Get lines linked to the selected transfer header.
        TransferLine.Reset();
        //TransferLine.SetRange("Entry Type", TransferHeader."Entry Type");
        TransferLine.SetRange("Document Number", TransferHeader."Document Number");

        if not TransferLine.FindSet() then
            Error(
                'No transfer lines exist for Document No. %1.',
                DocumentNo);
        // Validate all existing lot quantities before creating journal lines
        ValidateTransferLotAvailability(DocumentNo);

        // Find the next line number in the configured batch.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);

        if ItemJournalLine.FindLast() then
            LineNo := ItemJournalLine."Line No." + 10000
        else
            LineNo := 10000;

        TransferLine.Reset();
        TransferLine.SetRange("Document Number", DocumentNo);

        if not TransferLine.FindSet() then
            Error('No transfer lines exist for Document No. %1.', DocumentNo);

        repeat
            if TransferLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero for Document No. %1, Line No. %2.',
                    DocumentNo,
                    TransferLine."Line Number");

            if TransferLine."D365 Item Code" = '' then
                Error(
                    'Item Code must not be blank for Document No. %1, Line No. %2.',
                    DocumentNo,
                    TransferLine."Line Number");

            if not Item.Get(TransferLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist in Business Central.',
                    TransferLine."D365 Item Code");

            if TransferLine."D365 From Department Code" = '' then
                Error(
                    'From Department Code must not be blank for Document No. %1, Line No. %2.',
                    DocumentNo,
                    TransferLine."Line Number");

            if TransferLine."D365 To Department Code" = '' then
                Error(
                    'To Department Code must not be blank for Document No. %1, Line No. %2.',
                    DocumentNo,
                    TransferLine."Line Number");

            // Check existing lot availability for tracked items.
            if Item."Item Tracking Code" <> '' then begin
                if TransferLine."Batch No." = '' then
                    Error(
                        'An existing Batch No. is required for item %1, Document No. %2, Line No. %3.',
                        Item."No.", DocumentNo, TransferLine."Line Number");

                CheckExistingLotAvailability(Item."No.", TransferLine."D365 From Department Code",
                    TransferLine."Batch No.",
                    TransferLine.Quantity);
            end;

            // Create Item Reclassification Journal line.
            ItemJournalLine.Init();
            ItemJournalLine."Journal Template Name" := JournalTemplateName;
            ItemJournalLine."Journal Batch Name" := JournalBatchName;
            ItemJournalLine."Line No." := LineNo;
            ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
            ItemJournalLine.Validate("Item No.", TransferLine."D365 Item Code");
            ItemJournalLine.Validate("Posting Date", TransferHeader."v_Date");
            ItemJournalLine.Validate("Document No.", DocumentNo);
            ItemJournalLine.Validate(Quantity, TransferLine.Quantity);
            ItemJournalLine.Validate("Location Code", TransferLine."D365 From Department Code");
            ItemJournalLine.Validate("New Location Code", TransferLine."D365 To Department Code");
            ItemjournalLine."Bin Code" := TransferLine."D365 From Department Code";
            ItemJournalLine.Validate("Shortcut Dimension 1 Code", TransferLine."Business Unit");
            ItemJournalLine.Validate("New Shortcut Dimension 1 Code", TransferLine."Business Unit");

            if TransferLine."D365 Unit Code" <> '' then
                ItemJournalLine.Validate("Unit of Measure Code", TransferLine."D365 Unit Code");

            // Retain the existing lot. Do not assign New Lot No.
            if Item."Item Tracking Code" <> '' then
                ItemJournalLine.Validate("Lot No.", TransferLine."Batch No.");

            if ItemJournalLine."Item No." = '' then
                Error(
                    'Item No. is blank before inserting journal line. Document No.: %1, Transfer Line No.: %2, Item Code: %3.',
                    DocumentNo,
                    TransferLine."Line Number",
                    TransferLine."D365 Item Code");

            ItemJournalLine.Insert(true);

            // Create tracking entries for the existing lot.
            if Item."Item Tracking Code" <> '' then
                CreateExistingLotTracking(ItemJournalLine, TransferLine."Batch No.");


            LineNo += 10000;
        until TransferLine.Next() = 0;

        // TransferHeader."Is Created" := true;
        // TransferHeader.Modify();

        // Message(
        //     'Item Reclassification Journal created for Document No. %1 using template %2 and batch %3. The journal has not been posted.',
        //     DocumentNo,
        //     JournalTemplateName,
        //     JournalBatchName);
    end;

    local procedure GetReclassJournalSetup(
        var HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        var JournalTemplateName: Code[10];
        var JournalBatchName: Code[10])
    begin
        HISIntegrationSetupLine.Reset();
        HISIntegrationSetupLine.SetRange(
            Type,
            HISIntegrationSetupLine.Type::Reclass);

        if not HISIntegrationSetupLine.FindFirst() then
            Error(
                'No HIS Integration Setup Line found with Type = Reclass.');

        if HISIntegrationSetupLine."General Journal Template Code" = '' then
            Error(
                'General Journal Template Code is blank for Type = Reclass.');

        if HISIntegrationSetupLine."General Journal Batch Code" = '' then
            Error(
                'General Journal Batch Code is blank for Type = Reclass.');

        JournalTemplateName :=
            CopyStr(
                HISIntegrationSetupLine."General Journal Template Code",
                1,
                MaxStrLen(JournalTemplateName));

        JournalBatchName :=
            CopyStr(
                HISIntegrationSetupLine."General Journal Batch Code",
                1,
                MaxStrLen(JournalBatchName));
    end;

    local procedure CheckExistingLotAvailability(
        ItemNo: Code[20];
        LocationCode: Code[10];
        LotNo: Code[50];
        RequiredQty: Decimal)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        AvailableQty: Decimal;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Location Code", LocationCode);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');

        if ItemLedgerEntry.FindSet() then
            repeat
                AvailableQty += ItemLedgerEntry."Remaining Quantity";
            until ItemLedgerEntry.Next() = 0;

        if AvailableQty < RequiredQty then
            Error(
                'Insufficient existing lot quantity for item %1, lot %2, source location %3. Available: %4; required: %5.',
                ItemNo,
                LotNo,
                LocationCode,
                AvailableQty,
                RequiredQty);
    end;

    local procedure CreateExistingLotTracking(
        var ItemJournalLine: Record "Item Journal Line";
        LotNo: Code[50])
    var
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        QtyToHandle: Decimal;
        QtyToHandleBase: Decimal;
    begin
        // Validate Item Journal Line
        if ItemJournalLine."Item No." = '' then
            Error(
                'Item No. is required in Item Journal Line. Template: %1, Batch: %2, Line No.: %3.',
                ItemJournalLine."Journal Template Name",
                ItemJournalLine."Journal Batch Name",
                ItemJournalLine."Line No.");

        if ItemJournalLine."Line No." = 0 then
            Error(
                'Line No. cannot be zero in Item Journal Line. Template: %1, Batch: %2.',
                ItemJournalLine."Journal Template Name",
                ItemJournalLine."Journal Batch Name");

        if ItemJournalLine."Journal Template Name" = '' then
            Error('Journal Template Name cannot be blank.');

        if ItemJournalLine."Journal Batch Name" = '' then
            Error('Journal Batch Name cannot be blank.');

        if LotNo = '' then
            Error(
                'Lot No. is required for item %1.',
                ItemJournalLine."Item No.");

        if ItemJournalLine.Quantity = 0 then
            Error(
                'Quantity cannot be zero for item %1.',
                ItemJournalLine."Item No.");

        // Calculate Quantity
        QtyToHandle := Abs(ItemJournalLine.Quantity);
        QtyToHandleBase := Abs(ItemJournalLine."Quantity (Base)");

        if QtyToHandleBase = 0 then
            QtyToHandleBase :=
                Round(
                    QtyToHandle *
                    ItemJournalLine."Qty. per Unit of Measure",
                    0.00001);

        // Delete existing tracking entries for this journal line
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Item Journal Line");
        ReservationEntry.SetRange("Source Subtype", ItemJournalLine."Entry Type".AsInteger());
        ReservationEntry.SetRange("Source ID", ItemJournalLine."Journal Template Name");
        ReservationEntry.SetRange("Source Batch Name", ItemJournalLine."Journal Batch Name");
        ReservationEntry.SetRange("Source Ref. No.", ItemJournalLine."Line No.");

        if not ReservationEntry.IsEmpty() then
            ReservationEntry.DeleteAll(true);

        // Prepare existing Lot No.
        Clear(ReservationEntry);
        ReservationEntry.Init();
        ReservationEntry."Lot No." := LotNo;

        // Prepare New Lot No.
        Clear(TrackingSpecification);
        TrackingSpecification.Init();
        TrackingSpecification."New Lot No." := LotNo;

        CreateReservEntry.SetDates(0D, 0D);

        // Create source tracking entry
        CreateReservEntry.CreateReservEntryFor(
            Database::"Item Journal Line",
            ItemJournalLine."Entry Type".AsInteger(),
            ItemJournalLine."Journal Template Name",
            ItemJournalLine."Journal Batch Name",
            0,
            ItemJournalLine."Line No.",
            ItemJournalLine."Qty. per Unit of Measure",
            QtyToHandle,
            QtyToHandleBase,
            ReservationEntry);

        // Assign New Lot No.
        CreateReservEntry.SetNewTrackingFromNewTrackingSpecification(
            TrackingSpecification);

        // Create Reservation Entry
        CreateReservEntry.CreateEntry(
            ItemJournalLine."Item No.",
            ItemJournalLine."Variant Code",
            ItemJournalLine."Location Code",
            ItemJournalLine.Description,
            ItemJournalLine."Posting Date",
            ItemJournalLine."Document Date",
            0,
            ReservationEntry."Reservation Status"::Prospect);
    end;


    procedure ProcessTransferDocument(
    DocumentNo: Code[20];
    AutoTransferJournal: Boolean)
    var
        TransferHeader: Record "E3 Transfer Header";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        TransferHeader.Reset();
        TransferHeader.SetRange("Document Number", DocumentNo);

        if not TransferHeader.FindFirst() then
            Error('Transfer Document %1 does not exist.', DocumentNo);

        // Is Created now means creation AND posting completed successfully.
        if TransferHeader."Is Created" then
            exit;

        GetReclassJournalSetup(
            HISIntegrationSetupLine,
            JournalTemplateName,
            JournalBatchName);

        if not ItemJournalTemplate.Get(JournalTemplateName) then
            Error('Journal Template %1 does not exist.', JournalTemplateName);

        if not ItemJournalBatch.Get(JournalTemplateName, JournalBatchName) then
            Error(
                'Journal Batch %1 does not exist for Template %2.',
                JournalBatchName,
                JournalTemplateName);

        // Check whether journal lines already exist for this document.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.SetRange("Document No.", DocumentNo);

        // Create journal lines only if they do not already exist.
        if ItemJournalLine.IsEmpty() then
            CreateItemReclassificationJournal(DocumentNo);

        // If auto posting is disabled, leave Is Created = FALSE.
        // Existing journal lines will be reused when auto posting is enabled.
        if not AutoTransferJournal then
            exit;

        // Get the current document's journal lines.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.SetRange("Document No.", DocumentNo);

        if not ItemJournalLine.FindFirst() then
            Error(
                'No Item Journal Lines found for Document No. %1.',
                DocumentNo);

        // Post the journal.
        Codeunit.Run(
            Codeunit::"Item Jnl.-Post Batch",
            ItemJournalLine);

        // Mark completed ONLY after successful posting.
        TransferHeader."Is Created" := true;
        TransferHeader."Error Description" := '';
        TransferHeader.Modify(true);
    end;

    local procedure ProcessPendingTransferJournals()
    var
        TransferHeader: Record "E3 Transfer Header";
        IntegrationSetup: Record "E3 HIS Integartion Setup";
    begin
        if not IntegrationSetup.Get() then
            exit;

        TransferHeader.Reset();
        TransferHeader.SetRange("Is Created", false);

        if TransferHeader.FindSet() then
            repeat
                ProcessTransferHeaderWithErrorHandling(
                    TransferHeader,
                    IntegrationSetup."Auto Transfer Journal Enabled");
            until TransferHeader.Next() = 0;
    end;

    local procedure ProcessTransferHeaderWithErrorHandling(
    var TransferHeader: Record "E3 Transfer Header";
    AutoTransferJournal: Boolean)
    var
        ErrorDescription: Text;
        DocumentNo: Code[20];
    begin
        DocumentNo := TransferHeader."Document Number";

        ClearLastError();

        if TryProcessTransferDocument(
            DocumentNo,
            AutoTransferJournal)
        then begin
            UpdateTransferError(DocumentNo, '');
        end else begin
            ErrorDescription := GetLastErrorText();

            // Remove incomplete journal lines after an error.
            CleanupTransferJournalLines(DocumentNo);

            // Keep Is Created = FALSE and save the error.
            UpdateTransferError(
                DocumentNo,
                ErrorDescription);
        end;
    end;

    [TryFunction]
    local procedure TryProcessTransferDocument(
    DocumentNo: Code[20];
    AutoTransferJournal: Boolean)
    begin
        ProcessTransferDocument(
            DocumentNo,
            AutoTransferJournal);
    end;

    local procedure UpdateTransferError(
    DocumentNo: Code[20];
    ErrorText: Text)
    var
        TransferHeader: Record "E3 Transfer Header";
    begin
        TransferHeader.Reset();
        TransferHeader.SetRange(
            "Document Number",
            DocumentNo);

        if TransferHeader.FindFirst() then begin
            TransferHeader."Error Description" :=
                CopyStr(
                    ErrorText,
                    1,
                    MaxStrLen(TransferHeader."Error Description"));

            TransferHeader.Modify(true);
        end;
    end;

    local procedure ValidateTransferLotAvailability(DocumentNo: Code[20])
    var
        TransferLine: Record "E3 Transfer Line";
        Item: Record Item;
    begin
        TransferLine.Reset();
        TransferLine.SetRange("Document Number", DocumentNo);

        if TransferLine.FindSet() then
            repeat
                if not Item.Get(TransferLine."D365 Item Code") then
                    Error(
                        'Item %1 does not exist in Business Central.',
                        TransferLine."D365 Item Code");

                // Case 1: Item Tracking Code is blank.
                if Item."Item Tracking Code" = '' then begin
                    if TransferLine."Batch No." <> '' then
                        Error(
                            'Batch No. %1 must be blank because Item Tracking Code is not configured for item %2, Document No. %3, Line No. %4.',
                            TransferLine."Batch No.",
                            Item."No.",
                            DocumentNo,
                            TransferLine."Line Number");
                end else begin
                    // Case 2: Item Tracking Code is enabled.
                    if TransferLine."Batch No." = '' then
                        Error(
                            'Batch No. is required for tracked item %1, Document No. %2, Line No. %3.',
                            Item."No.",
                            DocumentNo,
                            TransferLine."Line Number");

                    // Check existing lot quantity.
                    CheckExistingLotAvailability(
                        Item."No.",
                        TransferLine."D365 From Department Code",
                        TransferLine."Batch No.",
                        TransferLine.Quantity);
                end;
            until TransferLine.Next() = 0;
    end;

    local procedure CleanupTransferJournalLines(DocumentNo: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        ReservationEntry: Record "Reservation Entry";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        GetReclassJournalSetup(
            HISIntegrationSetupLine,
            JournalTemplateName,
            JournalBatchName);

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.SetRange("Document No.", DocumentNo);

        if ItemJournalLine.FindSet() then
            repeat
                // Delete tracking entries belonging to this journal line.
                ReservationEntry.Reset();
                ReservationEntry.SetRange(
                    "Source Type",
                    Database::"Item Journal Line");
                ReservationEntry.SetRange(
                    "Source ID",
                    ItemJournalLine."Journal Template Name");
                ReservationEntry.SetRange(
                    "Source Batch Name",
                    ItemJournalLine."Journal Batch Name");
                ReservationEntry.SetRange(
                    "Source Ref. No.",
                    ItemJournalLine."Line No.");

                if not ReservationEntry.IsEmpty() then
                    ReservationEntry.DeleteAll(true);

                ItemJournalLine.Delete(true);
            until ItemJournalLine.Next() = 0;
    end;
}
