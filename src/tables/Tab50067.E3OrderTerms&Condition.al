table 50067 "E3 Order Terms & Conditions"
{
    Caption = 'Order Terms & Conditions';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Default Value"; Text[80])
        {
            Caption = 'Default Value';
            DataClassification = CustomerContent;
        }
        field(4; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(5; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Voucher Type".Code where("Entry Type" = const(Order));
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;
}