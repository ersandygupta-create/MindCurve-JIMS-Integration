table 50071 "E3 Rate Contract Line"
{
    Caption = 'Rate Contract Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Rate Contract Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Product Type"; Option)
        {
            Caption = 'Product Type';
            OptionMembers = Item;
            OptionCaption = 'Item';
            DataClassification = CustomerContent;
        }
        field(4; "Product No."; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                Item: Record Item;
                RCHdr: Record "E3 Rate Contract Header";
            begin
                if "Document No." = '' then
                    exit;

                if RCHdr.Get("Document No.") then
                    "Make Code" := RCHdr."Make Code";

                if not RCHdr.Get("Document No.") then
                    exit;

                Item.Reset();
                if RCHdr."RC Type" <> RCHdr."RC Type"::" " then
                    Item.SetRange("Margin Fix", RCHdr."RC Type");

                if RCHdr."Make Code" <> '' then
                    Item.SetRange("Item Make Code", RCHdr."Make Code");

                if Page.RunModal(Page::"Item List", Item) = Action::LookupOK then
                    Validate("Product No.", Item."No.");
            end;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if "Product No." = '' then begin
                    Description := '';
                    "Unit of Measure Code" := '';
                    "GST Group Code" := '';
                    "HSN/SAC Code" := '';
                    exit;
                end;

                if Item.Get("Product No.") then begin
                    Description := Item.Description;
                    "Unit of Measure Code" := Item."Base Unit of Measure";
                    "Type Of RC" := Item."Margin Fix";
                    "GST Group Code" := Item."GST Group Code";
                    "HSN/SAC Code" := Item."HSN/SAC Code";
                    "Incl Free Qty in Sale Rate" := Item."Incl Free Qty in Sale Rate";

                end;
            end;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code
                where("Item No." = field("Product No."));
            DataClassification = CustomerContent;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(8; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateMargin();
            end;
        }
        field(9; "Type Of RC"; Enum "E3 Margin Fix")
        {
            Caption = 'Type Of RC';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(10; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            DataClassification = CustomerContent;
            TableRelation = "GST Group".Code;
        }
        field(11; "HSN/SAC Code"; Code[20])
        {
            Caption = 'HSN/SAC Code';
            DataClassification = CustomerContent;
            TableRelation = "HSN/SAC".Code;
        }
        field(12; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(13; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateMargin();
            end;
        }
        field(14; Scheme; Text[30])
        {
            Caption = 'Scheme';
            DataClassification = CustomerContent;
            TableRelation = "E3 Scheme Type";
            trigger OnValidate()
            var
                SchemeType: Record "E3 Scheme Type";
            begin
                Rec."Free Qty" := 0;
                Rec."PO Qty" := 0;

                if Rec."Scheme" = '' then
                    exit;

                if SchemeType.Get(Rec."Scheme") then begin
                    Rec."Free Qty" := SchemeType."Free Qty";
                    Rec."PO Qty" := SchemeType."PO Qty";
                end
                else
                    Error(
                        'Scheme %1 does not exist in Scheme Type.',
                        Rec."Scheme");
            end;
        }
        field(15; "Incl Free Qty in Sale Rate"; Boolean)
        {
            Caption = 'Include Free Qty in Sale Rate';
            DataClassification = CustomerContent;
        }
        field(16; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code where("Make Type" = filter("Medicine/Marketing"));
        }
        field(17; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
            DataClassification = CustomerContent;
        }
        field(18; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
        }
        field(19; "PO Qty"; Decimal)
        {
            Caption = 'PO Qty';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    local procedure UpdateHeaderValueToLine()
    var
        RCHdr: Record "E3 Rate Contract Header";
    begin
        If ("Document No." = '') then
            exit;
        if RCHdr.Get("Document No.") then
            "Type Of RC" := "Type Of RC";
    end;

    local procedure CalculateMargin()
    begin
        if MRP = 0 then
            "Margin %" := 0
        else
            "Margin %" := ((MRP - Price) / MRP) * 100;
        CheckExistingMarginAgreement();
    end;

    local procedure CheckExistingMarginAgreement()
    var
        OldLine: Record "E3 Rate Contract Line";
        RCHdr: Record "E3 Rate Contract Header";
        CurrentMakeCode: Code[20];
    begin
        // Product must be selected
        if "Product No." = '' then
            exit;

        if MRP = 0 then
            exit;

        CurrentMakeCode := "Make Code";

        if CurrentMakeCode = '' then
            if RCHdr.Get("Document No.") then
                CurrentMakeCode := RCHdr."Make Code";

        OldLine.Reset();
        OldLine.SetRange("Product No.", "Product No.");

        OldLine.SetFilter("Document No.", '<>%1', "Document No.");

        if CurrentMakeCode <> '' then
            OldLine.SetRange("Make Code", CurrentMakeCode);

        if OldLine.FindFirst() then begin
            if OldLine."Margin %" = "Margin %" then
                exit;

            Message(
                'Old Purchase Price Agreement Details:\' +
                'Old Document No.: %1\' +
                'Old Margin %%: %2\' +
                'Current Margin %%: %3',
                OldLine."Document No.",
                OldLine."Margin %",
                "Margin %");
        end;
    end;
}