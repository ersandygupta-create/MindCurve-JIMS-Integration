codeunit 50061 "E3 Transfer Journal Mgmt."
{

    Permissions =
        tabledata "E3 Transfer Header" = rm,
        tabledata "E3 Transfer Line" = r,
        tabledata "Item Journal Line" = rim;

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
        CreatedLineCount: Integer;
    begin
        if EntryNumber = '' then
            Error('Entry Number must not be blank.');

        TransferHeader.Reset();
        TransferHeader.SetRange("Entry Number", EntryNumber);

        if not TransferHeader.FindFirst() then
            Error('Transfer Header %1 does not exist.', EntryNumber);

        if TransferHeader."Is Created" then
            Error('Item Reclassification Journal has already been created for Entry Number %1.', EntryNumber);

        if TransferHeader."Is Posted" then
            Error('Transfer %1 is already posted.', EntryNumber);

        JournalTemplateName := 'RECLASS';
        JournalBatchName := 'DEFAULT';

        if not ItemJournalTemplate.Get(JournalTemplateName) then
            Error('Item Journal Template %1 does not exist.', JournalTemplateName);

        if not ItemJournalBatch.Get(JournalTemplateName, JournalBatchName) then
            Error(
                'Item Journal Batch %1 does not exist for template %2.',
                JournalBatchName,
                JournalTemplateName);

        TransferLine.Reset();
        TransferLine.SetRange("Entry Type", TransferHeader."Entry Type");
        TransferLine.SetRange("Entry Number", TransferHeader."Entry Number");

        if not TransferLine.FindSet() then
            Error('No transfer lines exist for Entry Number %1.', EntryNumber);

        // Find the next journal line number.
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
                    'Quantity must be greater than zero for transfer Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if TransferLine."D365 Item Code" = '' then
                Error(
                    'Item Code must not be blank for transfer Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if not Item.Get(TransferLine."D365 Item Code") then
                Error(
                    'Item %1 does not exist in Business Central.',
                    TransferLine."D365 Item Code");

            if TransferLine."D365 From Department Code" = '' then
                Error(
                    'From Department Code must not be blank for transfer Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if TransferLine."D365 To Department Code" = '' then
                Error(
                    'To Department Code must not be blank for transfer Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if TransferLine."D365 From Department Code" =
               TransferLine."D365 To Department Code"
            then
                Error(
                    'From Department and To Department cannot be the same for transfer Entry Number %1, Line Number %2.',
                    EntryNumber,
                    TransferLine."Line Number");

            if not ItemJournalLine.Get(
                JournalTemplateName,
                JournalBatchName,
                LineNo)
            then begin
                ItemJournalLine.Init();
                ItemJournalLine.Validate("Journal Template Name", JournalTemplateName);
                ItemJournalLine.Validate("Journal Batch Name", JournalBatchName);
                ItemJournalLine.Validate("Line No.", LineNo);

                ItemJournalLine.Validate("Posting Date", TransferHeader."v_Date");
                ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
                ItemJournalLine.Validate("Document No.", TransferHeader."Document Number");

                ItemJournalLine.Validate("Item No.", TransferLine."D365 Item Code");

                // From department/location.
                ItemJournalLine.Validate(
                    "Location Code",
                    TransferLine."D365 From Department Code");

                // To department/location.
                ItemJournalLine.Validate(
                    "New Location Code",
                    TransferLine."D365 To Department Code");

                ItemJournalLine.Validate(Quantity, TransferLine.Quantity);

                if TransferLine."D365 Unit Code" <> '' then
                    ItemJournalLine.Validate("Unit of Measure Code", TransferLine."D365 Unit Code");

                // Batch tracking.
                if TransferLine."Batch No." <> '' then begin
                    ItemJournalLine.Validate("Applies-to Entry", 0);
                    ItemJournalLine.Validate("Lot No.", TransferLine."Batch No.");
                    ItemJournalLine.Validate("New Lot No.", TransferLine."Batch No.");
                end;

                ItemJournalLine.Insert(true);
                CreatedLineCount += 1;
                LineNo += 10000;
            end;
        until TransferLine.Next() = 0;

        TransferHeader."Is Created" := true;
        TransferHeader.Modify(true);

        Message(
            '%1 Item Reclassification Journal line(s) created successfully for Transfer %2 in template %3 and batch %4.',
            CreatedLineCount,
            EntryNumber,
            JournalTemplateName,
            JournalBatchName);
    end;
}