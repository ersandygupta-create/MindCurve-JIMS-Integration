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
            begin
                if DimensionValue.Get("Shortcut Dimension 2 Code") then
                    "Department Name" := DimensionValue.Name
                else
                    "Department Name" := '';
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