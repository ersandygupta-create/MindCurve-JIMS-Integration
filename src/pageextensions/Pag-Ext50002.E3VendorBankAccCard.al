pageextension 50002 "E3 HIS Vendor Bank Acc. Card" extends "Vendor Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Branch Name"; Rec."Branch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specify a value Branch Name';
            }
            field("E3 IFSC Code"; Rec."E3 IFSC Code")
            {
                Caption = 'IFSC Code';
                ToolTip = 'Enter IFSC Code of Bank Account.';
                ApplicationArea = all;
                Visible = true;
            }
        }
    }
}
