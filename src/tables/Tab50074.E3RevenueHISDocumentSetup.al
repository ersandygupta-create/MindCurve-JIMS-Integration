table 50074 "E3 Revenue HIS Doc. Type Setup"
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
            DataClassification = CustomerContent;
        }
        field(2; Type; enum "E3 HIS G/L Account Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(3; "HIS Document Type"; Text[30])
        {
            Caption = 'HIS Document Type';
            DataClassification = CustomerContent;
        }
        field(4; "Cash/Patient Payable"; Code[20])
        {
            Caption = 'Cash/Patient Payable';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account" where(Blocked = filter(false), "Direct Posting" = filter(true));
        }
        field(5; "Cash/Patient Payable Name"; Text[100])
        {
            Caption = 'Cash/Patient Payable Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Cash/Patient Payable")));
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