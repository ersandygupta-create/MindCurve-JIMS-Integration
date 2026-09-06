table 50076 "E3 Stock Consumption Line"
{
    Caption = 'Stock Consumption Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            BlankZero = true;
            MinValue = 1;
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(2; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line Number';
            DataClassification = CustomerContent;
        }
        field(4; "Entry Type"; Enum "Item Journal Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(5; "Entry Number"; Code[50])
        {
            Caption = 'Entry Number';
            DataClassification = CustomerContent;
        }
        field(6; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = CustomerContent;
        }
        field(7; "Document Type"; Text[100])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(8; "Business Unit"; Code[20])
        {
            Caption = 'Business Unit';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
        }
        field(9; "Legal Entity"; Text[100])
        {
            Caption = 'Legal Entity';
            DataClassification = CustomerContent;
        }
        field(10; "D365 From Department Code"; Code[20])
        {
            Caption = 'D365 From Department Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger OnValidate()
            var
                Location: Record Location;
            begin
                if "D365 From Department Code" = '' then begin
                    "D365 From Department Name" := '';
                    "Gen. Bus. Posting Group" := '';
                    exit;
                end;

                if Location.Get("D365 From Department Code") then
                    "D365 From Department Name" := Location.Name;
                Validate("Gen. Bus. Posting Group", Location."Gen. Bus. Posting Group");
            end;
        }
        field(11; "D365 From Department Name"; Text[100])
        {
            Caption = 'D365 From Department Name';
            DataClassification = CustomerContent;
        }
        field(12; "D365 To Department Code"; Code[20])
        {
            Caption = 'D365 To Department Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger OnValidate()
            var
                Location: Record Location;
            begin
                if "D365 To Department Code" = '' then begin
                    "D365 To Department Name" := '';
                    exit;
                end;

                if Location.Get("D365 To Department Code") then
                    "D365 To Department Name" := Location.Name;
            end;
        }
        field(13; "D365 To Department Name"; Text[100])
        {
            Caption = 'D365 To Department Name';
            DataClassification = CustomerContent;
        }
        field(14; "D365 Item Code"; Code[20])
        {
            Caption = 'D365 Item Code';
            DataClassification = CustomerContent;
            TableRelation = Item;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if "D365 Item Code" = '' then begin
                    "Item Name" := '';
                    exit;
                end;

                if Item.Get("D365 Item Code") then
                    "Item Name" := Item.Description;
            end;
        }
        field(15; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(16; "Item Type"; Text[50])
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Type";
        }
        field(17; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(18; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 7;
            DataClassification = CustomerContent;
        }
        field(19; "D365 Unit Code"; Code[20])
        {
            Caption = 'D365 Unit Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin
                if "D365 Unit Code" = '' then begin
                    "Unit Name" := '';
                    exit;
                end;

                DimensionValue.SetRange("Global Dimension No.", 1);
                DimensionValue.SetRange(Code, "D365 Unit Code");

                if DimensionValue.FindFirst() then
                    "Unit Name" := DimensionValue.Name
                else
                    "Unit Name" := '';
            end;
        }
        field(20; "Unit Name"; Text[50])
        {
            Caption = 'Unit Name';
            DataClassification = CustomerContent;
        }
        field(21; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(22; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
            TableRelation = "Gen. Business Posting Group";
        }
    }
    keys
    {
        key(PK; "Entry No.", "Entry Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    local procedure GetHISIntegrationSalesHdr()
    begin
        TestField("Entry Type");
        TestField("Document No.");
        IF ("Entry Type" <> StockCons."Entry Type") OR
            ("Document No." <> StockCons."Document No.") THEN BEGIN
            StockCons.Reset();
            StockCons.SetRange("Entry Type", "Entry Type");
            StockCons.SetRange("Document No.", "Document No.");
            StockCons.FindFirst();
        END;
    end;

    trigger OnInsert()
    BEGIN
        GetHISIntegrationSalesHdr();
    END;


    var
        StockCons: Record "E3 Stock Consumption Header";
}