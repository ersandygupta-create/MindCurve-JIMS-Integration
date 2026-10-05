pageextension 50094 "E3 Purchase Return Order Ext" extends "Purchase Return Order"
{
    layout
    {
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Voucher Type';
            }
        }
        addlast(General)
        {
            field("Item Make Code"; Rec."Item Make Code")
            {
                ApplicationArea = All;
                Caption = 'Item Make Code';
                ToolTip = 'Specifies the unique code of the item make.';
                ShowMandatory = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}