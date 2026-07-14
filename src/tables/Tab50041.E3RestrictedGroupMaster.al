table 50041 "E3 Restricted Group Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Restricted Group Master";
    LookupPageId = "E3 Restricted Group Master";

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
        field(4; Response; Text[30])
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
            Editable = false;
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
            InventorySetup.TestField("Restricted Group Nos.");

            "No. Series" := InventorySetup."Restricted Group Nos.";
            Code := NoSeries.GetNextNo("No. Series", Today, true);
        end;
    end;

    procedure AssistEdit(OldRestrictedGroup: Record "E3 Restricted Group Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Restricted Group Nos.");

        if NoSeries.LookupRelatedNoSeries(
            InventorySetup."Restricted Group Nos.",
            OldRestrictedGroup."No. Series",
            "No. Series")
        then begin
            Code := NoSeries.GetNextNo("No. Series", Today, true);
            exit(true);
        end;

        exit(false);
    end;

}

