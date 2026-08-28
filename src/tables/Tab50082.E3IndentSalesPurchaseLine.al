table 50082 "E3 Indent Sale/Purchase Line"
{
    Caption = 'Indent Sale/Purchase Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Nature Type"; Enum "E3 Nature Type")
        {
            Caption = 'Nature Type';
            DataClassification = CustomerContent;
        }
        field(3; "Entry Type"; Enum "E3 Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(5; "Item Type"; Text[50])
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(6; "Item ID"; Code[20])
        {
            Caption = 'Item ID';
            DataClassification = CustomerContent;
            TableRelation = Item;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                GetHISIntegrationSalesHdr();
                if "Item ID" <> '' then begin
                    Item.Get("Item ID");
                    "Item Name" := Item.Description;
                end else
                    "Item Name" := '';
            end;
        }
        field(7; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(8; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
        field(9; "Shipped Qty"; Decimal)
        {
            Caption = 'Shipped Qty';
            DataClassification = CustomerContent;
        }
        field(10; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            DataClassification = CustomerContent;
        }
        field(11; "GST Per"; Code[10])
        {
            Caption = 'GST Per';
            DataClassification = CustomerContent;
            TableRelation = "GST Group";
        }
        field(12; "HSN/SAC Code"; Code[20])
        {
            Caption = 'HSN/SAC Code';
            TableRelation = "HSN/SAC".Code where("GST Group Code" = field("GST Per"));
            ValidateTableRelation = false;

        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(14; Discount; Decimal)
        {
            Caption = 'Discount';
            DataClassification = CustomerContent;
        }
        field(15; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(16; BatchNo; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(17; ExpiryDate; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(18; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
        }
        field(19; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            DataClassification = CustomerContent;
        }
        field(20; "Indent No."; Code[50])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(21; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Nature Type", "Entry Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    local procedure GetHISIntegrationSalesHdr()
    begin
        TestField("Nature Type");
        TestField("Entry Type");
        TestField("Document No.");
        IF ("Nature Type" <> IndentSalePurchHdr."Nature Type") OR ("Entry Type" <> IndentSalePurchHdr."Entry Type") OR
            ("Document No." <> IndentSalePurchHdr."Document No.") THEN BEGIN
            IndentSalePurchHdr.Reset();
            IndentSalePurchHdr.SetRange("Nature Type", "Nature Type");
            IndentSalePurchHdr.SetRange("Entry Type", "Entry Type");
            IndentSalePurchHdr.SetRange("Document No.", "Document No.");
            IndentSalePurchHdr.FindFirst();
        END;
    end;

    trigger OnInsert()
    BEGIN
        GetHISIntegrationSalesHdr();
    END;

    var
        IndentSalePurchHdr: Record "E3 Indent Sale/Purchase Header";
}