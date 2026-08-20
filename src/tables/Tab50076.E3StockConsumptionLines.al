table 50076 "E3 Stock Consumption Line"
{
    Caption = 'Stock Consumption Line';
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
        field(2; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line Number';
            DataClassification = CustomerContent;
        }
        field(4; "Entry Type"; Enum "E3 Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(5; "Entry Number"; Code[50])
        {
            Caption = 'Entry Number';
            DataClassification = CustomerContent;
        }
        field(6; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = CustomerContent;
        }
        field(7; "Document Type"; Text[100])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(8; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            DataClassification = CustomerContent;
        }
        field(9; "Legal Entity"; Text[100])
        {
            Caption = 'Legal Entity';
            DataClassification = CustomerContent;
        }
        field(10; "D365 From Department Code"; Code[20])
        {
            Caption = 'D365 From Department Code';
            DataClassification = CustomerContent;
        }
        field(11; "D365 From Department Name"; Text[100])
        {
            Caption = 'D365 From Department Name';
            DataClassification = CustomerContent;
        }
        field(12; "D365 To Department Code"; Code[20])
        {
            Caption = 'D365 To Department Code';
            DataClassification = CustomerContent;
        }
        field(13; "D365 To Department Name"; Text[100])
        {
            Caption = 'D365 To Department Name';
            DataClassification = CustomerContent;
        }
        field(14; "D365 Item Code"; Code[20])
        {
            Caption = 'D365 Item Code';
            DataClassification = CustomerContent;
        }
        field(15; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(16; "Item Type"; Text[50])
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(17; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(18; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 7;
            DataClassification = CustomerContent;
        }
        field(19; "D365 Unit Code"; Code[20])
        {
            Caption = 'D365 Unit Code';
            DataClassification = CustomerContent;
        }
        field(20; "Unit Name"; Text[50])
        {
            Caption = 'Unit Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.", "Entry Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}