using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using System.IO;

codeunit 50100 "Item Tracking CSV Import"
{
    procedure ImportAppliesToEntries(SelectedLine: Record "Item Journal Line")
    var
        CSVBuffer: Record "CSV Buffer" temporary;
        JournalLine: Record "Item Journal Line";
        LedgerEntry: Record "Item Ledger Entry";
        FileStream: InStream;
        TotalsByJournalLine: Dictionary of [Integer, Decimal];
        TotalsByLedgerEntry: Dictionary of [Integer, Decimal];
        SeenApplications: Dictionary of [Text, Boolean];
        ApplicationKey: Text;
        RowNo: Integer;
        LastRowNo: Integer;
        JournalLineNo: Integer;
        LedgerEntryNo: Integer;
        QuantityBase: Decimal;
        JournalTotal: Decimal;
        EntryTotal: Decimal;
    begin
        if not UploadIntoStream('CSV files (*.csv)|*.csv', FileStream) then
            exit;

        CSVBuffer.LoadDataFromStream(FileStream, ',');
        LastRowNo := CSVBuffer.GetNumberOfLines();

        if (CSVBuffer.GetValue(1, 1) <> 'JournalLineNo') or
           (CSVBuffer.GetValue(1, 2) <> 'AppliesToEntryNo') or
           (CSVBuffer.GetValue(1, 3) <> 'QuantityBase')
        then
            Error('Use the CSV header JournalLineNo,AppliesToEntryNo,QuantityBase.');

        CSVBuffer.SetFilter("Field No.", '>3');
        if not CSVBuffer.IsEmpty() then
            Error('The CSV must have exactly three columns.');
        CSVBuffer.Reset();

        if LastRowNo < 2 then
            Error('The CSV must contain at least one tracking row.');

        JournalLine.LockTable();

        for RowNo := 2 to LastRowNo do begin
            ReadRow(CSVBuffer, RowNo, JournalLineNo, LedgerEntryNo, QuantityBase);
            GetJournalLine(SelectedLine, JournalLineNo, JournalLine);

            if not TotalsByJournalLine.ContainsKey(JournalLineNo) then
                CheckJournalLine(JournalLine);

            ApplicationKey := StrSubstNo('%1/%2', JournalLineNo, LedgerEntryNo);
            if SeenApplications.ContainsKey(ApplicationKey) then
                Error(
                    'CSV row %1 repeats entry %2 for journal line %3. Combine the quantities in one row.',
                    RowNo, LedgerEntryNo, JournalLineNo);
            SeenApplications.Add(ApplicationKey, true);

            if not LedgerEntry.Get(LedgerEntryNo) then
                Error('CSV row %1 refers to missing item ledger entry %2.', RowNo, LedgerEntryNo);
            CheckLedgerEntry(JournalLine, LedgerEntry, QuantityBase, RowNo);

            if not TotalsByJournalLine.Get(JournalLineNo, JournalTotal) then
                JournalTotal := 0;
            TotalsByJournalLine.Set(JournalLineNo, JournalTotal + QuantityBase);

            if not TotalsByLedgerEntry.Get(LedgerEntryNo, EntryTotal) then
                EntryTotal := 0;
            EntryTotal += QuantityBase;

            if EntryTotal > LedgerEntry."Remaining Quantity" then
                Error(
                    'CSV row %1 brings the total for entry %2 to %3 base units, but only %4 remain.',
                    RowNo, LedgerEntryNo, EntryTotal, LedgerEntry."Remaining Quantity");
            TotalsByLedgerEntry.Set(LedgerEntryNo, EntryTotal);
        end;

        foreach JournalLineNo in TotalsByJournalLine.Keys() do begin
            GetJournalLine(SelectedLine, JournalLineNo, JournalLine);
            JournalTotal := TotalsByJournalLine.Get(JournalLineNo);
            if JournalTotal <> JournalLine."Quantity (Base)" then
                Error(
                    'Journal line %1 requires %2 base units. The CSV contains %3.',
                    JournalLineNo, JournalLine."Quantity (Base)", JournalTotal);
        end;

        for RowNo := 2 to LastRowNo do begin
            ReadRow(CSVBuffer, RowNo, JournalLineNo, LedgerEntryNo, QuantityBase);
            GetJournalLine(SelectedLine, JournalLineNo, JournalLine);
            LedgerEntry.Get(LedgerEntryNo);
            CreateTrackingRow(JournalLine, LedgerEntry, QuantityBase);
        end;

        Message('Imported %1 tracking rows. Review Item Tracking Lines before posting.', LastRowNo - 1);
    end;

    local procedure ReadRow(
        var CSVBuffer: Record "CSV Buffer" temporary;
        RowNo: Integer;
        var JournalLineNo: Integer;
        var LedgerEntryNo: Integer;
        var QuantityBase: Decimal)
    begin
        if not Evaluate(JournalLineNo, CSVBuffer.GetValue(RowNo, 1), 9) then
            Error('CSV row %1 has an invalid journal line number.', RowNo);
        if not Evaluate(LedgerEntryNo, CSVBuffer.GetValue(RowNo, 2), 9) then
            Error('CSV row %1 has an invalid item ledger entry number.', RowNo);
        if not Evaluate(QuantityBase, CSVBuffer.GetValue(RowNo, 3), 9) then
            Error('CSV row %1 has an invalid base quantity. Use a period for decimals.', RowNo);

        if (JournalLineNo <= 0) or (LedgerEntryNo <= 0) or (QuantityBase <= 0) then
            Error('All values on CSV row %1 must be positive.', RowNo);
    end;

    local procedure GetJournalLine(
        SelectedLine: Record "Item Journal Line";
        JournalLineNo: Integer;
        var JournalLine: Record "Item Journal Line")
    begin
        if not JournalLine.Get(
            SelectedLine."Journal Template Name",
            SelectedLine."Journal Batch Name",
            JournalLineNo)
        then
            Error(
                'Journal line %1 does not exist in batch %2.',
                JournalLineNo, SelectedLine."Journal Batch Name");
    end;

    local procedure CheckJournalLine(JournalLine: Record "Item Journal Line")
    var
        ExistingTracking: Record "Reservation Entry";
    begin
        JournalLine.TestField("Entry Type", JournalLine."Entry Type"::"Negative Adjmt.");
        JournalLine.TestField("Item No.");
        JournalLine.TestField("Applies-to Entry", 0);

        if (JournalLine."Quantity (Base)" <= 0) or
           (JournalLine."Qty. per Unit of Measure" <= 0)
        then
            Error('Journal line %1 needs a positive quantity and a valid unit of measure.', JournalLine."Line No.");

        ExistingTracking.SetRange("Source Type", Database::"Item Journal Line");
        ExistingTracking.SetRange("Source Subtype", JournalLine."Entry Type".AsInteger());
        ExistingTracking.SetRange("Source ID", JournalLine."Journal Template Name");
        ExistingTracking.SetRange("Source Batch Name", JournalLine."Journal Batch Name");
        ExistingTracking.SetRange("Source Ref. No.", JournalLine."Line No.");
        if not ExistingTracking.IsEmpty() then
            Error('Journal line %1 already has tracking or reservations.', JournalLine."Line No.");
    end;

    local procedure CheckLedgerEntry(
        JournalLine: Record "Item Journal Line";
        LedgerEntry: Record "Item Ledger Entry";
        QuantityBase: Decimal;
        RowNo: Integer)
    begin
        if (not LedgerEntry.Positive) or (not LedgerEntry.Open) or
           (LedgerEntry."Item No." <> JournalLine."Item No.") or
           (LedgerEntry."Variant Code" <> JournalLine."Variant Code") or
           (LedgerEntry."Location Code" <> JournalLine."Location Code")
        then
            Error(
                'CSV row %1 requires an open inbound entry for the same item, variant, and location as journal line %2.',
                RowNo, JournalLine."Line No.");

        if (LedgerEntry."Lot No." = '') and
           (LedgerEntry."Serial No." = '') and
           (LedgerEntry."Package No." = '')
        then
            Error('CSV row %1 refers to an entry with no tracking numbers.', RowNo);

        if (LedgerEntry."Serial No." <> '') and (QuantityBase <> 1) then
            Error('CSV row %1 must have a base quantity of 1 for a serial number.', RowNo);
    end;

    local procedure CreateTrackingRow(
        JournalLine: Record "Item Journal Line";
        LedgerEntry: Record "Item Ledger Entry";
        QuantityBase: Decimal)
    var
        Tracking: Record "Reservation Entry" temporary;
        CreateReservation: Codeunit "Create Reserv. Entry";
    begin
        Tracking."Lot No." := LedgerEntry."Lot No.";
        Tracking."Serial No." := LedgerEntry."Serial No.";
        Tracking."Package No." := LedgerEntry."Package No.";

        CreateReservation.CreateReservEntryFor(
            Database::"Item Journal Line",
            JournalLine."Entry Type".AsInteger(),
            JournalLine."Journal Template Name",
            JournalLine."Journal Batch Name",
            0,
            JournalLine."Line No.",
            JournalLine."Qty. per Unit of Measure",
            QuantityBase / JournalLine."Qty. per Unit of Measure",
            QuantityBase,
            Tracking);

        CreateReservation.SetApplyToEntryNo(LedgerEntry."Entry No.");
        CreateReservation.SetDates(LedgerEntry."Warranty Date", LedgerEntry."Expiration Date");
        CreateReservation.CreateEntry(
            JournalLine."Item No.",
            JournalLine."Variant Code",
            JournalLine."Location Code",
            JournalLine.Description,
            0D,
            JournalLine."Posting Date",
            0,
            Enum::"Reservation Status"::Surplus);
    end;
}