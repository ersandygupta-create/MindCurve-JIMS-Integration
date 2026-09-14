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
                TempReservEntry: Record "Reservation Entry" temporary;
                ItemTrackingSummaryPage: Page "Item Tracking Summary";
                CreateReservEntry: Codeunit "Create Reserv. Entry";
                NextEntryNo: Integer;
            begin
                TestField(Type, Type::Item);
                TestField("No.");
                TestField(Quantity);

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

                // Initialize temporary reservation entry context for Page 6500 signature
                TempReservEntry.Init();
                TempReservEntry."Item No." := Rec."No.";
                TempReservEntry."Location Code" := Rec."Location Code";
                TempReservEntry."Variant Code" := Rec."Variant Code";

                Clear(ItemTrackingSummaryPage);
                ItemTrackingSummaryPage.SetSources(TempReservEntry, TempEntrySummary);
                ItemTrackingSummaryPage.LookupMode(true);

                if ItemTrackingSummaryPage.RunModal() = ACTION::LookupOK then begin
                    ItemTrackingSummaryPage.GetRecord(TempEntrySummary);

                    // 1. Assign values back to Sales Line
                    Rec.Validate("Batch No.", TempEntrySummary."Lot No.");

                    if TempEntrySummary."Expiration Date" <> 0D then
                        Rec."Expiry Date" := TempEntrySummary."Expiration Date";

                    // 2. Create or Update Item Tracking Line (Reservation Entry)
                    CreateOrUpdateItemTracking(Rec, TempEntrySummary."Lot No.", TempEntrySummary."Expiration Date", rec.Quantity);
                end;
            end;
        }
        field(50006; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }

    }
    local procedure CreateOrUpdateItemTracking(SalesLine: Record "Sales Line"; LotNo: Code[50]; ExpiryDate: Date; AvailableQty: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        QtyToAssign: Decimal;
        QtyToAssignBase: Decimal;
    begin
        // Calculate quantities to assign
        QtyToAssign := AvailableQty;
        QtyToAssignBase := QtyToAssign * SalesLine."Qty. per Unit of Measure";

        // 1. Set tracking attributes directly on the Reservation Entry record
        ReservEntry.Init();
        ReservEntry."Lot No." := LotNo;
        ReservEntry."Expiration Date" := ExpiryDate;

        // 2. Initialize tracking context for the Sales Line
        CreateReservEntry.CreateReservEntryFor(
            Database::"Sales Line",
            SalesLine."Document Type".AsInteger(),
            SalesLine."Document No.",
            '',
            0,
            SalesLine."Line No.",
            SalesLine."Qty. per Unit of Measure",
            QtyToAssign,
            QtyToAssignBase,
            ReservEntry
        );

        // 3. Insert record into Table 337 (Reservation Entry)
        CreateReservEntry.CreateEntry(
            SalesLine."No.",
            SalesLine."Variant Code",
            SalesLine."Location Code",
            SalesLine.Description,
            SalesLine."Shipment Date",
            SalesLine."Shipment Date",
            0,
            Enum::"Reservation Status"::Surplus
        );
    end;
}