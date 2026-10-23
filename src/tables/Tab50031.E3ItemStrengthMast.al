table 50031 "E3 Item Strength Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Item Strength Master";
    LookupPageId = "E3 Item Strength Master";

    fields
    {
        field(1; Code; Code[30])
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
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(7; "First Sent"; Boolean)
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
                'You do not have permission to create a new Item Strength record. ' +
                'Please contact your administrator.');

        TestField(Name);
        if Code = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Item Strength Nos.");

            "No. Series" := InventorySetup."Item Strength Nos.";
            Code := NoSeries.GetNextNo("No. Series");
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
                'You do not have permission to modify an Item Strength record. ' +
                'Please contact your administrator.');
    end;

    procedure AssistEdit(OldItemStrength: Record "E3 Item Strength Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Item Strength Nos.");

        if NoSeries.LookupRelatedNoSeries(
            InventorySetup."Item Strength Nos.",
            OldItemStrength."No. Series",
            "No. Series")
        then begin
            Code := NoSeries.GetNextNo("No. Series", Today, true);
            exit(true);
        end;

        exit(false);
    end;
}

