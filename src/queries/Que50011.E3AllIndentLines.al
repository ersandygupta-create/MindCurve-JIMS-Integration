
query 50011 "E3 Indent Line API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    Caption = 'indentLine';
    EntityName = 'indentLine';
    EntitySetName = 'indentLines';
    QueryType = API;

    elements
    {
        dataitem(IndentLine; "E3 Indent Line")
        {
            column(documentNo; "Document No.") { }
            column(lineNo; "Line No.") { }
            column(type; Type) { }
            column(no; "No.") { }
            column(description; Description) { }
            column(unitOfMeasure; "Unit of Measure") { }
            column(requestedQty; "Requested Qty") { }
            column(unitCost; "Unit Cost") { }
            column(amount; Amount) { }
            column(remarks; Remarks) { }
            column(approvedQty; "Approved Qty") { }
            column(requestedReceivedDate; "Requested Received Date") { }
            column(vendorNo; "Vendor No.") { }
            column(vendorName; "Vendor Name") { }
            column(quotationPrice; "Quotation Price") { }
            column(quotationAmount; "Quotation Amount") { }
            column(entryNo; "Entry No.") { }
            column(itemMakeCode; "Item Make Code") { }
            column(orderedQty; "Ordered Qty") { }
            column(quotationRemarks; "Quotation Remarks") { }
            column(itemMakeName; "Item Make Name") { }
            column(criticalItem; "Critical Item") { }
            column(quotationType; "Quotation Type") { }
            column(vendorPOCreation; "Vendor PO Creation") { }
            column(shortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(purchaseOrderNo; "Purchase Order No.") { }
            column(purchaseType; "Purchase Type") { }
            column(discount; "discount %") { }
            column(fixedAssetsNo; "Fixed Assets No.") { }
            column(locationCode; "Location Code") { }
            column(paymentTerms; "Payment Terms") { }
            column(deliveryTerms; "Delivery Terms") { }
            column(amcAmount; "AMC Amount") { }
            column(cmcAmount; "CMC Amount") { }
            column(shortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(released; Released) { }
            column(splitLine; "Split Line") { }
            column(splitedLines; SplitedLines) { }
            column(shortClose; "Short Close") { }
            column(createdPOQty; "Created PO Qty") { }
            column(sNo; "SNo.") { }
            column(indentQty; "Indent Qty") { }
            column(indentApprovedQty; "Indent Approved Qty") { }
            column(purchUnitOfMeasure; "Purch. Unit of Measure") { }
            column(qtyPerPurchUnitOfMeasure; "Qty Per Purch. Unit of Measure") { }
            column(shortQtyRequisition; "Short Qty Requisition") { }
            column(shortQtyApproved; "Short Qty Approved") { }
            column(shortQtyOrder; "Short Qty Order") { }
            column(poCreated; "PO Created") { }
            column(mrp; MRP) { }
            column(scheme; Scheme) { }
            column(status; Status) { }
            column(marginFix; "Margin Fix") { }
            column(indentStatus; "Indent Status") { }
            column(storeSale; "Store Sale") { }
            column(salesReleased; "Sales Released") { }
            column(purchaseReleased; "Purchase Released") { }
            column(closedIndent; "Closed Indent") { }
            column(stockIssueCreated; "Stock Issue Created") { }
            column(stockReceiptCreated; "Stock Receipt Created") { }
            column(select; Select) { }
            column(releasedStockIssuePurchase; "Released Stock Issue Purchase") { }
            column(releasedStockIssue; "Released Stock Issue") { }
            column(freeQty; "Free Qty") { }
            column(poQty; "PO Qty") { }
            column(inclFreeQtyInSaleRate; "Incl Free Qty in Sale Rate") { }
            column(closedIndentGroupedLine; "Closed Indent Grouped Line") { }
            column(orderLineNo; "Order Line No.") { }
            column(salesOrderNo; "Sales Order No.") { }
            column(soCreated; "SO Created") { }
            column(isSent; IsSent) { }
            column(response; Response) { }
            column(cancelIndentRemark; "Cancel Indent Remark") { }
            column(currencyCode; "Currency Code") { }
            column(currencyFactor; "Currency Factor") { }
            column(sentEmail; "Sent Email") { }
        }
    }

    trigger OnBeforeOpen()
    begin
    end;
}
