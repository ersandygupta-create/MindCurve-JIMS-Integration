table 50080 "E3 Stock Transfer Setup"
{
    DataPerCompany = false;

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
        field(4; "From BU"; Code[20])
        {
            Caption = 'From BU';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; "From Dept"; Code[20])
        {
            Caption = 'From Dept';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                "From Dept Name" := '';

                if "To Dept" = '' then
                    exit;

                GeneralLedgerSetup.Get();
                DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
                DimensionValue.SetRange(Code, "From Dept");
                if DimensionValue.FindFirst() then
                    "From Dept Name" := DimensionValue.Name;
            end;
        }
        field(6; "From Location"; Code[20])
        {
            Caption = 'From Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(7; "To BU"; Code[20])
        {
            Caption = 'To BU';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(8; "To Dept"; Code[20])
        {
            Caption = 'To Dept';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                "To Dept Name" := '';

                if "To Dept" = '' then
                    exit;

                GeneralLedgerSetup.Get();

                DimensionValue.SetRange(
                    "Dimension Code",
                    GeneralLedgerSetup."Global Dimension 2 Code");

                DimensionValue.SetRange(Code, "To Dept");

                if DimensionValue.FindFirst() then
                    "To Dept Name" := DimensionValue.Name;
            end;
        }
        field(9; "To Location"; Code[20])
        {
            Caption = 'To Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(10; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(11; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(12; "From Company"; Text[50])
        {
            Caption = 'From Company';
            DataClassification = CustomerContent;
            TableRelation = Company;
        }
        field(13; "To Company"; Text[50])
        {
            Caption = 'To Company';
            DataClassification = CustomerContent;
            TableRelation = Company;
        }
        field(14; "From Dept Name"; Text[100])
        {
            Caption = 'From Dept Name';
            DataClassification = CustomerContent;
        }
        field(15; "To Dept Name"; Text[100])
        {
            Caption = 'To Dept Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}