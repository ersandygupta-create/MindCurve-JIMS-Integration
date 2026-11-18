
page 50273 "E3 Asset Item Sub Group"
{
    PageType = List;
    SourceTable = "E3 Asset Item Sub Group";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Asset Item Sub Group';
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
                    ToolTip = 'Specifies the asset item sub group code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset item sub group description.';
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
                field("Asset Item Name Group"; Rec."Asset Item Name Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the parent asset item name group.';
                }
            }
        }
    }
}
