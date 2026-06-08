page 50132 "E3 Gate Entry Inward Subform"
{
    Caption = 'Gate Entry Inward Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "E3 Gate Entry Line";
    SourceTableView = sorting("Entry No.");

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Name field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Unit of Measurement"; Rec."Unit of Measurement")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measurement field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Qty field.';
                }
                field("Ship Qty"; Rec."Ship Qty")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship Qty field.';
                }
                field("Qty to Receive"; Rec."Qty to Receive")
                {
                    ApplicationArea = All;
                    Caption = 'Qty to Receive';
                    ToolTip = 'Specifies the value of the Qty to Receive field.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        PurchRcptLine: Record "E3 Posted Gate Entry Line";
                    begin
                        // PurchRcptLine.SetCurrentKey("Document No.", "Document No.");
                        PurchRcptLine.SetRange("Document No.", Rec."Document No.");
                        PurchRcptLine.SetRange("Line No.", Rec."Line No.");
                        PurchRcptLine.SetFilter("Quantity Received", '<>%1', 0);
                        PAGE.RunModal(50105, PurchRcptLine);
                    end;

                }
                field("Pending Qty"; Rec."Pending Qty")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pending Qty field.';
                }
                field("Estimated Value"; Rec."Estimated Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Estimated Value field.';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset No. field.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }
}