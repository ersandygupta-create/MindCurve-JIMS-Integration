pageextension 50117 "E3 Posted Sales CM Ext" extends "Posted Sales Credit Memos"
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
                ToolTip = 'Specifies the posted sales credit memo amount including VAT and GST.';
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
            "Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
        DetailedGSTLedgerEntry.SetRange(
            "Document Type", DetailedGSTLedgerEntry."Document Type"::"Credit Memo");
        DetailedGSTLedgerEntry.SetRange("Document No.", Rec."No.");
        DetailedGSTLedgerEntry.CalcSums("GST Amount");

        GSTAmount := Abs(DetailedGSTLedgerEntry."GST Amount");
        if Rec."Amount Including VAT" < 0 then
            GSTAmount := -GSTAmount;

        if (Rec."Currency Code" <> '') and (Rec."Currency Factor" <> 0) then begin
            Currency.Get(Rec."Currency Code");
            GSTAmount := Round(
                GSTAmount * Rec."Currency Factor",
                Currency."Amount Rounding Precision");
        end;

        exit(GSTAmount);
    end;
}