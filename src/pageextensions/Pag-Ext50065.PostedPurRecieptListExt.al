pageextension 50065 "Posted Pur Receipt List Ext" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Location Code")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Posting Description';
                ToolTip = 'Specifies a posting description of the order.';
            }
            field("Purchase Invoice No"; Rec."Purchase Invoice No")
            {
                ApplicationArea = all;
                ToolTip = 'Purchase Invoice No.';
            }
            field("Purchase Invoice Created"; Rec."Purchase Invoice Created")
            {
                ApplicationArea = all;
                ToolTip = 'Purchase Invoice Created';
            }
        }

    }

    actions
    {
        addlast(processing)
        {
            action(CreateInvoicesForSelected)
            {
                ApplicationArea = All;
                Caption = 'Create Invoices for Selected';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generates Purchase Invoices for the selected Posted Purchase Receipt records.';

                trigger OnAction()
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                    GRNInvoiceMgmt: Codeunit "E3 GRN Invoice Management";
                begin
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    GRNInvoiceMgmt.CreateInvoicesFromSelectedReceipts(PurchRcptHeader);
                end;
            }
            action(CleanupData)
            {
                ApplicationArea = All;
                Caption = 'Cleanup Data';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Cleanup Data';

                trigger OnAction()
                var
                    GRNInvoiceMgmt: Codeunit "E3 Invoice Cleanup Management";
                begin
                    GRNInvoiceMgmt.DeleteAllPurchaseInvoicesForcefully();
                end;
            }
        }
    }
}