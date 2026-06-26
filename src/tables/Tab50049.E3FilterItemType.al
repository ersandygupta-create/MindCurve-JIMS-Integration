table 50049 "E3 Filter Item Type"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Filter Item Type";
    LookupPageId = "E3 Filter Item Type";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Manual Code"; Text[10])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(4; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(5; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(6; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }
        field(7; Segment1; Text[60])
        {
            Caption = 'Segment1';
            DataClassification = CustomerContent;
        }
        field(8; Segment2; Text[60])
        {
            Caption = 'Segment2';
            DataClassification = CustomerContent;
        }
        field(9; Segment3; Text[60])
        {
            Caption = 'Segmen3';
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

