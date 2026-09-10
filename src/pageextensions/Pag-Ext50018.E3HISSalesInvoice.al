pageextension 50018 "E3 HIS Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("E3 RCM"; Rec."E3 RCM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RCM field.';
            }

        }
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
}
