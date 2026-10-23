table 50035 "E3 Item Category Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Item Category Master";
    LookupPageId = "E3 Item Category Master";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (xRec.Code <> '') and (Rec.Code <> xRec.Code) then
                    Error('Code cannot be modified once it has been assigned.');
            end;
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
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; "First Sent"; Boolean)
        {
            Caption = 'First Sent';
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
    trigger OnInsert()
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        UserSetup: Record "User Setup";
    begin

        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Item Sub Table Insert" then
            Error(
                'You do not have permission to create a new Item Category record. ' +
                'Please contact your administrator.');

        TestField(Name);
        if Code = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Item Category Nos.");

            "No. Series" := InventorySetup."Item Category Nos.";
            Code := NoSeries.GetNextNo("No. Series", Today, true);
        end;
    end;

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Item Sub Table Modify" then
            Error(
                'You do not have permission to modify an Item Category record. ' +
                'Please contact your administrator.');
    end;


    procedure AssistEdit(OldItemCategory: Record "E3 Item Category Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Item Category Nos.");

        if NoSeries.LookupRelatedNoSeries(
            InventorySetup."Item Category Nos.",
            OldItemCategory."No. Series",
            "No. Series")
        then begin
            Code := NoSeries.GetNextNo("No. Series", Today, true);
            exit(true);
        end;

        exit(false);
    end;

}

