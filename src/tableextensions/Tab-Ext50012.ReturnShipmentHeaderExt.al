tableextension 50012 "E3 HIS Return Shipment Header" extends "Return Shipment Header"
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
        field(50016; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
        }
        field(50017; "GRN Voucher Type Name"; Text[60])
        {
            Caption = 'GRN Voucher Type Name';
            DataClassification = CustomerContent;
        }
        field(50018; "Print Caption"; Text[50])
        {
            Caption = 'Print Caption';
            DataClassification = CustomerContent;
        }
        field(50100; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(50101; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
    }
}
