table 50042 "E3 Medicine Composition"
{
    DataPerCompany = false;

    fields
    {
        field(1; Code; Integer)
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
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
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
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}

