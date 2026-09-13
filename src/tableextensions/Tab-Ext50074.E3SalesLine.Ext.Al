tableextension 50074 E3SalesLineExt extends "Sales Line"
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
    }


}