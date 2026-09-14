tableextension 50074 E3SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50001; "Stock No"; Code[50])
        {
            Caption = 'Stock No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50002; "Stock Line No"; Integer)
        {
            Caption = 'Stock Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50003; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(50004; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50005; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TempEntrySummary: Record "Entry Summary" temporary;
                TempReservEntry: Record "Reservation Entry" temporary; // 1. Declare temp Reservation Entry
                ItemTrackingSummaryPage: Page "Item Tracking Summary";
                NextEntryNo: Integer;
            begin
                TestField(Type, Type::Item);
                TestField("No.");

                // Clear and apply filters on Item Ledger Entry
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Item No.", Rec."No.");

                if Rec."Location Code" <> '' then
                    ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");

                if Rec."Variant Code" <> '' then
                    ItemLedgerEntry.SetRange("Variant Code", Rec."Variant Code");

                ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
                ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');

                // Aggregate stock lot-wise
                if ItemLedgerEntry.FindSet() then
                    repeat
                        TempEntrySummary.Reset();
                        TempEntrySummary.SetRange("Lot No.", ItemLedgerEntry."Lot No.");

                        if TempEntrySummary.FindFirst() then begin
                            TempEntrySummary."Total Quantity" += ItemLedgerEntry."Remaining Quantity";
                            TempEntrySummary."Total Available Quantity" += ItemLedgerEntry."Remaining Quantity";
                            TempEntrySummary.Modify();
                        end else begin
                            NextEntryNo += 1;
                            TempEntrySummary.Init();
                            TempEntrySummary."Entry No." := NextEntryNo;
                            TempEntrySummary."Table ID" := Database::"Sales Line";
                            TempEntrySummary."Lot No." := ItemLedgerEntry."Lot No.";
                            TempEntrySummary."Expiration Date" := ItemLedgerEntry."Expiration Date";
                            TempEntrySummary."Total Quantity" := ItemLedgerEntry."Remaining Quantity";
                            TempEntrySummary."Total Available Quantity" := ItemLedgerEntry."Remaining Quantity";
                            TempEntrySummary.Insert();
                        end;
                    until ItemLedgerEntry.Next() = 0;

                TempEntrySummary.Reset();

                if TempEntrySummary.IsEmpty() then
                    Error('No available inventory found for Item %1 at Location %2.', Rec."No.", Rec."Location Code");

                // 2. Initialize dummy reservation context required by Page 6500 signature
                TempReservEntry.Init();
                TempReservEntry."Item No." := Rec."No.";
                TempReservEntry."Location Code" := Rec."Location Code";
                TempReservEntry."Variant Code" := Rec."Variant Code";

                // 3. Pass BOTH required parameters to SetSources
                Clear(ItemTrackingSummaryPage);
                ItemTrackingSummaryPage.SetSources(TempReservEntry, TempEntrySummary);
                ItemTrackingSummaryPage.LookupMode(true);

                if ItemTrackingSummaryPage.RunModal() = ACTION::LookupOK then begin
                    ItemTrackingSummaryPage.GetRecord(TempEntrySummary);

                    // Assign values back to Sales Line
                    Rec.Validate("Batch No.", TempEntrySummary."Lot No.");

                    if TempEntrySummary."Expiration Date" <> 0D then
                        Rec."Expiry Date" := TempEntrySummary."Expiration Date";
                end;
            end;
        }
        field(50006; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }

    }


}