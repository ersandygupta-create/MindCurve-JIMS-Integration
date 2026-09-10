pageextension 50098 "E3 Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                Caption = 'Voucher Type';
                Editable = Rec."Voucher Type" = '';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
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