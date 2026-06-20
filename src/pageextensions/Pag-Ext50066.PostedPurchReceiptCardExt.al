pageextension 50066 "Posted Purch Receipt Card Ext" extends "Posted Purchase Receipt"
{
    layout
    {
        addbefore("Quote No.")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Posting Description';
                ToolTip = 'Specifies a posting description of the order.';
            }
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

    actions
    {
    }
}