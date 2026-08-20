tableextension 50006 "E3 HIS Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; "E3 Capex Type"; Enum "E3 Capex Type")
        {
            Caption = 'Capex Type';
            DataClassification = CustomerContent;
        }
        field(50001; "E3 Work Order Type"; Enum "E3 Work Order Type")
        {
            Caption = 'Work Order Type';
            DataClassification = CustomerContent;
        }
        field(50002; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50004; "E3 Delivery Terms"; Text[150])
        {
            Caption = 'Delivery Terms';
            DataClassification = CustomerContent;
        }
        field(50005; "Store Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Store Name';
        }
        field(50008; "W/S DL No."; Text[60])
        {
            Caption = 'W/S DL No.';
            DataClassification = CustomerContent;
        }

        field(50009; "Retail DL No."; Text[60])
        {
            Caption = 'Retail DL No.';
            DataClassification = CustomerContent;
        }
        field(50010; "E3 Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Exp. CN Value"; Decimal)
        {
            Caption = 'Exp. CN Value';
            DataClassification = CustomerContent;
        }

    }
}
