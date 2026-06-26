table 50042 "E3 Medicine Composition"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Medicine Composition";
    LookupPageId = "E3 Medicine Composition";

    fields
    {
        field(1; Code; Code[30])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "SNo"; Integer)
        {
            Caption = 'SNo';
            DataClassification = CustomerContent;
        }
        field(3; "Composition Code"; Code[20])
        {
            Caption = 'Composition Code';
            DataClassification = CustomerContent;
        }
        field(4; IsBase; Boolean)
        {
            Caption = 'IsBase';
            DataClassification = CustomerContent;
        }
        field(5; Power; Decimal)
        {
            Caption = 'Power';
            DataClassification = CustomerContent;
        }
        field(6; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(7; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(8; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; Code, "Composition Code")
        {
            Clustered = true;
        }
    }

}

