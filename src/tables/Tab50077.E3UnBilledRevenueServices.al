table 50077 "E3 UnBilled Service Revenue"
{
    Caption = 'Service Revenue Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "SNo."; Integer)
        {
            Caption = 'SNo.';
            AutoIncrement = true;
            BlankZero = true;
            MinValue = 1;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No."; Code[50])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(3; "Service Type"; Text[50])
        {
            Caption = 'Service Type';
            DataClassification = CustomerContent;
        }
        field(4; "GL Account Name"; Text[100])
        {
            Caption = 'GL Account Name';
            DataClassification = CustomerContent;
        }
        field(5; Department; Text[100])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(6; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(7; "Service Category"; Text[100])
        {
            Caption = 'Service Category';
            DataClassification = CustomerContent;
        }
        field(8; "Service Item ID"; Code[50])
        {
            Caption = 'Service Item ID';
            DataClassification = CustomerContent;
        }
        field(9; "Service Item Name"; Text[150])
        {
            Caption = 'Service Item Name';
            DataClassification = CustomerContent;
        }
        field(10; "Service Item Code"; Code[50])
        {
            Caption = 'Service Item Code';
            DataClassification = CustomerContent;
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 7;
            DataClassification = CustomerContent;
        }
        field(12; Rate; Decimal)
        {
            Caption = 'Rate';
            DataClassification = CustomerContent;
        }
        field(13; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DataClassification = CustomerContent;
        }
        field(14; "MOU Discount"; Decimal)
        {
            Caption = 'MOU Discount';
            DataClassification = CustomerContent;
        }
        field(15; "AddOn Discount"; Decimal)
        {
            Caption = 'AddOn Discount';
            DataClassification = CustomerContent;
        }
        field(16; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DataClassification = CustomerContent;
        }
        field(17; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(18; "Location Name"; Text[100])
        {
            Caption = 'Location Name';
            DataClassification = CustomerContent;
        }
        field(19; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(20; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
            DataClassification = CustomerContent;
        }
        field(21; "Payor Code"; Code[50])
        {
            Caption = 'Payor Code';
            DataClassification = CustomerContent;
        }
        field(22; "Payor Category"; Text[50])
        {
            Caption = 'Payor Category';
            DataClassification = CustomerContent;
        }
        field(23; "Payor Name"; Text[100])
        {
            Caption = 'Payor Name';
            DataClassification = CustomerContent;
        }
        field(24; "Service Line No."; Integer)
        {
            Caption = 'Service Line No.';
            DataClassification = CustomerContent;
        }
        field(25; "Department ID"; Code[50])
        {
            Caption = 'Department ID';
            DataClassification = CustomerContent;
        }
        field(26; "Facility ID"; Code[20])
        {
            Caption = 'Facility ID';
            DataClassification = CustomerContent;
        }
        field(27; "Header ID"; Code[50])
        {
            Caption = 'Header ID';
            DataClassification = CustomerContent;
        }
        field(28; "Net Payable Amount"; Decimal)
        {
            Caption = 'Net Payable Amount';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(29; "Validation HIS Key"; Code[100])
        {
            Caption = 'Validation HIS Key';
            DataClassification = CustomerContent;
        }
        field(30; "Reg. No."; Code[50])
        {
            Caption = 'Reg. No.';
            DataClassification = CustomerContent;
        }
        field(31; Created; Boolean)
        {
            Caption = 'Created';
            DataClassification = CustomerContent;
        }
        field(32; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(33; UHID; Text[30])
        {
            Caption = 'UHID';
            DataClassification = CustomerContent;
        }
        field(34; "Patient Name"; Text[100])
        {
            Caption = 'Patient Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "SNo.")
        {
            Clustered = true;
        }
    }
}