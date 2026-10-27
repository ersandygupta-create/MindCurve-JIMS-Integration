table 50097 "E3 Custodian Type"
{
    Caption = 'Custodian Type';
    DrillDownPageId = "E3 Custodian Type List";
    LookupPageId = "E3 Custodian Type List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Name (Head of Department)"; Text[100])
        {
            Caption = 'Name (Head of Department)';
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