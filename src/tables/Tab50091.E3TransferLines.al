table 50091 "E3 Transfer Line"
{
    Caption = 'Transfer Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
            Editable = false;
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
            TableRelation = "E3 Transfer Header"."Entry Number";
        }
        field(4; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = CustomerContent;
        }
        field(5; "Document Type"; Text[50])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(6; "Document Number"; Text[50])
        {
            Caption = 'Document Number';
            DataClassification = CustomerContent;
        }
        field(7; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            DataClassification = CustomerContent;
        }
        field(8; "Legal Entity"; Text[150])
        {
            Caption = 'Legal Entity';
            DataClassification = CustomerContent;
        }
        field(9; "Line Number"; Integer)
        {
            Caption = 'Line Number';
            DataClassification = CustomerContent;
        }
        field(10; "D365 From Department Code"; Code[30])
        {
            Caption = 'D365 From Department Code';
            DataClassification = CustomerContent;
        }
        field(11; "D365 From Department Name"; Text[100])
        {
            Caption = 'D365 From Department Name';
            DataClassification = CustomerContent;
        }
        field(12; "D365 To Department Code"; Code[30])
        {
            Caption = 'D365 To Department Code';
            DataClassification = CustomerContent;
        }
        field(13; "D365 To Department Name"; Text[100])
        {
            Caption = 'D365 To Department Name';
            DataClassification = CustomerContent;
        }
        field(14; "D365 Item Code"; Code[30])
        {
            Caption = 'D365 Item Code';
            DataClassification = CustomerContent;
        }
        field(15; "Item Name"; Text[150])
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
            DecimalPlaces = 0 : 5;
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
        key(PK; "Entry No.", "Entry Type", "Document Type", "Entry Number", "Line Number")
        {
            Clustered = true;
        }
    }
}