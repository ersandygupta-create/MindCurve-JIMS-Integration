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
        }
    }
}