table 50030 "E3 Item Model Master"
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

    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}

