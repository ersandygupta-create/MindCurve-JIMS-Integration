tableextension 50077 "E3 Sale Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(50003; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(50004; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50005; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(50006; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }
        field(50007; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(50008; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(50009; "Purchase Line Created"; Boolean)
        {
            Caption = 'Purchase Line Created';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50010; "E3 Indent Line"; Boolean)
        {
            Caption = 'Indent Line';
            DataClassification = CustomerContent;
        }
    }
}