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
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
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
    trigger OnInsert()
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if Code = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Item Make Nos.");

            "No. Series" := InventorySetup."Item Make Nos.";
            Code := NoSeries.GetNextNo("No. Series", Today, true);
        end;
    end;

    procedure AssistEdit(OldItemMake: Record "E3 Item Make Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Item Make Nos.");

        if NoSeries.LookupRelatedNoSeries(
            InventorySetup."Item Make Nos.",
            OldItemMake."No. Series",
            "No. Series")
        then begin
            Code := NoSeries.GetNextNo("No. Series", Today, true);
            exit(true);
        end;

        exit(false);
    end;

}

