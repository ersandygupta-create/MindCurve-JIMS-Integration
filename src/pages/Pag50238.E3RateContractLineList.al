page 50238 "E3 Rate Contract Line Lists"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Rate Contract Line";
    Caption = 'Purchase Price Line';
    //AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document No.';
                }
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product description.';
                }
                field("Make Code H"; Rec."Make Code H")
                {
                    ApplicationArea = All;
                    ToolTip = 'Make Code';
                }
                field("Make Name H"; Rec."Make Name H")
                {
                    ApplicationArea = All;
                    ToolTip = 'Make Name';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Caption = 'Purch. unit of Measure';
                    ToolTip = 'Specifies the unit of measure code.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate contract price.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies The Value MRP';
                }
                field(Scheme; Rec.Scheme)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies The Value Scheme';
                }
                field("Incl Free Qty in Sale Rate"; Rec."Incl Free Qty in Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies The Value Incl Free Qty in Sale Rate';
                }
                field("Free Qty"; Rec."Free Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Free Qty';
                    ToolTip = 'Specifies the free quantity.';
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                    Caption = 'PO Qty';
                    ToolTip = 'Specifies the purchase order quantity.';
                }
                field("Type Of RC"; Rec."Type Of RC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate contract type for the line.';
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST group code.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN/SAC code.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remarks for the rate contract line.';
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies remarks for the Margin % line.';

                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Approval Date';
                }
            }
        }
    }
}