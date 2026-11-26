pageextension 50116 "E3 Posted Purch. CM List Ext" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field(AmountIncludingGST; AmountIncludingGST)
            {
                ApplicationArea = All;
                Caption = 'Amount Including GST';
                Editable = false;
                ToolTip = 'Specifies the posted credit memo amount including VAT and GST.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Amount Including VAT");
        AmountIncludingGST := Rec."Amount Including VAT" + GetPostedGSTAmount();
    end;

    var
        AmountIncludingGST: Decimal;

    local procedure GetPostedGSTAmount(): Decimal
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        Currency: Record Currency;
        GSTAmount: Decimal;
    begin
        DetailedGSTLedgerEntry.SetRange(
            "Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Purchase);
        DetailedGSTLedgerEntry.SetRange(
            "Document Type", DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SetRange("Document No.", Rec."No.");
        DetailedGSTLedgerEntry.CalcSums("GST Amount");

        GSTAmount := DetailedGSTLedgerEntry."GST Amount";

        // Match the GST sign to the displayed credit memo amount.
        if Rec."Amount Including VAT" < 0 then
            GSTAmount := -Abs(GSTAmount)
        else
            GSTAmount := Abs(GSTAmount);

        if (Rec."Currency Code" <> '') and (Rec."Currency Factor" <> 0) then begin
            Currency.Get(Rec."Currency Code");
            GSTAmount := Round(
                GSTAmount * Rec."Currency Factor",
                Currency."Amount Rounding Precision");
        end;

        exit(GSTAmount);
    end;
}