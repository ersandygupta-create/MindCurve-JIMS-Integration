page 50276 "E3 Asset Item Sub Group"
{
    Caption = 'Asset Item Sub Group';
    PageType = List;
    SourceTable = "E3 Asset Item Sub Group";
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
                    ToolTip = 'Specifies the Asset Item Sub Group code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Asset Item Sub Group description.';
                }
            }
        }
    }
}