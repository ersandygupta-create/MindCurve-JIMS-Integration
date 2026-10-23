
codeunit 50061 "E3 Transfer Journal Mgmt."
{
    Permissions =
        tabledata "E3 Transfer Header" = rm,
        tabledata "E3 Transfer Line" = r,
        tabledata "Item Journal Line" = rim,
        tabledata "Item Ledger Entry" = r,
        tabledata "Reservation Entry" = rim;

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
        TransferLine.SetRange("Entry Type", TransferHeader."Entry Type");
        TransferLine.SetRange("Entry Number", TransferHeader."Entry Number");

        if not TransferLine.FindSet() then
            Error(
                'No transfer lines exist for Document No. %1.',
                DocumentNo);

        // Find the next line number in the configured batch.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);

        if ItemJournalLine.FindLast() then
            LineNo := ItemJournalLine."Line No." + 10000
        else
            LineNo := 10000;

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
            ItemJournalLine.Validate("Journal Template Name", JournalTemplateName);
            ItemJournalLine.Validate("Journal Batch Name", JournalBatchName);
            ItemJournalLine.Validate("Line No.", LineNo);
            ItemJournalLine.Validate("Posting Date", TransferHeader."v_Date");
            ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
            ItemJournalLine.Validate("Document No.", DocumentNo);
            ItemJournalLine.Validate("Item No.", TransferLine."D365 Item Code");
            ItemJournalLine.Validate("Location Code", TransferLine."D365 From Department Code");
            ItemJournalLine.Validate("New Location Code", TransferLine."D365 To Department Code");
            ItemJournalLine.Validate("Shortcut Dimension 1 Code", TransferLine."Business Unit");
            ItemJournalLine.Validate("New Shortcut Dimension 1 Code", TransferLine."Business Unit");
            ItemJournalLine.Validate(Quantity, TransferLine.Quantity);

            if TransferLine."D365 Unit Code" <> '' then
                ItemJournalLine.Validate("Unit of Measure Code", TransferLine."D365 Unit Code");

            // Retain the existing lot. Do not assign New Lot No.
            if Item."Item Tracking Code" <> '' then
                ItemJournalLine.Validate("Lot No.", TransferLine."Batch No.");

            ItemJournalLine.Insert(true);

            // Create tracking entries for the existing lot.
            if Item."Item Tracking Code" <> '' then
                CreateExistingLotTracking(ItemJournalLine, TransferLine."Batch No.");

            LineNo += 10000;
        until TransferLine.Next() = 0;

        TransferHeader."Is Created" := true;
        TransferHeader.Modify(true);

        Message(
            'Item Reclassification Journal created for Document No. %1 using template %2 and batch %3. The journal has not been posted.',
            DocumentNo,
            JournalTemplateName,
            JournalBatchName);
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
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        QtyToHandle: Decimal;
        QtyToHandleBase: Decimal;
    begin
        if LotNo = '' then
            Error(
                'Lot No. is required for item %1.',
                ItemJournalLine."Item No.");

        QtyToHandle := Abs(ItemJournalLine.Quantity);
        QtyToHandleBase := Abs(ItemJournalLine."Quantity (Base)");

        if QtyToHandleBase = 0 then
            QtyToHandleBase :=
                Round(
                    QtyToHandle *
                    ItemJournalLine."Qty. per Unit of Measure",
                    0.00001);

        // Remove existing tracking entries for this journal line.
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Item Journal Line");
        ReservationEntry.SetRange("Source Subtype", ItemJournalLine."Entry Type".AsInteger());
        ReservationEntry.SetRange("Source ID", ItemJournalLine."Journal Template Name");
        ReservationEntry.SetRange("Source Batch Name", ItemJournalLine."Journal Batch Name");
        ReservationEntry.SetRange("Source Ref. No.", ItemJournalLine."Line No.");

        if not ReservationEntry.IsEmpty() then
            ReservationEntry.DeleteAll(true);

        Clear(ReservationEntry);
        ReservationEntry.Init();
        ReservationEntry."Lot No." := LotNo;

        CreateReservEntry.SetDates(0D, 0D);
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

        CreateReservEntry.CreateEntry(
            ItemJournalLine."Item No.",
            ItemJournalLine."Variant Code",
            ItemJournalLine."Location Code",
            ItemJournalLine.Description,
            ItemJournalLine."Posting Date",
            ItemJournalLine."Document Date",
            0,
            ReservationEntry."Reservation Status"::Prospect);

        ItemJournalLine.Validate("Lot No.", LotNo);
        ItemJournalLine.Modify(true);
    end;

    procedure PostItemReclassificationJournal(DocumentNo: Code[20])
    var
        TransferHeader: Record "E3 Transfer Header";
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        if DocumentNo = '' then
            Error('Document No. must not be blank.');

        TransferHeader.Reset();
        TransferHeader.SetRange("Document Number", DocumentNo);

        if not TransferHeader.FindFirst() then
            Error(
                'Transfer Header with Document No. %1 does not exist.',
                DocumentNo);

        if not TransferHeader."Is Created" then
            CreateItemReclassificationJournal(DocumentNo);

        // Read template and batch from setup where Type = Reclass.
        GetReclassJournalSetup(HISIntegrationSetupLine, JournalTemplateName, JournalBatchName);

        // Filter journal lines for this document only.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.SetRange("Document No.", DocumentNo);

        if not ItemJournalLine.FindFirst() then
            Error(
                'No Item Journal Lines found for Document No. %1 in template %2 and batch %3.',
                DocumentNo,
                JournalTemplateName,
                JournalBatchName);

        // Post the selected document's journal lines.
        ItemJnlPostBatch.Run(ItemJournalLine);

        Message(
            'Item Reclassification Journal posting process completed for Document No. %1.',
            DocumentNo);
    end;
}
