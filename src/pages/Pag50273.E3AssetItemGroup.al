
page 50273 "E3 Asset Item Group"
{
    Caption = 'Asset Item Group';
    PageType = Document;
    SourceTable = "E3 Asset Item Group";
    ApplicationArea = All;
    DelayedInsert = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset category description.';
                }
                field("Asset Item Category"; Rec."Asset Item Category")
                {
                    ApplicationArea = All;
                    Caption = 'Asset Item Category';
                    ToolTip = 'Specifies the asset item category.';
                }
                field("Asset Item Name Group"; Rec."Asset Item Name Group")
                {
                    ApplicationArea = All;
                    Caption = 'Asset Item Name Group';
                    ToolTip = 'Specifies the asset item name group.';
                }
                field("Asset Item Sub Group"; Rec."Asset Item Sub Group")
                {
                    ApplicationArea = All;
                    Caption = 'Asset Item Sub Group';
                    ToolTip = 'Specifies the asset item sub group.';
                }
            }
        }
    }
}
