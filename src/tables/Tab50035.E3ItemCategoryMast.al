table 50035 "E3 Item Category Master"
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
        field(3; "Filter Item Type"; Integer)
        {
            Caption = 'Filter Item Type';
            DataClassification = CustomerContent;
        }
        field(4; SaleRateProfitMargin; Decimal)
        {
            Caption = 'Sale Rate Profit Margin';
            DataClassification = CustomerContent;
        }
        field(5; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(6; Response; Text[200])
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

