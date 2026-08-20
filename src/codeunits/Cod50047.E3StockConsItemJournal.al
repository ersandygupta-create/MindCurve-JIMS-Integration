codeunit 50047 "E3 Post Stock Consumption"
{
    TableNo = "E3 Stock Consumption Header";

    trigger OnRun()
    begin
        CreateItemJournal(Rec);
        //PostItemJournal(Rec);
    end;

    procedure CreateItemJournal(var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    begin
        CreateItemJournalLines(StockConsumptionHeader);
    end;

    procedure PostItemJournal(var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    begin
        PostItemJournalLines(StockConsumptionHeader);
    end;

    local procedure CreateItemJournalLines(var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    var
        StockConsumptionLine: Record "E3 Stock Consumption Line";
        ItemJournalLine: Record "Item Journal Line";
        Item: Record Item;
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
        LineNo: Integer;
    begin
        if StockConsumptionHeader.Posted then
            Error('Stock Consumption %1 is already posted.', StockConsumptionHeader."Document No.");

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
                Error('Item Code is blank for Line No. %1.', StockConsumptionLine."Line No.");

            Item.Reset();
            if not Item.Get(StockConsumptionLine."D365 Item Code")
            then
                Error('Item %1 does not exist for Line No. %2.', StockConsumptionLine."D365 Item Code", StockConsumptionLine."Line No.");

            if StockConsumptionLine.Quantity <= 0 then
                Error('Quantity must be greater than zero for Line No. %1.', StockConsumptionLine."Line No.");

            ItemJournalLine.Reset();
            ItemJournalLine.SetRange("Journal Template Name", ItemJournalTemplate.Name);
            ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);

            if ItemJournalLine.FindLast() then
                LineNo := ItemJournalLine."Line No." + 10000
            else
                LineNo := 10000;

            ItemJournalLine.Init();
            ItemJournalLine.Validate("Journal Template Name", ItemJournalTemplate.Name);
            ItemJournalLine.Validate("Journal Batch Name", ItemJournalBatch.Name);
            ItemJournalLine."Line No." := LineNo;
            ItemJournalLine.Validate("Entry Type", StockConsumptionLine."Entry Type");
            ItemJournalLine.Validate("Item No.", StockConsumptionLine."D365 Item Code");
            ItemJournalLine.Validate("Posting Date", StockConsumptionHeader."Entry Date");
            ItemJournalLine.Validate("Document No.", StockConsumptionHeader."Document No.");
            ItemJournalLine.Validate(Quantity, StockConsumptionLine.Quantity);
            if StockConsumptionLine."D365 Unit Code" <> '' then
                ItemJournalLine.Validate("Unit of Measure Code", StockConsumptionLine."D365 Unit Code");
            if StockConsumptionLine."D365 From Department Code" <> '' then
                ItemJournalLine.Validate("Location Code", StockConsumptionLine."D365 From Department Code");
            ItemJournalLine.Validate("External Document No.", StockConsumptionHeader."Entry Number");
            ItemJournalLine.Insert(true);

        until StockConsumptionLine.Next() = 0;
    end;

    // Post Item Journal
    local procedure PostItemJournalLines(var StockConsumptionHeader: Record "E3 Stock Consumption Header")
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        ItemJournalBatch.Reset();
        ItemJournalBatch.SetRange("Journal Template Name", GetItemJournalTemplate());
        ItemJournalBatch.SetRange(Name, GetItemJournalBatch());
        if not ItemJournalBatch.FindFirst() then
            Error('Item Journal Batch not found.');

        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);
        ItemJournalLine.SetRange("Document No.", StockConsumptionHeader."Document No.");
        if not ItemJournalLine.FindFirst() then
            Error('Item Journal Lines not found for Document No. %1.', StockConsumptionHeader."Document No.");
        //ItemJournalPostBatch.Run(ItemJournalBatch);

        StockConsumptionHeader."Posted" := true;
        StockConsumptionHeader.Modify(true);
    end;


    // Get Item Journal Template
    local procedure GetItemJournalTemplate(): Code[10]
    var
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange(Type, ItemJournalTemplate.Type::Item);
        if ItemJournalTemplate.FindFirst() then
            exit(ItemJournalTemplate.Name);

        Error('Item Journal Template not found.');
    end;

    // Get Item Journal Batch
    local procedure GetItemJournalBatch(): Code[10]
    var
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange(Type, ItemJournalTemplate.Type::Item);
        if not ItemJournalTemplate.FindFirst() then
            Error('Item Journal Template not found.');

        ItemJournalBatch.Reset();
        ItemJournalBatch.SetRange("Journal Template Name", ItemJournalTemplate.Name);
        if ItemJournalBatch.FindFirst() then
            exit(ItemJournalBatch.Name);
        Error('Item Journal Batch not found for Template %1.', ItemJournalTemplate.Name);
    end;
}