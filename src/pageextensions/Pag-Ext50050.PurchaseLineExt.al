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

            field(Critical; Rec.Critical)
            {
                ApplicationArea = All;
                Caption = 'Critical Item';
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
    actions
    {
        addlast(processing)
        {
            action("GRNWorkSheet")
            {
                ApplicationArea = All;
                Caption = 'GRN Work Sheet';
                Image = Create;
                Ellipsis = true;
                ToolTip = 'GRN Work Sheet';

                trigger OnAction()
                var
                    GRNWorkSheet: Record "E3 GRN Work Sheet";
                begin
                    GRNWorkSheet.SetRange("PO No.");
                    Page.Run(Page::"E3 GRN Work Sheet", GRNWorkSheet);
                end;
            }
        }
    }
}