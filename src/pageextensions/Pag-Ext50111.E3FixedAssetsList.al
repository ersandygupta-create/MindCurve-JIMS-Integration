pageextension 50111 "E3 Fixed Asset List Ext" extends "Fixed Asset List"
{
    actions
    {
        addafter("C&opy Fixed Asset")
        {
            action("E3 Fixed Asset Transfer")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Transfer';
                Image = TransferOrder;
                ToolTip = 'Open the Fixed Asset Transfer List.';
                RunObject = page "E3 Fixed Asset Transfer List";
            }
        }
    }
}