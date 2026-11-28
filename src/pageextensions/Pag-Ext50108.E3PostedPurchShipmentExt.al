pageextension 50108 "E3 Posted Purch. Ship Ext" extends "Posted Return Shipments"
{
    layout
    {
        addafter("Location Code")
        {
            field(IsSent; Rec.IsSent)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the record has been successfully sent to the HIS system.';
            }
            field(Response; Rec.Response)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the response received from the HIS system after processing the API request.';
            }
        }
    }
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

                    if not Rec.Sync then
                        Error('Purchase Return %1 cannot be sent because Sync Boolean is False.', Rec."No.");

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
