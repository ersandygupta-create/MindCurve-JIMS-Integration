page 50237 "E3 Closed Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Indent Line";
    Caption = 'Closed Indent List';
    SourceTableView = where("Closed Indent" = const(true));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of the indent line.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the item or resource.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the description of the indent line.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure for the indent line.';
                }
                field("Indent Qty"; Rec."Indent Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity requested in the indent.';
                }
                field("Indent Approved Qty"; Rec."Indent Approved Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity approved against the indent.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure used for purchasing the item.';
                }
                field("Qty Per Purch. Unit of Measure"; Rec."Qty Per Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity contained in one purchase unit of measure.';
                }
                field("Requested Qty"; Rec."Requested Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the requested quantity for the purchase.';
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity approved for purchase.';
                }
                field("Short Qty Requisition"; Rec."Short Qty Requisition")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortage quantity after comparing the approved quantity with the purchase quantity.';
                }
                field("Short Qty Approved"; Rec."Short Qty Approved")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortage quantity based on the approved indent quantity.';
                }
                field("Short Qty Order"; Rec."Short Qty Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortage quantity based on the purchase order quantity.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit cost of the item.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total amount for the indent line.';
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item make code associated with the indent line.';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the item make.';
                }
                field("Requested Received Date"; Rec."Requested Received Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the requested date for receiving the item.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies additional remarks for the indent line.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the entry number of the indent line.';
                }
                field("SNo."; Rec."SNo.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the serial number of the indent line.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortcut dimension code assigned to the indent line.';
                }
                field("Critical Item"; Rec."Critical Item")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the item is marked as a critical item.';
                }
            }
        }
    }
}
