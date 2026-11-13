
table 50099 "E3 Asset Item Group"
{
    Caption = 'Asset Item Group';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Asset Item Group List";
    LookupPageId = "E3 Asset Item Group List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Asset Item Category"; Code[20])
        {
            Caption = 'Asset Item Category';
            TableRelation = "E3 Asset Item Categories".Code;
        }
        field(4; "Asset Item Name Group"; Code[20])
        {
            Caption = 'Asset Item Name Group';
            TableRelation = "E3 Asset Item Group".Code;
        }
        field(5; "Asset Item Sub Group"; Code[20])
        {
            Caption = 'Presentation Order';
            TableRelation = "E3 Asset Item Sub Group".Code;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
