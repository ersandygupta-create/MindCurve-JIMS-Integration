table 50037 "E3 Medicine Component Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Medicine Component Master";
    LookupPageId = "E3 Medicine Component Master";

    fields
    {
        field(1; Code; Integer)
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[60])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Restrict Group Code"; Code[20])
        {
            Caption = 'Restrict Group Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Restricted Group Master".Code;
        }
        field(4; IsActive; Boolean)
        {
            Caption = 'IsActive';
            DataClassification = CustomerContent;
        }
        field(5; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(6; Response; Text[60])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(7; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; Code, Name)
        {
            Clustered = true;
        }
    }

}

