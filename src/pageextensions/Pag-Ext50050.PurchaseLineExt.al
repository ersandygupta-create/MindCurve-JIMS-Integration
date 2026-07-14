pageextension 50050 "E3 HIS Purch. Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addafter("TDS Section Code")
        {
            field("Item Make Code"; Rec."Item Make Code")
            {
                ApplicationArea = All;
                Caption = 'Item Make Code';
                ToolTip = 'Specifies the unique code of the item make.';
            }

            field("Item Make Name"; Rec."Item Make Name")
            {
                ApplicationArea = All;
                Caption = 'Item Make Name';
                ToolTip = 'Specifies the name of the item make.';
            }

            field(Cretical; Rec.Cretical)
            {
                ApplicationArea = All;
                Caption = 'Cretical Item';
                ToolTip = 'Specifies whether the item make is marked as critical.';
            }
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Indent Number from which the item or requirement is being referenced.';
            }

            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number associated with the selected Indent Number.';
            }
        }
    }
}