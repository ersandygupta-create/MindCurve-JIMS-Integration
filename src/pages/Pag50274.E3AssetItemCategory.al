page 50274 "E3 Asset Item Category"
{
    Caption = 'Asset Item Category';
    PageType = List;
    SourceTable = "E3 Asset Item Categories";
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
                    ToolTip = 'Specifies the Asset Item Category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Asset Item Category description.';
                }
            }
        }
    }
}