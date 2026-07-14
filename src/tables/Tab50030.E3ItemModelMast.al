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
    begin
        if Code = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Item Model Nos.");

            "No. Series" := InventorySetup."Item Model Nos.";
            Code := NoSeries.GetNextNo("No. Series", Today, true);
        end;
    end;

    procedure AssistEdit(OldItemModel: Record "E3 Item Model Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Item Model Nos.");

        if NoSeries.LookupRelatedNoSeries(InventorySetup."Item Model Nos.", OldItemModel."No. Series", "No. Series") then begin
            Code := NoSeries.GetNextNo("No. Series", Today, true);
            exit(true);
        end;

        exit(false);
    end;

}

