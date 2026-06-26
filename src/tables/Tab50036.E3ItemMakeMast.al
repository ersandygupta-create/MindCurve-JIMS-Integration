table 50036 "E3 Item Make Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Item Make Master";
    LookupPageId = "E3 Item Make Master";

    fields
    {
        field(1; Code; Code[30])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Company Name"; Text[60])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(3; "Filter Item Type"; Integer)
        {
            Caption = 'Filter Item Type';
            DataClassification = CustomerContent;
        }
        field(4; "Short Name"; Text[60])
        {
            Caption = 'Short Name';
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
        field(8; "Make Type"; Enum "E3 Item Make Type")
        {
            Caption = 'Item Make Type';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; Code, "Company Name")
        {
            Clustered = true;
        }
    }

}

