query 50009 "E3 Indent Cancel API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    Caption = 'Indent Cancel API';
    EntityName = 'indentCancelData';
    EntitySetName = 'indentCancelDatas';
    QueryType = API;

    elements
    {
        dataitem(IndentLine; "E3 Indent Line")
        {
            column(documentNo; "Document No.")
            {
            }
            column(type; Type)
            {
            }
            column(no; "No.")
            {
            }
            column(description; Description)
            {
            }
            column(unitOfMeasure; "Unit of Measure")
            {
            }
            column(indentQty; "Indent Qty")
            {
            }
            column(indentApprovedQty; "Indent Approved Qty")
            {
            }
            column(purchUnitOfMeasure; "Purch. Unit of Measure")
            {
            }
            column(qtyPerPurchUnitOfMeasure; "Qty Per Purch. Unit of Measure")
            {
            }
            column(requestedQty; "Requested Qty")
            {
            }
            column(approvedQty; "Approved Qty")
            {
            }
            column(shortQtyRequisition; "Short Qty Requisition")
            {
            }
            column(shortQtyApproved; "Short Qty Approved")
            {
            }
            column(itemMakeCode; "Item Make Code")
            {
            }
            column(itemMakeName; "Item Make Name")
            {
            }
            column(requestedReceivedDate; "Requested Received Date")
            {
            }
            column(entryNo; "Entry No.")
            {
            }
            column(sNo; "SNo.")
            {
            }
            column(buCode; "Shortcut Dimension 1 Code")
            {
            }
            column(criticalItem; "Critical Item")
            {
            }
            column(purchaseOrderNo; "Purchase Order No.")
            {
            }
            column(cancelIndentRemark; "Cancel Indent Remark")
            {
            }
            column(isSent; IsSent)
            {
            }
            column(response; Response)
            {
            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}