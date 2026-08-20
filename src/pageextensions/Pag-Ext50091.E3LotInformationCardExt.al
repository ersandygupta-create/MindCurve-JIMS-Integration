pageextension 50091 "E3 Lot No. Information Ext" extends "Lot No. Information Card"
{
    layout
    {
        addafter("Lot No.")
        {
            field("Vendor Code"; Rec."Vendor Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor code for the lot.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the vendor name for the lot.';
            }
            field("Item Name"; Rec."Item Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the item name for the lot.';
            }
            field("Manufacturing Date"; Rec."Manufacturing Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the manufacturing date of the lot.';
            }
            field("Expairy Date"; Rec."Expairy Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the expiry date of the lot.';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Rec."Item No." <> '' then
            if Item.Get(Rec."Item No.") then
                Rec."Item Name" := Item.Description;
    end;
}