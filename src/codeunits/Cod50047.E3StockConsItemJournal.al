codeunit 50047 "E3 Post Stock Consumption"
{
    TableNo = "E3 Stock Consumption Header";

    trigger OnRun()
    begin
        CreateItemJournal(Rec);
        PostItemJournal(Rec);
    end;

    procedure CreateItemJournal(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    begin
        CreateItemJournalLines(StockConsumptionHeader);
    end;

    procedure PostItemJournal(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    begin
        PostItemJournalLines(StockConsumptionHeader);
    end;

    local procedure CreateItemJournalLines(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    var
        StockConsumptionLine: Record "E3 Stock Consumption Line";
        ItemJournalLine: Record "Item Journal Line";
        Item: Record Item;
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        LineNo: Integer;
        LotNoToUse: Code[50];
        Location: Record Location;
    begin
        if StockConsumptionHeader.Posted then
            Error(
                'Stock Consumption %1 is already posted.',
                StockConsumptionHeader."Document No.");

        StockConsumptionLine.Reset();
        StockConsumptionLine.SetRange("Entry Type", StockConsumptionHeader."Entry Type");
        StockConsumptionLine.SetRange("Document No.", StockConsumptionHeader."Document No.");

        if not StockConsumptionLine.FindSet() then
            Error('No Stock Consumption Lines found for Document No. %1.', StockConsumptionHeader."Document No.");

        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange(Type, ItemJournalTemplate.Type::Item);

        if not ItemJournalTemplate.FindFirst() then
            Error('Item Journal Template not found.');

        ItemJournalBatch.Reset();
        ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);

        if not ItemJournalBatch.FindFirst() then
            Error('Item Journal Batch not found for Template %1.', ItemJournalTemplate.Name);

        repeat
            if StockConsumptionLine."D365 Item Code" = '' then
                Error(
                    'Item Code is blank for Line No. %1.',
                    StockConsumptionLine."Line No.");

            if not Item.Get(StockConsumptionLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist for Line No. %2.',
                    StockConsumptionLine."D365 Item Code",
                    StockConsumptionLine."Line No.");

            if StockConsumptionLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero for Line No. %1.',
                    StockConsumptionLine."Line No.");

            if StockConsumptionLine."Entry Type" <> StockConsumptionLine."Entry Type"
            then
                Error(
                    'Stock Consumption Line %1 must have Entry Type Negative Adjmt.',
                    StockConsumptionLine."Line No.");

            LotNoToUse := ResolveLotNo(Item, StockConsumptionLine."Batch No.");

            ValidateLotRequirement(Item, LotNoToUse);

            LineNo :=
                GetNextJournalLineNo(
                    ItemJournalTemplate.Name,
                    ItemJournalBatch.Name);

            Clear(ItemJournalLine);
            ItemJournalLine.Init();

            ItemJournalLine.Validate(
                "Journal Template Name",
                ItemJournalTemplate.Name);

            ItemJournalLine.Validate(
                "Journal Batch Name",
                ItemJournalBatch.Name);

            ItemJournalLine."Line No." := LineNo;

            ItemJournalLine.Validate(
                "Entry Type",
                StockConsumptionLine."Entry Type");

            ItemJournalLine.Validate(
                "Item No.",
                StockConsumptionLine."D365 Item Code");

            ItemJournalLine.Validate(
                "Posting Date",
                StockConsumptionHeader."Entry Date");

            ItemJournalLine.Validate("Document No.", StockConsumptionHeader."Document No.");
            ItemJournalLine.Validate(Quantity, StockConsumptionLine.Quantity);
            if StockConsumptionLine."D365 Unit Code" <> '' then
                ItemJournalLine.Validate("Shortcut Dimension 1 Code", StockConsumptionLine."D365 Unit Code");
            if StockConsumptionLine."D365 From Department Code" <> '' then
                ItemJournalLine.Validate("Location Code", StockConsumptionLine."D365 From Department Code");
            if ItemJournalLine."Location Code" <> '' then
                if Location.Get(ItemJournalLine."Location Code") then
                    ItemJournalLine.Validate("Gen. Bus. Posting Group", Location."Gen. Bus. Posting Group");
            ItemJournalLine.Validate("External Document No.", StockConsumptionHeader."Entry Number");
            ItemJournalLine.Insert(true);

            if LotNoToUse <> '' then
                AssignBatchNoToItemJournalLine(
                    ItemJournalLine,
                    LotNoToUse,
                    GetExpiryDate(StockConsumptionLine));

        until StockConsumptionLine.Next() = 0;
    end;

    local procedure ResolveLotNo(
        Item: Record Item;
        StagingLotNo: Code[50]): Code[50]
    begin
        if StagingLotNo <> '' then
            exit(StagingLotNo);

        if not IsLotTracked(Item) then
            exit('');

        exit(GenerateLotNo(Item));
    end;

    local procedure IsLotTracked(
        Item: Record Item): Boolean
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        if Item."Item Tracking Code" = '' then
            exit(false);

        ItemTrackingCode.Get(Item."Item Tracking Code");

        exit(
            ItemTrackingCode."Lot Specific Tracking" or
            ItemTrackingCode."Lot Warehouse Tracking");
    end;

    local procedure ValidateLotRequirement(
        Item: Record Item;
        LotNo: Code[50])
    begin
        if IsLotTracked(Item) then begin
            if LotNo = '' then
                Error(
                    'Lot No. is required for item %1.',
                    Item."No.");
        end
        else begin
            if LotNo <> '' then
                Error(
                    'Item %1 is not lot tracked, but Lot No. %2 was supplied.',
                    Item."No.",
                    LotNo);
        end;
    end;

    local procedure GenerateLotNo(
        Item: Record Item): Code[50]
    var
        NoSeries: Codeunit "No. Series";
    begin
        exit(
            NoSeries.GetNextNo(
                'LOT',
                WorkDate(),
                true));
    end;

    local procedure GetNextJournalLineNo(
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10]): Integer
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.Reset();

        ItemJournalLine.SetRange(
            "Journal Template Name",
            JournalTemplateName);

        ItemJournalLine.SetRange(
            "Journal Batch Name",
            JournalBatchName);

        if ItemJournalLine.FindLast() then
            exit(
                ItemJournalLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure AssignBatchNoToItemJournalLine(
        var ItemJournalLine: Record "Item Journal Line";
        LotNoToUse: Code[50];
        ExpiryDate: Date)
    var
        Item: Record Item;
        ReservationEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LotInformation: Record "Lot No. Information";
        QtyToHandle: Decimal;
        QtyToHandleBase: Decimal;
    begin
        ItemJournalLine.TestField("Item No.");

        if LotNoToUse = '' then
            Error(
                'Lot No. must be entered for Item %1.',
                ItemJournalLine."Item No.");

        Item.Get(ItemJournalLine."Item No.");

        if Item."Item Tracking Code" = '' then
            Error(
                'Item %1 does not have an Item Tracking Code.',
                Item."No.");

        QtyToHandle :=
            Abs(ItemJournalLine.Quantity);

        QtyToHandleBase :=
            Abs(ItemJournalLine."Quantity (Base)");

        if QtyToHandleBase = 0 then
            QtyToHandleBase :=
                Round(
                    QtyToHandle *
                    ItemJournalLine."Qty. per Unit of Measure",
                    0.00001);

        LotInformation.Reset();

        LotInformation.SetRange(
            "Item No.",
            ItemJournalLine."Item No.");

        LotInformation.SetRange(
            "Lot No.",
            LotNoToUse);

        if not LotInformation.FindFirst() then begin
            LotInformation.Init();

            LotInformation.Validate(
                "Item No.",
                ItemJournalLine."Item No.");

            LotInformation.Validate(
                "Lot No.",
                LotNoToUse);

            LotInformation.Insert(true);
        end;

        LotInformation."Item Name" :=
            Item.Description;

        LotInformation.Description :=
            Item.Description;

        if ExpiryDate <> 0D then
            LotInformation."Expairy Date" :=
                ExpiryDate;

        LotInformation.Modify(true);

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

        ReservationEntry."Lot No." :=
            LotNoToUse;

        if ExpiryDate <> 0D then
            ReservationEntry."Expiration Date" :=
                ExpiryDate;

        CreateReservEntry.SetDates(
            0D,
            ReservationEntry."Expiration Date");

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

        ItemJournalLine.Validate(
            "Lot No.",
            LotNoToUse);

        ItemJournalLine.Modify(true);
    end;

    local procedure GetExpiryDate(
        StockConsumptionLine: Record "E3 Stock Consumption Line"): Date
    begin
        exit(
            StockConsumptionLine."Expiry Date");
    end;

    local procedure PostItemJournalLines(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        ItemJournalBatch.Reset();

        ItemJournalBatch.SetRange(
            "Journal Template Name",
            GetItemJournalTemplate());

        ItemJournalBatch.SetRange(
            Name,
            GetItemJournalBatch());

        if not ItemJournalBatch.FindFirst() then
            Error('Item Journal Batch not found.');

        ItemJournalLine.Reset();

        ItemJournalLine.SetRange(
            "Journal Template Name",
            ItemJournalBatch."Journal Template Name");

        ItemJournalLine.SetRange(
            "Journal Batch Name",
            ItemJournalBatch.Name);

        ItemJournalLine.SetRange(
            "Document No.",
            StockConsumptionHeader."Document No.");

        if not ItemJournalLine.FindFirst() then
            Error(
                'Item Journal Lines not found for Document No. %1.',
                StockConsumptionHeader."Document No.");

        // Uncomment this line when actual posting is required.
        // ItemJournalPostBatch.Run(ItemJournalBatch);

        StockConsumptionHeader.Posted := true;
        StockConsumptionHeader.Modify(true);
    end;

    local procedure GetItemJournalTemplate(): Code[10]
    var
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        ItemJournalTemplate.Reset();

        ItemJournalTemplate.SetRange(
            Type,
            ItemJournalTemplate.Type::Item);

        if ItemJournalTemplate.FindFirst() then
            exit(ItemJournalTemplate.Name);

        Error('Item Journal Template not found.');
    end;

    local procedure GetItemJournalBatch(): Code[10]
    var
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        ItemJournalTemplate.Reset();

        ItemJournalTemplate.SetRange(
            Type,
            ItemJournalTemplate.Type::Item);

        if not ItemJournalTemplate.FindFirst() then
            Error('Item Journal Template not found.');

        ItemJournalBatch.Reset();

        ItemJournalBatch.SetRange(
            "Journal Template Name",
            ItemJournalTemplate.Name);

        if ItemJournalBatch.FindFirst() then
            exit(ItemJournalBatch.Name);

        Error(
            'Item Journal Batch not found for Template %1.',
            ItemJournalTemplate.Name);
    end;
}