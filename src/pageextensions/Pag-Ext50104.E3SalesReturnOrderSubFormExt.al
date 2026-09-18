pageextension 50104 "E3 Sale Ret. Order SubForm Ext" extends "Sales Return Order Subform"
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