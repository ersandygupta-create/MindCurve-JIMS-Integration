pageextension 50000 "E3 HIS Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("E3 HIS Code"; Rec."E3 HIS Code")
            {
                ApplicationArea = All;
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("E3 MSME Type"; Rec."E3 MSME Type")
            {
                ApplicationArea = All;
                Editable = true;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("MSME No."; Rec."E3 MSME No.")
            {
                ApplicationArea = All;
                Editable = true;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the MSME No. field';
            }
            field("E3 Auto E-Mail"; Rec."E3 Auto E-Mail")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("DL No."; Rec."DL No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("Name2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Caption = 'Name 2';
                ToolTip = 'Specifies the value of the Name 2 field';
            }
            field("Bank Integration"; Rec."Bank Integration")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Integration Enabled';
                ToolTip = 'Indicates whether bank integration is enabled for this vendor.';
            }

        }
    }


    var
        recVendor: Record Vendor;
        recTDSEntry: Record "TDS Entry";
}
