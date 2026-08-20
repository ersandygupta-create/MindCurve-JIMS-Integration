table 50085 "E3 Bill Application"
{
    Caption = 'Bill Application';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Bill No"; Code[50])
        {
            Caption = 'Bill No.';
            DataClassification = CustomerContent;
        }
        field(3; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            DataClassification = CustomerContent;
        }
        field(4; "Patient Name"; Text[100])
        {
            Caption = 'Patient Name';
            DataClassification = CustomerContent;
        }
        field(5; "UHIDNo"; Code[50])
        {
            Caption = 'UHID No.';
            DataClassification = CustomerContent;
        }
        field(6; "Bill Amount"; Decimal)
        {
            Caption = 'Bill Amount';
            DataClassification = CustomerContent;
        }
        field(7; "Payment Received"; Decimal)
        {
            Caption = 'Payment Received';
            DataClassification = CustomerContent;
        }
        field(8; "Receipt From Patient Against Bill"; Decimal)
        {
            Caption = 'Receipt From Patient Against Bill';
            DataClassification = CustomerContent;
        }
        field(9; "Disallowed Service Wise"; Decimal)
        {
            Caption = 'Disallowed Service Wise';
            DataClassification = CustomerContent;
        }
        field(10; "Disallowed Reg. Wise"; Decimal)
        {
            Caption = 'Disallowed Reg. Wise';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(11; "Disallowed Billable"; Decimal)
        {
            Caption = 'Disallowed Billable';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(12; "Disallowed Security"; Decimal)
        {
            Caption = 'Disallowed Security';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(13; "TDS Amount"; Decimal)
        {
            Caption = 'TDS Amount';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(14; "Total Received From TPA"; Decimal)
        {
            Caption = 'Total Received From TPA';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(15; "Excess Billable"; Decimal)
        {
            Caption = 'Excess Billable';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(16; "Balance TPA Due"; Decimal)
        {
            Caption = 'Balance TPA Due';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(17; "Net Received From TPA"; Decimal)
        {
            Caption = 'Net Received From TPA';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(18; "Admission Date"; Date)
        {
            Caption = 'Admission Date';
            DataClassification = CustomerContent;
        }
        field(19; "Discharged Date"; Date)
        {
            Caption = 'Discharged Date';
            DataClassification = CustomerContent;
        }
        field(20; "Patient Type"; Text[50])
        {
            Caption = 'Patient Type';
            DataClassification = CustomerContent;
        }
        field(21; "Reg No."; Code[50])
        {
            Caption = 'Reg. No.';
            DataClassification = CustomerContent;
        }
        field(22; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(23; "Insurance Co."; Text[100])
        {
            Caption = 'Insurance Co.';
            DataClassification = CustomerContent;
        }
        field(24; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Organization Receipt";
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}