codeunit 50069 "Item Tracking Application"
{
    Permissions = tabledata "Reservation Entry" = rm;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ApplyEntryFromJournal(SelectedLine: Record "Item Journal Line"; LedgerEntryNo: Integer)
    var
        JournalLine: Record "Item Journal Line";
        LedgerEntry: Record "Item Ledger Entry";
        ExistingTracking: Record "Reservation Entry";
        TrackingEntryNo: Integer;
        AlreadyApplied: Boolean;
    begin
        JournalLine.LockTable();
        ExistingTracking.LockTable();
        GetJournalLine(SelectedLine, SelectedLine."Line No.", JournalLine);
        CheckJournalLine(JournalLine);
        LedgerEntry.Get(LedgerEntryNo);
        if (JournalLine."Lot No." <> '') and (JournalLine."Lot No." <> LedgerEntry."Lot No.") then
            Error('Item ledger entry %1 does not match lot %2 on the journal line.', LedgerEntryNo, JournalLine."Lot No.");

        TrackingEntryNo := FindExistingTracking(
            JournalLine, LedgerEntry, JournalLine."Quantity (Base)", 0, AlreadyApplied);
        if AlreadyApplied then begin
            ExistingTracking.Get(TrackingEntryNo, false);
            if ExistingTracking."Appl.-to Item Entry" <> LedgerEntryNo then
                Error(
                    'This tracking row already applies to entry %1. Change it in Item Tracking Lines.',
                    ExistingTracking."Appl.-to Item Entry");
            exit;
        end;

        CheckLedgerEntry(JournalLine, LedgerEntry, JournalLine."Quantity (Base)", 0);
        if JournalLine."Quantity (Base)" > LedgerEntry."Remaining Quantity" then
            Error('Item ledger entry %1 has only %2 base units remaining.', LedgerEntryNo, LedgerEntry."Remaining Quantity");

        if TrackingEntryNo = 0 then begin
            CreateTrackingRow(JournalLine, LedgerEntry, JournalLine."Quantity (Base)");
            exit;
        end;

        ExistingTracking.Get(TrackingEntryNo, false);
        ExistingTracking.Validate("Appl.-to Item Entry", LedgerEntryNo);
        ExistingTracking.Modify(true);
    end;

    internal procedure GetJournalLine(
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

    internal procedure CheckJournalLine(JournalLine: Record "Item Journal Line")
    begin
        JournalLine.TestField("Entry Type", JournalLine."Entry Type"::"Negative Adjmt.");
        JournalLine.TestField("Item No.");
        JournalLine.TestField("Applies-to Entry", 0);

        if (JournalLine."Quantity (Base)" <= 0) or
           (JournalLine."Qty. per Unit of Measure" <= 0)
        then
            Error('Journal line %1 needs a positive quantity and a valid unit of measure.', JournalLine."Line No.");
    end;

    internal procedure FindExistingTracking(
        JournalLine: Record "Item Journal Line";
        LedgerEntry: Record "Item Ledger Entry";
        QuantityBase: Decimal;
        RowNo: Integer;
        var AlreadyApplied: Boolean): Integer
    var
        Tracking: Record "Reservation Entry";
    begin
        AlreadyApplied := false;
        Tracking.SetRange("Source Type", Database::"Item Journal Line");
        Tracking.SetRange("Source Subtype", JournalLine."Entry Type".AsInteger());
        Tracking.SetRange("Source ID", JournalLine."Journal Template Name");
        Tracking.SetRange("Source Batch Name", JournalLine."Journal Batch Name");
        Tracking.SetRange("Source Ref. No.", JournalLine."Line No.");
        if Tracking.IsEmpty() then
            exit(0);

        Tracking.SetFilter(
            "Reservation Status", '%1|%2',
            Tracking."Reservation Status"::Surplus,
            Tracking."Reservation Status"::Prospect);
        Tracking.SetRange(Positive, false);
        Tracking.SetRange("Item No.", JournalLine."Item No.");
        Tracking.SetRange("Variant Code", JournalLine."Variant Code");
        Tracking.SetRange("Location Code", JournalLine."Location Code");
        Tracking.SetRange("Lot No.", LedgerEntry."Lot No.");
        Tracking.SetRange("Serial No.", LedgerEntry."Serial No.");
        Tracking.SetRange("Package No.", LedgerEntry."Package No.");
        Tracking.SetRange("Quantity (Base)", -QuantityBase);

        if not Tracking.FindFirst() then
            Error(
                '%1 has no matching tracking row for ledger entry %2 (lot %3, serial %4, package %5, base quantity %6).',
                ApplicationSource(JournalLine, RowNo), LedgerEntry."Entry No.", LedgerEntry."Lot No.",
                LedgerEntry."Serial No.", LedgerEntry."Package No.", QuantityBase);

        if Tracking.Count() > 1 then
            Error('%1 matches multiple tracking rows.', ApplicationSource(JournalLine, RowNo));

        AlreadyApplied := Tracking."Appl.-to Item Entry" <> 0;
        exit(Tracking."Entry No.");
    end;

    local procedure ApplicationSource(JournalLine: Record "Item Journal Line"; RowNo: Integer): Text
    begin
        if RowNo = 0 then
            exit(StrSubstNo('Journal line %1', JournalLine."Line No."));
        exit(StrSubstNo('CSV row %1 for journal line %2', RowNo, JournalLine."Line No."));
    end;

    internal procedure CheckLedgerEntry(
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
                '%1 requires an open inbound entry for the same item, variant, and location.',
                ApplicationSource(JournalLine, RowNo));

        if (LedgerEntry."Lot No." = '') and
           (LedgerEntry."Serial No." = '') and
           (LedgerEntry."Package No." = '')
        then
            Error('%1 refers to an entry with no tracking numbers.', ApplicationSource(JournalLine, RowNo));

        if (LedgerEntry."Serial No." <> '') and (QuantityBase <> 1) then
            Error('%1 must have a base quantity of 1 for a serial number.', ApplicationSource(JournalLine, RowNo));
    end;

    internal procedure CreateTrackingRow(
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
