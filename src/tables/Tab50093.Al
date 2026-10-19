table 50100 "A"
{
    DataClassification = CustomerContent;
    Caption = 'A';

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; }
        field(2; "Selected Allocation Entry No."; Integer) { Caption = 'Selected Allocation Entry No.'; }
        field(3; "Selected Customer Code"; Code[20]) { Caption = 'Selected Customer Code'; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }
}

