
page 50263 "E3 Asset Item Name Group"
{
    PageType = List;
    SourceTable = "E3 Asset Item Name Group";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Asset Item Name Group';
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
                    ToolTip = 'Specifies the asset item name group code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset item name group description.';
                }
                field("Asset Item Group"; Rec."Asset Item Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the parent asset item group.';
                }
                field("Asset Item Category"; Rec."Asset Item Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the parent asset item category.';
                }
            }
        }
    }
}
