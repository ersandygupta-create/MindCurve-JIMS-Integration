table 50081 "E3 Indent Sale/Purchase Header"
{
    Caption = 'Indent Sale/Purchase Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "Nature Type"; Enum "E3 Nature Type")
        {
            Caption = 'Nature Type';
            DataClassification = CustomerContent;
        }
        field(3; "Entry Type"; Enum "E3 Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(4; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(6; "Indent No."; Code[50])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(7; "Indent Date"; Date)
        {
            Caption = 'Indent Date';
            DataClassification = CustomerContent;
        }
        field(8; "Vendor/Customer No."; Code[20])
        {
            Caption = 'Vendor/Customer No.';
            DataClassification = CustomerContent;
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = ,Vendor,Customer;
            DataClassification = CustomerContent;
        }
        field(10; "Vendor/Customer Name"; Text[100])
        {
            Caption = 'Vendor/Customer Name';
            DataClassification = CustomerContent;
        }
        field(11; "Invoice No."; Code[50])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
        }
        field(12; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            DataClassification = CustomerContent;
        }
        field(13; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(14; "No. of Lines"; Integer)
        {
            Caption = 'No. of Lines';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(16; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(17; "Error 1"; Boolean)
        {
            Caption = 'Error 1';
            DataClassification = CustomerContent;
        }
        field(18; "Error 2"; Boolean)
        {
            Caption = 'Error 2';
            DataClassification = CustomerContent;
        }
        field(19; "Error 3"; Boolean)
        {
            Caption = 'Error 3';
            DataClassification = CustomerContent;
        }
        field(20; "Error 4"; Boolean)
        {
            Caption = 'Error 4';
            DataClassification = CustomerContent;
        }
        field(21; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            DataClassification = CustomerContent;
        }
        field(22; "Dept Code"; Code[20])
        {
            Caption = 'Dept Code';
            DataClassification = CustomerContent;
        }
        field(23; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
            DataClassification = CustomerContent;
        }
        field(24; "Create PO"; Boolean)
        {
            Caption = 'Create PO';
            DataClassification = CustomerContent;
        }
        field(25; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(26; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Nature Type", "Entry Type", "Document No.")
        {
            Clustered = true;
        }
    }
    procedure AssistEdit(OldIndentSalePurchaseHeader: Record "E3 Indent Sale/Purchase Header"): Boolean
    var
        Location: Record Location;
        NoSeries: Codeunit "No. Series";
        IndentSalePurchaseHeader: Record "E3 Indent Sale/Purchase Header";
    begin
        IndentSalePurchaseHeader := Rec;

        Location.Get();
        Location.TestField("InterCompany Nos.");

        if NoSeries.LookupRelatedNoSeries(Location."InterCompany Nos.", OldIndentSalePurchaseHeader."No. Series", IndentSalePurchaseHeader."No. Series")
        then begin
            IndentSalePurchaseHeader."Document No." := NoSeries.GetNextNo(IndentSalePurchaseHeader."No. Series");
            Rec := IndentSalePurchaseHeader;
            exit(true);
        end;

        exit(false);
    end;

}