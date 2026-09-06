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
        }
    }
    actions
    {
        addlast(Processing)
        {
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
                            OrderAutoEmail.SendMailforPurchaseOrderJob(
                                PurchaseHeader);
                        until PurchaseHeader.Next() = 0;

                    CurrPage.Update(false);
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
}