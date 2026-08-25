page 50227 "E3 Get Sale Indent Lines"
{
    Caption = 'Get Store Indent Stock Lines';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "E3 Indent Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("Document No.", "Line No.") order(descending) where("Sales Released" = const(true));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Visible = true;
                    ToolTip = 'Specifies the quotation document number.';
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Item Make Code';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Item Make Name';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'No.';
                    ToolTip = 'Specifies the item number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the item.';
                }
                field(Quantity; Rec."Requested Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Requested Quantity';
                    ToolTip = 'Specifies the required quantity.';
                }
                field("Indent Qty"; Rec."Indent Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity requested in the indent.';
                }
                field("Indent Approved Qty"; Rec."Indent Approved Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity approved against the indent.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure used for purchasing the item.';
                }
                field("Qty Per Purch. Unit of Measure"; Rec."Qty Per Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity contained in one purchase unit of measure.';
                }
                field("Short Qty Requisition"; Rec."Short Qty Requisition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortage quantity after comparing the approved quantity with the purchase quantity.';
                }
                field("Short Qty Approved"; Rec."Short Qty Approved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortage quantity based on the approved indent quantity.';
                }
                field("Short Qty Order"; Rec."Short Qty Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortage quantity based on the purchase order quantity.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the required Amount.';
                }
                field("SNo."; Rec."SNo.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specify a value SNo. field.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies The Value MRP';
                }
                field(Scheme; Rec.Scheme)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Scheme';
                }
            }
        }
    }
}