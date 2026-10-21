codeunit 50061 "E3 Transfer Journal Mgmt."
{
    Permissions =
        tabledata "E3 Transfer Header" = rm,
        tabledata "E3 Transfer Line" = r,
        tabledata "Item Journal Line" = rim,
        tabledata "Item Ledger Entry" = r,
        tabledata "Reservation Entry" = rim;

    procedure CreateItemReclassificationJournal(EntryNumber: Text[100])
    var
        TransferHeader: Record "E3 Transfer Header";
        TransferLine: Record "E3 Transfer Line";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        Item: Record Item;
        LineNo: Integer;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        if EntryNumber = '' then
            Error('Entry Number must not be blank.');

        TransferHeader.Reset();
        TransferHeader.SetRange("Entry Number", EntryNumber);

        if not TransferHeader.FindFirst() then
            Error(
                'Transfer Header %1 does not exist.',
                EntryNumber);

        if TransferHeader."Is Created" then
            Error(
                'Item Reclassification Journal has already been created for Entry Number %1.',
                EntryNumber);

        JournalTemplateName := 'RECLASS';
        JournalBatchName := 'DEFAULT';

        if not ItemJournalTemplate.Get(JournalTemplateName) then
            Error(
                'Item Journal Template %1 does not exist.',
                JournalTemplateName);

        if not ItemJournalBatch.Get(
            JournalTemplateName,
            JournalBatchName)
        then
            Error(
                'Item Journal Batch %1 does not exist for template %2.',
                JournalBatchName,
                JournalTemplateName);

        TransferLine.Reset();
        TransferLine.SetRange(
            "Entry Type",
            TransferHeader."Entry Type");
        TransferLine.SetRange(
            "Entry Number",
            TransferHeader."Entry Number");

        if not TransferLine.FindSet() then
            Error(
                'No transfer lines exist for Entry Number %1.',
                EntryNumber);

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange(
            "Journal Template Name",
            JournalTemplateName);
        ItemJournalLine.SetRange(
            "Journal Batch Name",
            JournalBatchName);

        if ItemJournalLine.FindLast() then
            LineNo := ItemJournalLine."Line No." + 10000
        else
            LineNo := 10000;

        repeat
            if TransferLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero for Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if TransferLine."D365 Item Code" = '' then
                Error(
                    'Item Code must not be blank for Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if not Item.Get(TransferLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist in Business Central.',
                    TransferLine."D365 Item Code");

            if TransferLine."D365 From Department Code" = '' then
                Error(
                    'From Department Code must not be blank for Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if TransferLine."D365 To Department Code" = '' then
                Error(
                    'To Department Code must not be blank for Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if TransferLine."D365 From Department Code" =
               TransferLine."D365 To Department Code"
            then
                Error(
                    'From Department and To Department cannot be the same for Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            // For lot-tracked items, require an existing available source lot.
            if Item."Item Tracking Code" <> '' then begin
                if TransferLine."Batch No." = '' then
                    Error(
                        'An existing Batch No. is required for item %1, Entry Number %2, Line Number %3.',
                        Item."No.",
                        EntryNumber,
                        TransferLine."Line Number");

                CheckExistingLotAvailability(
                    Item."No.",
                    TransferLine."D365 From Department Code",
                    TransferLine."Batch No.",
                    TransferLine.Quantity);
            end;

            // Create the Item Reclassification Journal line.
            ItemJournalLine.Init();

            ItemJournalLine.Validate(
                "Journal Template Name",
                JournalTemplateName);

            ItemJournalLine.Validate(
                "Journal Batch Name",
                JournalBatchName);

            ItemJournalLine.Validate(
                "Line No.",
                LineNo);

            ItemJournalLine.Validate(
                "Posting Date",
                TransferHeader."v_Date");

            ItemJournalLine.Validate(
                "Entry Type",
                ItemJournalLine."Entry Type"::Transfer);

            ItemJournalLine.Validate(
                "Document No.",
                TransferHeader."Document Number");

            ItemJournalLine.Validate(
                "Item No.",
                TransferLine."D365 Item Code");

            ItemJournalLine.Validate(
                "Location Code",
                TransferLine."D365 From Department Code");

            ItemJournalLine.Validate(
                "New Location Code",
                TransferLine."D365 To Department Code");

            ItemJournalLine.Validate(
                Quantity,
                TransferLine.Quantity);

            if TransferLine."D365 Unit Code" <> '' then
                ItemJournalLine.Validate(
                    "Unit of Measure Code",
                    TransferLine."D365 Unit Code");

            // Assign existing lot number for item reclassification
            if Item."Item Tracking Code" <> '' then begin
                if TransferLine."Batch No." = '' then
                    Error(
                        'Batch No. must be specified for tracked item %1.',
                        TransferLine."D365 Item Code");

                // Existing lot at the source location
                ItemJournalLine.Validate(
                    "Lot No.",
                    TransferLine."Batch No.");

                // Reuse the same lot at the destination location
                ItemJournalLine.Validate(
                    "New Lot No.",
                    TransferLine."Batch No.");
            end;

            // Insert the journal line; do not post it.
            ItemJournalLine.Insert(true);

            // Create the tracking entry for the existing source lot.
            if Item."Item Tracking Code" <> '' then
                CreateExistingLotTracking(
                    ItemJournalLine,
                    TransferLine."Batch No.");

            LineNo += 10000;
        until TransferLine.Next() = 0;

        TransferHeader."Is Created" := true;
        TransferHeader.Modify(true);

        Message(
            'Item Reclassification Journal lines created for Transfer %1. The journal has not been posted.',
            EntryNumber);
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
                'Insufficient existing lot quantity for item %1, lot %2, source location %3. Available quantity: %4; required quantity: %5.',
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

        // Avoid duplicate tracking entries for this journal line.
        ReservationEntry.Reset();
        ReservationEntry.SetRange(
            "Source Type",
            Database::"Item Journal Line");
        ReservationEntry.SetRange(
            "Source Subtype",
            ItemJournalLine."Entry Type".AsInteger());
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
        //ItemJournalLine.Validate("New Lot No.", LotNo);
        ItemJournalLine.Modify(true);
    end;

    procedure PostItemReclassificationJournal(EntryNumber: Text[100])
    var
        TransferHeader: Record "E3 Transfer Header";
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        if EntryNumber = '' then
            Error('Entry Number must not be blank.');

        TransferHeader.Reset();
        TransferHeader.SetRange("Entry Number", EntryNumber);

        if not TransferHeader.FindFirst() then
            Error(
                'Transfer Header %1 does not exist.',
                EntryNumber);

        if not TransferHeader."Is Created" then
            CreateItemReclassificationJournal(EntryNumber);

        JournalTemplateName := 'RECLASS';
        JournalBatchName := 'DEFAULT';

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange(
            "Journal Template Name",
            JournalTemplateName);
        ItemJournalLine.SetRange(
            "Journal Batch Name",
            JournalBatchName);
        ItemJournalLine.SetRange(
            "Document No.",
            TransferHeader."Document Number");

        if not ItemJournalLine.FindFirst() then
            Error(
                'No Item Journal Lines found for Transfer %1.',
                EntryNumber);

        // Posting is separate from journal creation.
        ItemJnlPostBatch.Run(ItemJournalLine);

        Message(
            'Item Reclassification Journal posting process completed for Transfer %1.',
            EntryNumber);
    end;
}