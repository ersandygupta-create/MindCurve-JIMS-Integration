pageextension 50115 "E3 Posted Purch. Invoices Ext" extends "Posted Purchase Invoices"
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
                ToolTip = 'Specifies the invoice amount including VAT plus posted GST.';
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
        DetailedGSTLedgerEntry.SetRange("Transaction Type",
            DetailedGSTLedgerEntry."Transaction Type"::Purchase);
        DetailedGSTLedgerEntry.SetRange("Document Type",
            DetailedGSTLedgerEntry."Document Type"::Invoice);
        DetailedGSTLedgerEntry.SetRange("Document No.", Rec."No.");
        DetailedGSTLedgerEntry.CalcSums("GST Amount");

        GSTAmount := DetailedGSTLedgerEntry."GST Amount";

        if (Rec."Currency Code" <> '') and (Rec."Currency Factor" <> 0) then begin
            Currency.Get(Rec."Currency Code");
            GSTAmount := Round(GSTAmount * Rec."Currency Factor",
                Currency."Amount Rounding Precision");
        end;

        exit(GSTAmount);
    end;
}