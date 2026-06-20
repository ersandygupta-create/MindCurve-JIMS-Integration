pageextension 50009 "E3 HIS Purchase Order" extends "Purchase Order"
{
    layout

    {
        addlast(General)
        {

            field("E3 Item Type"; Rec."E3 Item Type")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the Item Type field.';
            }
            field("E3 Delivery Terms"; Rec."E3 Delivery Terms")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the Delivery Terms field.';
            }
            field("Store Name"; Rec."Store Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Store Name field';
            }
            field("Advance PO"; Rec."Advance PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance PO field';
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
        addafter("No.")
        {
            field("TransactionType"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                Caption = 'Transaction Type';
            }
        }
    }

    var
        recPurchHdr: Record "Purchase Header";

}
