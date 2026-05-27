table 50027 "E3 Employee Details"
{
    DataClassification = ToBeClassified;

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
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Salary Header"."Document No.";
            ValidateTableRelation = true;
        }
        field(3; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
        }
        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(5; "Employee Status"; Text[50])
        {
            Caption = 'Employee Status';
            DataClassification = CustomerContent;
        }
        field(6; "Date of Joining"; Date)
        {
            Caption = 'Date of Joining';
            DataClassification = CustomerContent;
        }
        field(7; "Date of Leaving"; Date)
        {
            Caption = 'Date of Leaving';
            DataClassification = CustomerContent;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(9; Designation; Text[100])
        {
            Caption = 'Designation';
            DataClassification = CustomerContent;
        }
        field(10; "Salary Head"; Text[200])
        {
            Caption = 'Salary Head';
            DataClassification = CustomerContent;
        }
        field(11; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(12; Grade; Text[50])
        {
            Caption = 'Grade';
            DataClassification = CustomerContent;
        }
        field(13; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            DataClassification = CustomerContent;
        }
        field(14; "Cost Center Name"; Text[100])
        {
            Caption = 'Cost Center Name';
            DataClassification = CustomerContent;
        }
        field(15; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(16; PAN; Code[10])
        {
            Caption = 'PAN';
            DataClassification = CustomerContent;
        }
        field(17; "Paymode"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'PAYMODE';
        }
        field(18; "Bank Account Name"; Text[100])
        {
            Caption = 'Bank Account Name';
            DataClassification = CustomerContent;
        }
        field(19; "Bank Account No."; Code[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        }
        field(20; "IFSC Code"; Text[20])
        {
            Caption = 'IFSC Code';
            DataClassification = CustomerContent;
        }
        field(21; "Salary Hold"; Boolean)
        {
            Caption = 'Salary Hold';
            DataClassification = CustomerContent;
        }
        field(22; "PF No."; Code[20])
        {
            Caption = 'PF No.';
            DataClassification = CustomerContent;
        }
        field(23; "UAN No."; Code[20])
        {
            Caption = 'UAN No.';
            DataClassification = CustomerContent;
        }
        field(24; "ESI No."; Code[20])
        {
            Caption = 'ESI No.';
            DataClassification = CustomerContent;
        }
        field(25; "PT Location"; Text[50])
        {
            Caption = 'PT Location';
            DataClassification = CustomerContent;
        }
        field(26; "Arrear Days"; Decimal)
        {
            Caption = 'Arrear Days';
            DataClassification = CustomerContent;
        }
        field(27; Stddays; Decimal)
        {
            Caption = 'Stddays';
            DataClassification = CustomerContent;
        }
        field(28; WRKDAYS; Decimal)
        {
            Caption = 'WRKDAYS';
            DataClassification = CustomerContent;
        }
        field(29; "LOP DAYS"; Decimal)
        {
            Caption = 'LOP_DAYS';
            DataClassification = CustomerContent;
        }
        field(30; ARREARDAYS; Decimal)
        {
            Caption = 'ARREARDAYS';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "Entry No.", "Document No.", "Employee Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestField("Document No.");
    end;

    var
        PayrollHDR: Record "E3 Salary Header";

}