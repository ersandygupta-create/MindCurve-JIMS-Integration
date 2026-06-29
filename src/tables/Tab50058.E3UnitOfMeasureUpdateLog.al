table 50058 "E3 Unit Of Measure Update Log"
{
    DataPerCompany = false;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Sync Status"; Option)
        {
            Caption = 'Sync Status';
            OptionMembers = " ",Synced,Error;
            OptionCaption = ' ,Synced,Error';
        }
        field(4; "Error Message"; Text[100])
        {
            Caption = 'Error Message';
        }
    }

    keys
    {
        key(PK; Code)
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