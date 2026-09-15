pageextension 50106 "E3 Posted Sales Invoice Card" extends 132
{
    layout
    {
        addafter("No.")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Purchase Order No.';
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

                    // 2. Execute Purchase Order Creation Logic
                    CreateMgmt.CreatePurchaseOrderFromSalesInvoice(Rec);
                end;
            }
        }
    }

}