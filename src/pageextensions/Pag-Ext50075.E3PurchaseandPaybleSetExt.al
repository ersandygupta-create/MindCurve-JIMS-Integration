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
            field("Posted Gate Entry Inward No."; Rec."Posted Gate Entry Inward No.")
            {
                ApplicationArea = All;
                ToolTip = 'Posted Inward Gate Entry number Sequence';
            }
            field("Posted Gate Entry Outward No."; rec."Posted Gate Entry Outward No.")
            {
                ApplicationArea = All;
                ToolTip = 'Posted Outward Gate Entry number Sequence';
            }
            field("Indent Nos."; Rec."Indent Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Indent Nos.';
            }
            field("Lot Nos."; Rec."Lot Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Lot Nos.';
            }
            field("RC Nos"; Rec."RC Nos")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value RC Nos field.';
            }
            field("RC Disc Nos."; Rec."RC Disc Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value RC Nos field.';
            }
            field("Allowed Expiry Date"; Rec."Allowed Expiry Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Allow Expiry Date';
            }
            field("Enable Advance Settlement"; Rec."Enable Advance Settlement")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Enable Advance Settlement';
            }

        }

    }

    actions
    {
        // Add changes to page actions here
    }

}