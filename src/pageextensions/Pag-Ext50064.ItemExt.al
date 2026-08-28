pageextension 50064 "Item Ext" extends "Item Card"
{
    layout
    {
        modify(Description)
        {
            Editable = false;
            ShowMandatory = true;
        }
        modify("GST Group Code")
        {
            ShowMandatory = true;
        }
        modify("HSN/SAC Code")
        {
            ShowMandatory = true;
        }
        modify("Purch. Unit of Measure")
        {
            ShowMandatory = true;
        }
        modify("Sales Unit of Measure")
        {
            ShowMandatory = true;
        }
        addafter(Description)
        {
            field(Name; Rec.Name)
            {
                ApplicationArea = All;
                Editable = false;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of Name field.';
            }
            field("Composition Name"; Rec."Composition Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Composition Name for the item.';
                Editable = false;
            }
        }
        addlast(content)
        {
            group("JIMS Attributes")
            {
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    //Editable = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Item Type field.';
                }
                field("Item Type Name"; Rec."Item Type Name")
                {
                    ToolTip = 'Specifies the value of Item Type Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Material Category Code"; Rec."Material Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Material Category Code.';
                }
                field("Material Category Name"; Rec."Material Category Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Meterial Category field.';
                }
                field("Strength Code"; Rec."Strength Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Strength Code.';
                }
                field("Strength Name"; Rec."Strength Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Strength field.';
                }
                field("Item Group Code"; Rec."Item Group Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Item Group Code.';
                }
                field("Item Group Name"; Rec."Item Group Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Item Group field.';
                }
                field("Medicine Group"; Rec."Medicine Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Medicine Group field.';
                }
                field("Marketing Company Code"; Rec."Marketing Company Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Marketing Company Code.';
                }
                field("Marketing Company Name"; Rec."Marketing Company Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Marketing Company Name';
                    ToolTip = 'Specifies the value of Marketing Company field.';
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Model field.';
                }
                field("Model Name"; Rec."Model Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Model Name field.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Category field.';
                }
                field("Category Name"; Rec."Category Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Category field.';
                }
                field("Medicine SubCategory Code"; Rec."Medicine SubCategory Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine SubCategory Code field.';
                }
                field("Medicine SubCategory Name"; Rec."Medicine SubCategory Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Medicine SubCategory Name field.';
                }
                field("Medicine Manufacturer Code"; Rec."Medicine Manufacturer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Manufacturer Code field.';
                }
                field("Medicine Manufacturer Name"; Rec."Medicine Manufacturer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Manufacturer Name field.';
                }
                field("Res. Group Code"; Rec."Res. Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Res. Group Code field.';
                }
                field("Res. Group Name"; Rec."Res. Group Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Res. Group Name field.';
                }
                field("Sub Group Nature"; Rec."Sub Group Nature")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Sub Group Nature field.';
                }

                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Caption = 'Medicine Company / Brand-Make Code';
                    ToolTip = 'Specifies the Item Make Code.';
                }
                field("Make Name"; Rec."Make Name")
                {
                    ApplicationArea = All;
                    Caption = 'Medicine Company/Brand-Make Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of Make field.';
                }
                field("Medicine Component"; Rec."Medicine Component")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Medicine Component field.';
                }

                field("Material Type Code"; Rec."Material Type Code")
                {
                    ApplicationArea = All;
                    //Editable = false;
                    ToolTip = 'Specifies the Material Type Code.';
                }
                field("Material Type Name"; Rec."Material Type Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Material Type Name field.';
                }
                field("Medicine Composition Code"; Rec."Medicine Composition Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Medicine Composition Code field.';
                }
                field("Sub Group Site"; Rec."Sub Group Site")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Sub Group Site field.';
                }
                field("Property List Code"; Rec."Property List Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Property List Code field.';
                }
                field("Property List Name"; Rec."Property List Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Property List field.';
                }
                field("Tolerance excess"; Rec."Tolerance excess")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Tolerance Excess field.';
                }
                field("Tolerance Shortage"; Rec."Tolerance Shortage")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of Tolerance Shortage field.';
                }
                field("Margin Fix"; Rec."Margin Fix")
                {
                    ApplicationArea = All;
                    ShowMandatory = Rec."Margin Fix" = Rec."Margin Fix"::" ";
                    Caption = 'Type of RC';
                    ToolTip = 'Specifies the value of Margin Fix field.';
                }
                field("E3 Margin Code"; Rec."E3 Margin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of E3 Margin Code field.';
                }
                field("Margin Name"; Rec."Margin Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of E3 Margin Name field.';
                }
                field("Manual Code"; Rec."Manual Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Manual Code field.';
                }
                field("Composition Code"; Rec."Composition Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the Composition Code.';
                }
                field("Sub Category Code"; Rec."Sub Category Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the Sub Category Code.';
                }
                field("ManufacturerCode"; Rec."ManufacturerCode")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the Manufacturer Code.';
                }

                field("Item Speciality Code"; Rec."Item Speciality Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Speciality Code field.';
                }
                field("Speciality Name"; Rec."Speciality Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the speciality Name assigned to the item.';
                }

                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the division code for the item.';
                }

                field("Division Name"; Rec."Division Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the division associated with the item.';
                }
            }
        }
        addafter("JIMS Attributes")
        {
            group("JIMS Other Attributes")
            {
                field(IsActive; Rec.IsActive)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies whether this is a IsActive item.';
                }
                field("Allow Negative Stock"; Rec."Allow Negative Stock")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether negative inventory is allowed for this item.';
                }

                field("Is Indent Mandatory"; Rec."Is Indent Mandatory")
                {
                    ApplicationArea = All;
                    Caption = 'Indent Mandatory';
                    ToolTip = 'Specifies whether an indent is mandatory before processing this item.';
                }

                field("Is Common"; Rec."Is Common")
                {
                    ApplicationArea = All;
                    Caption = 'Common';
                    ToolTip = 'Specifies whether this is a common item.';
                }
                field("Is Life Saving"; Rec."Is Life Saving")
                {
                    ApplicationArea = All;
                    Caption = 'Life Saving';
                    ToolTip = 'Specifies whether this item is classified as a life-saving item.';
                }
                field("Is High Value"; Rec."Is High Value")
                {
                    ApplicationArea = All;
                    Caption = 'High Value';
                    ToolTip = 'Specifies whether this item is classified as a high-value item.';
                }

                field("Is Flow Through"; Rec."Is Flow Through")
                {
                    ApplicationArea = All;
                    Caption = 'Flow Through';
                    ToolTip = 'Specifies whether this item is a flow-through item.';
                }

                field("Is Billed Item"; Rec."Is Billed Item")
                {
                    ApplicationArea = All;
                    Caption = 'Billed Item';
                    ToolTip = 'Specifies whether this item is billed to the customer.';
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
                field("BarCode Active"; Rec."BarCode Active")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of BarCode Active field.';
                }
                field("Psychotropic Substance"; Rec."Psychotropic Substance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item is a psychotropic substance.';
                }

                field("Schedule H1"; Rec."Schedule H1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item belongs to Schedule H1.';
                }

                field("Formulary Drug"; Rec."Formulary Drug")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item is a formulary Drug item.';
                }

                field("Anti TB"; Rec."Anti TB")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item is an Anti-TB medicine.';
                }
                field(Antibiotic; Rec.Antibiotic)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item is an antibiotic.';
                }

                field(Capex; Rec.Capex)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item is a Capex item.';
                }

                field("PO Mandatory"; Rec."PO Mandatory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a Purchase Order is mandatory for this item.';
                }
                field(SkuName; Rec.SkuName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether this is a SkuName item.';
                }
                field("Scheme On Qty"; Rec."Scheme On Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity on which the scheme is applicable.';
                }
                field("Scheme Free Qty"; Rec."Scheme Free Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free quantity provided under the scheme.';
                }
                field(Packing; Rec.Packing)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of Packing field.';
                }

                field("Filter Item Type Code"; Rec."Filter Item Type Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of Filter Item Type Code field.';
                }
                field("Filter Item Type Name"; Rec."Filter Item Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Filter Item Type field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Remarks field.';
                }

                field("Instruction"; Rec."Instruction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instructions for the item.';
                }
                field("Regional Instruction"; Rec."Regional Instruction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the regional instructions for the item.';
                }
                field("Sales Unit of Measure Name"; Rec."Sales Unit of Measure Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the sales unit of measure name.';
                }

                field("Purch. Unit of Measure Name"; Rec."Purch. Unit of Measure Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchase unit of measure name.';
                }

                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the person who prepared the record.';
                }
                field("Margin Code"; Rec."Margin Code")
                {
                    ApplicationArea = All;
                    Caption = 'Margin Code';
                    ToolTip = 'Specifies the margin code for the item.';
                }
                field("Margin Amount"; Rec."Margin Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Margin Amount';
                    ToolTip = 'Specifies the margin amount for the item.';
                }
                field(GLEN; Rec.GLEN)
                {
                    ApplicationArea = All;
                    Caption = 'GLEN';
                    Editable = true;
                    ToolTip = 'Specifies the GLEN for the item.';
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
            action(CompositionPage)
            {
                ApplicationArea = All;
                Caption = 'Composition Page';
                ToolTip = 'View Composition Page';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    MedicineComposition: Record "E3 Medicine Composition";
                begin
                    MedicineComposition.Reset();
                    MedicineComposition.SetRange(Code, Rec."No.");

                    if not MedicineComposition.FindFirst() then begin
                        Clear(MedicineComposition);
                        MedicineComposition.Init();
                        MedicineComposition.Code := Rec."No.";
                        MedicineComposition."Item Name" := Rec.Description;
                        MedicineComposition."Unit Of Measure" := Rec."Base Unit of Measure";
                        MedicineComposition.Insert(true);
                    end;

                    MedicineComposition.Reset();
                    MedicineComposition.SetRange(Code, Rec."No.");
                    Page.Run(Page::"E3 Medicine Composition", MedicineComposition);
                end;
            }
            action("Update Composition Name")
            {
                Caption = 'Update Composition Name';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Updates the Composition Name from the Medicine Composition records for the current item.';

                trigger OnAction()
                begin
                    UpdateCompositionName();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Base Unit of Measure");
        exit(true);
    end;

    local procedure UpdateCompositionName()
    var
        MedicineComposition: Record "E3 Medicine Composition";
        CompositionNames: Text;
        Separator: Text;
    begin
        CompositionNames := '';
        Separator := '';

        MedicineComposition.Reset();
        MedicineComposition.SetRange(Code, Rec."No.");

        if MedicineComposition.FindSet() then
            repeat
                if MedicineComposition."Medicine Component Name" <> '' then begin
                    CompositionNames +=
                        Separator +
                        MedicineComposition."Medicine Component Name";

                    Separator := ' + ';
                end;
            until MedicineComposition.Next() = 0;

        Rec."Composition Name" :=
            CopyStr(
                CompositionNames,
                1,
                MaxStrLen(Rec."Composition Name"));

        Rec.Modify(true);

        CurrPage.Update(false);
    end;
}