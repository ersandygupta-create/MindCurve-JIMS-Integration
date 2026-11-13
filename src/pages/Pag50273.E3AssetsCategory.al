page 50273 "E3 Assets Category List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Assets Category";
    Caption = 'Assets Category List';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assets category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assets category description.';
                }
            }
        }
    }
}