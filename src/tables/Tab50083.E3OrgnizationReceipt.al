table 50083 "E3 Organization Receipt"
{
    Caption = 'Organization Receipt';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Get Orgnization Receipt";
    LookupPageId = "E3 Get Orgnization Receipt";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "HIS Document Type"; Enum "HIS Settlement Type")
        {
            Caption = 'HIS Document Type';
            DataClassification = CustomerContent;
        }
        field(3; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;

        }
        field(5; "Received Amount"; Decimal)
        {
            Caption = 'Received Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateBalance();
            end;
        }
        field(6; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST(Employee)) Employee;
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // var
            //     GLAccount: Record "G/L Account";
            //     BankAccount: Record "Bank Account";
            // begin
            //     IF "Account Type" = "Account Type"::"G/L Account" then begin
            //         IF GLAccount.Get("Account No.") then
            //             "Account Name" := GLAccount.Name;
            //     end ELSE
            //         if "Account Type" = "Account Type"::"Bank Account" then begin
            //             IF BankAccount.Get("Account No.") then
            //                 "Account Name" := BankAccount.Name;
            //         end ELSE
            //             "Account Name" := '';

            // end;
        }
        field(8; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            DataClassification = CustomerContent;
        }
        field(9; "Bal. Account No"; Code[20])
        {
            Caption = 'Bal. Account No';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(10; "Instrument No."; Code[50])
        {
            Caption = 'Instrument No.';
            DataClassification = CustomerContent;
        }
        field(11; "Instrument Date"; Date)
        {
            Caption = 'Instrument Date';
            DataClassification = CustomerContent;
        }
        field(12; IsCreated; Boolean)
        {
            Caption = 'IsCreated';
            DataClassification = CustomerContent;
        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(15; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(16; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
            DataClassification = CustomerContent;
        }
        field(17; "Allocation Amount"; Decimal)
        {
            Caption = 'Allocation Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("E3 Allocation Receipt"."Allocated Amount"
        WHERE("Receipt No." = FIELD("Document No.")));
            Editable = false;
            trigger OnValidate()
            begin
                UpdateBalance();
            end;
        }
        field(18; Balance; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(19; "Allocation Status"; Enum "E3 Allocation Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(20; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(21; "Selected Allocation Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(22; "Selected Customer CodeCode"; code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Document No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        IntegrationSetup: Record "E3 HIS Integartion Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Document No." = '' then begin
            IntegrationSetup.Get();
            IntegrationSetup.TestField("Settlement Nos.");

            "Document No." :=
                NoSeries.GetNextNo(IntegrationSetup."Settlement Nos.", WorkDate());
            "Document Date" := WorkDate();
        end;
    end;

    procedure AssistEdit(OldORHeader: Record "E3 Organization Receipt"): Boolean
    var
        IntegrationSetup: Record "E3 HIS Integartion Setup";
        NoSeries: Codeunit "No. Series";
        ORHeader: Record "E3 Organization Receipt";
    begin
        ORHeader := Rec;

        IntegrationSetup.Get();
        IntegrationSetup.TestField("Settlement Nos.");

        if NoSeries.LookupRelatedNoSeries(
            IntegrationSetup."Settlement Nos.",
            OldORHeader."No. Series",
            ORHeader."No. Series")
        then begin
            ORHeader."Document No." := NoSeries.GetNextNo(ORHeader."No. Series");
            Rec := ORHeader;
            exit(true);
        end;

        exit(false);
    end;

    local procedure UpdateBalance()
    begin
        Balance := "Received Amount" - "Allocation Amount";

        // if "Allocation Amount" >= "Received Amount" then
        //     "Allocation Status" := "Allocation Status"::"Fully Allocate"
        // else
        //     "Allocation Status" := "Allocation Status"::"Partial Allocate";
    end;
}