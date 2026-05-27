table 50032 "E3 Item Property Master"
{
    DataPerCompany = false;

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
        field(3; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(4; Response; Text[60])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(5; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }
        field(6; "Manual Code"; Text[60])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(7; IsActive; Boolean)
        {
            Caption = 'IsActive';
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

