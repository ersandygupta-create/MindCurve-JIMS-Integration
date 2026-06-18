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
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(5; "Allocated Qty"; Decimal)
        {
            Caption = 'Allocated Qty';
        }
        field(6; "Remaining Qty For Quote"; Decimal)
        {
            Caption = 'Qty to Procure';
        }
        field(7; "First Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Second Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Third Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "First Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Second Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Third Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "First Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(14; "Second Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(15; "Third Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(16; "Quotation No."; Option)
        {
            OptionMembers = "Quote 1","Quote 2","Quote 3";
        }
        field(17; "Price Quoted"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Finalized"; Boolean)
        {
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