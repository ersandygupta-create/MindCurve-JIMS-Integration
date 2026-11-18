
page 50261 "E3 Asset Item Group"
{
    PageType = List;
    SourceTable = "E3 Asset Item Group";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Asset Item Group';
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset item group code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset item group description.';
                }
            }
        }
    }
}
