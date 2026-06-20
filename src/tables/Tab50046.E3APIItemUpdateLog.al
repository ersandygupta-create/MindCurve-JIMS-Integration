table 50046 "E3 API Item Update Log"
{
    Caption = 'API Item Update Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the number of the item.';
        }
        field(2; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
            ToolTip = 'Specifies an alternative account number which can be used internally in the company.';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the item.';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies information in addition to the description.';
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
        }
        field(9; "Price Unit Conversion"; Integer)
        {
            Caption = 'Price Unit Conversion';
        }
        field(10; Type; Enum "Item Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies if the item card represents a physical inventory unit (Inventory), a labor time unit (Service), or a physical unit that is not tracked in inventory (Non-Inventory).';
        }
        field(11; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
        }
        field(54; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies that transactions with the item cannot be posted, for example, because the item is in quarantine.';
        }
        field(5425; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            ToolTip = 'Specifies the unit of measure code used when you sell the item.';
        }
        field(5426; "Purch. Unit of Measure"; Code[10])
        {
            Caption = 'Purch. Unit of Measure';
            ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
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
        field(50007; "Rate Margin Fix"; Text[50])
        {
            Caption = 'Rate Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50008; "Medicine Manufacturer"; Text[50])
        {
            Caption = 'Medicine Manufacturer';
            DataClassification = CustomerContent;
        }
        field(50009; "Medicine Company"; Text[50])
        {
            Caption = 'Medicine Company';
            DataClassification = CustomerContent;
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
        field(50033; "Request Payload"; Blob)
        {
            Caption = 'Request Payload';
        }
        field(50034; "Response Payload"; Blob)
        {
            Caption = 'Response Payload';
        }
        field(50035; "Unique Log No."; Integer)
        {
            Caption = 'Unique ID';
        }
        field(50036; "Sync Status"; Option)
        {
            Caption = 'Sync Status';
            OptionMembers = " ",Synced,Error;
            OptionCaption = ' ,Synced,Error';
        }
        field(50037; "Error Message"; Text[100])
        {
            Caption = 'Error Message';
        }
        field(50038; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = " ",New,Update;
            OptionCaption = ' ,New,Update';
        }
        field(50039; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
        }
        field(50040; "Item Group"; Text[60])
        {
            Caption = 'Item Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Group".Name;
        }
        field(50041; "Filter Item Type"; Text[60])
        {
            Caption = 'Filter Item Type';
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
        field(50046; SkuName; Text[100])
        {
            Caption = 'SkuName';
            DataClassification = CustomerContent;
        }
        field(50047; "Manual Code"; Code[20])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(50049; "Purch. Qty. Per Rate"; Decimal)
        {
            Caption = 'Purch. Unit Conversion Rate';
            DataClassification = CustomerContent;
        }
        field(50050; "Sale Qty. Per Rate"; Decimal)
        {
            Caption = 'Sale Unit Conversion Rate';
            DataClassification = CustomerContent;
        }
        field(91; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
        }
        field(18000; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        field(18001; "HSN/SAC Code"; Code[10])
        {
            Caption = 'HSN/SAC Code';
            ToolTip = 'Specifies the Harmonized System Nomenclature (HSN) code for a physical item or the Service Accounting Code (SAC) for a service item, to classify items for tax calculation purposes.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}