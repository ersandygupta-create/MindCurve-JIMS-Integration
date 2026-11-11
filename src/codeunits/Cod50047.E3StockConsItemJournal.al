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
        CreateItemJournalLines(StockConsumptionHeader);
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
        if StockConsumptionHeader."Is Created" then
            Error(
                'Stock Consumption %1 is already posted.',
                StockConsumptionHeader."Document No.");

        StockConsumptionLine.Reset();
        //StockConsumptionLine.SetRange("Entry Type", StockConsumptionHeader."Entry Type");
        StockConsumptionLine.SetRange("Document No.", StockConsumptionHeader."Document No.");

        if not StockConsumptionLine.FindSet() then
            Error('No Stock Consumption Lines found for Document No. %1.', StockConsumptionHeader."Document No.");

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

            if StockConsumptionLine."Entry Type" <> StockConsumptionLine."Entry Type"::"Negative Adjmt."
             then
                Error(
                    'Stock Consumption Line %1 must have Entry Type Negative Adjmt.',
                    StockConsumptionLine."Line No.");

            LotNoToUse := ResolveLotNo(Item, StockConsumptionLine."Batch No.");

            ValidateLotRequirement(Item, LotNoToUse);

            LineNo := GetNextJournalLineNo(JournalTemplateName, JournalBatchName);

            Clear(ItemJournalLine);
            ItemJournalLine.Init();

            ItemJournalLine.Validate("Journal Template Name", JournalTemplateName);
            ItemJournalLine.Validate("Journal Batch Name", JournalBatchName);
            ItemJournalLine."Line No." := LineNo;
            ItemJournalLine.Validate("Entry Type", StockConsumptionLine."Entry Type"::"Negative Adjmt.");
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

    [TryFunction]
    local procedure TryProcessStockConsumption(
    var StockConsumptionHeader: Record "E3 Stock Consumption Header";
    AutoPostStockConsumption: Boolean)
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        if StockConsumptionHeader."Is Created" then
            exit;

        // Get configured Template and Batch.
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

        // Check existing journal lines for this document
        // in the configured Template and Batch only.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange(
            "Journal Template Name",
            JournalTemplateName);
        ItemJournalLine.SetRange(
            "Journal Batch Name",
            JournalBatchName);
        ItemJournalLine.SetRange(
            "Document No.",
            StockConsumptionHeader."Document No.");

        // Create journal lines only if they do not already exist.
        if ItemJournalLine.IsEmpty() then
            CreateItemJournalLines(StockConsumptionHeader);

        // If Auto Post is disabled, keep the journal unposted.
        if not AutoPostStockConsumption then
            exit;

        // Recheck status before posting.
        StockConsumptionHeader.LockTable();
        StockConsumptionHeader.Get(
            StockConsumptionHeader."Entry No.",
            StockConsumptionHeader."Entry Type",
            StockConsumptionHeader."Document Type",
            StockConsumptionHeader."Document No.");

        if StockConsumptionHeader."Is Created" then
            Error(
                'Stock Consumption %1 is already posted. Duplicate posting is not allowed.',
                StockConsumptionHeader."Document No.");

        // Get current document's journal lines.
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange(
            "Journal Template Name",
            JournalTemplateName);
        ItemJournalLine.SetRange(
            "Journal Batch Name",
            JournalBatchName);
        ItemJournalLine.SetRange(
            "Document No.",
            StockConsumptionHeader."Document No.");

        if not ItemJournalLine.FindFirst() then
            Error(
                'No Item Journal Lines found for Document No. %1.',
                StockConsumptionHeader."Document No.");

        // Post using the same method as Codeunit 50061.
        Codeunit.Run(
            Codeunit::"Item Jnl.-Post Batch",
            ItemJournalLine);

        // Mark completed only after successful posting.
        StockConsumptionHeader."Is Created" := true;
        StockConsumptionHeader."Error Description" := '';
        StockConsumptionHeader.Modify(true);
    end;

    local procedure UpdateStockConsumptionError(
    var StockConsumptionHeader: Record "E3 Stock Consumption Header";
    ErrorText: Text)
    begin
        StockConsumptionHeader."Error Description" :=
            CopyStr(
                ErrorText,
                1,
                MaxStrLen(StockConsumptionHeader."Error Description"));

        if ErrorText <> '' then
            StockConsumptionHeader."Is Created" := false;

        StockConsumptionHeader.Modify(true);
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
        ErrorDescription: Text;
        CleanupError: Text;
    begin
        // Do not process an already created/posted document.
        if StockConsumptionHeader."Is Created" then
            exit;

        ClearLastError();

        if TryProcessStockConsumption(
            StockConsumptionHeader,
            AutoPostStockConsumption)
        then begin
            UpdateStockConsumptionError(
                StockConsumptionHeader,
                '');
        end else begin
            // Capture the original document processing/posting error.
            ErrorDescription := GetLastErrorText();

            // Attempt cleanup without allowing cleanup failure
            // to stop processing of the next document.
            ClearLastError();

            if not TryCleanupStockConsumptionJournalLines(
                StockConsumptionHeader)
            then begin
                CleanupError := GetLastErrorText();

                if CleanupError <> '' then
                    ErrorDescription :=
                        CopyStr(
                            ErrorDescription + ' | Cleanup Error: ' + CleanupError,
                            1,
                            MaxStrLen(StockConsumptionHeader."Error Description"));
            end;

            // Update only the current document's error.
            UpdateStockConsumptionError(
                StockConsumptionHeader,
                ErrorDescription);
        end;
    end;

    [TryFunction]
    local procedure TryCleanupStockConsumptionJournalLines(
    var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    begin
        CleanupStockConsumptionJournalLines(
            StockConsumptionHeader);
    end;

    local procedure CleanupStockConsumptionJournalLines(
    var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    var
        ItemJournalLine: Record "Item Journal Line";
        ReservationEntry: Record "Reservation Entry";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        GetStockConsumptionJournalSetup(
            JournalTemplateName,
            JournalBatchName);

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange(
            "Journal Template Name",
            JournalTemplateName);
        ItemJournalLine.SetRange(
            "Journal Batch Name",
            JournalBatchName);
        ItemJournalLine.SetRange(
            "Document No.",
            StockConsumptionHeader."Document No.");

        if ItemJournalLine.FindSet() then
            repeat
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

                ItemJournalLine.Delete(true);
            until ItemJournalLine.Next() = 0;
    end;
}