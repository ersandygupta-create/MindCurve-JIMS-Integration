pageextension 50110 "E3 Purchase Return Order List" extends "Purchase Return Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(SendPurchaseReturnOrderEmail)
            {
                Caption = 'Send Purchase Return Order E-Mail';
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Send the selected purchase return order by e-mail.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    OrderAutoEmail: Codeunit "E3 Purch Ret. Order E-Mail";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    if PurchaseHeader.FindSet() then
                        repeat
                            if PurchaseHeader."Document Type" <>
                                PurchaseHeader."Document Type"::"Return Order"
                            then
                                Error(
                                    'Document %1 is not a Purchase Return Order.',
                                    PurchaseHeader."No.");

                            if PurchaseHeader."E3 Send E-Mail" then
                                Error(
                                    'Purchase Return Order %1 mail already sent.',
                                    PurchaseHeader."No.");

                            OrderAutoEmail.SendMailforPurchaseReturnOrderJob(
                                PurchaseHeader);

                        until PurchaseHeader.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
        }
    }
}