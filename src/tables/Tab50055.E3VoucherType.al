table 50055 "E3 Voucher Type"
{
    DataClassification = ToBeClassified;
    Caption = 'Voucher Type';
    LookupPageId = "E3 Voucher Types";
    DrillDownPageId = "E3 Voucher Types";

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Order Nos."; Code[20])
        {
            Caption = 'Order Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(4; "Entry Type"; Option)
        {
            OptionMembers = ,Indent,Order;
            DataClassification = CustomerContent;
        }
        field(5; "Item Type"; Code[20])
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Type".Code;
            trigger OnValidate()
            var
                ItemType: Record "E3 Item Type";
            begin
                if "Item Type" = '' then begin
                    "Item Type Name" := '';
                    exit;
                end;

                if ItemType.Get("Item Type") then
                    "Item Type Name" := ItemType.Name;
            end;
        }
        field(6; "Item Type Name"; Text[60])
        {
            Caption = 'Item Type Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "GRN Voucher Type Code"; Code[20])
        {
            Caption = 'GRN Voucher Type Code';
            DataClassification = CustomerContent;
        }
        field(8; "GRN Voucher Type Name"; Text[60])
        {
            Caption = 'GRN Voucher Type Name';
            DataClassification = CustomerContent;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(11; Sync; Boolean)
        {
            Caption = 'Sync';
            DataClassification = CustomerContent;
        }
        field(12; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
            TableRelation = "Responsibility Center";
        }
        field(13; "Print Caption"; Text[50])
        {
            Caption = 'Print Caption';
            DataClassification = CustomerContent;
        }
        field(14; "Purchase Return Order Nos."; Code[20])
        {
            Caption = 'Purchase Return Order Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(15; "Purchase Invoice Nos."; Code[20])
        {
            Caption = 'Purchase Invoice Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(16; "Sale Order Nos."; Code[20])
        {
            Caption = 'Sale Order Nos';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(17; "Sale Return Order"; Code[20])
        {
            Caption = 'Sale Return Order';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(18; "Sale Credit Nos."; Code[20])
        {
            Caption = 'Sale Credit Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(19; "Sale Invoice Nos."; Code[20])
        {
            Caption = 'Sale Invoice Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Voucher Type Master Editable" then
            Error(
                'You do not have permission to modify Voucher Type %1. ' +
                'Please contact your administrator.',
                Rec.Code);
    end;

    trigger OnDelete()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Voucher Type Master Editable" then
            Error(
                'You do not have permission to delete Voucher %1. ' +
                'Please contact your administrator.',
                Rec.Code);
    end;

    trigger OnRename()
    begin

    end;

}