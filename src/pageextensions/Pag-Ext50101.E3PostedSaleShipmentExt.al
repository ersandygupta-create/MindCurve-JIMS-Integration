pageextension 50101 "E3 Posted Sales Ship Ext" extends "Posted Sales Shipments"
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
                ToolTip = 'Sends the selected posted sales shipment data to HIS.';

                trigger OnAction()
                var
                    HISIntegrationMgt: Codeunit "E3 Sale Shipment Cons. Mgmt.";
                begin
                    // Validate selected shipment
                    if Rec."No." = '' then
                        Error('Posted Sales Shipment No. cannot be blank.');
                    HISIntegrationMgt.SendSaleShipmentDetails(Rec."No.");

                    Message(
                        'Posted Sales Shipment %1 has been sent to HIS.',
                        Rec."No.");
                end;
            }
        }
    }
}
