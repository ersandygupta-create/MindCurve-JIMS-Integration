table 50098 "E3 Fixed Asset Transfer"
{
    Caption = 'Fixed Asset Transfer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Transfer Date"; Date)
        {
            Caption = 'Transfer Date';
            DataClassification = CustomerContent;
        }
        field(3; "Fixed Assets No"; Code[20])
        {
            Caption = 'Fixed Assets No';
            DataClassification = CustomerContent;
            TableRelation = "Fixed Asset"."No.";
            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                "Shortcut Dimension 1 Code" := '';
                "From FA Location Code" := '';
                "From FA Location Name" := '';
                "From Building Code" := '';
                "From Building Name" := '';
                "From Room/Ward No. Code" := '';
                "From Room/Ward No. Name" := '';
                "From Custodian Code" := '';
                "From Custodian Name" := '';
                "Name (Head of Department)" := '';

                if "Fixed Assets No" <> '' then
                    if FixedAsset.Get("Fixed Assets No") then begin
                        "Shortcut Dimension 1 Code" := FixedAsset."Global Dimension 1 Code";
                        "From FA Location Code" := FixedAsset."FA Location Code";
                        "From Building Code" := FixedAsset."Building Code";
                        "From Room/Ward No. Code" := FixedAsset."Room/Ward No.";
                        "From Custodian Code" := FixedAsset."Custodian ID";

                        Validate("From FA Location Code");
                        Validate("From Building Code");
                        Validate("From Room/Ward No. Code");
                        Validate("From Custodian Code");
                    end;
            end;
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(5; "From FA Location Code"; Code[20])
        {
            Caption = 'From FA Location Code';
            DataClassification = CustomerContent;
            TableRelation = "FA Location".Code;

            trigger OnValidate()
            var
                FALocation: Record "FA Location";
            begin
                "From FA Location Name" := '';

                if "From FA Location Code" <> '' then
                    if FALocation.Get("From FA Location Code") then
                        "From FA Location Name" := FALocation.Name;
            end;
        }
        field(6; "From FA Location Name"; Text[100])
        {
            Caption = 'From FA Location Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "From Building Code"; Code[20])
        {
            Caption = 'From Building Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Building Type".Code;

            trigger OnValidate()
            var
                BuildingType: Record "E3 Building Type";
            begin
                "From Building Name" := '';

                if "From Building Code" <> '' then
                    if BuildingType.Get("From Building Code") then
                        "From Building Name" := BuildingType.Description;
            end;
        }
        field(8; "From Building Name"; Text[100])
        {
            Caption = 'From Building Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "From Room/Ward No. Code"; Code[20])
        {
            Caption = 'From Room/Ward No. Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Room/Ward Type".Code;

            trigger OnValidate()
            var
                RoomWardType: Record "E3 Room/Ward Type";
            begin
                "From Room/Ward No. Name" := '';

                if "From Room/Ward No. Code" <> '' then
                    if RoomWardType.Get("From Room/Ward No. Code") then
                        "From Room/Ward No. Name" := RoomWardType.Description;
            end;
        }
        field(10; "From Room/Ward No. Name"; Text[100])
        {
            Caption = 'From Room/Ward No. Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "To Building Code"; Code[20])
        {
            Caption = 'To Building Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Building Type".Code;

            trigger OnValidate()
            var
                BuildingType: Record "E3 Building Type";
            begin
                "To Building Name" := '';

                if "To Building Code" <> '' then
                    if BuildingType.Get("To Building Code") then
                        "To Building Name" := BuildingType.Description;
            end;
        }
        field(12; "To Building Name"; Text[100])
        {
            Caption = 'To Building Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "To Room/Ward No. Code"; Code[20])
        {
            Caption = 'To Room/Ward No. Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Room/Ward Type".Code;

            trigger OnValidate()
            var
                RoomWardType: Record "E3 Room/Ward Type";
            begin
                "To Room/Ward No. Name" := '';

                if "To Room/Ward No. Code" <> '' then
                    if RoomWardType.Get("To Room/Ward No. Code") then
                        "To Room/Ward No. Name" := RoomWardType.Description;
            end;
        }
        field(14; "To Room/Ward No. Name"; Text[100])
        {
            Caption = 'To Room/Ward No. Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "To FA Location Code"; Code[20])
        {
            Caption = 'To FA Location Code';
            DataClassification = CustomerContent;
            TableRelation = "FA Location".Code;

            trigger OnValidate()
            var
                FALocation: Record "FA Location";
            begin
                "To FA Location Name" := '';

                if "To FA Location Code" <> '' then
                    if FALocation.Get("To FA Location Code") then
                        "To FA Location Name" := FALocation.Name;
            end;
        }
        field(16; "To FA Location Name"; Text[100])
        {
            Caption = 'To FA Location Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "From Department"; Code[20])
        {
            Caption = 'From Department';
            DataClassification = CustomerContent;
        }
        field(18; "To Department"; Code[20])
        {
            Caption = 'To Department';
            DataClassification = CustomerContent;
        }
        field(19; "From Custodian Code"; Code[20])
        {
            Caption = 'From Custodian Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Custodian Type".Code;

            trigger OnValidate()
            var
                CustodianType: Record "E3 Custodian Type";
            begin
                "From Custodian Name" := '';
                "Name (Head of Department)" := '';

                if "From Custodian Code" <> '' then
                    if CustodianType.Get("From Custodian Code") then begin
                        "From Custodian Name" :=
                            CustodianType."Name (Head of Department)";
                        "Name (Head of Department)" :=
                            CustodianType."Name (Head of Department)";
                    end;
            end;
        }
        field(20; "From Custodian Name"; Text[100])
        {
            Caption = 'From Custodian Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Name (Head of Department)"; Text[100])
        {
            Caption = 'Name (Head of Department)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "To Custodian Code"; Code[20])
        {
            Caption = 'To Custodian Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Custodian Type".Code;

            trigger OnValidate()
            var
                CustodianType: Record "E3 Custodian Type";
            begin
                "To Custodian Name" := '';
                "To Name (Head of Department)" := '';

                if "To Custodian Code" <> '' then
                    if CustodianType.Get("To Custodian Code") then begin
                        "To Custodian Name" :=
                            CustodianType."Name (Head of Department)";
                        "To Name (Head of Department)" :=
                            CustodianType."Name (Head of Department)";
                    end;
            end;
        }
        field(23; "To Custodian Name"; Text[100])
        {
            Caption = 'To Custodian Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(24; "To Name (Head of Department)"; Text[100])
        {
            Caption = 'To Name (Head of Department)';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Transfer Date" = 0D then
            "Transfer Date" := WorkDate();
    end;
}