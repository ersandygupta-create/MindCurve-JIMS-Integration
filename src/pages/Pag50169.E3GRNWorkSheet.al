page 50169 "E3 GRN Work Sheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 GRN Work Sheet";
    Caption = 'GRN Work Sheet';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order number.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item name.';
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchase order quantity.';
                }
                field("Outstanding Qty"; Rec."Outstanding Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the outstanding quantity.';
                }
                field("Invoice Qty"; Rec."Invoice Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the invoice quantity.';
                }
                field("Receipt Qty"; Rec."Receipt Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt quantity.';
                }
                field("Rejected Qty"; Rec."Rejected Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rejected quantity.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the lot number.';
                }
                field("Mfg Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturing date.';
                }
                field("Exp. Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                    Editable = false;
                }
                field("Supplier Batch No."; Rec."Supplier Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier batch number.';
                }
                field("Line Gross"; Rec."Line Gross")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the gross amount for the line.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum retail price.';
                }
                field(skuMrp; Rec."SKU MRP")
                {
                    ApplicationArea = All;
                    Caption = 'SKU MRP';
                    ToolTip = 'Specifies the SKU MRP.';
                }
                field(saleRate; Rec."Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Rate';
                    ToolTip = 'Specifies the sale rate.';
                }
                field(skuSaleRate; Rec."SKU Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'SKU Sale Rate';
                    ToolTip = 'Specifies the SKU sale rate.';
                }
                field(staffSaleRate; Rec."Staff Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Staff Sale Rate';
                    ToolTip = 'Specifies the staff sale rate.';
                }
                field(skuStaffSaleRate; Rec."SKU Staff Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'SKU Staff Sale Rate';
                    ToolTip = 'Specifies the SKU staff sale rate.';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the item make.';
                }
                field(itemMakeCode; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Code';
                    Editable = false;
                    ToolTip = 'Specifies the item make code.';
                }
                field(gstTypeCode; Rec."GST Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'GST Type Code';
                    ToolTip = 'Specifies the GST type code.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount amount.';
                    Editable = false;
                }
                field("Line Discount Percentage"; Rec."Line Discount Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the line discount percentage.';
                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the taxable amount.';
                }
                field("CGST %"; Rec."CGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST percentage.';
                }
                field("CGST Amount"; Rec."CGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST amount.';
                }
                field("SGST %"; Rec."SGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST percentage.';
                }
                field("SGST Amount"; Rec."SGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST amount.';
                }
                field("IGST %"; Rec."IGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST percentage.';
                }
                field("IGST Amount"; Rec."IGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST amount.';
                }
                field("Final Discount %"; Rec."Final Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount percentage.';
                }
                field("Final Discount Amount"; Rec."Final Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount amount.';
                }
            }
        }
    }
}