pageextension 50075 "E3 Purchase & Payable Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("RCM Exempt End Date (Unreg)")
        {
            field("Bank File Series"; Rec."Bank File Series")
            {
                Caption = 'Bank File Series';
                ApplicationArea = All;
            }
            field("Gate Entry Nos."; Rec."Gate Entry Nos.")
            {
                ApplicationArea = All;
            }
            field("E3 Order Address Number"; Rec."E3 Order Address Number")
            {
                ApplicationArea = All;
            }
            field("Gate Entry Receipt Series"; Rec."Gate Entry Receipt Series")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
    }

}