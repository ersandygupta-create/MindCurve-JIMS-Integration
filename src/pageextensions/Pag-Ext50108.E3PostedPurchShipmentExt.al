pageextension 50108 "E3 Posted Purch. Ship Ext" extends "Posted Return Shipments"
{
    actions
    {
        addlast(Processing)
        {
            action(SendToHIS)
            {
                ApplicationArea = All;
                Caption = 'Send to HIS';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Sends the selected posted sPosted Return Shipments data to HIS.';

                trigger OnAction()
                var
                    HISIntegrationMgt: Codeunit "E3 Purch. Shipment Cons. Mgmt.";
                begin
                    // Validate selected shipment
                    if Rec."No." = '' then
                        Error('Posted Return Shipments No. cannot be blank.');
                    HISIntegrationMgt.SendPurchaseShipmentDetails(Rec."No.");

                    Message(
                        'Posted Return Shipments %1 has been sent to HIS.',
                        Rec."No.");
                end;
            }
        }
    }
}
