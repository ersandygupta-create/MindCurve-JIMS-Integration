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
                    //Editable = false;
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
                field("Item Group"; Rec."Item Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Item Group field.';
                }
                field("Medicine Group"; Rec."Medicine Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Medicine Group field.';
                }
                field("Medicine Company"; Rec."Medicine Company")
                {
                    ApplicationArea = All;
                    Caption = 'Marketing Company';
                    ToolTip = 'Specifies the value of Medicine Company field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field("Sub Group Nature"; Rec."Sub Group Nature")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Sub Group Nature field.';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                    Caption = 'Medicine Company';
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
                    Editable = false;
                    ToolTip = 'Specifies the value of Material Type field.';
                }
                field("Medicine Composition Code"; Rec."Medicine Composition Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Composition Code field.';
                }
                field("Sub Group Site"; Rec."Sub Group Site")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Sub Group Site field.';
                }
                field("Property List"; Rec."Property List")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Property List field.';
                }
                field("Tolerance excess"; Rec."Tolerance excess")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Tolerance Excess field.';
                }
                field("Tolerance Shortage"; Rec."Tolerance Shortage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Tolerance Shortage field.';
                }
                field("Margin Fix"; Rec."Margin Fix")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Margin Fix field.';
                }
                field("Manual Code"; Rec."Manual Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Manual Code field.';
                }
                field("Strength Code"; Rec."Strength Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Strength Code.';
                }
                field("Item Group Code"; Rec."Item Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Group Code.';
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Caption = 'Medicine Company Code';
                    ToolTip = 'Specifies the Item Make Code.';
                }
                field("Composition Code"; Rec."Composition Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Composition Code.';
                }
                field("Sub Category Code"; Rec."Sub Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sub Category Code.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Category Code.';
                }
                field("ManufacturerCode"; Rec."ManufacturerCode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Manufacturer Code.';
                }
                field("Marketing Company Code"; Rec."Marketing Company Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Marketing Company Code.';
                }
                field("Material Type Code"; Rec."Material Type Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Material Type Code.';
                }
                field("Material Category Code"; Rec."Material Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Material Category Code.';
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
                field("Quotation Required"; Rec."Quatation Required")
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
                field("Filter Item Type"; Rec."Filter Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Filter Item Type field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Remarks field.';
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
            }
        }
        addafter(SendToJIMS)
        {
            action(SyncLog)
            {
                ApplicationArea = All;
                Caption = 'Item Sync Log';
                ToolTip = 'View Item Sync Log.';
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "E3 API Item Update Log";
                RunPageLink = "No." = field("No.");
                RunPageMode = View;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Base Unit of Measure");
        exit(true);
    end;

}