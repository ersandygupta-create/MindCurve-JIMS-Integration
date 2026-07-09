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
                field("Sync Status"; Rec."Sync Status")
                {
                    ToolTip = 'Specifies the value of the Sync Status field.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    Caption = 'Response';
                    ToolTip = 'Specifies the value of the Error Message field.';
                }
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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
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
                    Visible = false;
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
                field("Sale Qty. Per Rate"; Rec."Sale Qty. Per Rate")
                {
                    ToolTip = 'Specifies the value of the Sale Qty. Per Rate field.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Purch. Unit of Measure field.';
                }
                field("Purch. Qty. Per Rate"; Rec."Purch. Qty. Per Rate")
                {
                    ToolTip = 'Specifies the value of the Purch. Qty. Per Rate field.';
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
                    Visible = false;
                }
                field("Medicine Manufacturer Code"; Rec."Medicine Manufacturer Code")
                {
                    ToolTip = 'Specifies the value of the Medicine Manufacturer Code field.';
                }
                field("Medicine Manufacturer Name"; Rec."Medicine Manufacturer Name")
                {
                    ToolTip = 'Specifies the value of the Medicine Manufacturer Name field.';
                }
                field("Medicine Company Code"; Rec."Medicine Company Code")
                {
                    ToolTip = 'Specifies the value of the Medicine Company field.';
                }
                field("Medicine Company Name"; Rec."Medicine Company Name")
                {
                    ToolTip = 'Specifies the value of the Medicine Company Name field.';
                }
                field(Packing; Rec.Packing)
                {
                    ToolTip = 'Specifies the value of the Packing field.';
                }
                field("Res. Group Code"; Rec."Res. Group Code")
                {
                    ToolTip = 'Specifies the value of the Res. Group Code field.';
                }
                field("Res. Group Name"; Rec."Res. Group Name")
                {
                    ToolTip = 'Specifies the value of the Res. Group Name field.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ToolTip = 'Specifies the value of the Item Type field.';
                }
                field("Medicine SubCategory Code"; Rec."Medicine SubCategory Code")
                {
                    ToolTip = 'Specifies the value of the Medicine SubCategory Code field.';
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
                field(SpecialityName; Rec."Speciality Name")
                {
                    ToolTip = 'Specifies the value of the Speciality Name field.';
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
                field("Filter Item Type Code"; Rec."Filter Item Type Code")
                {
                    ToolTip = 'Specifies the value of the Filter Item Type field.';
                }
                field("Filter Item Type Name"; Rec."Filter Item Type Name")
                {
                    ToolTip = 'Specifies the value of the Filter Item Type Name field.';
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
                field("Property List Code"; Rec."Property List Code")
                {
                    ToolTip = 'Specifies the value of the Property List Code field.';
                }
                field("Property List Name"; Rec."Property List Name")
                {
                    ToolTip = 'Specifies the value of the Property List Name field.';
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
                field("Manufacturer Code"; Rec."Manufacturer Code")
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
                    ToolTip = 'Specifies the Material Type Code.';
                }
                field("Material Category Code"; Rec."Material Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Material Category Code.';
                }
                field("Sales Unit of Measure Name"; Rec."Sales Unit of Measure Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales unit of measure name.';
                    Editable = false;
                }

                field("Purch. Unit of Measure Name"; Rec."Purch. Unit of Measure Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase unit of measure name.';
                    Editable = false;
                }

                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who prepared the item.';
                }

                field("HSN/SAC Type"; Rec."HSN/SAC Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN/SAC type.';
                    Editable = false;
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Maximum Retail Price.';
                }

                field("Sale Rate"; Rec."Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sale rate.';
                }

                field("Purchase Rate"; Rec."Purchase Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase rate.';
                }

                field("Purchase Discount %"; Rec."Purchase Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase discount percentage.';
                }

                field("Sale Discount %"; Rec."Sale Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sale discount percentage.';
                }
                field("Marketing Company Name"; Rec."Marketing Company Name")
                {
                    ApplicationArea = All;
                    Caption = 'Marketing Company Name';
                    ToolTip = 'Specifies the marketing company name associated with the item.';
                }

                field("Model Name"; Rec."Model Name")
                {
                    ApplicationArea = All;
                    Caption = 'Model Name';
                    ToolTip = 'Specifies the model name of the item.';
                }

                field("Medicine SubCategory Name"; Rec."Medicine SubCategory Name")
                {
                    ApplicationArea = All;
                    Caption = 'Medicine SubCategory Name';
                    ToolTip = 'Specifies the medicine subcategory name for the item.';
                }

                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = All;
                    Caption = 'Division Code';
                    ToolTip = 'Specifies the division code assigned to the item.';
                }

                field("Division Name"; Rec."Division Name")
                {
                    ApplicationArea = All;
                    Caption = 'Division Name';
                    ToolTip = 'Specifies the name of the division assigned to the item.';
                }

                field("Allow Negative Stock"; Rec."Allow Negative Stock")
                {
                    ApplicationArea = All;
                    Caption = 'Allow Negative Stock';
                    ToolTip = 'Specifies whether negative inventory is allowed for this item.';
                }

                field("Is Indent Mandatory"; Rec."Is Indent Mandatory")
                {
                    ApplicationArea = All;
                    Caption = 'Indent Mandatory';
                    ToolTip = 'Specifies whether an indent is mandatory before creating a purchase document.';
                }

                field("Is Common"; Rec."Is Common")
                {
                    ApplicationArea = All;
                    Caption = 'Common';
                    ToolTip = 'Specifies whether this item is classified as a common item.';
                }

                field("Scheme On Qty"; Rec."Scheme On Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Scheme On Qty';
                    ToolTip = 'Specifies the quantity on which the scheme is applicable.';
                }

                field("Scheme Free Qty"; Rec."Scheme Free Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Scheme Free Qty';
                    ToolTip = 'Specifies the free quantity provided under the scheme.';
                }

                field("Is Life Saving"; Rec."Is Life Saving")
                {
                    ApplicationArea = All;
                    Caption = 'Is Life Saving';
                    ToolTip = 'Specifies whether the item is classified as a life-saving item.';
                }

                field("Is High Value"; Rec."Is High Value")
                {
                    ApplicationArea = All;
                    Caption = 'High Value';
                    ToolTip = 'Specifies whether the item is classified as a high-value item.';
                }

                field("Is Flow Through"; Rec."Is Flow Through")
                {
                    ApplicationArea = All;
                    Caption = 'Flow Through';
                    ToolTip = 'Specifies whether the item is a flow-through item.';
                }

                field("Is Billed Item"; Rec."Is Billed Item")
                {
                    ApplicationArea = All;
                    Caption = 'Billed Item';
                    ToolTip = 'Specifies whether the item is billed.';
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Caption = 'Remarks';
                    ToolTip = 'Specifies additional remarks for the item.';
                }

                field(Instruction; Rec.Instruction)
                {
                    ApplicationArea = All;
                    Caption = 'Instruction';
                    ToolTip = 'Specifies special instructions for the item.';
                }

                field("Regional Instruction"; Rec."Regional Instruction")
                {
                    ApplicationArea = All;
                    Caption = 'Regional Instruction';
                    ToolTip = 'Specifies regional instructions applicable to the item.';
                }

                field("Item Speciality Code"; Rec."Item Speciality Code")
                {
                    ApplicationArea = All;
                    Caption = 'Item Speciality Code';
                    ToolTip = 'Specifies the speciality code assigned to the item.';
                }

                field("Speciality Name"; Rec."Speciality Name")
                {
                    ApplicationArea = All;
                    Caption = 'Speciality Name';
                    ToolTip = 'Specifies the speciality name associated with the item.';
                }
                field("Common Item No."; Rec."Common Item No.")
                {
                    ToolTip = 'Specifies the Common Item No. associated with the item.';
                }
                field("Unique Log No."; Rec."Unique Log No.")
                {
                    ToolTip = 'Specifies the value of the Unique Log No. field.';
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
                    ItemRec: Record "E3 API Item Update Log";
                    E3AkhilMgmt: Codeunit "E3 Item Integration Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(ItemRec);

                    if ItemRec.FindSet() then
                        repeat
                            Clear(E3AkhilMgmt);
                            E3AkhilMgmt.SendItemDetails(ItemRec);
                        until ItemRec.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
        }
    }
}