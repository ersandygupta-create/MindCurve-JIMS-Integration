tableextension 50076 "E3 Sales Cr. Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50001; "Stock No"; Code[50])
        {
            Caption = 'Stock No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50002; "Stock Line No"; Integer)
        {
            Caption = 'Stock Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
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