table 50070 "E3 Rate Contract Header"
{
    Caption = 'Rate Contract Header';
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
        field(3; "RC Type"; Enum "E3 Margin Fix")
        {
            Caption = 'RC Type';
            DataClassification = CustomerContent;

        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Make / Supplier"; Option)
        {
            Caption = 'Make / Supplier';
            OptionMembers = Make,Supplier;
            OptionCaption = 'Make,Supplier';
            DataClassification = CustomerContent;
        }
        field(6; "Vendor Code"; Code[20])
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
        field(7; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(8; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code where("Make Type" = filter("Medicine/Marketing"));
            trigger OnValidate()
            var
                ItemMakeMaster: Record "E3 Item Make Master";
            begin
                ItemMakeMaster.Reset();
                ItemMakeMaster.SetRange(Code, "Make Code");

                if ItemMakeMaster.FindFirst() then
                    "Make Name" := ItemMakeMaster."Company Name"
                else
                    Clear("Make Name");
            end;
        }
        field(9; "Make Name"; Text[100])
        {
            Caption = 'Make Name';
            DataClassification = CustomerContent;
        }
        field(10; Status; Enum "Price Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
            DataClassification = CustomerContent;
        }
        field(12; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(13; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(14; "Approve Date"; Date)
        {
            Caption = 'Approve Date';
            DataClassification = CustomerContent;
        }
        field(15; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            TableRelation = "User Setup"."User ID";
            DataClassification = CustomerContent;
        }
        field(16; "No. Series"; Code[10])
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
            PurchSetup.TestField("RC Nos");

            "Document No." :=
                NoSeries.GetNextNo(PurchSetup."RC Nos", WorkDate());
        end;
    end;

    procedure AssistEdit(OldRCHeader: Record "E3 Rate Contract Header"): Boolean
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
        RCHeader: Record "E3 Rate Contract Header";
    begin
        RCHeader := Rec;

        PurchSetup.Get();
        PurchSetup.TestField("RC Nos");

        if NoSeries.LookupRelatedNoSeries(
            PurchSetup."RC Nos",
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