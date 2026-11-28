pageextension 50105 "E3 Posted Sales Invoice" extends 143
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
                ToolTip = 'Specifies the posted sales invoice amount including VAT and GST.';
            }
            field(IsSent; Rec.IsSent)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Issent';
            }
            field(Response; Rec.Response)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Response from api';
            }
        }
    }
    actions
    {
        addafter(ActivityLog)
        {
            action(CreatePurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Order';
                Image = CreatePO;
                ToolTip = 'Create a Purchase Order based on this Sales Invoice.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateMgmt: Codeunit "E3 Create PO Management";
                begin
                    // 1. Validate that Voucher Type is populated
                    Rec.TestField("Voucher Type");
                    if (rec."Purchase Order Created" = false) then
                        // 2. Execute Purchase Order Creation Logic
                        CreateMgmt.CreatePurchaseOrderFromSalesInvoice(Rec)
                    else
                        Message('Purchase Order already created.');
                end;
            }
            action(SendToHIS)
            {
                ApplicationArea = All;
                Caption = 'Send to HIS';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Sends the selected posted sales Invoice data to HIS.';

                trigger OnAction()
                var
                    HISIntegrationMgt: Codeunit "E3 Sale Invoice Cons. Mgmt.";
                begin
                    Rec.TestField("No.");
                    if not Rec.Sync then
                        Error('Sales %1 cannot be sent because Sync Boolean is False.', Rec."No.");


                    if not Confirm(
                         StrSubstNo('Do you want to send Invoice %1 to the DB?', Rec."No."))
                    then
                        exit;

                    if HISIntegrationMgt.SendSaleInvoiceDetails(Rec."No.") then begin
                        Message('Sale %1 has been sent successfully.', Rec."No.");
                        CurrPage.Update(true);
                    end else
                        Error('Failed to send Sale %1. Please check the Response field.', Rec."No.");
                end;
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
            "Document Type", DetailedGSTLedgerEntry."Document Type"::Invoice);
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