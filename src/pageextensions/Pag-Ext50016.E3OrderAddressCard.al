pageextension 50016 "E3 Order Address Card" extends "Order Address"
{
    layout
    {
        addlast(General)
        {
            field("E3 NPU"; Rec."E3 NPU")
            {
                ToolTip = 'Specifies the value of the NPU field.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            group("SupplierSend")
            {
                Caption = 'Integration';
                Image = SendTo;

                action(SendToJIMS)
                {
                    ApplicationArea = all;
                    Caption = 'Send to JIMS';
                    ToolTip = 'Send to JIMS';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = SendTo;
                    trigger OnAction()
                    var
                        E3IntegrationMgmt: Codeunit "E3 Supplier Integration Mgmt.";
                        VendRec: Record Vendor;
                    begin
                        // Get the vendor record for this address
                        if VendRec.Get(Rec."Vendor No.") then
                            E3IntegrationMgmt.ManualSendToHIS(Rec);
                    end;
                }
                action(SyncLog)
                {
                    Caption = 'JIMS Sync Logs';
                    ToolTip = 'JIMS System Sync Logs.';
                    Image = Log;
                    ApplicationArea = all;
                    RunObject = page "E3 API Supplier Update Logs";
                    RunPageLink = "No." = field("Vendor No.");
                    RunPageMode = View;
                }
            }
        }
    }
}
