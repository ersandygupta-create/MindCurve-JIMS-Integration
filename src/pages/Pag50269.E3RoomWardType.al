page 50269 "E3 Room/Ward Type List"
{
    Caption = 'Room/Ward Type List';
    PageType = List;
    SourceTable = "E3 Room/Ward Type";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room or ward code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the room or ward description.';
                }
            }
        }
    }
}