table 50102 "C"
{
    DataClassification = CustomerContent;
    Caption = 'C';

    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Allocation Entry No."; Integer) { Caption = 'Allocation Entry No.'; }
        field(3; "Line No."; Integer) { Caption = 'Line No.'; }
        field(4; "Customer Code"; Code[20]) { Caption = 'Customer Code'; }
        field(5; "Applied Amount"; Decimal) { Caption = 'Applied Amount'; }
    }

    keys
    {
        key(PK; "Document No.", "Allocation Entry No.", "Line No.") { Clustered = true; }
    }
}