page 50035 "E3 API Item Update Log"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "E3 API Item Update Log";
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    Caption = 'E3 API Item Update Log';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'Code';
                }
                field("No. 2"; Rec."No. 2")
                {
                    ToolTip = 'Specifies the value of the No. 2 field.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Name';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                    Caption = 'Display Name';
                }
                field("Manual Code"; Rec."Manual Code")
                {
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Caption = 'Item Type';
                }
                field(SkuName; Rec.SkuName)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.';
                }
                field("Price Unit Conversion"; Rec."Price Unit Conversion")
                {
                    ToolTip = 'Specifies the value of the Price Unit Conversion field.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ToolTip = 'Specifies the value of the Inventory Posting Group field.';
                }
                field("Sales Unit of Measure"; Rec."Sales Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Sales Unit of Measure field.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Purch. Unit of Measure field.';
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ToolTip = 'Specifies the value of the GST Group Code field.';
                }
                field("E3 Item Type"; Rec."E3 Item Type")
                {
                    ToolTip = 'Specifies the value of the E3 Item Type field.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field("Material Category"; Rec."Material Category")
                {
                    ToolTip = 'Specifies the value of the Material Category field.';
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.';
                }
                field(Strength; Rec.Strength)
                {
                    ToolTip = 'Specifies the value of the Strength field.';
                }
                field("Medicine Group"; Rec."Medicine Group")
                {
                    ToolTip = 'Specifies the value of the Medicine Group field.';
                }
                field("Rate Margin Fix"; Rec."Rate Margin Fix")
                {
                    ToolTip = 'Specifies the value of the Rate Margin Fix field.';
                }
                field("Medicine Manufacturer"; Rec."Medicine Manufacturer")
                {
                    ToolTip = 'Specifies the value of the Medicine Manufacturer field.';
                }
                field("Medicine Company"; Rec."Medicine Company")
                {
                    ToolTip = 'Specifies the value of the Medicine Company field.';
                }
                field(Packing; Rec.Packing)
                {
                    ToolTip = 'Specifies the value of the Packing field.';
                }
                field(Scheme; Rec.Scheme)
                {
                    ToolTip = 'Specifies the value of the Scheme field.';
                }
                field("Res. Group"; Rec."Res. Group")
                {
                    ToolTip = 'Specifies the value of the Res. Group field.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ToolTip = 'Specifies the value of the Item Type field.';
                }
                field("Medicine SubCategory"; Rec."Medicine SubCategory")
                {
                    ToolTip = 'Specifies the value of the Medicine SubCategory field.';
                }
                field("Sub Group Nature"; Rec."Sub Group Nature")
                {
                    ToolTip = 'Specifies the value of the Sub Group Nature field.';
                }
                field(Make; Rec.Make)
                {
                    ToolTip = 'Specifies the value of the Make field.';
                }
                field("Medicine Component"; Rec."Medicine Component")
                {
                    ToolTip = 'Specifies the value of the Medicine Component field.';
                }
                field(Speciality; Rec.Speciality)
                {
                    ToolTip = 'Specifies the value of the Speciality field.';
                }
                field("Material Type"; Rec."Material Type")
                {
                    ToolTip = 'Specifies the value of the Material Type field.';
                }
                field("Medicine Composition"; Rec."Medicine Composition")
                {
                    ToolTip = 'Specifies the value of the Medicine Composition field.';
                }
                field("Sub Group Site"; Rec."Sub Group Site")
                {
                    ToolTip = 'Specifies the value of the Sub Group Site field.';
                }
                field("Incl Free Qty in Sale Rate"; Rec."Incl Free Qty in Sale Rate")
                {
                    ToolTip = 'Specifies the value of the Incl Free Qty in Sale Rate field.';
                }
                field("Sale Discount Allow"; Rec."Sale Discount Allow")
                {
                    ToolTip = 'Specifies the value of the Sale Discount Allow field.';
                }
                field("Sale Rate Editable"; Rec."Sale Rate Editable")
                {
                    ToolTip = 'Specifies the value of the Sale Rate Editable field.';
                }
                field("Allow MRP Discount"; Rec."Allow MRP Discount")
                {
                    ToolTip = 'Specifies the value of the Allow MRP Discount field.';
                }
                field("Consignment Item"; Rec."Consignment Item")
                {
                    ToolTip = 'Specifies the value of the Consignment Item field.';
                }
                field("Sale Returnable Item"; Rec."Sale Returnable Item")
                {
                    ToolTip = 'Specifies the value of the Sale Returnable Item field.';
                }
                field("Quatation Required"; Rec."Quatation Required")
                {
                    ToolTip = 'Specifies the value of the Quatation Required field.';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("BarCode Active"; Rec."BarCode Active")
                {
                    ToolTip = 'Specifies the value of the BarCode Active field.';
                }
                field("Narcotics Control Substances"; Rec."Narcotics Control Substances")
                {
                    ToolTip = 'Specifies the value of the Narcotics Control Substances field.';
                }
                field("Item Group"; Rec."Item Group")
                {
                    ToolTip = 'Specifies the value of the Item Group field.';
                }
                field("Filter Item Type"; Rec."Filter Item Type")
                {
                    ToolTip = 'Specifies the value of the Filter Item Type field.';
                }
                field("Tolerance excess"; Rec."Tolerance excess")
                {
                    ToolTip = 'Specifies the value of the Tolerance excess field.';
                    Caption = 'tl_ExcessPer';
                }
                field("Tolerance Shortage"; Rec."Tolerance Shortage")
                {
                    ToolTip = 'Specifies the value of the Tolerance Shortage field.';
                    Caption = 'tl_ShortagePer';
                }
                field("Margin Fix"; Rec."Margin Fix")
                {
                    ToolTip = 'Specifies the value of the Margin Fix field.';
                }
                field("Property List"; Rec."Property List")
                {
                    ToolTip = 'Specifies the value of the Property List field.';
                }
                field("Unique Log No."; Rec."Unique Log No.")
                {
                    ToolTip = 'Specifies the value of the Unique Log No. field.';
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ToolTip = 'Specifies the value of the Sync Status field.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Specifies the value of the Error Message field.';

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Sync)
            {
                Caption = 'Sync';
                ApplicationArea = All;
                Image = Link;
                ToolTip = 'Executes the Sync action.';
                trigger OnAction()
                var
                    E3AkhilMgmt: Codeunit "E3 Item Integration Mgmt.";
                begin
                    Clear(E3AkhilMgmt);
                    E3AkhilMgmt.SendItemDetails(Rec);
                    Rec.Modify(false);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}