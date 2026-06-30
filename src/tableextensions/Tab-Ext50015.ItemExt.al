tableextension 50015 "E3 HIS Item" extends Item
{
    fields
    {
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
        field(50002; Category; Text[60])
        {
            Caption = 'Category';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Category Master".Name;

            trigger OnValidate()
            var
                CategoryRec: Record "E3 Item Category Master";
            begin
                Clear("Category Code");

                CategoryRec.Reset();
                CategoryRec.SetRange(Name, Category);

                if CategoryRec.FindFirst() then
                    "Category Code" := CategoryRec.Code;
            end;
        }
        field(50003; "Material Category"; Text[60])
        {
            Caption = 'Material Category';
            //Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Category Master".Name;
            trigger OnValidate()
            var
                MaterialCategoryRec: Record "E3 Material Category Master";
            begin
                Clear("Material Category Code");

                MaterialCategoryRec.Reset();
                MaterialCategoryRec.SetRange(Name, "Material Category");

                if MaterialCategoryRec.FindFirst() then
                    "Material Category Code" := MaterialCategoryRec.Code;
            end;
        }
        field(50004; Model; Text[60])
        {
            Caption = 'Model';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Model Master".name;
        }
        field(50005; Strength; Text[60])
        {
            Caption = 'Strength';
            DataClassification = CustomerContent;
            //Editable = false;
            TableRelation = "E3 Item Strength Master".Name;
            trigger OnValidate()
            var
                StrengthMaster: Record "E3 Item Strength Master";
            begin
                Clear("Strength Code");

                StrengthMaster.Reset();
                StrengthMaster.SetRange(Name, Strength);

                if StrengthMaster.FindFirst() then
                    "Strength Code" := StrengthMaster.Code;
            end;
        }
        field(50006; "Medicine Group"; Text[50])
        {
            Caption = 'Medicine Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Sub Group Master".Name;
        }
        field(50008; "Medicine Manufacturer"; Text[50])
        {
            Caption = 'Medicine Manufacturer';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master"."Company Name" WHERE("Make Type" = filter('Manufacturer'));
            ;

            trigger OnValidate()
            var
                MakeMasterRec: Record "E3 Item Make Master";
            begin
                Clear("Manufacturer Code");

                MakeMasterRec.Reset();
                MakeMasterRec.SetRange("Company Name", "Medicine Manufacturer");

                if MakeMasterRec.FindFirst() then
                    ManufacturerCode := MakeMasterRec.Code;
            end;
        }
        field(50009; "Medicine Company"; Text[50])
        {
            Caption = 'Medicine Company';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master"."Company Name" WHERE("Make Type" = filter('Medicine/Marketing'));
            ;

            trigger OnValidate()
            var
                MakeMasterRec: Record "E3 Item Make Master";
            begin
                Clear("Marketing Company Code");

                MakeMasterRec.Reset();
                MakeMasterRec.SetRange("Company Name", "Medicine Company");

                if MakeMasterRec.FindFirst() then
                    "Marketing Company Code" := MakeMasterRec.Code;
            end;
        }
        field(50010; Packing; Text[60])
        {
            Caption = 'Packing';
            DataClassification = CustomerContent;
        }
        field(50011; Scheme; Text[60])
        {
            Caption = 'Scheme';
            DataClassification = CustomerContent;
        }
        field(50012; "Res. Group"; Text[60])
        {
            Caption = 'Res. Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Restricted Group Master".Name;
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
        field(50020; Active; Boolean)
        {
            Caption = 'Active';
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
            TableRelation = "E3 Item Type".Name;
            trigger OnValidate()
            var
                ItemTypeRec: Record "E3 Item Type";
            begin
                if ItemTypeRec.Get("Item Type") then begin

                    // Flow Item Tracking Code
                    Validate("Item Tracking Code", ItemTypeRec."Item Tracking Code");

                    // Flow Lot Nos.
                    "Lot Nos." := ItemTypeRec."Lot Nos.";

                end else begin
                    Clear("Item Tracking Code");
                    Clear("Lot Nos.");
                end;
            end;
        }
        field(50024; "Medicine SubCategory"; Text[60])
        {
            Caption = 'Medicine SubCategory';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Sub-Category Mast".Name;

            trigger OnValidate()
            var
                SubCategoryRec: Record "E3 Medicine Sub-Category Mast";
            begin
                Clear("Sub Category Code");

                SubCategoryRec.Reset();
                SubCategoryRec.SetRange(Name, "Medicine SubCategory");

                if SubCategoryRec.FindFirst() then
                    "Sub Category Code" := SubCategoryRec.Code;
            end;
        }
        field(50025; "Sub Group Nature"; Text[60])
        {
            Caption = 'Sub Group nature';
            DataClassification = CustomerContent;
            TableRelation = "E3 Sub-Group Nature".Name;
        }
        field(50026; Make; Text[60])
        {
            Caption = 'Make';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master"."Company Name" WHERE("Make Type" = filter('Medicine/Marketing'));
            ;

            trigger OnValidate()
            var
                ItemMakeMaster: Record "E3 Item Make Master";
            begin
                Clear("Item Make Code");

                ItemMakeMaster.Reset();
                ItemMakeMaster.SetRange("Company Name", Make);

                if ItemMakeMaster.FindFirst() then
                    "Item Make Code" := ItemMakeMaster.Code;
            end;
        }
        field(50027; "Medicine Component"; Text[60])
        {
            Caption = 'Medicine Component';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Component Master".Name;
        }
        field(50028; Speciality; Text[60])
        {
            Caption = 'Speciality';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Speciality Master".Name;
        }
        field(50029; "Material Type"; Text[60])
        {
            Caption = 'Material Type';
            DataClassification = CustomerContent;
            //Editable = false;
            TableRelation = "E3 Material Type Master".Name;
            trigger OnValidate()
            var
                MaterialTypeRec: Record "E3 Material Type Master";
            begin
                Clear("Material Type Code");

                MaterialTypeRec.Reset();
                MaterialTypeRec.SetRange(Name, "Material Type");

                if MaterialTypeRec.FindFirst() then
                    "Material Type Code" := MaterialTypeRec.Code;
            end;
        }
        field(50030; "Medicine Composition"; Text[60])
        {
            Caption = 'Medicine Composition';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Composition".Code;

            trigger OnValidate()
            var
                CompositionRec: Record "E3 Medicine Composition";
            begin
                Clear("Composition Code");
                CompositionRec.Reset();
                CompositionRec.SetRange(Code, "Medicine Composition");
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
        field(50040; "Item Group"; Text[60])
        {
            Caption = 'Item Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Group".Name;
            trigger OnValidate()
            var
                ItemGroupRec: Record "E3 Item Group";
            begin
                Clear("Item Group Code");

                ItemGroupRec.Reset();
                ItemGroupRec.SetRange(Name, "Item Group");

                if ItemGroupRec.FindFirst() then
                    "Item Group Code" := ItemGroupRec.Code;
                "Gen. Prod. Posting Group" := ItemGroupRec."Gen. Prod. Posting Group";
                "Inventory Posting Group" := ItemGroupRec."Inventory Posting Group";
            end;
        }
        field(50041; "Filter Item Type"; Text[60])
        {
            Caption = 'Filter Item Type';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Filter Item Type".Name;
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
        field(50045; "Property List"; Text[60])
        {
            Caption = 'Property List';
            DataClassification = CustomerContent;
            TableRelation = "E3 Property List".Name;
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
        }
        field(50052; "Item Group Code"; Code[30])
        {
            Caption = 'Item Group Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Group".Code;
        }
        field(50053; "Item Make Code"; Code[30])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
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
        }
        field(50059; "Material Type Code"; Code[30])
        {
            Caption = 'Material Type Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Type Master".Code;
        }
        field(50060; "Material Category Code"; Code[30])
        {
            Caption = 'Material Category Code';
            Editable = false;
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Category Master".Code;
        }

    }
    trigger OnBeforeRename()
    begin
        if (Rec."No." <> xRec."No.") and (xRec."No." <> '') then
            Error('You cannot modify the Item No.');
    end;
}
