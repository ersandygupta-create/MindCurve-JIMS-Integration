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
    }
}