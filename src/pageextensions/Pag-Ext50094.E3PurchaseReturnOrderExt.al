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
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}