table 50099 "E3 Assets Category"
{
    Caption = 'Assets Category';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Assets Category List";
    LookupPageId = "E3 Assets Category List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}