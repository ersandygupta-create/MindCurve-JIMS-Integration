table 50101 "B"
{
    DataClassification = CustomerContent;
    Caption = 'B';

    fields
    {
        field(1; "Document No."; Code[20]) { TableRelation = "A"; }
        field(2; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(3; "Customer Code"; Code[20]) { Caption = 'Customer Code'; }
        field(4; "Receipt Date"; Date) { Caption = 'Receipt Date'; }
        field(5; "Receipt Amount"; Decimal) { Caption = 'Receipt Amount'; }
    }

    keys
    {
        key(PK; "Document No.", "Entry No.") { Clustered = true; }
    }
}

