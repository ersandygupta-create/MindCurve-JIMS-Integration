table 50106 "E3 Med PRD Refund"
{
    Caption = 'E3 Med PRD Refund';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(2; "UHID"; Code[30])
        {
            Caption = 'UHID';
            DataClassification = CustomerContent;
        }
        field(3; "Patient Name"; Text[100])
        {
            Caption = 'Patient Name';
            DataClassification = CustomerContent;
        }
        field(4; "Total"; Decimal)
        {
            Caption = 'Total';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(5; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(6; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else if ("Account Type" = const(Customer)) Customer
            else if ("Account Type" = const(Vendor)) Vendor
            else if ("Account Type" = const("Bank Account")) "Bank Account"
            else if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else if ("Account Type" = const("IC Partner")) "IC Partner"
            else if ("Account Type" = const(Employee)) Employee;
        }
        field(7; "Balance Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Balance A/c Type';
            DataClassification = CustomerContent;
        }
        field(8; "Balance Account No."; Code[20])
        {
            Caption = 'Balance A/c No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Balance Account Type" = const("G/L Account")) "G/L Account"
            else if ("Balance Account Type" = const(Customer)) Customer
            else if ("Balance Account Type" = const(Vendor)) Vendor
            else if ("Balance Account Type" = const("Bank Account")) "Bank Account"
            else if ("Balance Account Type" = const("Fixed Asset")) "Fixed Asset"
            else if ("Balance Account Type" = const("IC Partner")) "IC Partner"
            else if ("Balance Account Type" = const(Employee)) Employee;
        }
        field(9; "Pt. Account No."; Code[30])
        {
            Caption = 'Pt Account No.';
            DataClassification = CustomerContent;
        }
        field(10; "IFSC Code"; Code[20])
        {
            Caption = 'IFSC Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "External Document No.", "UHID")
        {
            Clustered = true;
        }
    }
}