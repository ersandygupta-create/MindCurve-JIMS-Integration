table 50034 "E3 Sub-Group Nature"
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
        field(3; "Manual Code"; Text[60])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(4; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(5; Response; Text[60])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(6; "Last Sent"; DateTime)
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

