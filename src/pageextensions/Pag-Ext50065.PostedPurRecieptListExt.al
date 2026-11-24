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
                    PurchRcptHeader2: Record "Purch. Rcpt. Header";
                    GRNInvoiceMgmt: Codeunit "E3 GRN Invoice Management";
                    FirstBUCode: Code[20];
                begin
                    CurrPage.SetSelectionFilter(PurchRcptHeader);

                    if not PurchRcptHeader.FindSet() then
                        Error('Please select at least one Posted Purchase Receipt.');

                    // Get first selected receipt Business Unit
                    FirstBUCode := PurchRcptHeader."Shortcut Dimension 1 Code";

                    // Validate all selected receipts
                    repeat
                        if PurchRcptHeader."Shortcut Dimension 1 Code" <> FirstBUCode then
                            Error(
                                'You cannot create Purchase Invoices for different Business Units. Please select receipts belonging to the same Business Unit.');
                    until PurchRcptHeader.Next() = 0;

                    // Create invoices after successful validation
                    Clear(PurchRcptHeader);
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
                Visible = false;
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
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Purchase Resp. Ctr. Filter" <> '' then
                Rec.SetFilter(
                    "Responsibility Center",
                    UserSetup."Purchase Resp. Ctr. Filter");
    end;
}