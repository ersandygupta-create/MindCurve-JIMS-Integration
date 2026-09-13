tableextension 50075 "E3 Sales Invoice Line Ext" extends "Sales Invoice Line"
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
    }
}