pageextension 50087 "E3 Item Lookup Ext" extends "Item Lookup"
{
    layout
    {
        addbefore(Description)
        {
            field("Composition Name"; Rec."Composition Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Composition Name';
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