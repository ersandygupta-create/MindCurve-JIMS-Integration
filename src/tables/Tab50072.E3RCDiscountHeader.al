table 50072 "E3 RC Discount Header"
{
    Caption = 'RC Discount Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(2; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; Supplier; Option)
        {
            Caption = 'Supplier';
            OptionMembers = Supplier;
            OptionCaption = 'Supplier';
            DataClassification = CustomerContent;
        }
        field(5; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                VendorRec: Record Vendor;
            begin
                "Vendor Name" := '';

                if VendorRec.Get("Vendor Code") then
                    "Vendor Name" := VendorRec.Name;
            end;
        }
        field(6; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(7; Status; Enum "Price Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
            DataClassification = CustomerContent;
        }
        field(9; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(10; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(11; "Approve Date"; Date)
        {
            Caption = 'Approve Date';
            DataClassification = CustomerContent;
        }
        field(12; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            TableRelation = "User Setup"."User ID";
            DataClassification = CustomerContent;
        }
        field(13; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Document No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("RC Disc Nos.");

            "Document No." :=
                NoSeries.GetNextNo(PurchSetup."RC Disc Nos.", WorkDate());
        end;
    end;

    procedure AssistEdit(OldRCHeader: Record "E3 RC Discount Header"): Boolean
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
        RCHeader: Record "E3 RC Discount Header";
    begin
        RCHeader := Rec;

        PurchSetup.Get();
        PurchSetup.TestField("RC Disc Nos.");

        if NoSeries.LookupRelatedNoSeries(
            PurchSetup."RC Disc Nos.",
            OldRCHeader."No. Series",
            RCHeader."No. Series")
        then begin
            RCHeader."Document No." := NoSeries.GetNextNo(RCHeader."No. Series");
            Rec := RCHeader;
            exit(true);
        end;

        exit(false);
    end;

}