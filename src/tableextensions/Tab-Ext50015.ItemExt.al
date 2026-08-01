tableextension 50015 "E3 HIS Item" extends Item
{
    fields
    {
        modify("Base Unit of Measure")
        {
            trigger OnAfterValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
                if "Base Unit of Measure" = '' then begin
                    "Base Unit of Measure Name" := '';
                    "Sales Unit of Measure Name" := '';
                    "Purch. Unit of Measure Name" := '';
                    SkuName := '';
                    exit;
                end;

                if UnitOfMeasure.Get("Base Unit of Measure") then begin
                    "Base Unit of Measure Name" := UnitOfMeasure.Description;
                    "Sales Unit of Measure Name" := UnitOfMeasure.Description;
                    "Purch. Unit of Measure Name" := UnitOfMeasure.Description;
                    SkuName := UnitOfMeasure.Description;
                end else begin
                    "Base Unit of Measure Name" := '';
                    "Sales Unit of Measure Name" := '';
                    "Purch. Unit of Measure Name" := '';
                    SkuName := '';
                end;
            end;
        }
        modify("Sales Unit of Measure")
        {
            trigger OnAfterValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
                if UnitOfMeasure.Get("Sales Unit of Measure") then
                    "Sales Unit of Measure Name" := UnitOfMeasure.Description;
            end;
        }
        modify("Purch. Unit of Measure")
        {
            trigger OnAfterValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
                if UnitOfMeasure.Get("Purch. Unit of Measure") then
                    "Purch. Unit of Measure Name" := UnitOfMeasure.Description;

            end;
        }
        modify("HSN/SAC Code")
        {
            trigger OnAfterValidate()
            var
                HSNSAC: Record "HSN/SAC";
            begin
                if HSNSAC.Get("HSN/SAC Code") then
                    "HSN/SAC Type" := HSNSAC.Type
                else
                    Clear("HSN/SAC Type");
            end;
        }
        field(50000; "E3 HIS Type"; Enum "E3 HIS Type")
        {
            Caption = 'HIS Type';
            DataClassification = CustomerContent;
        }
        field(50001; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50002; "Category Name"; Text[60])
        {
            Caption = 'Category Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50003; "Material Category Name"; Text[60])
        {
            Caption = 'Material Category Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50004; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Model Master".Code;
            trigger OnValidate()
            var
                ItemModel: Record "E3 Item Model Master";
            begin
                if "Model Code" = '' then begin
                    "Model Name" := '';
                    exit;
                end;

                if ItemModel.Get("Model Code") then
                    "Model Name" := ItemModel.Name
                else
                    "Model Name" := '';
            end;
        }
        field(50005; "Strength Name"; Text[60])
        {
            Caption = 'Strength Name';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(50006; "Medicine Group"; Text[50])
        {
            Caption = 'Medicine Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Sub Group Master".Name;
        }
        field(50008; "Medicine Manufacturer Name"; Text[60])
        {
            Caption = 'Medicine Manufacturer Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50009; "Medicine Company Name"; Text[60])
        {
            Caption = 'Medicine Company Name';
            DataClassification = CustomerContent;
        }
        field(50010; Packing; Text[60])
        {
            Caption = 'Packing';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure".Code;
        }
        field(50012; "Res. Group Name"; Text[60])
        {
            Caption = 'Res. Group Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50013; "Incl Free Qty in Sale Rate"; Boolean)
        {
            Caption = 'Include Free Qty in Sale Rate';
            DataClassification = CustomerContent;
        }
        field(50014; "Sale Discount Allow"; Boolean)
        {
            Caption = 'Sale Discount Allow';
            DataClassification = CustomerContent;
        }
        field(50015; "Sale Rate Editable"; Boolean)
        {
            Caption = 'Sale Rate Editable';
            DataClassification = CustomerContent;
        }
        field(50016; "Allow MRP Discount"; Boolean)
        {
            Caption = 'Allow MRP Discount';
            DataClassification = CustomerContent;
        }
        field(50017; "Consignment Item"; Boolean)
        {
            Caption = 'Consignment Item';
            DataClassification = CustomerContent;
        }
        field(50018; "Sale Returnable Item"; Boolean)
        {
            Caption = 'Sale Returnable Item';
            DataClassification = CustomerContent;
        }
        field(50019; "Quatation Required"; Boolean)
        {
            Caption = 'Quotation Required';
            DataClassification = CustomerContent;
        }
        field(50021; "BarCode Active"; Boolean)
        {
            Caption = 'BarCode Active';
            DataClassification = CustomerContent;
        }
        field(50022; "Item Type"; Text[60])
        {
            Caption = 'Item Type';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Type".Code;
            trigger OnValidate()
            var
                ItemTypeRec: Record "E3 Item Type";
            begin
                if "Item Type" = '' then begin
                    Clear("Item Type Name");
                    Clear("Item Tracking Code");
                    Clear("Lot Nos.");
                    exit;
                end;

                if ItemTypeRec.Get("Item Type") then begin
                    // Auto fill Item Type Name
                    "Item Type Name" := ItemTypeRec.Name;

                    // Flow Item Tracking Code
                    Validate("Item Tracking Code", ItemTypeRec."Item Tracking Code");

                    // Flow Lot Nos.
                    "Lot Nos." := ItemTypeRec."Lot Nos.";
                end else begin
                    Clear("Item Type Name");
                    Clear("Item Tracking Code");
                    Clear("Lot Nos.");
                end;
            end;
        }
        field(50024; "Medicine SubCategory Name"; Text[60])
        {
            Caption = 'Medicine SubCategory Name';
            DataClassification = CustomerContent;
        }
        field(50025; "Sub Group Nature"; Text[60])
        {
            Caption = 'Sub Group nature';
            DataClassification = CustomerContent;
            TableRelation = "E3 Sub-Group Nature".Name;
        }
        field(50026; "Make Name"; Text[60])
        {
            Caption = 'Make';
            DataClassification = CustomerContent;
        }
        field(50027; "Medicine Component"; Text[60])
        {
            Caption = 'Medicine Component';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Component Master".Name;
        }
        field(50028; "Speciality Name"; Text[60])
        {
            Caption = 'Speciality Name';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Speciality Master".Name;
        }
        field(50029; "Material Type Name"; Text[60])
        {
            Caption = 'Material Type Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50030; "Medicine Composition Code"; Code[20])
        {
            Caption = 'Medicine Composition Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Composition".Code WHERE(Code = FIELD("No."));

            trigger OnValidate()
            var
                CompositionRec: Record "E3 Medicine Composition";
            begin
                Clear("Composition Code");
                CompositionRec.Reset();
                CompositionRec.SetRange(Code, "Medicine Composition Code");
                if CompositionRec.FindFirst() then
                    "Composition Code" := CompositionRec.Code;
            end;
        }
        field(50031; "Sub Group Site"; Text[60])
        {
            Caption = 'Sub Group Site';
            DataClassification = CustomerContent;
            TableRelation = "E3 Sub Group Site List"."Site Code";
        }
        field(50032; "Narcotics Control Substances"; Boolean)
        {
            Caption = 'Narcotics & Control Substances';
            DataClassification = CustomerContent;
        }
        field(50040; "Item Group Name"; Text[60])
        {
            Caption = 'Item Group Name';
            DataClassification = CustomerContent;
        }
        field(50041; "Filter Item Type Name"; Text[60])
        {
            Caption = 'Filter Item Type Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50042; "Tolerance excess"; Decimal)
        {
            Caption = 'tl_ExcessPer';
            DataClassification = CustomerContent;
        }
        field(50043; "Tolerance Shortage"; Decimal)
        {
            Caption = 'tl_ShortagePer';
            DataClassification = CustomerContent;
        }
        field(50044; "Margin Fix"; Enum "E3 Margin Fix")
        {
            Caption = 'Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50045; "Property List Name"; Text[60])
        {
            Caption = 'Property List Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50046; SkuName; Text[100])
        {
            Caption = 'SkuName';
            DataClassification = CustomerContent;
        }
        field(50047; "Manual Code"; Text[20])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(50048; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50051; "Strength Code"; Code[30])
        {
            Caption = 'Strength Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Strength Master".Code;
            trigger OnValidate()
            var
                StrengthMaster: Record "E3 Item Strength Master";
            begin
                if "Strength Code" = '' then begin
                    "Strength Name" := '';
                    exit;
                end;

                if StrengthMaster.Get("Strength Code") then
                    "strength Name" := StrengthMaster.Name
                else
                    "strength Name" := '';
            end;
        }
        field(50052; "Item Group Code"; Code[30])
        {
            Caption = 'Item Group Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Group".Code;

            trigger OnValidate()
            var
                ItemGroupRec: Record "E3 Item Group";
            begin
                if "Item Group Code" = '' then begin
                    "Item Group Name" := '';
                    exit;
                end;

                if ItemGroupRec.Get("Item Group Code") then
                    "Item Group Name" := ItemGroupRec.Name
                else
                    "Item Group Name" := '';
                "Gen. Prod. Posting Group" := ItemGroupRec."Gen. Prod. Posting Group";
                "Inventory Posting Group" := ItemGroupRec."Inventory Posting Group";
            end;
        }
        field(50053; "Item Make Code"; Code[30])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;

            trigger OnValidate()
            var
                ItemMakeMaster: Record "E3 Item Make Master";
            begin
                ItemMakeMaster.Reset();
                ItemMakeMaster.SetRange(Code, "Item Make Code");

                if ItemMakeMaster.FindFirst() then
                    "Make Name" := ItemMakeMaster."Company Name"
                else
                    Clear("Make Name");
            end;
        }
        field(50054; "Composition Code"; Code[30])
        {
            Caption = 'Composition Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Composition".Code;
        }
        field(50055; "Sub Category Code"; Code[30])
        {
            Caption = 'Sub Category Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Sub-Category Mast".Code;
        }
        field(50056; "Category Code"; Code[30])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Category Master".Code;

            trigger OnValidate()
            var
                CategoryRec: Record "E3 Item Category Master";
            begin
                if "Category Code" = '' then begin
                    "Category Name" := '';
                    exit;
                end;

                if CategoryRec.Get("Category Code") then
                    "Category Name" := CategoryRec.Name
                else
                    "Category Name" := '';
            end;
        }
        field(50057; "ManufacturerCode"; Code[30])
        {
            Caption = 'Manufacturer Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
        }
        field(50058; "Marketing Company Code"; Code[30])
        {
            Caption = 'Marketing Company Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
            trigger OnValidate()
            var
                ItemMakeMaster: Record "E3 Item Make Master";
            begin
                ItemMakeMaster.Reset();
                ItemMakeMaster.SetRange(Code, "Marketing Company Code");

                if ItemMakeMaster.FindFirst() then
                    "Marketing Company Name" := ItemMakeMaster."Company Name"
                else
                    Clear("Marketing Company Name");
            end;
        }
        field(50059; "Material Type Code"; Code[30])
        {
            Caption = 'Material Type Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Type Master".Code;
            trigger OnValidate()
            var
                MaterialTypeRec: Record "E3 Material Type Master";
            begin
                if "Material Type Code" = '' then begin
                    "Material Type Name" := '';
                    exit;
                end;

                if MaterialTypeRec.Get("Material Type Code") then
                    "Material Type Name" := MaterialTypeRec.Name
                else
                    "Material Type Name" := '';
            end;
        }
        field(50060; "Material Category Code"; Code[30])
        {
            Caption = 'Material Category Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Category Master".Code;
            trigger OnValidate()
            var
                MaterialCategoryRec: Record "E3 Material Category Master";
            begin
                if "Material Category Code" = '' then begin
                    "Material Category Name" := '';
                    exit;
                end;

                if MaterialCategoryRec.Get("Material Category Code") then
                    "Material Category Name" := MaterialCategoryRec.Name
                else
                    "Material Category Name" := '';
            end;
        }
        field(50062; "Allow Negative Stock"; Boolean)
        {
            Caption = 'Allow Negative Stock';
            DataClassification = CustomerContent;
        }
        field(50063; "Is Indent Mandatory"; Boolean)
        {
            Caption = 'Is Indent Mandatory';
            DataClassification = CustomerContent;
        }
        field(50064; "Is Common"; Boolean)
        {
            Caption = 'Is Common';
            DataClassification = CustomerContent;
        }
        field(50065; "Scheme On Qty"; Decimal)
        {
            Caption = 'Scheme On Qty';
            DataClassification = CustomerContent;
        }
        field(50066; "Scheme Free Qty"; Decimal)
        {
            Caption = 'Scheme Free Qty';
            DataClassification = CustomerContent;
        }
        field(50067; "Is Life Saving"; Boolean)
        {
            Caption = 'Is Life Saving';
            DataClassification = CustomerContent;
        }
        field(50068; "Is High Value"; Boolean)
        {
            Caption = 'Is High Value';
            DataClassification = CustomerContent;
        }
        field(50069; "Is Flow Through"; Boolean)
        {
            Caption = 'Is Flow Through';
            DataClassification = CustomerContent;
        }
        field(50070; "Is Billed Item"; Boolean)
        {
            Caption = 'Is Billed Item';
            DataClassification = CustomerContent;
        }
        field(50071; "Item Speciality Code"; Code[20])
        {
            Caption = 'Item Speciality Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Speciality Master".Code;
            trigger OnValidate()
            var
                ItemSpeciality: Record "E3 Item Speciality Master";
            begin
                if "Item Speciality Code" = '' then begin
                    "Speciality Name" := '';
                    exit;
                end;

                if ItemSpeciality.Get("Item Speciality Code") then
                    "Speciality Name" := ItemSpeciality.Name
                else
                    "Speciality Name" := '';
            end;
        }
        field(50072; "Division Code"; Code[20])
        {
            Caption = 'Division Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Division Master".Code;

            trigger OnValidate()
            var
                Division: Record "E3 Division Master";
            begin
                if "Division Code" = '' then begin
                    "Division Name" := '';
                    exit;
                end;

                if Division.Get("Division Code") then
                    "Division Name" := Division.Name
                else
                    "Division Name" := '';
            end;
        }

        field(50073; "Division Name"; Text[60])
        {
            Caption = 'Division Name';
            DataClassification = CustomerContent;
        }

        field(50074; "Instruction"; Text[250])
        {
            Caption = 'Instruction';
            DataClassification = CustomerContent;
        }
        field(50075; "Regional Instruction"; Text[250])
        {
            Caption = 'Regional Instruction';
            DataClassification = CustomerContent;
        }
        field(50076; "Model Name"; Text[60])
        {
            Caption = 'Model Name';
            DataClassification = CustomerContent;
        }
        field(50077; Name; Text[250])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50078; "Medicine Company Code"; Code[20])
        {
            Caption = 'Medicine Company Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".code;
            trigger OnValidate()
            var
                ItemMakeMaster: Record "E3 Item Make Master";
            begin
                ItemMakeMaster.Reset();
                ItemMakeMaster.SetRange(Code, "Marketing Company Code");

                if ItemMakeMaster.FindFirst() then
                    "Medicine Company Name" := ItemMakeMaster."Company Name"
                else
                    Clear("Medicine Company Name");
            end;
        }
        field(50079; "Medicine SubCategory Code"; Code[20])
        {
            Caption = 'Medicine Sub Category Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Sub-Category Mast".Code;

            trigger OnValidate()
            var
                SubCategoryRec: Record "E3 Medicine Sub-Category Mast";
            begin
                if "Medicine SubCategory Code" = '' then begin
                    "Medicine SubCategory Name" := '';
                    exit;
                end;

                SubCategoryRec.Reset();
                SubCategoryRec.SetRange(Code, "Medicine SubCategory Code");

                if SubCategoryRec.FindFirst() then
                    "Medicine SubCategory Name" := SubCategoryRec.Name
                else
                    "Medicine SubCategory Name" := '';
            end;
        }
        field(50080; "Medicine Manufacturer Code"; Code[20])
        {
            Caption = 'Medicine Manufacturer Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;

            trigger OnValidate()
            var
                MakeMasterRec: Record "E3 Item Make Master";
            begin
                if "Medicine Manufacturer Code" = '' then begin
                    "Medicine Manufacturer Name" := '';
                    exit;
                end;

                MakeMasterRec.Reset();
                MakeMasterRec.SetRange(Code, "Medicine Manufacturer Code");

                if MakeMasterRec.FindFirst() then
                    "Medicine Manufacturer Name" := MakeMasterRec."Company Name"
                else
                    "Medicine Manufacturer Name" := '';
            end;
        }
        field(50081; "Res. Group Code"; Code[20])
        {
            Caption = 'Res. Group Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Restricted Group Master".Code;
            trigger OnValidate()
            var
                RestrictedGroup: Record "E3 Restricted Group Master";
            begin
                if "Res. Group Code" = '' then begin
                    "Res. Group Name" := '';
                    exit;
                end;

                RestrictedGroup.Reset();
                RestrictedGroup.SetRange(Code, "Res. Group Code");

                if RestrictedGroup.FindFirst() then
                    "Res. Group Name" := RestrictedGroup.Name
                else
                    "Res. Group Name" := '';
            end;
        }
        field(50082; "Property List Code"; Code[20])
        {
            Caption = 'Property List Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Property List".Code;
            trigger OnValidate()
            var
                PropertyList: Record "E3 Property List";
            begin
                if "Property List Code" = '' then begin
                    "Property List Name" := '';
                    exit;
                end;

                if PropertyList.Get("Property List Code") then
                    "Property List Name" := PropertyList.Name
                else
                    "Property List Name" := '';
            end;
        }
        field(50083; "Item Type Name"; Text[60])
        {
            Caption = 'Item Type Name';
            DataClassification = CustomerContent;
        }
        field(50084; "Sales Unit of Measure Name"; Text[50])
        {
            Caption = 'Sales Unit of Measure Name';
            DataClassification = CustomerContent;
        }
        field(50085; "Purch. Unit of Measure Name"; Text[50])
        {
            Caption = 'Purch. Unit of Measure Name';
            DataClassification = CustomerContent;
        }
        field(50086; "Prepared By"; Text[50])
        {
            Caption = 'Prepared By';
            DataClassification = CustomerContent;
        }
        field(50087; "HSN/SAC Type"; enum "GST Goods And Services Type")
        {
            Caption = 'HSN/SAC Type';
            DataClassification = CustomerContent;
            TableRelation = "HSN/SAC".Code;
        }
        field(50093; "Marketing Company Name"; Text[60])
        {
            Caption = 'Marketing Company Name';
            DataClassification = CustomerContent;
        }
        field(50094; "Filter Item Type Code"; Code[20])
        {
            Caption = 'Filter Item Type Code';
            DataClassification = CustomerContent;
            // TableRelation = "E3 Filter Item Type".Code;
            // trigger OnValidate()
            // var
            //     FilterItemType: Record "E3 Filter Item Type";
            // begin
            //     if "Filter Item Type Code" = '' then begin
            //         "Filter Item Type Name" := '';
            //         exit;
            //     end;

            //     if FilterItemType.Get("Filter Item Type Code") then
            //         "Filter Item Type Name" := FilterItemType.Name
            //     else
            //         "Filter Item Type Name" := '';
            // end;
        }
        field(50095; "Base Unit of Measure Name"; Text[50])
        {
            Caption = 'Base Unit of Measure Name';
            DataClassification = CustomerContent;
        }
        field(50096; IsActive; Boolean)
        {
            Caption = 'IsActive';
            DataClassification = CustomerContent;
        }
        field(50098; "Psychotropic Substance"; Boolean)
        {
            Caption = 'Psychotropic Substance';
            DataClassification = CustomerContent;
        }

        field(50099; "Schedule H1"; Boolean)
        {
            Caption = 'Schedule H1';
            DataClassification = CustomerContent;
        }

        field(50100; "Formulary Drug"; Boolean)
        {
            Caption = 'Formulary Drug';
            DataClassification = CustomerContent;
        }

        field(50101; "Non-Formulary"; Boolean)
        {
            Caption = 'Non-Formulary';
            DataClassification = CustomerContent;
        }
        field(50102; "Anti TB"; Boolean)
        {
            Caption = 'Anti TB';
            DataClassification = CustomerContent;
        }

        field(50103; Antibiotic; Boolean)
        {
            Caption = 'Antibiotic';
            DataClassification = CustomerContent;
        }

        field(50104; Capex; Boolean)
        {
            Caption = 'Capex';
            DataClassification = CustomerContent;
        }

        field(50105; "PO Mandatory"; Boolean)
        {
            Caption = 'PO Mandatory';
            DataClassification = CustomerContent;
        }
        field(50106; "Margin Code"; Code[20])
        {
            Caption = 'Margin Code';
            DataClassification = CustomerContent;
        }
        field(50107; "Margin Amount"; Decimal)
        {
            Caption = 'Margin Amount';
            DataClassification = CustomerContent;
        }
        field(50108; GLEN; Enum "E3 GLEN Type")
        {
            Caption = 'GLEN';
            DataClassification = CustomerContent;
        }

    }
    trigger OnBeforeRename()
    begin
        if (Rec."No." <> xRec."No.") and (xRec."No." <> '') then
            Error('You cannot modify the Item No.');
    end;

    trigger OnBeforeInsert()
    begin
        UpdatePreparedBy();
    end;

    trigger OnBeforeModify()
    begin
        UpdatePreparedBy();
    end;

    local procedure UpdatePreparedBy()
    var
        UserRec: Record User;
    begin
        if UserRec.Get(UserSecurityId()) then
            Rec."Prepared By" := UserRec."User Name"
        else
            Rec."Prepared By" := UserId();
    end;
}
