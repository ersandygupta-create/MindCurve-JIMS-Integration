tableextension 50079 "E3 General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "GL Entries Edit"; Boolean)
        {
            Caption = 'GL Entries Edit';
            DataClassification = CustomerContent;
        }
    }

}