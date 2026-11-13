page 50275 "E3 Asset Item Name Group"
{
    Caption = 'Asset Item Category';
    PageType = List;
    SourceTable = "E3 Asset Item Name Group";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Asset Item Name Group code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Name Group description.';
                }
            }
        }
    }
}