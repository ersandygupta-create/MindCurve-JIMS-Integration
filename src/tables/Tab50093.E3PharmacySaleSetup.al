table 50093 "E3 Pharmacy Sale Setup"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "E3 Pharmacy Sale Setup";
    LookupPageId = "E3 Pharmacy Sale Setup";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            BlankZero = true;
            MinValue = 1;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Document Type"; Text[60])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(4; "Account No."; Code[20])
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
            trigger OnValidate()
            begin
                UpdateAccountName();
            end;
        }
        field(5; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = ,Sale,"Credit Memo";
            DataClassification = CustomerContent;
        }
        field(7; "Shortcut Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    local procedure UpdateAccountName()
    var
        GLAccount: Record "G/L Account";
        CustomerRec: Record Customer;
        VendorRec: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        EmployeeRec: Record Employee;
    begin
        Name := '';

        case "Account Type" of
            "Account Type"::"G/L Account":
                if GLAccount.Get("Account No.") then
                    Name := GLAccount.Name;

            "Account Type"::Customer:
                if CustomerRec.Get("Account No.") then
                    Name := CustomerRec.Name;

            "Account Type"::Vendor:
                if VendorRec.Get("Account No.") then
                    Name := VendorRec.Name;

            "Account Type"::"Bank Account":
                if BankAccount.Get("Account No.") then
                    Name := BankAccount.Name;

            "Account Type"::"Fixed Asset":
                if FixedAsset.Get("Account No.") then
                    Name := FixedAsset.Description;

            "Account Type"::"IC Partner":
                if ICPartner.Get("Account No.") then
                    Name := ICPartner.Name;

            "Account Type"::Employee:
                if EmployeeRec.Get("Account No.") then
                    Name := EmployeeRec.FullName();
        end;
    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}