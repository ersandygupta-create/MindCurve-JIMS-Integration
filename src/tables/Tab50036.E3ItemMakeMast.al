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
            trigger OnValidate()
            begin
                if (xRec.Code <> '') and (Rec.Code <> xRec.Code) then
                    Error('Code cannot be modified once it has been assigned.');
            end;
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
        field(10; "First Sent"; Boolean)
        {
            Caption = 'First Sent';
            DataClassification = CustomerContent;
        }
        field(11; LocalEmail; Text[80])
        {
            Caption = 'localEmail';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateEmail();
            end;
        }
        field(12; RegEmail; Text[80])
        {
            Caption = 'regEmail';
            DataClassification = CustomerContent;
        }
        field(13; NatEmail; Text[80])
        {
            Caption = 'natEmail';
            DataClassification = CustomerContent;
        }
        field(14; Email; Text[80])
        {
            Caption = 'Email';
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
        TestField("Company Name");
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

    local procedure ValidateEmail()
    var
        MailManagement: Codeunit "Mail Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateEmail(Rec, IsHandled, xRec);
        if IsHandled then
            exit;

        if Email = '' then
            exit;
        MailManagement.CheckValidEmailAddresses(Email);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateEmail(var ItemMakeMaster: Record "E3 Item Make Master"; var IsHandled: Boolean; xItemMakeMaster: Record "E3 Item Make Master")
    begin
    end;

}

