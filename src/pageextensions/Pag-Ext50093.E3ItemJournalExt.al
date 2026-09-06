pageextension 50093 "E3 Item Journal Ext" extends "Item Journal"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(lotNo; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No field';
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