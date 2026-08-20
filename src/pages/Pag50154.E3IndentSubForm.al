page 50154 "E3 Indent Line Subform"
{
    PageType = ListPart;
    SourceTable = "E3 Indent Line";
    ApplicationArea = All;
    Caption = 'Indent Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
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
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Visible = false;
                    Editable = IsLineEditable;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsLineEditable;
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested Received Date"; Rec."Requested Received Date")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("SNo."; Rec."SNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify a value SNo. field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Critical Item"; Rec."Critical Item")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
            }
        }
    }
    var
        IsLineEditable: Boolean;
        IsApprovedQtyEditable: Boolean;
        IndentHeader: Record "E3 Indent Header";

    trigger OnOpenPage()
    begin
        SetEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditable();
    end;

    local procedure SetEditable()
    begin
        IsLineEditable := true;
        IsApprovedQtyEditable := false;

        if IndentHeader.Get(Rec."Document No.") then begin
            case IndentHeader.Status of
                IndentHeader.Status::Open:
                    begin
                        IsLineEditable := true;
                        IsApprovedQtyEditable := true;
                    end;

                IndentHeader.Status::"Pending Approval":
                    begin
                        IsLineEditable := false;
                        IsApprovedQtyEditable := true;
                    end;

                IndentHeader.Status::Approved:
                    begin
                        IsLineEditable := false;
                        IsApprovedQtyEditable := false;
                    end;
            end;
        end;
    end;
}