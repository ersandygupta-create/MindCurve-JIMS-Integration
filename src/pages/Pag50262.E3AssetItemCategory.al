
page 50262 "E3 Asset Item Category"
{
    PageType = List;
    SourceTable = "E3 Asset Item Category";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Asset Item Category';
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
                    ToolTip = 'Specifies the asset item category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset item category description.';
                }
                field("Asset Item Group"; Rec."Asset Item Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the parent asset item group.';
                }
            }
        }
    }
}
