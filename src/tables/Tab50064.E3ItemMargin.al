table 50064 "E3 Item Margin"
{
    Caption = 'Item Margin';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Margin Code"; Code[20])
        {
            Caption = 'Margin Code';
            DataClassification = CustomerContent;
            tableRelation = "E3 Margin Type".Code;
            trigger OnValidate()
            var
                MarginType: Record "E3 Margin Type";
            begin
                if MarginType.Get("Margin Code") then
                    "Margin Name" := MarginType.Name
                else
                    "Margin Name" := '';
            end;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Margin Name"; Text[100])
        {
            Caption = 'Margin Name';
            DataClassification = CustomerContent;
        }
        field(5; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DimValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
                ItemMargin: Record "E3 Item Margin";
            begin
                GLSetup.Get();

                DimValue.Reset();
                DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                DimValue.SetRange(Code, "Business Unit Code");

                if DimValue.FindFirst() then
                    "Business Unit Name" := DimValue.Name
                else
                    "Business Unit Name" := '';
            end;
        }
        field(6; "Business Unit Name"; Text[100])
        {
            Caption = 'Business Unit Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(7; "Margin Type"; Enum "E3 Margin Type")
        {
            Caption = 'Margin Type';
            DataClassification = CustomerContent;
        }
        field(8; Value; Decimal)
        {
            Caption = 'Value';
            DecimalPlaces = 0 : 2;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Margin Code", "Line No.")
        {
        }
    }
    trigger OnInsert()
    begin
        SetLineNo();
    end;

    local procedure SetLineNo()
    var
        ItemMargin: Record "E3 Item Margin";
    begin
        if "Line No." <> 0 then
            exit;

        ItemMargin.Reset();
        ItemMargin.SetRange("Margin Code", "Margin Code");

        if ItemMargin.FindLast() then
            "Line No." := ItemMargin."Line No." + 10000
        else
            "Line No." := 10000;
    end;
}