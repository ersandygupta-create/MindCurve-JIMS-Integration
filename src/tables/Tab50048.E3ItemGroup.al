table 50048 "E3 Item Group"
{
    DataPerCompany = false;
    LookupPageId = "E3 Item Group";
    DrillDownPageId = "E3 Item Group";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[60])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Filter Item Type"; Decimal)
        {
            Caption = 'Filter Item Type';
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
        field(7; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            TableRelation = "Gen. Product Posting Group";
        }
        field(8; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
            TableRelation = "Inventory Posting Group";
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

