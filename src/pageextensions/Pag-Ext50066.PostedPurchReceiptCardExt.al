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
                Editable = false;
            }

            field("Retail DL No."; Rec."Retail DL No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Purchase Invoice No"; Rec."Purchase Invoice No")
            {
                ApplicationArea = all;
                ToolTip = 'Purchase Invoice No.';
            }
            field("Purchase Invoice Created"; Rec."Purchase Invoice Created")
            {
                ApplicationArea = all;
                ToolTip = 'Purchase Invoice Created';
            }
        }

    }

    actions
    {
    }
}