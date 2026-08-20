pageextension 50011 "E3 HIS Cash Payment Voucherr" extends "Cash Payment Voucher"
{
    layout
    {
        addlast(Control1)
        {
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the account posting group that the entry on the journal line will be posted to.';
            }
            field("E3 Narration"; Rec."E3 Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Narrantion field.';
            }

        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        if not UserSetup."Cash Payment Voucher" then
            Error('You do not have permission to open Cash Payment Voucher.');
    end;
}
