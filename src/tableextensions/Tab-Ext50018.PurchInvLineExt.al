tableextension 50018 "E3 HIS Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {

        field(50000; "E3 HIS Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }

        field(50002; "E3 HIS Type"; Enum "E3 HIS Type")
        {
            Caption = 'HIS Type';
            DataClassification = CustomerContent;
        }
        field(50003; "Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50004; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
        field(50005; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
        }
        field(50006; "Item Make Name"; Text[60])
        {
            Caption = 'Item Make Name';
            DataClassification = CustomerContent;
        }
        field(50007; Critical; Boolean)
        {
            Caption = 'Critical';
            DataClassification = CustomerContent;
        }

    }
}
