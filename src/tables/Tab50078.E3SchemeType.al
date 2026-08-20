table 50078 "E3 Scheme Type"
{
    DataClassification = ToBeClassified;
    Caption = 'Scheme Type';
    DrillDownPageId = "E3 Scheme Type";
    LookupPageId = "E3 Scheme Type";
    fields
    {
        field(1; Scheme; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Scheme';
        }
        field(2; "Free Qty"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Free Qty';
        }
    }

    keys
    {
        key(PK; Scheme)
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