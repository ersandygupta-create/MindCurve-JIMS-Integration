pageextension 50057 "E3 HIS Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the transaction type of the document.';
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Responsibility Center of the document.';
            }
            field("E3 Send E-Mail"; Rec."E3 Send E-Mail")
            {
                ApplicationArea = all;
                Caption = 'Send E-mail';
                ToolTip = 'Send E-mail';
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Order Date of the document.';
            }
            field("Make Name"; Rec."Make Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Make Name of the document.';
            }
            field("No. of Archived Versions"; Rec."No. of Archived Versions")
            {
                ApplicationArea = All;
            }
            field("Advance PO Count"; Rec."Advance PO Count")
            {
                ApplicationArea = All;
            }
            field("Net Amount"; Rec."Net Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Net Amount of the document.';
            }
        }
        addbefore("No.")
        {

            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the voucher type.';
            }
            field("GRN Voucher Type Name"; Rec."GRN Voucher Type Name")
            {
                ApplicationArea = All;
                Caption = 'Voucher Type Name';
                ToolTip = 'Specifies the name of the GRN voucher type.';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("View Approval Entries")
            {
                ApplicationArea = All;
                Caption = 'Approval History';
                ToolTip = 'View approval entries for the selected purchase order.';
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Document No.", Rec."No.");

                    Page.Run(Page::"Approval Entries", ApprovalEntry);
                end;
            }
            action("Send Order E-Mail")
            {
                ApplicationArea = All;
                Caption = 'Send Order E-Mail';
                Image = Email;
                ToolTip = 'Sends the selected purchase orders by email.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    OrderAutoEmail: Codeunit "E3 Purchase Order Auto E-Mail";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    if PurchaseHeader.FindSet() then
                        repeat
                            if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
                                Error(
                                    'Document %1 is not a Purchase Order.',
                                    PurchaseHeader."No.");
                            if PurchaseHeader."E3 Send E-Mail" then
                                Error(
                                    'Purchase Order %1 mail already sent.',
                                    PurchaseHeader."No.");

                            OrderAutoEmail.SendMailforPurchaseOrderJob(
                                PurchaseHeader);
                        until PurchaseHeader.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
            action("View PO Cancel Entries")
            {
                ApplicationArea = All;
                Caption = 'PO Cancel History';
                ToolTip = 'View PO Cancel entries for the selected purchase order.';
                Image = Approvals;

                trigger OnAction()
                var
                    POCancelEntry: Record "E3 Cancel PO Lines";
                begin
                    POCancelEntry.Reset();
                    POCancelEntry.SetRange("Document No.", Rec."No.");
                    Page.Run(Page::"E3 Cancel PO Lines", POCancelEntry);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());

        if not UserSetup."Purchase Order" then
            Error(
                'You do not have permission to open Purchase Order.');
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalculateGSTAmount();
        Rec.UpdateItemMakeName();
    end;


}