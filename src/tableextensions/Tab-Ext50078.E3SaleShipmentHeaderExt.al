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
            TableRelation = "E3 Voucher Type".Code where("Entry Type" = const(Sale));
        }
    }
}