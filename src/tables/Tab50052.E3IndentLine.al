table 50052 "E3 Indent Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "E3 Indent Header";
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; Type; Enum Type)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                Description := '';
                "Unit of Measure" := '';
                if Item.Get("No.") then
                    Description := Item.Description;
                "Unit of Measure" := Item."Base Unit of Measure";
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(7; "Requested Qty"; Decimal)
        {
            Caption = 'Requested';
            DataClassification = CustomerContent;
        }
        field(8; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(10; "Approved Qty"; Decimal)
        {
            Caption = 'Approved Qty';
            DataClassification = CustomerContent;
        }
        field(11; "Requested Received Date"; Date)
        {
            Caption = 'Requested Received Date';
            DataClassification = CustomerContent;
        }
        field(12; "First Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Second Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Third Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "First Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Second Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Third Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "First Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(19; "Second Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(20; "Third Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(21; "Quotation No."; Option)
        {
            OptionMembers = "Quote 1","Quote 2","Quote 3";
        }
        field(22; "Price Quoted"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(23; "Finalized"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
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