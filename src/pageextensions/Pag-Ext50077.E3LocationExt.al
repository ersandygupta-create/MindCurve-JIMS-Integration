pageextension 50077 "E3 Location Extension" extends "Location Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Caption = 'Name 2';
            }
        }
    }
}