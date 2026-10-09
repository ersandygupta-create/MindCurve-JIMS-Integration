table 50088 "E3 Pharmacy Sale Header"
{
    Caption = 'Pharmacy Sale Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            BlankZero = true;
            MinValue = 1;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(2; "Entry Type"; Text[30])
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(3; "Entry Number"; Text[100])
        {
            Caption = 'Entry Number';
            DataClassification = CustomerContent;
        }
        field(4; "Document Type"; Text[50])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(5; "Document Number"; Text[50])
        {
            Caption = 'Document Number';
            DataClassification = CustomerContent;
        }
        field(6; "D365 Department Code"; Code[30])
        {
            Caption = 'D365 Department Code';
            DataClassification = CustomerContent;
        }
        field(7; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            DataClassification = CustomerContent;
        }
        field(8; "Location Code"; Code[30])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(9; "Location Name"; Text[100])
        {
            Caption = 'Location Name';
            DataClassification = CustomerContent;
        }
        field(10; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            DataClassification = CustomerContent;
        }
        field(11; "Legal Entity"; Text[150])
        {
            Caption = 'Legal Entity';
            DataClassification = CustomerContent;
        }
        field(12; "Consultant Name"; Text[100])
        {
            Caption = 'Consultant Name';
            DataClassification = CustomerContent;
        }
        field(13; Speciality; Text[100])
        {
            Caption = 'Speciality';
            DataClassification = CustomerContent;
        }
        field(14; "Patient UHID"; Text[50])
        {
            Caption = 'Patient UHID';
            DataClassification = CustomerContent;
        }
        field(15; "Patient Name"; Text[100])
        {
            Caption = 'Patient Name';
            DataClassification = CustomerContent;
        }
        field(16; "Patient Mobile"; Text[30])
        {
            Caption = 'Patient Mobile';
            DataClassification = CustomerContent;
        }
        field(17; "Bill No."; Text[50])
        {
            Caption = 'Bill No.';
            DataClassification = CustomerContent;
        }
        field(18; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            DataClassification = CustomerContent;
        }
        field(19; "Bill Time"; Time)
        {
            Caption = 'Bill Time';
            DataClassification = CustomerContent;
        }
        field(20; "OH Amt Gross"; Decimal)
        {
            Caption = 'OH Amt Gross';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(21; "OH Amt Discount"; Decimal)
        {
            Caption = 'OH Amt Discount';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(22; "OH Amt Taxable"; Decimal)
        {
            Caption = 'OH Amt Taxable';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(23; "OH Amt CGST"; Decimal)
        {
            Caption = 'OH Amt CGST';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(24; "OH Amt SGST"; Decimal)
        {
            Caption = 'OH Amt SGST';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(25; "OH Amt UGST"; Decimal)
        {
            Caption = 'OH Amt UGST';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(26; "OH Amt IGST"; Decimal)
        {
            Caption = 'OH Amt IGST';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(27; "OH Amt RoundOff"; Decimal)
        {
            Caption = 'OH Amt RoundOff';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(28; "OH Amt Net"; Decimal)
        {
            Caption = 'OH Amt Net';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
        field(29; "Prepared By"; Code[30])
        {
            Caption = 'Prepared By';
            DataClassification = CustomerContent;
        }
        field(30; "No of Lines"; Integer)
        {
            Caption = 'No of Lines';
            DataClassification = CustomerContent;
        }
        field(31; "Is Created"; Boolean)
        {
            Caption = 'Is Created';
            DataClassification = CustomerContent;
        }
        field(32; "Is Posted"; Boolean)
        {
            Caption = 'Is Posted';
            DataClassification = CustomerContent;
        }
        field(33; "Validation Key"; Text[60])
        {
            Caption = 'Validation Key';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Entry Type", "Document Type", "Entry Number")
        {
            Clustered = true;
        }
    }
}