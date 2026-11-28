pageextension 50015 "E3 HIS Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Qty. to Assign")
        {
            field("GST Reverse Charge"; Rec."GST Reverse Charge")
            {
                ApplicationArea = All;
                Editable = CanEditBillHandlingLine;
                ToolTip = 'Specifies the value of the GST Reverse Charge field.';
            }
        }
        modify(Control39)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(Control33)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(Control15)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(Type)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("No.")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(Description)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Gen. Bus. Posting Group")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Gen. Prod. Posting Group")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Location Code")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(Quantity)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Unit of Measure Code")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Direct Unit Cost")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Line Discount %")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Line Discount Amount")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Line Amount")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("GST Group Code")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("HSN/SAC Code")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("GST Credit")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(Exempted)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("GST Assessable Value")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(ShortcutDimCode3)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Custom Duty Amount")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify(FOC)
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Act Applicable")
        {
            Editable = CanEditBillHandlingLine;
        }
        modify("Nature of Remittance")
        {
            Editable = CanEditBillHandlingLine;
        }
    }
    trigger OnAfterGetRecord()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        CanEditBillHandlingLine := true;

        if not Rec."Bill handling Line created" then
            exit;

        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            CanEditBillHandlingLine := not PurchaseHeader."Bill handling Invoice Created";
    end;

    var
        CanEditBillHandlingLine: Boolean;
}
