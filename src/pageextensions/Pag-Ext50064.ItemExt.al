pageextension 50064 "Item Ext" extends "Item Card"
{
    layout
    {
        addlast(content)
        {
            group("JIMS Attributes")
            {
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Item Type field.';
                }
                field("Material Category"; Rec."Material Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Meterial Category field.';
                }
                field(Strength; Rec.Strength)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Strength field.';
                }
                field("Medicine Group"; Rec."Medicine Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Group field.';
                }
                field("Medicine Company"; Rec."Medicine Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Company field.';
                }
                field("Rate Margin Fix"; Rec."Rate Margin Fix")
                {
                    ApplicationArea = All;
                    Caption = 'Rate/Margin Fix';
                    ToolTip = 'Specifies the value of Rate Margin Fix field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Model field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Category field.';
                }
                field("Medicine SubCategory"; Rec."Medicine SubCategory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine SubCategory field.';
                }
                field("Medicine Manufacturer"; Rec."Medicine Manufacturer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Manufacturer field.';
                }
                field("Res. Group"; Rec."Res. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Res. Group field.';
                }
                field("Item Property"; Rec."Item Property")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Item Property field.';
                }
                field("Sub Group Nature"; Rec."Sub Group Nature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Sub Group Nature field.';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Make field.';
                }
                field("Medicine Component"; Rec."Medicine Component")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Component field.';
                }
                field(Speciality; Rec.Speciality)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Speciality field.';
                }
                field("Material Type"; Rec."Material Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Material Type field.';
                }
                field("Medicine Composition"; Rec."Medicine Composition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Composition field.';
                }
                field("Sub Group Site"; Rec."Sub Group Site")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Sub Group Site field.';
                }
            }
        }
        addafter("JIMS Attributes")
        {
            group("JIMS Other Attributes")
            {

                field(Packing; Rec.Packing)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Packing field.';
                }
                field(Scheme; Rec.Scheme)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Scheme field.';
                }
                field("Narcotics Control Substances"; Rec."Narcotics Control Substances")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Narcotics Control Substances field.';
                }
                field("Incl Free Qty in Sale Rate"; Rec."Incl Free Qty in Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Incl Free Qty in Sale Rate field.';
                }
                field("Sale Discount Allow"; Rec."Sale Discount Allow")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Sale Discount Allow field.';
                }
                field("Sale Rate Editable"; Rec."Sale Rate Editable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Sale Rate Editable field.';
                }
                field("Allow MRP Discount"; Rec."Allow MRP Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Allow MRP Discount field.';
                }
                field("Consignment Item"; Rec."Consignment Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Consignment Item field.';
                }
                field("Sale Returnable Item"; Rec."Sale Returnable Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Sale Returnable Item field.';
                }
                field("Quatation Required"; Rec."Quatation Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Quatation Required field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Active field.';
                }
                field("BarCode Active"; Rec."BarCode Active")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of BarCode Active field.';
                }

            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            group("ItemSend")
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
                        E3IntegrationMgmt: Codeunit "E3 Item Integration Mgmt.";
                        ItemRec: Record Item;
                    begin
                        // Get the vendor record for this address
                        if ItemRec.Get(Rec."No.") then
                            E3IntegrationMgmt.ManualSendToJIMS(ItemRec);
                    end;
                }
                action(SyncLog)
                {
                    Caption = 'Item Sync Logs';
                    ToolTip = 'JIMS System Sync Logs.';
                    Image = Log;
                    ApplicationArea = all;
                    RunObject = page "E3 API Item Update Log";
                    RunPageLink = "No." = field("No.");
                    RunPageMode = View;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Base Unit of Measure");
        exit(true);
    end;

}