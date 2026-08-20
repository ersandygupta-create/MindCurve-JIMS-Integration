tableextension 50073 "E3 Lot Information Ext" extends "Lot No. Information"
{
    fields
    {
        field(50000; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(50001; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(50002; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(50003; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(50004; "Expairy Date"; Date)
        {
            Caption = 'Expairy Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        // Add changes to keys here
    }
    trigger OnModify()
    var
        Item: Record Item;
    begin
        if Rec."Item No." <> '' then
            if Item.Get(Rec."Item No.") then
                Rec."Item Name" := Item.Description;
    end;
}