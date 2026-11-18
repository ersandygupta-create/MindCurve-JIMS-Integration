
table 50101 "E3 Asset Item Name Group"
{
    Caption = 'Asset Item Name Group';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Asset Item Name Group";
    LookupPageId = "E3 Asset Item Name Group";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Asset Item Group"; Code[20])
        {
            Caption = 'Asset Item Group';
            TableRelation = "E3 Asset Item Group".Code;
            DataClassification = CustomerContent;
        }
        field(4; "Asset Item Category"; Code[20])
        {
            Caption = 'Asset Item Category';
            TableRelation = "E3 Asset Item Category".Code
                where("Asset Item Group" = field("Asset Item Group"));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(Category; "Asset Item Category")
        {
        }
    }
}
