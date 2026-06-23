table 50051 "E3 Indent Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Indent Header';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            DataClassification = CustomerContent;
        }
        field(3; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(4; Status; Option)
        {
            OptionMembers = Open,Pending,Approved,Rejected;
            Caption = 'Status';
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                "Business Unit Name" := '';
                GLSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                DimensionValue.SetRange(Code, "Shortcut Dimension 1 Code");

                if DimensionValue.FindFirst() then
                    "Business Unit Name" := DimensionValue.Name;
            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                "Department Name" := '';
                GLSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                DimensionValue.SetRange(Code, "Shortcut Dimension 2 Code");

                if DimensionValue.FindFirst() then
                    "Department Name" := DimensionValue.Name;
            end;
        }
        field(7; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
            trigger OnValidate()
            var
                LocationRec: Record Location;
            begin
                "Location Name" := '';
                if LocationRec.Get("Location Code") then
                    "Location Name" := LocationRec.Name
                else
                    "Location Name" := '';
            end;
        }
        field(8; "Location Name"; Text[100])
        {
            Caption = 'Location Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            DataClassification = CustomerContent;
        }
        field(10; "Site Code"; Text[50])
        {
            Caption = 'Site Code';
            DataClassification = CustomerContent;
        }
        field(11; "Site Name"; Text[100])
        {
            Caption = 'Site Name';
            DataClassification = CustomerContent;
        }
        field(12; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(13; "Approved By"; Text[100])
        {
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(14; "Entry No."; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(15; "Business Unit Name"; Text[100])
        {
            Caption = 'Business Unit Name';
            DataClassification = CustomerContent;
        }
        field(16; Indentor; Text[50])
        {
            Caption = 'Indentor';
            DataClassification = CustomerContent;
        }
        field(17; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(18; "To Department Code"; Code[20])
        {
            Caption = 'To Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                "To Department Name" := '';
                GLSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                DimensionValue.SetRange(Code, "To Department Code");

                if DimensionValue.FindFirst() then
                    "To Department Name" := DimensionValue.Name;
            end;
        }
        field(19; "To Department Name"; Text[100])
        {
            Caption = 'To Department Name';
            DataClassification = CustomerContent;
        }
        field(20; "Approval Date Time"; DateTime)
        {
            Caption = 'Approval Date Time';
            DataClassification = CustomerContent;
        }
        field(21; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Document No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("Indent Nos.");

            "Document No." :=
                NoSeries.GetNextNo(PurchSetup."Indent Nos.", WorkDate());
        end;
    end;

    procedure AssistEdit(OldIndentHeader: Record "E3 Indent Header"): Boolean
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
        IndentHeader: Record "E3 Indent Header";
    begin
        IndentHeader := Rec;

        PurchSetup.Get();
        PurchSetup.TestField("Indent Nos.");

        if NoSeries.LookupRelatedNoSeries(
            PurchSetup."Indent Nos.",
            OldIndentHeader."No. Series",
            IndentHeader."No. Series")
        then begin
            IndentHeader."Document No." := NoSeries.GetNextNo(IndentHeader."No. Series");
            Rec := IndentHeader;
            exit(true);
        end;

        exit(false);
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