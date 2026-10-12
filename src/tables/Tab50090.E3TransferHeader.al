table 50090 "E3 Transfer Header"
{
    Caption = 'Transfer Header';
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
        }
        field(4; "v_Date"; Date)
        {
            Caption = 'Date';
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
        field(7; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            DataClassification = CustomerContent;
        }
        field(8; "Legal Entity"; Text[150])
        {
            Caption = 'Legal Entity';
            DataClassification = CustomerContent;
        }
        field(9; "Number of Lines"; Integer)
        {
            Caption = 'Number of Lines';
            DataClassification = CustomerContent;
        }
        field(10; "Is Created"; Boolean)
        {
            Caption = 'Is Created';
            DataClassification = CustomerContent;
        }
        field(11; "Is Posted"; Boolean)
        {
            Caption = 'Is Posted';
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