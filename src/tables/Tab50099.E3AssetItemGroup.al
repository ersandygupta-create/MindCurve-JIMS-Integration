
table 50099 "E3 Asset Item Group"
{
    Caption = 'Asset Item Group';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Asset Item Group";
    LookupPageId = "E3 Asset Item Group";

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
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
