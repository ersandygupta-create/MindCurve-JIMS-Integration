
codeunit 50061 "E3 Transfer Journal Mgmt."
{
    Permissions =
        tabledata "E3 Transfer Header" = rm,
        tabledata "E3 Transfer Line" = r,
        tabledata "Item Journal Line" = rimd,
        tabledata "Item Ledger Entry" = r,
        tabledata "Reservation Entry" = rim;

    trigger OnRun()
    begin
        ProcessPendingTransferJournals();
    end;

    [CommitBehavior(CommitBehavior::Error)]
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
        TransferLineCount: Integer;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        if DocumentNo = '' then
            Error('Document No. must not be blank.');

        TransferHeader.LockTable();
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

        ItemJournalBatch.LockTable();
        if not ItemJournalBatch.Get(JournalTemplateName, JournalBatchName)
        then
            Error(
                'Item Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        TransferLineCount := ValidateTransferDocument(TransferHeader);

        ItemJournalLine.LockTable();
        SetTransferJournalFilters(ItemJournalLine, JournalTemplateName, JournalBatchName, DocumentNo);
        if ItemJournalLine.Count() = TransferLineCount then
            exit;

        // Run the journal line delete trigger to remove its item tracking.
        ItemJournalLine.DeleteAll(true);
        ItemJournalLine.SetRange("Document No.");
        ItemJournalLine.SetRange("Entry Type");

        if ItemJournalLine.FindLast() then
            LineNo := ItemJournalLine."Line No." + 10000
        else
            LineNo := 10000;

        TransferLine.Reset();
        TransferLine.SetRange("Document Number", DocumentNo);

        if not TransferLine.FindSet() then
            Error('No transfer lines exist for Document No. %1.', DocumentNo);

        repeat
            Item.Get(TransferLine."D365 Item Code");

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
            ItemJournalLine.Validate("Shortcut Dimension 1 Code", TransferLine."Business Unit");
            ItemJournalLine.Validate("New Shortcut Dimension 1 Code", TransferLine."Business Unit");

            if TransferLine."D365 Unit Code" <> '' then
                ItemJournalLine.Validate("Unit of Measure Code", TransferLine."D365 Unit Code");

            //ItemJournalLine.Validate("Bin Code", TransferLine."D365 From Department Code");

            if Item."Item Tracking Code" <> '' then begin
                if TransferLine."Batch No." = '' then
                    Error('Enter the source lot in Batch No. for transfer %1, line %2, item %3, location %4.',
                        DocumentNo, TransferLine."Line Number", ItemJournalLine."Item No.", ItemJournalLine."Location Code");
                ItemJournalLine.Validate("Lot No.", TransferLine."Batch No.");
                CheckExistingLotAvailability(ItemJournalLine, TransferLine."Batch No.");
            end;


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

    local procedure CheckExistingLotAvailability(JournalLine: Record "Item Journal Line"; LotNo: Code[50])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        BatchLine: Record "Item Journal Line";
        ReservationEntry: Record "Reservation Entry";
        AvailableQty: Decimal;
    begin
        ItemLedgerEntry.SetRange("Item No.", JournalLine."Item No.");
        ItemLedgerEntry.SetRange("Variant Code", JournalLine."Variant Code");
        ItemLedgerEntry.SetRange("Location Code", JournalLine."Location Code");
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
        ItemLedgerEntry.CalcSums("Remaining Quantity");
        AvailableQty := ItemLedgerEntry."Remaining Quantity";

        BatchLine.SetRange("Journal Template Name", JournalLine."Journal Template Name");
        BatchLine.SetRange("Journal Batch Name", JournalLine."Journal Batch Name");
        BatchLine.SetRange("Entry Type", BatchLine."Entry Type"::Transfer);
        BatchLine.SetRange("Item No.", JournalLine."Item No.");
        BatchLine.SetRange("Variant Code", JournalLine."Variant Code");
        BatchLine.SetRange("Location Code", JournalLine."Location Code");
        BatchLine.SetFilter("Quantity (Base)", '>0');

        ReservationEntry.SetRange("Source Type", Database::"Item Journal Line");
        ReservationEntry.SetRange("Source Subtype", BatchLine."Entry Type"::Transfer.AsInteger());
        ReservationEntry.SetRange("Source ID", JournalLine."Journal Template Name");
        ReservationEntry.SetRange("Source Batch Name", JournalLine."Journal Batch Name");
        ReservationEntry.SetRange(Positive, false);

        if BatchLine.FindSet() then
            repeat
                ReservationEntry.SetRange("Source Ref. No.", BatchLine."Line No.");
                ReservationEntry.SetFilter("Lot No.", '<>%1', '');
                if ReservationEntry.IsEmpty() then begin
                    if BatchLine."Lot No." = LotNo then
                        AvailableQty -= BatchLine."Quantity (Base)";
                end else begin
                    ReservationEntry.SetRange("Lot No.", LotNo);
                    ReservationEntry.CalcSums("Quantity (Base)");
                    AvailableQty -= Abs(ReservationEntry."Quantity (Base)");
                end;
            until BatchLine.Next() = 0;

        if AvailableQty < JournalLine."Quantity (Base)" then
            Error(
                'Insufficient existing lot quantity for item %1, lot %2, source location %3. Available (base): %4; required (base): %5.',
                JournalLine."Item No.", LotNo, JournalLine."Location Code",
                AvailableQty, JournalLine."Quantity (Base)");
    end;

    local procedure SetTransferJournalFilters(var ItemJournalLine: Record "Item Journal Line"; JournalTemplateName: Code[10]; JournalBatchName: Code[10]; DocumentNo: Code[20])
    begin
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.SetRange("Document No.", DocumentNo);
        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::Transfer);
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



    [CommitBehavior(CommitBehavior::Error)]
    procedure ProcessTransferDocument(
        DocumentNo: Code[20];
        AutoTransferJournal: Boolean)
    var
        TransferHeader: Record "E3 Transfer Header";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        TransferLineCount: Integer;
    begin
        TransferHeader.LockTable();
        TransferHeader.SetRange("Document Number", DocumentNo);

        if not TransferHeader.FindFirst() then
            Error('Transfer Document %1 does not exist.', DocumentNo);

        // Do not create or post an already completed document.
        if TransferHeader."Is Created" then
            exit;

        GetReclassJournalSetup(
            HISIntegrationSetupLine,
            JournalTemplateName,
            JournalBatchName);

        if not ItemJournalTemplate.Get(JournalTemplateName) then
            Error('Journal Template %1 does not exist.', JournalTemplateName);

        ItemJournalBatch.LockTable();
        if not ItemJournalBatch.Get(JournalTemplateName, JournalBatchName) then
            Error(
                'Journal Batch %1 does not exist for Template %2.',
                JournalBatchName,
                JournalTemplateName);

        if TransferHeader."Error Description" <> '' then begin
            TransferHeader."Error Description" := '';
            TransferHeader.Modify(true);
        end;

        // Validate complete document before journal creation.
        TransferLineCount := ValidateTransferDocument(TransferHeader);

        ItemJournalLine.LockTable();
        SetTransferJournalFilters(ItemJournalLine, JournalTemplateName, JournalBatchName, DocumentNo);
        if ItemJournalLine.Count() <> TransferLineCount then begin
            CreateItemReclassificationJournal(DocumentNo);
            SetTransferJournalFilters(ItemJournalLine, JournalTemplateName, JournalBatchName, DocumentNo);
        end;

        if ItemJournalLine.Count() <> TransferLineCount then
            Error('Journal line count for Transfer Document %1 does not match the transfer line count.', DocumentNo);

        if AutoTransferJournal then begin
            ItemJournalLine.FindFirst();
            ItemJnlPostBatch.SetSuppressCommit(true);
            ItemJnlPostBatch.Run(ItemJournalLine);
            TransferHeader."Is Created" := true;
            TransferHeader.Modify(true);
        end;
    end;


    local procedure ProcessPendingTransferJournals()
    var
        TransferHeader: Record "E3 Transfer Header";
        IntegrationSetup: Record "E3 HIS Integartion Setup";
    begin
        if not IntegrationSetup.Get() then
            exit;

        TransferHeader.Reset();
        // Process pending transfers by voucher date, oldest date first.
        TransferHeader.SetCurrentKey("Is Created", "v_Date");
        TransferHeader.Ascending(true);
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
        CurrentTransferHeader: Record "E3 Transfer Header";
        TransferJournalDocument: Codeunit "E3 Transfer Journal Document";
        ErrorDescription: Text;
    begin
        TransferJournalDocument.SetAutoTransferJournal(AutoTransferJournal);
        ClearLastError();
        // A Boolean Run commits on success and rolls back on error.
        if TransferJournalDocument.Run(TransferHeader) then
            exit;

        ErrorDescription := GetLastErrorText();
        CurrentTransferHeader.LockTable();
        if CurrentTransferHeader.Get(TransferHeader."Entry No.", TransferHeader."Entry Type",
               TransferHeader."Document Type", TransferHeader."Entry Number")
        then
            if not CurrentTransferHeader."Is Created" then begin
                CurrentTransferHeader."Error Description" :=
                    CopyStr(ErrorDescription, 1, MaxStrLen(CurrentTransferHeader."Error Description"));
                CurrentTransferHeader.Modify(true);
            end;

        Commit();
    end;

    local procedure ValidateTransferDocument(TransferHeader: Record "E3 Transfer Header"): Integer
    var
        TransferLine: Record "E3 Transfer Line";
        Item: Record Item;
        DocumentNo: Text[50];
        LineCount: Integer;
    begin
        DocumentNo := TransferHeader."Document Number";
        TransferLine.Reset();
        TransferLine.SetRange("Document Number", DocumentNo);

        if not TransferLine.FindSet() then
            Error('No transfer lines found for Document No. %1.', DocumentNo);

        repeat
            LineCount += 1;
            // Quantity validation
            if TransferLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero. Document No.: %1, Line No.: %2.',
                    DocumentNo, TransferLine."Line Number");

            // Item validation
            if TransferLine."D365 Item Code" = '' then
                Error(
                    'Item Code is blank. Document No.: %1, Line No.: %2.',
                    DocumentNo, TransferLine."Line Number");

            if not Item.Get(TransferLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist. Document No.: %2, Line No.: %3.',
                    TransferLine."D365 Item Code",
                    DocumentNo,
                    TransferLine."Line Number");

            // Department validation
            if TransferLine."D365 From Department Code" = '' then
                Error(
                    'From Department Code is blank. Document No.: %1, Line No.: %2.',
                    DocumentNo, TransferLine."Line Number");

            if TransferLine."D365 To Department Code" = '' then
                Error(
                    'To Department Code is blank. Document No.: %1, Line No.: %2.',
                    DocumentNo, TransferLine."Line Number");

            // Item tracking validation
            if Item."Item Tracking Code" = '' then begin
                if TransferLine."Batch No." <> '' then
                    Error(
                        'Batch No. is not allowed for untracked item %1. Document No.: %2, Line No.: %3.',
                        Item."No.", DocumentNo, TransferLine."Line Number");
            end else begin
                if TransferLine."Batch No." = '' then
                    Error(
                        'Batch No. is required for item %1. Document No.: %2, Line No.: %3.',
                        Item."No.", DocumentNo, TransferLine."Line Number");
            end;

        until TransferLine.Next() = 0;

        if (TransferHeader."Number of Lines" > 0) and (LineCount <> TransferHeader."Number of Lines") then
            Error('Transfer Document %1 has %2 lines. Expected %3.', DocumentNo, LineCount, TransferHeader."Number of Lines");

        exit(LineCount);
    end;


}
