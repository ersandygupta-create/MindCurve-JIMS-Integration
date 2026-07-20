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
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item name.';
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order quantity.';
                }
                field("Free Qty"; Rec."Free Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free quantity.';
                }
                field("Outstanding Qty"; Rec."Outstanding Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the outstanding quantity.';
                }
                field("Invoice Qty"; Rec."Invoice Qty")
                {
                    ApplicationArea = All;
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
                    ToolTip = 'Specifies the lot number.';
                }
                field("Mfg Date"; Rec."Mfg Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturing date.';
                }
                field("Exp. Date"; Rec."Exp. Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                }
                field("Supplier Batch No."; Rec."Supplier Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier batch number.';
                }
                field("Line Gross"; Rec."Line Gross")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount for the line.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum retail price.';
                }
                field(skuMrp; Rec.skuMrp)
                {
                    ApplicationArea = All;
                    Caption = 'SKU MRP';
                    ToolTip = 'Specifies the SKU MRP.';
                }
                field(saleRate; Rec.saleRate)
                {
                    ApplicationArea = All;
                    Caption = 'Sale Rate';
                    ToolTip = 'Specifies the sale rate.';
                }
                field(skuSaleRate; Rec.skuSaleRate)
                {
                    ApplicationArea = All;
                    Caption = 'SKU Sale Rate';
                    ToolTip = 'Specifies the SKU sale rate.';
                }
                field(staffSaleRate; Rec.staffSaleRate)
                {
                    ApplicationArea = All;
                    Caption = 'Staff Sale Rate';
                    ToolTip = 'Specifies the staff sale rate.';
                }
                field(skuStaffSaleRate; Rec.skuStaffSaleRate)
                {
                    ApplicationArea = All;
                    Caption = 'SKU Staff Sale Rate';
                    ToolTip = 'Specifies the SKU staff sale rate.';
                }
                field(batchNo; Rec.batchNo)
                {
                    ApplicationArea = All;
                    Caption = 'Batch No.';
                    ToolTip = 'Specifies the batch number.';
                }
                field(manufacturingDate; Rec.manufacturingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Manufacturing Date';
                    ToolTip = 'Specifies the manufacturing date.';
                }
                field(expiryDate; Rec.expiryDate)
                {
                    ApplicationArea = All;
                    Caption = 'Expiry Date';
                    ToolTip = 'Specifies the expiry date.';
                }
                field(itemMakeCode; Rec.itemMakeCode)
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Code';
                    ToolTip = 'Specifies the item make code.';
                }
                field(gstTypeCode; Rec.gstTypeCode)
                {
                    ApplicationArea = All;
                    Caption = 'GST Type Code';
                    ToolTip = 'Specifies the GST type code.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount amount.';
                }
                field("Line Discount Percentage"; Rec."Line Discount Percentage")
                {
                    ApplicationArea = All;
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