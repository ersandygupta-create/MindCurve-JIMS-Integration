pageextension 50099 "E3 Purchase Credit Memo Ext" extends "Purchase Credit Memo"
{
    layout
    {
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a vlaue Voucher Type';
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