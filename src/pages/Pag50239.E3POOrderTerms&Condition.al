page 50239 "E3 PO Order Terms & Conditions"
{
    PageType = List;
    SourceTable = "E3 PO Order Terms & Conditions";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'PO Order Terms & Conditions';

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
                field("Terms and Condition"; Rec."Terms and Condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Terms and Condition of the order term.';
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