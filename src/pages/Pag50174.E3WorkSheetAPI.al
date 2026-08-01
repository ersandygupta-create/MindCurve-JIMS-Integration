page 50174 "E3 GRN Work Sheet API"
{
    PageType = API;
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    Caption = 'GRN WorkSheet API';
    EntityName = 'grnWorksheetDetail';
    EntitySetName = 'grnWorksheetDetails';
    SourceTable = "E3 GRN Work Sheet";
    DelayedInsert = true;
    ApplicationArea = All;
    ODataKeyFields = "PO No.";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(poNo; Rec."PO No.")
                {
                    Caption = 'PO No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(itemName; Rec."Item Name")
                {
                    Caption = 'Item Name';
                }
                field(poQty; Rec."PO Qty")
                {
                    Caption = 'PO Qty';
                }
                field(freeQty; Rec."Free Qty")
                {
                    Caption = 'Free Qty';
                }
                field(outstandingQty; Rec."Outstanding Qty")
                {
                    Caption = 'Outstanding Qty';
                }
                field(invoiceQty; Rec."Invoice Qty")
                {
                    Caption = 'Invoice Qty';
                }
                field(receiptQty; Rec."Receipt Qty")
                {
                    Caption = 'Receipt Qty';
                }
                field(rejectedQty; Rec."Rejected Qty")
                {
                    Caption = 'Rejected Qty';
                }
                field(lotNo; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                }
                field(manufacturingDate; Rec."Manufacturing Date")
                {
                    Caption = 'Manufacturing Date';
                }
                field(expiryDate; Rec."Expiry Date")
                {
                    Caption = 'Expiry Date';
                }
                field(supplierBatchNo; Rec."Supplier Batch No.")
                {
                    Caption = 'Supplier Batch No.';
                }
                field(lineGross; Rec."Line Gross")
                {
                    Caption = 'Line Gross';
                }
                field(mrp; Rec.MRP)
                {
                    Caption = 'MRP';
                }
                field(skuMRP; Rec."SKU MRP")
                {
                    Caption = 'SKU MRP';
                }
                field(saleRate; Rec."Sale Rate")
                {
                    Caption = 'Sale Rate';
                }
                field(skuSaleRate; Rec."SKU Sale Rate")
                {
                    Caption = 'SKU Sale Rate';
                }
                field(staffSaleRate; Rec."Staff Sale Rate")
                {
                    Caption = 'Staff Sale Rate';
                }
                field(skuStaffSaleRate; Rec."SKU Staff Sale Rate")
                {
                    Caption = 'SKU Staff Sale Rate';
                }
                field(itemMakeName; Rec."Item Make Name")
                {
                    Caption = 'Item Make Name';
                }
                field(itemMakeCode; Rec."Item Make Code")
                {
                    Caption = 'Item Make Code';
                }
                field(gstTypeCode; Rec."GST Type Code")
                {
                    Caption = 'GST Type Code';
                }
                field(lineDiscountAmount; Rec."Line Discount Amount")
                {
                    Caption = 'Line Discount Amount';
                }
                field(lineDiscountPercentage; Rec."Line Discount Percentage")
                {
                    Caption = 'Line Discount Percentage';
                }
                field(taxableAmount; Rec."Taxable Amount")
                {
                    Caption = 'Taxable Amount';
                }
                field(cgstPercentage; Rec."CGST %")
                {
                    Caption = 'CGST %';
                }
                field(cgstAmount; Rec."CGST Amount")
                {
                    Caption = 'CGST Amount';
                }
                field(sgstPercentage; Rec."SGST %")
                {
                    Caption = 'SGST %';
                }
                field(sgstAmount; Rec."SGST Amount")
                {
                    Caption = 'SGST Amount';
                }
                field(igstPercentage; Rec."IGST %")
                {
                    Caption = 'IGST %';
                }
                field(igstAmount; Rec."IGST Amount")
                {
                    Caption = 'IGST Amount';
                }
                field(finalDiscountPercentage; Rec."Final Discount %")
                {
                    Caption = 'Final Discount %';
                }
                field(finalDiscountAmount; Rec."Final Discount Amount")
                {
                    Caption = 'Final Discount Amount';
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure';
                }
                field(quantityReceived; Rec."Quantity Received")
                {
                    Caption = 'Quantity Received';
                }
                field(itemTrackingCode; Rec."Item Tracking Code")
                {
                    Caption = 'Item Tracking Code';
                }
                field(indentDocID; Rec."Indent Doc ID")
                {
                    Caption = 'Indent Doc ID';
                }
                field(indentLineNo; Rec."Indent Line No.")
                {
                    Caption = 'Indent Line No.';
                }
                field(departmentCode; Rec."Department Code")
                {
                    Caption = 'Department Code';
                }
                field(departmentName; Rec."Department Name")
                {
                    Caption = 'Department Name';
                }
                field(unitCode; Rec."Unit Code")
                {
                    Caption = 'Unit Code';
                }
                field(hsnCode; Rec."HSN Code")
                {
                    Caption = 'HSN Code';
                }
                field(indentSKUQty; Rec."Indent SKU Qty")
                {
                    Caption = 'Indent SKU Qty';
                }
                field(itemGSTNature; Rec."Item GST Nature")
                {
                    Caption = 'Item GST Nature';
                }
                field(ohAmtNet; Rec."OH Amt Net")
                {
                    Caption = 'OH Amt Net';
                }
                field(landedSKUValue; Rec."Landed SKU Value")
                {
                    Caption = 'Landed SKU Value';
                }
                field(landedSKURate; Rec."Landed SKU Rate")
                {
                    Caption = 'Landed SKU Rate';
                }
                field(remark; Rec.Remark)
                {
                    Caption = 'Remark';
                }
                field(rate; Rec.Rate)
                {
                    Caption = 'Rate';
                }
            }
        }
    }
}