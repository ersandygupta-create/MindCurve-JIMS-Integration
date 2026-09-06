page 50178 "E3 Order Terms & Conditions"
{
    PageType = List;
    SourceTable = "E3 Order Terms & Conditions";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Order Terms & Conditions';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code or type of the order term.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the order term.';
                }
                field("Default Value"; Rec."Default Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default text or value that will be populated in the Purchase Order.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this order term is available for selection.';
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this Voucher Type term is available for selection.';
                }
            }
        }
    }
}