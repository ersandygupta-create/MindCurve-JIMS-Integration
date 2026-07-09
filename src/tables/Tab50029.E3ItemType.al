table 50029 "E3 Item Type"
{
    DataPerCompany = false;
    Caption = 'Item Type';
    DrillDownPageId = "E3 Item Type";
    LookupPageId = "E3 Item Type";

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
        field(6500; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            ToolTip = 'Specifies how serial, lot or package numbers assigned to the item are tracked in the supply chain.';
            TableRelation = "Item Tracking Code";
        }
        field(6501; "Lot Nos."; Code[20])
        {
            Caption = 'Lot Nos.';
            ToolTip = 'Specifies the number series code that will be used when assigning lot numbers.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "Lot Nos." <> '' then
                    TestField("Item Tracking Code");
            end;
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

