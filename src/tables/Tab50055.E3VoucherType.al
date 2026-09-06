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
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}