page 50214 "E3 Indent Sale/Purchase Lines"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "E3 Indent Sale/Purchase Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item type.';
                }
                field("Item ID"; Rec."Item ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item name.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.';
                }
                field("Shipped Qty"; Rec."Shipped Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shipped quantity.';
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("GST Per"; Rec."GST Per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST percentage.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN/SAC code.';
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line amount.';
                }
                field(BatchNo; Rec.BatchNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch number.';
                }
                field(ExpiryDate; Rec.ExpiryDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item category code.';
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product group code.';
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent number.';
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent line number.';
                }
            }
        }
    }
}