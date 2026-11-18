
table 50100 "E3 Asset Item Category"
{
    Caption = 'Asset Item Category';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Asset Item Category";
    LookupPageId = "E3 Asset Item Category";

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
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(Group; "Asset Item Group")
        {
        }
    }
}
