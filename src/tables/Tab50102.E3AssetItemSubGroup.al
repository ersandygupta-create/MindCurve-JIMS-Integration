
table 50102 "E3 Asset Item Sub Group"
{
    Caption = 'Asset Item Sub Group';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Asset Item Sub Group";
    LookupPageId = "E3 Asset Item Sub Group";

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
        field(5; "Asset Item Name Group"; Code[20])
        {
            Caption = 'Asset Item Name Group';
            TableRelation = "E3 Asset Item Name Group".Code
                where(
                    "Asset Item Category" = field("Asset Item Category"));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(NameGroup; "Asset Item Name Group")
        {
        }
    }
}
