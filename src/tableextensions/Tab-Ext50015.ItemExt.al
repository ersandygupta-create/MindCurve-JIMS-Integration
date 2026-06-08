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
        }
        field(50003; "Material Category"; Text[60])
        {
            Caption = 'Material Category';
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Category Master".Name;
        }
        field(50004; Model; Text[60])
        {
            Caption = 'Model';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Model Master".name;
        }
        field(50005; Strength; Text[60])
        {
            Caption = 'Strength';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Strength Master".Name;
        }
        field(50006; "Medicine Group"; Text[50])
        {
            Caption = 'Medicine Group';
            DataClassification = CustomerContent;
        }
        field(50008; "Medicine Manufacturer"; Text[50])
        {
            Caption = 'Medicine Manufacturer';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master"."Company Name";
        }
        field(50009; "Medicine Company"; Text[50])
        {
            Caption = 'Medicine Company';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master"."Company Name";
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
            Caption = 'Quatation Required';
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
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Type".Name;
        }
        field(50024; "Medicine SubCategory"; Text[60])
        {
            Caption = 'Medicine SubCategory';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Sub-Category Mast".Name;
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
            TableRelation = "E3 Item Make Master"."Company Name";
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
            TableRelation = "E3 Material Type Master".Name;
        }
        field(50030; "Medicine Composition"; Text[60])
        {
            Caption = 'Medicine Composition';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Composition"."Composition Code";
        }
        field(50031; "Sub Group Site"; Text[60])
        {
            Caption = 'Sub Group Site';
            DataClassification = CustomerContent;
            TableRelation = "E3 Sub Group Site List"."Sub Code";
        }
        field(50032; "Narcotics Control Substances"; Boolean)
        {
            Caption = 'Narcotics & Control Substances';
            DataClassification = CustomerContent;
        }
        field(50033; "Item Group"; Text[60])
        {
            Caption = 'Item Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Group".Name;
        }
        field(50034; "Filter Item Type"; Text[60])
        {
            Caption = 'Filter Item Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Filter Item Type".Name;
        }
        field(50035; "Tolerance excess"; Decimal)
        {
            Caption = 'tl_ExcessPer';
            DataClassification = CustomerContent;
        }
        field(50036; "Tolerance Shortage"; Decimal)
        {
            Caption = 'tl_ShortagePer';
            DataClassification = CustomerContent;
        }
        field(50037; "Margin Fix"; Enum "E3 Margin Fix")
        {
            Caption = 'Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50038; "Property List"; Text[60])
        {
            Caption = 'Property List';
            DataClassification = CustomerContent;
            TableRelation = "E3 Property List".Name;
        }

    }
}
