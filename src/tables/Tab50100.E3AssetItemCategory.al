table 50100 "E3 Asset Item Categories"
{
    Caption = 'Asset Item Categories';
    DrillDownPageId = "E3 Asset Item Category";
    LookupPageId = "E3 Asset Item Category";
    DataClassification = ToBeClassified;


    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[60])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
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