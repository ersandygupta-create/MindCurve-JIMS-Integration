codeunit 50047 "E3 Post Stock Consumption"
{
    TableNo = "Job Queue Entry";
    Permissions =
    tabledata "E3 Stock Consumption Header" = rm,
    tabledata "E3 Stock Consumption Line" = r,
    tabledata "E3 HIS Integartion Setup" = r,
    tabledata "E3 HIS Integration Setup Line" = r,
    tabledata "Item Journal Line" = rimd,
    tabledata "Item Journal Template" = r,
    tabledata "Item Journal Batch" = r,
    tabledata "Item" = r,
    tabledata "Location" = r,
    tabledata "Item Tracking Code" = r,
    tabledata "Reservation Entry" = rimd,
    tabledata "Lot No. Information" = rimd;

    trigger OnRun()
    begin
        ProcessPendingStockConsumption();
    end;

    procedure CreateItemJournal(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    begin
        ProcessStockConsumptionDocument(StockConsumptionHeader, false);
    end;

    local procedure CreateItemJournalLines(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    var
        StockConsumptionLine: Record "E3 Stock Consumption Line";
        ItemJournalLine: Record "Item Journal Line";
        Item: Record Item;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        LineNo: Integer;
        LotNoToUse: Code[50];
        Location: Record Location;
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";

    begin
        // Prevent duplicate journal creation.
        if StockConsumptionHeader."Is Created" then
            exit;

        StockConsumptionLine.Reset();
        StockConsumptionLine.SetRange(
            "Document No.",
            StockConsumptionHeader."Document No.");

        if not StockConsumptionLine.FindSet() then
            Error(
                'No Stock Consumption Lines found for Document No. %1.',
                StockConsumptionHeader."Document No.");

        GetStockConsumptionJournalSetup(
            JournalTemplateName,
            JournalBatchName);


        if not ItemJournalTemplate.Get(JournalTemplateName) then
            Error(
                'Item Journal Template %1 does not exist.',
                JournalTemplateName);

        if not ItemJournalBatch.Get(
            JournalTemplateName,
            JournalBatchName)
        then
            Error(
                'Item Journal Batch %1 does not exist for Template %2.',
                JournalBatchName,
                JournalTemplateName);

        repeat
            if StockConsumptionLine."D365 Item Code" = '' then
                Error(
                    'Item Code is blank for Line No. %1.',
                    StockConsumptionLine."Line No.");

            if not Item.Get(StockConsumptionLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist for Line No. %2.',
                    StockConsumptionLine."D365 Item Code", StockConsumptionLine."Line No.");

            if StockConsumptionLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero for Line No. %1.',
                    StockConsumptionLine."Line No.");

            LotNoToUse := ResolveLotNo(Item, StockConsumptionLine."Batch No.");

            ValidateLotRequirement(Item, LotNoToUse);

            LineNo := GetNextJournalLineNo(JournalTemplateName, JournalBatchName);

            Clear(ItemJournalLine);
            ItemJournalLine.Init();

            ItemJournalLine.Validate("Journal Template Name", JournalTemplateName);
            ItemJournalLine.Validate("Journal Batch Name", JournalBatchName);
            ItemJournalLine."Line No." := LineNo;
            ItemJournalLine.Validate("Entry Type", StockConsumptionLine."Entry Type");
            ItemJournalLine.Validate("Item No.", StockConsumptionLine."D365 Item Code");
            ItemJournalLine.Validate(Quantity, StockConsumptionLine.Quantity);
            ItemJournalLine.Validate("Unit Cost", StockConsumptionLine."Unit Cost");
            ItemJournalLine.Validate("Posting Date", StockConsumptionHeader."Entry Date");
            ItemJournalLine.Validate("Document No.", StockConsumptionHeader."Document No.");
            if StockConsumptionLine."Business Unit" <> '' then
                ItemJournalLine.Validate("Shortcut Dimension 1 Code", StockConsumptionLine."Business Unit");
            if StockConsumptionLine."D365 From Department Code" <> '' then
                ItemJournalLine.Validate("Location Code", StockConsumptionLine."D365 From Department Code");
            if ItemJournalLine."Location Code" <> '' then
                if Location.Get(ItemJournalLine."Location Code") then
                    ItemJournalLine.Validate("Gen. Bus. Posting Group", Location."Gen. Bus. Posting Group");
            ItemJournalLine.Validate("Unit Amount", StockConsumptionLine."Unit Cost");
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

    [CommitBehavior(CommitBehavior::Error)]
    internal procedure ProcessStockConsumptionDocument(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header";
        AutoPostStockConsumption: Boolean)
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        StockConsumptionLineCount: Integer;
    begin
        StockConsumptionHeader.LockTable();
        StockConsumptionHeader.Get(
            StockConsumptionHeader."Entry No.",
            StockConsumptionHeader."Document No.",
            StockConsumptionHeader."Entry Type");

        if StockConsumptionHeader."Is Created" then
            exit;

        StockConsumptionLineCount := ValidateStockConsumptionDocument(StockConsumptionHeader."Document No.");
        GetStockConsumptionJournalSetup(JournalTemplateName, JournalBatchName);

        ItemJournalLine.LockTable();
        ItemJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        ItemJournalLine.SetRange("Document No.", StockConsumptionHeader."Document No.");

        if ItemJournalLine.IsEmpty() then
            CreateItemJournalLines(StockConsumptionHeader);

        if ItemJournalLine.Count() <> StockConsumptionLineCount then
            Error(
                'Journal line count does not match the stock consumption line count for document %1.',
                StockConsumptionHeader."Document No.");

        if AutoPostStockConsumption then begin
            ItemJournalLine.FindFirst();
            ItemJnlPostBatch.SetSuppressCommit(true);
            ItemJnlPostBatch.Run(ItemJournalLine);
            StockConsumptionHeader."Is Created" := true;
        end;

        if AutoPostStockConsumption or (StockConsumptionHeader."Error Description" <> '') then begin
            StockConsumptionHeader."Error Description" := '';
            StockConsumptionHeader.Modify(true);
        end;
    end;


    local procedure GetStockConsumptionJournalSetup(
    var JournalTemplateName: Code[10];
    var JournalBatchName: Code[10])
    var
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
    begin
        HISIntegrationSetupLine.Reset();
        HISIntegrationSetupLine.SetRange(
            Type,
            HISIntegrationSetupLine.Type::Stockconsumption);

        if not HISIntegrationSetupLine.FindFirst() then
            Error(
                'No HIS Integration Setup Line found with Type = Stockconsumption.');

        if HISIntegrationSetupLine."General Journal Template Code" = '' then
            Error(
                'General Journal Template Code is blank for Type = Stockconsumption.');

        if HISIntegrationSetupLine."General Journal Batch Code" = '' then
            Error(
                'General Journal Batch Code is blank for Type = Stockconsumption.');

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

    local procedure ProcessPendingStockConsumption()
    var
        StockConsumptionHeader: Record "E3 Stock Consumption Header";
        IntegrationSetup: Record "E3 HIS Integartion Setup";
    begin
        if not IntegrationSetup.Get() then
            Error('E3 HIS Integration Setup record not found.');

        StockConsumptionHeader.Reset();
        // Process pending documents oldest first, with entry number breaking date ties.
        StockConsumptionHeader.SetCurrentKey("Is Created", "Entry Date", "Entry No.");
        StockConsumptionHeader.Ascending(true);
        StockConsumptionHeader.SetRange("Is Created", false);

        if StockConsumptionHeader.FindSet() then
            repeat
                ProcessStockConsumptionWithErrorHandling(
                    StockConsumptionHeader,
                    IntegrationSetup."Auto Post Stockconsumption");
            until StockConsumptionHeader.Next() = 0;
    end;

    local procedure ProcessStockConsumptionWithErrorHandling(
        var StockConsumptionHeader: Record "E3 Stock Consumption Header";
        AutoPostStockConsumption: Boolean)
    var
        CurrentStockConsumptionHeader: Record "E3 Stock Consumption Header";
        StockConsumptionDocument: Codeunit "E3 Stock Consumption Document";
        ErrorDescription: Text;
    begin
        StockConsumptionDocument.SetAutoPost(AutoPostStockConsumption);
        ClearLastError();
        // Boolean Run commits a successful document and rolls back its writes on error.
        if StockConsumptionDocument.Run(StockConsumptionHeader) then
            exit;

        ErrorDescription := GetLastErrorText();
        CurrentStockConsumptionHeader.LockTable();
        if CurrentStockConsumptionHeader.Get(
            StockConsumptionHeader."Entry No.",
            StockConsumptionHeader."Document No.",
            StockConsumptionHeader."Entry Type")
        then
            if not CurrentStockConsumptionHeader."Is Created" then begin
                CurrentStockConsumptionHeader."Error Description" :=
                    CopyStr(ErrorDescription, 1, MaxStrLen(CurrentStockConsumptionHeader."Error Description"));
                CurrentStockConsumptionHeader.Modify(true);
            end;

        Commit();
    end;


    local procedure ValidateStockConsumptionDocument(DocumentNo: Code[20]): Integer
    var
        StockConsumptionLine: Record "E3 Stock Consumption Line";
        Item: Record Item;
        LotNoToUse: Code[50];
        LineCount: Integer;
    begin
        StockConsumptionLine.Reset();
        StockConsumptionLine.SetRange("Document No.", DocumentNo);

        if not StockConsumptionLine.FindSet() then
            Error(
                'No Stock Consumption Lines found for Document No. %1.',
                DocumentNo);

        repeat
            LineCount += 1;
            if StockConsumptionLine."D365 Item Code" = '' then
                Error(
                    'Item Code is blank. Document No.: %1, Line No.: %2.',
                    DocumentNo, StockConsumptionLine."Line No.");

            if not Item.Get(StockConsumptionLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist. Document No.: %2, Line No.: %3.',
                    StockConsumptionLine."D365 Item Code",
                    DocumentNo,
                    StockConsumptionLine."Line No.");

            if StockConsumptionLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero. Document No.: %1, Line No.: %2.',
                    DocumentNo, StockConsumptionLine."Line No.");

            if StockConsumptionLine."Entry Type" <> StockConsumptionLine."Entry Type"::"Negative Adjmt." then
                Error(
                    'Entry Type must be Negative Adjmt. Document No.: %1, Line No.: %2.',
                    DocumentNo, StockConsumptionLine."Line No.");

            // Validate supplied Lot No. without generating a new one.
            LotNoToUse := StockConsumptionLine."Batch No.";

            if LotNoToUse <> '' then
                ValidateLotRequirement(Item, LotNoToUse)
            else
                if not IsLotTracked(Item) then
                    ValidateLotRequirement(Item, '');

        until StockConsumptionLine.Next() = 0;

        exit(LineCount);
    end;

}
