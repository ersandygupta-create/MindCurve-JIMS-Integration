table 50026 "E3 Salary Header"
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
        }
        field(3; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(5; "Group Name"; Text[200])
        {
            Caption = 'Group Name';
            DataClassification = CustomerContent;
        }
        field(6; Narration; Text[200])
        {
            Caption = 'Narration';
            DataClassification = CustomerContent;
        }
        field(7; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            DataClassification = CustomerContent;
        }
        field(8; "Salary Dimension Code"; Code[20])
        {
            Caption = 'Salary Dimension Code';
            DataClassification = CustomerContent;
        }
        field(9; IsProcessed; Boolean)
        {
            Caption = 'Is Processed';
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(PK; "Entry No.", "Document No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        SalaryComponent: Record "E3 Salary Component";
        EmployeeDetails: Record "E3 Employee Details";
    begin

        SalaryComponent.SetRange("Employee Code", Rec."Employee Code");
        SalaryComponent.DeleteAll();

        EmployeeDetails.SetRange("Employee Code", Rec."Employee Code");
        EmployeeDetails.DeleteAll();
    end;

}