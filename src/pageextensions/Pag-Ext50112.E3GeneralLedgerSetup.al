pageextension 50112 "E3 General Ledger Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Local Cont. Addr. Format")
        {
            field("GL Entries Edit"; Rec."GL Entries Edit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether to handle GL Entries Edit.';
            }
        }
    }
}