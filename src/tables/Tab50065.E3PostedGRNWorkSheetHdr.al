table 50065 "E3 GRN Work Sheet Header"
{
    Caption = 'E3 GRN Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document ID"; Code[20])
        {
            Caption = 'Document ID';
            DataClassification = CustomerContent;
        }
        field(2; "Voucher Type"; Integer)
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
        }
        field(3; Prefix; Integer)
        {
            Caption = 'Prefix';
            DataClassification = CustomerContent;
        }
        field(4; "Voucher Date"; DateTime)
        {
            Caption = 'Voucher Date';
            DataClassification = CustomerContent;
        }
        field(5; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(6; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            DataClassification = CustomerContent;
        }
        field(7; "Supplier Code"; Code[20])
        {
            Caption = 'Supplier Code';
            DataClassification = CustomerContent;
        }
        field(8; "Place of Supply"; Text[100])
        {
            Caption = 'Place of Supply';
            DataClassification = CustomerContent;
        }
        field(9; Remark; Text[250])
        {
            Caption = 'Remark';
            DataClassification = CustomerContent;
        }
        field(10; "Purchase Challan No."; Code[30])
        {
            Caption = 'Purchase Challan No.';
            DataClassification = CustomerContent;
        }
        field(11; "Purchase Challan Date"; DateTime)
        {
            Caption = 'Purchase Challan Date';
            DataClassification = CustomerContent;
        }
        field(12; "OH Amount Gross"; Decimal)
        {
            Caption = 'Gross Amount';
            DecimalPlaces = 0 : 5;
        }
        field(13; "OH Amount Discount"; Decimal)
        {
            Caption = 'Discount Amount';
            DecimalPlaces = 0 : 5;
        }
        field(14; "OH Amount Taxable"; Decimal)
        {
            Caption = 'Taxable Amount';
            DecimalPlaces = 0 : 5;
        }
        field(15; "OH Amount CGST"; Decimal)
        {
            Caption = 'CGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(16; "OH Amount SGST"; Decimal)
        {
            Caption = 'SGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(17; "OH Amount IGST"; Decimal)
        {
            Caption = 'IGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(18; "OH Amount UGST"; Decimal)
        {
            Caption = 'UGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(19; "OH Amount Total"; Decimal)
        {
            Caption = 'Total Amount';
            DecimalPlaces = 0 : 5;
        }
        field(20; "OH Final Discount %"; Decimal)
        {
            Caption = 'Final Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(21; "OH Final Discount Amount"; Decimal)
        {
            Caption = 'Final Discount Amount';
            DecimalPlaces = 0 : 5;
        }
        field(22; "OH Round Off"; Decimal)
        {
            Caption = 'Round Off';
            DecimalPlaces = 0 : 5;
        }
        field(23; "OH Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DecimalPlaces = 0 : 5;
        }
        field(24; "OH Landed Value"; Decimal)
        {
            Caption = 'Landed Value';
            DecimalPlaces = 0 : 5;
        }
        field(25; "Prepared By"; Code[50])
        {
            Caption = 'Prepared By';
        }
        field(26; "Prepared Date"; DateTime)
        {
            Caption = 'Prepared Date';
        }
        field(27; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
        }
        field(28; "Approval Date Time"; DateTime)
        {
            Caption = 'Approval Date Time';
        }
        field(29; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
        }
        field(30; "Business Unit Name"; Text[100])
        {
            Caption = 'Business Unit Name';
        }
        field(31; "RCM Applicable"; Boolean)
        {
            Caption = 'RCM Applicable';
        }
        field(32; "Party Type"; Text[30])
        {
            Caption = 'Party Type';
        }
        field(33; GSTIN; Code[20])
        {
            Caption = 'GSTIN';
        }
        field(34; "E-Way Bill No."; Code[30])
        {
            Caption = 'E-Way Bill No.';
        }
        field(35; "E-Way Bill Date"; DateTime)
        {
            Caption = 'E-Way Bill Date';
        }
        field(36; "LR No."; Code[30])
        {
            Caption = 'LR No.';
        }
        field(37; "LR Date"; DateTime)
        {
            Caption = 'LR Date';
        }
        field(38; "GST Location"; Text[100])
        {
            Caption = 'GST Location';
        }
        field(39; Status; Text[30])
        {
            Caption = 'Status';
        }
        field(40; "DM Doc ID"; BigInteger)
        {
            Caption = 'DM Document ID';
        }
        field(41; "Legal Entity"; Text[100])
        {
            Caption = 'Legal Entity';
        }
        field(42; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(43; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Document ID")
        {
            Clustered = true;
        }
    }
}