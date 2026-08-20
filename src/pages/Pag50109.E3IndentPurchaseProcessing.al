page 50109 "E3 Indent Purchase Processing"
{
    PageType = List;
    SourceTable = "E3 Indent Purchase Processing";
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;
    Caption = 'Released Indent Details';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number of the indent.';
                }
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number of the indent line.';
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of item or account used on the indent line.';
                }
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item, account, resource, fixed asset, or item charge.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the selected item or account.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure used for the indent line.';
                }
                field("Requested Qty"; Rec."Requested Qty")
                {
                    Caption = 'Requested Qty';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity requested for the indent line.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost of the item or service.';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount calculated from the requested quantity and unit cost.';
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Line Remarks';
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional remarks for the indent line.';
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    Caption = 'Approved Qty';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity approved for the indent line.';
                }
                field("Requested Received Date"; Rec."Requested Received Date")
                {
                    Caption = 'Requested Received Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the requested quantity is required to be received.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor selected for the indent line.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the selected vendor.';
                }
                field("Quotation Price"; Rec."Quotation Price")
                {
                    Caption = 'Price';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quoted price for the item.';
                }
                field("Quotation Amount"; Rec."Quotation Amount")
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total quotation amount for the ordered quantity.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number of the indent line.';
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    Caption = 'Item Make Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the make code of the item.';
                }
                field("Ordered Qty"; Rec."Ordered Qty")
                {
                    Caption = 'Ordered Qty';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity ordered for the indent line.';
                }
                field("Quotation Remarks"; Rec."Quotation Remarks")
                {
                    Caption = 'Quotation Remarks';
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional remarks related to the quotation.';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    Caption = 'Item Make Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the item make.';
                }
                field("Critical Item"; Rec."Critical Item")
                {
                    Caption = 'Critical Item';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the item is marked as a critical item.';
                }
                field("Quotation Type"; Rec."Quotation Type")
                {
                    Caption = 'Quotation Type';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quotation type used for the indent line.';
                }
                field("Vendor PO Creation"; Rec."Vendor PO Creation")
                {
                    Caption = 'Vendor PO Creation';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a purchase order should be created for the selected vendor.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Business Unit';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit associated with the indent line.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'Purchase Order No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order number created for the indent line.';
                }
                field("Purchase Type"; Rec."Purchase Type")
                {
                    Caption = 'Purchase Type';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the purchase is a contract, order, or invoice.';
                }
                field("discount %"; Rec."discount %")
                {
                    Caption = 'Discount %';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount percentage applicable to the purchase.';
                }
                field("Fixed Assets No."; Rec."Fixed Assets No.")
                {
                    Caption = 'Fixed Assets No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fixed asset number associated with the line.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location from which the item is requested or purchased.';
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    Caption = 'Payment Terms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment terms agreed with the vendor.';
                }
                field("Delivery Terms"; Rec."Delivery Terms")
                {
                    Caption = 'Delivery Terms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the delivery terms agreed with the vendor.';
                }
                field("AMC Amount"; Rec."AMC Amount")
                {
                    Caption = 'AMC Amount';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the annual maintenance contract amount.';
                }
                field("CMC Amount"; Rec."CMC Amount")
                {
                    Caption = 'CMC Amount';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comprehensive maintenance contract amount.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Department Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department associated with the indent line.';
                }
                field(Released; Rec.Released)
                {
                    Caption = 'Released';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the indent line has been released.';
                }
                field("Split Line"; Rec."Split Line")
                {
                    Caption = 'Split Line';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the indent line has been split.';
                }
                field(SplitedLines; Rec.SplitedLines)
                {
                    Caption = 'SplitedLines';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this line was created from a split indent line.';
                }
                field("Short Close"; Rec."Short Close")
                {
                    Caption = 'Short Close';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the indent line has been short closed.';
                }
                field("Created PO Qty"; Rec."Created PO Qty")
                {
                    Caption = 'Created PO Qty';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity for which a purchase order has been created.';
                }
                field("SNo."; Rec."SNo.")
                {
                    Caption = 'SNo.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number of the indent line.';
                }
                field("Indent Qty"; Rec."Indent Qty")
                {
                    Caption = 'Indent Qty';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity requested in the original indent.';
                }
                field("Indent Approved Qty"; Rec."Indent Approved Qty")
                {
                    Caption = 'Indent Approved Qty';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity approved against the original indent quantity.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    Caption = 'Purch. Unit of Measure';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure used for purchasing the item.';
                }
                field("Qty Per Purch. Unit of Measure"; Rec."Qty Per Purch. Unit of Measure")
                {
                    Caption = 'Qty Per Purch. Unit of Measure';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity contained in one purchasing unit of measure.';
                }
                field("Short Qty Requisition"; Rec."Short Qty Requisition")
                {
                    Caption = 'Short Qty Requisition';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between the indent quantity and the requested purchase quantity.';
                }
                field("Short Qty Approved"; Rec."Short Qty Approved")
                {
                    Caption = 'Short Qty Approved';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity remaining after the approved quantity is converted to the purchasing unit.';
                }
                field("Short Qty Order"; Rec."Short Qty Order")
                {
                    Caption = 'Short Qty Order';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between the requested quantity and the approved quantity.';
                }
                field("PO Created"; Rec."PO Created")
                {
                    Caption = 'PO Created';
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a purchase order has been created for the indent line.';
                }
                field(MRP; Rec.MRP)
                {
                    Caption = 'MRP';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum retail price of the item.';
                }
                field(Scheme; Rec.Scheme)
                {
                    Caption = 'Scheme';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the scheme applicable to the item.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the indent line.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency used for the indent line amount.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    Caption = 'Currency Factor';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency conversion factor used for the transaction.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreatePurchaseOrder)
            {
                Caption = 'Create Purchase Order';
                ApplicationArea = All;
                Image = NewOrder;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create a purchase order from the selected released indent purchase processing lines.';

                trigger OnAction()
                var
                    IndentProcessing: Record "E3 Indent Purchase Processing";
                begin
                    CurrPage.SetSelectionFilter(IndentProcessing);

                    if IndentProcessing.IsEmpty() then
                        Error('Please select at least one line.');
                    Report.RunModal(Report::"E3 Create Purchase Order", true, false, IndentProcessing);
                end;
            }
        }
    }
}