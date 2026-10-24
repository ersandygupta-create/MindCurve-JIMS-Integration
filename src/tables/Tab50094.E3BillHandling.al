
table 50094 "E3 Bill Handling"
{
    Caption = 'Bill Handling';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; "Voucher Type Code"; Code[20])
        {
            Caption = 'Voucher Type Code';
            DataClassification = CustomerContent;
        }
        field(3; "Voucher Type Name"; Text[80])
        {
            Caption = 'Voucher Type Name';
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(5; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(6; "Challan No."; Code[35])
        {
            Caption = 'Challan No.';
            DataClassification = CustomerContent;
        }
        field(7; "Challan Date"; Date)
        {
            Caption = 'Challan Date';
            DataClassification = CustomerContent;
        }
        field(8; "GRN No."; Code[50])
        {
            Caption = 'GRN No.';
            DataClassification = CustomerContent;
        }
        field(9; "GRN Date"; Date)
        {
            Caption = 'GRN Date';
            DataClassification = CustomerContent;
        }
        field(10; "Bill Handling No."; Code[50])
        {
            Caption = 'Bill Handling No.';
            DataClassification = CustomerContent;
        }
        field(11; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(12; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(13; "Event Name"; Text[100])
        {
            Caption = 'Event Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
