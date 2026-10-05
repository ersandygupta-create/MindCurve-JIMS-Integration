pageextension 50103 "E3 Purch. Ret. Order SubForm" extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field(MRP; Rec.MRP)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the maximum retail price (MRP) of the item.';
            }
            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the batch or lot number assigned to the item.';
            }
            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the expiry date of the item batch or lot.';
            }
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
                Editable = false;
                ToolTip = 'Specifies the name of the item make.';
            }
        }
    }
}