table 50105 "E3 Item Adj. Staging"
{
    Caption = 'Item Adjustment Staging';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(3; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = "Purchase","Sale","Positive Adjmt.","Negative Adjmt.","Transfer","Consumption","Output";
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            DataClassification = CustomerContent;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(9; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(10; "Unit Amount"; Decimal)
        {
            Caption = 'Unit Amount';
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(12; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            AutoFormatType = 2;
            DecimalPlaces = 2 : 5;
            DataClassification = CustomerContent;
        }
        field(13; "BU Code"; Code[20])
        {
            Caption = 'BU Code';
            DataClassification = CustomerContent;
        }
        field(14; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }
        field(15; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(16; Error; Boolean)
        {
            Caption = 'Error';
            DataClassification = ToBeClassified;
        }
        field(17; ErrorMessage; Text[2048])
        {
            Caption = 'Error Message';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(DocItem; "Document No.", "Item No.", "Posting Date")
        {
        }
    }
}