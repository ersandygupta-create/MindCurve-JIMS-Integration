table 50050 "E3 Sub Group Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Sub Code"; Code[20])
        {
            Caption = 'Sub Code';
            DataClassification = CustomerContent;
        }
        field(2; "Manual Code"; Text[10])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(3; Initial; Text[20])
        {
            Caption = 'Initial';
            DataClassification = CustomerContent;
        }
        field(4; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(5; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(6; Response; Text[30])
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
        key(PK; "Manual Code", Name)
        {
            Clustered = true;
        }
    }

}

