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
                    Rec.TestField("No.");

                    if not Confirm(
                         StrSubstNo('Do you want to send GRN %1 to the DB?', Rec."No."))
                    then
                        exit;

                    if HISIntegrationMgt.SendSaleShipmentDetails(Rec."No.") then begin
                        Message('Sale %1 has been sent successfully.', Rec."No.");
                        CurrPage.Update(true);
                    end else
                        Error('Failed to send Sale %1. Please check the Response field.', Rec."No.");
                end;
            }
        }
    }
}
