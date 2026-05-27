table 50028 "E3 Salary Component"
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
        field(5; "Salary Head"; Code[20])
        {
            Caption = 'Salary Head';
            DataClassification = CustomerContent;
        }
        field(6; "Amount"; Decimal)
        {
            Caption = 'Amount';
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
        TestField("Employee Code");
    end;

    var
        PayrollHDR: Record "E3 Salary Header";

}