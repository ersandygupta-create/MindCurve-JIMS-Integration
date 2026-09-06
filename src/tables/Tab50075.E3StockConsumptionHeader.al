table 50075 "E3 Stock Consumption Header"
{
    Caption = 'Stock Consumption Header';
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
        field(3; "Entry Type"; Enum "Item Journal Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(4; "Entry Number"; Code[50])
        {
            Caption = 'Entry Number';
            DataClassification = CustomerContent;
        }
        field(5; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = CustomerContent;
        }
        field(6; "Document Type"; Text[100])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(7; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
        }
        field(8; "Legal Entity"; Text[100])
        {
            Caption = 'Legal Entity';
            DataClassification = CustomerContent;
        }
        field(9; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.", "Entry Type", "Document No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        StockLine: Record "E3 Stock Consumption Line";
    begin
        StockLine.SetRange("Entry Type", "Entry Type");
        StockLine.SetRange("Document No.", Rec."Document No.");
        StockLine.DeleteAll();
    end;

}