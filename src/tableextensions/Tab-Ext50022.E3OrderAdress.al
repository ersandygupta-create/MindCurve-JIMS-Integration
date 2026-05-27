tableextension 50022 "E3 Order Adress" extends "Order Address"
{
    fields
    {
        field(50010; "E3 NPU"; Boolean)
        {
            Caption = 'NPU';
            DataClassification = CustomerContent;
        }
    }
}
