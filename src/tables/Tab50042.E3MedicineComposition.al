table 50042 "E3 Medicine Composition"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Medicine Composition";
    LookupPageId = "E3 Medicine Composition";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if Code = '' then begin
                    "Item Name" := '';
                    "Unit of Measure" := '';
                    exit;
                end;

                if ItemRec.Get(Code) then begin
                    "Item Name" := ItemRec.Description;
                    "Unit of Measure" := ItemRec."Base Unit of Measure";
                end;
            end;

        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line''s number.';
        }
        field(3; "Medicine Component Code"; Code[20])
        {
            Caption = 'Medicine Component Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Medicine Component Master".Code;
            trigger OnValidate()
            var
                MedicineComponent: Record "E3 Medicine Component Master";
            begin
                if "Medicine Component Code" = '' then begin
                    "Medicine Component Name" := '';
                    exit;
                end;

                MedicineComponent.SetRange(Code, "Medicine Component Code");
                if MedicineComponent.FindFirst() then
                    "Medicine Component Name" := MedicineComponent.Name
                else
                    "Medicine Component Name" := '';
            end;
        }
        field(4; IsBase; Boolean)
        {
            Caption = 'IsBase';
            DataClassification = CustomerContent;
        }
        field(5; Power; Decimal)
        {
            Caption = 'Power';
            DataClassification = CustomerContent;
        }
        field(6; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(7; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(8; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }
        field(9; "Unit Of Measure"; Code[10])
        {
            Caption = 'Unit Of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure".Code;
        }
        field(10; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(11; "Medicine Component Name"; Text[60])
        {
            Caption = 'Medicine Component Name';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        MedicineComposition: Record "E3 Medicine Composition";
    begin
        MedicineComposition.Reset();

        if MedicineComposition.FindLast() then
            exit(MedicineComposition."Line No." + 10000);

        exit(10000);
    end;
}

