table 50037 "E3 Medicine Component Master"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Medicine Component Master";
    LookupPageId = "E3 Medicine Component Master";

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
        field(3; "Restrict Group Code"; Code[20])
        {
            Caption = 'Restrict Group Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Restricted Group Master".Code;
        }
        field(4; IsActive; Boolean)
        {
            Caption = 'IsActive';
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
    begin
        TestField(Name);
        if Code = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Medicine Component Nos.");

            "No. Series" := InventorySetup."Medicine Component Nos.";
            Code := NoSeries.GetNextNo("No. Series", Today, true);
        end;
    end;

    procedure AssistEdit(OldMedicineComponent: Record "E3 Medicine Component Master"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Medicine Component Nos.");

        if NoSeries.LookupRelatedNoSeries(
            InventorySetup."Medicine Component Nos.",
            OldMedicineComponent."No. Series",
            "No. Series")
        then begin
            Code := NoSeries.GetNextNo("No. Series", Today, true);
            exit(true);
        end;

        exit(false);
    end;

}

