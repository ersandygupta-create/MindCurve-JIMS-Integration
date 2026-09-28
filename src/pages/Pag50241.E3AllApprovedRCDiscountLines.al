page 50241 "All App. RC Discount Line"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "E3 RC Discount Line";
    Caption = 'Approved Purchase Discount Line';
    AutoSplitKey = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of product.';
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product description.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remarks for the rate contract line.';
                }
            }
        }
    }
}