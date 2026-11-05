table 50030 "E3 Item Model Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Item Model Master";
    LookupPageId = "E3 Item Model Master";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                InventorySetup: Record "Inventory Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if Code <> xRec.Code then begin
                    InventorySetup.Get();
                    InventorySetup.TestField("Item Model Nos.");
                    NoSeries.TestManual(InventorySetup."Item Model Nos.");
                    "No. Series" := '';
                end;
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
            Error('You do not have permission to create a new Item Model record. Please contact your administrator.');



        if Code = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Item Model Nos.");
            "No. Series" := InventorySetup."Item Model Nos.";
            // Pass false for the third parameter (increment) if you want to test, 
            // but standard usage uses true only upon actual assignment.
            Code := NoSeries.GetNextNo("No. Series", WorkDate(), true);
        end;
        // TestField(Name);
    end;

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Item Sub Table Modify" then
            Error('You do not have permission to modify an Item Model record. Please contact your administrator.');
    end;

    procedure AssistEdit(OldItemModel: Record "E3 Item Model Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        TempCode: Code[20];
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Item Model Nos.");

        if NoSeries.LookupRelatedNoSeries(InventorySetup."Item Model Nos.", OldItemModel."No. Series", "No. Series") then begin
            TempCode := NoSeries.GetNextNo("No. Series", WorkDate(), true);
            if TempCode <> '' then begin
                Code := TempCode;
                exit(true);
            end;
        end;
        exit(false);
    end;
}