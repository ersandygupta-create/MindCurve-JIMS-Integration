table 50066 "E3 GRN Work Sheet Line"
{
    Caption = 'E3 GRN Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document ID"; Code[20])
        {
            Caption = 'Document ID';
            DataClassification = CustomerContent;
            TableRelation = "E3 GRN Work Sheet Header"."Document ID";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Indent Document ID"; Code[20])
        {
            Caption = 'Indent Document ID';
            DataClassification = CustomerContent;
        }
        field(4; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
            DataClassification = CustomerContent;
        }
        field(6; "DM Item Code"; BigInteger)
        {
            Caption = 'DM Item Code';
            DataClassification = CustomerContent;
        }
        field(7; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(8; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
        field(9; "DM Department Code"; BigInteger)
        {
            Caption = 'DM Department Code';
            DataClassification = CustomerContent;
        }
        field(10; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            DataClassification = CustomerContent;
        }
        field(11; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            DataClassification = CustomerContent;
        }
        field(12; "DM Unit Code"; BigInteger)
        {
            Caption = 'DM Unit Code';
            DataClassification = CustomerContent;
        }
        field(13; "HSN Code"; Code[20])
        {
            Caption = 'HSN Code';
            DataClassification = CustomerContent;
        }
        field(14; "DM HSN Code"; BigInteger)
        {
            Caption = 'DM HSN Code';
            DataClassification = CustomerContent;
        }
        field(15; "Indent SKU Qty"; Decimal)
        {
            Caption = 'Indent SKU Qty';
            DecimalPlaces = 0 : 5;
        }
        field(16; "Received SKU Qty"; Decimal)
        {
            Caption = 'Received SKU Qty';
            DecimalPlaces = 0 : 5;
        }
        field(17; Rate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 0 : 5;
        }
        field(18; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DecimalPlaces = 0 : 5;
        }
        field(19; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DecimalPlaces = 0 : 5;
        }
        field(20; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(21; "Taxable Amount"; Decimal)
        {
            Caption = 'Taxable Amount';
            DecimalPlaces = 0 : 5;
        }
        field(22; "CGST %"; Decimal)
        {
            Caption = 'CGST %';
            DecimalPlaces = 0 : 5;
        }
        field(23; "CGST Amount"; Decimal)
        {
            Caption = 'CGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(24; "SGST %"; Decimal)
        {
            Caption = 'SGST %';
            DecimalPlaces = 0 : 5;
        }
        field(25; "SGST Amount"; Decimal)
        {
            Caption = 'SGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(26; "IGST %"; Decimal)
        {
            Caption = 'IGST %';
            DecimalPlaces = 0 : 5;
        }
        field(27; "IGST Amount"; Decimal)
        {
            Caption = 'IGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(28; "UGST %"; Decimal)
        {
            Caption = 'UGST %';
            DecimalPlaces = 0 : 5;
        }
        field(29; "UGST Amount"; Decimal)
        {
            Caption = 'UGST Amount';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Final Discount %"; Decimal)
        {
            Caption = 'Final Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(31; "Final Discount Amount"; Decimal)
        {
            Caption = 'Final Discount Amount';
            DecimalPlaces = 0 : 5;
        }
        field(32; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DecimalPlaces = 0 : 5;
        }
        field(33; "Landed SKU Value"; Decimal)
        {
            Caption = 'Landed SKU Value';
            DecimalPlaces = 0 : 5;
        }
        field(34; "Landed SKU Rate"; Decimal)
        {
            Caption = 'Landed SKU Rate';
            DecimalPlaces = 0 : 5;
        }
        field(35; Remark; Text[250])
        {
            Caption = 'Remark';
        }
        field(36; MRP; Decimal)
        {
            Caption = 'MRP';
            DecimalPlaces = 0 : 5;
        }
        field(37; "SKU MRP"; Decimal)
        {
            Caption = 'SKU MRP';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Sale Rate"; Decimal)
        {
            Caption = 'Sale Rate';
            DecimalPlaces = 0 : 5;
        }
        field(39; "SKU Sale Rate"; Decimal)
        {
            Caption = 'SKU Sale Rate';
            DecimalPlaces = 0 : 5;
        }
        field(40; "Staff Sale Rate"; Decimal)
        {
            Caption = 'Staff Sale Rate';
            DecimalPlaces = 0 : 5;
        }
        field(41; "SKU Staff Sale Rate"; Decimal)
        {
            Caption = 'SKU Staff Sale Rate';
            DecimalPlaces = 0 : 5;
        }
        field(42; Barcode; Code[50])
        {
            Caption = 'Barcode';
        }
        field(43; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
        }
        field(44; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
        }
        field(45; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
        }
        field(46; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
        }
        field(47; "GST Type Code"; Code[20])
        {
            Caption = 'GST Type Code';
        }
        field(48; "Item GST Nature"; Code[10])
        {
            Caption = 'Item GST Nature';
        }
        field(49; Status; Text[30])
        {
            Caption = 'Status';
        }
        field(50; "DM TimeStamp"; DateTime)
        {
            Caption = 'DM TimeStamp';
        }
        field(51; "DM Document ID"; BigInteger)
        {
            Caption = 'DM Document ID';
        }
        field(52; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(53; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document ID", "Line No.")
        {
            Clustered = true;
        }
    }
}