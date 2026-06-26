table 50043 "E3 Sub Group Site List"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Sub Group Site List";
    LookupPageId = "E3 Sub Group Site List";

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
        field(2; "Sub Code"; Integer)
        {
            Caption = 'Sub Code';
            DataClassification = CustomerContent;
        }
        field(3; "Site Code"; Integer)
        {
            Caption = 'Site Code';
            DataClassification = CustomerContent;
        }
        field(4; "Is Opd Consultant"; Boolean)
        {
            Caption = 'Is OPD Consultant';
            DataClassification = CustomerContent;
        }
        field(5; "Allow For Site"; Boolean)
        {
            Caption = 'Allow For Site';
            DataClassification = CustomerContent;
        }
        field(6; "Is Ipd Consultant"; Boolean)
        {
            Caption = 'Is IPD Consultant';
            DataClassification = CustomerContent;
        }
        field(7; "Drug License No."; Text[30])
        {
            Caption = 'Drug License No.';
            DataClassification = CustomerContent;
        }
        field(8; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(9; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(10; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Site Code")
        {
            Clustered = true;
        }
    }

}

