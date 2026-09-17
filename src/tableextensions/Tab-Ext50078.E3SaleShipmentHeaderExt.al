tableextension 50078 "E3 Sale Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(50001; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(50108; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
        }
        field(50112; "GRN Voucher Type Name"; Text[60])
        {
            Caption = 'GRN Voucher Type Name';
            DataClassification = CustomerContent;
        }
        field(50113; Sync; Boolean)
        {
            Caption = 'Sync';
            DataClassification = CustomerContent;
        }
    }
}