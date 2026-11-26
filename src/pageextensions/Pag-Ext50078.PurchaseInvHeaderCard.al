pageextension 50078 "E3 Posted Purch Inv Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Location Code")
        {
            field("W/S DL No."; Rec."W/S DL No.")
            {
                ApplicationArea = All;
            }

            field("Retail DL No."; Rec."Retail DL No.")
            {
                ApplicationArea = All;
            }
        }
    }
}