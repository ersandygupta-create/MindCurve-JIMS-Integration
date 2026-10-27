table 50096 "E3 Room/Ward Type"
{
    Caption = 'Room/Ward Type';
    DrillDownPageId = "E3 Room/Ward Type List";
    LookupPageId = "E3 Room/Ward Type List";
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
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}