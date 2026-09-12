table 50022 "Vendor Adv. Pay. Ag. PO"
{
    Caption = 'Vendor Adv. Pay. Ag. PO';
    DataClassification = ToBeClassified;
    LookupPageId = "Vendor Advance Pay. Against PO";
    DrillDownPageId = "Vendor Advance Pay. Against PO";

    fields
    {
        field(1; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            var
                PurchaseHeader: Record "Purchase Header";
                PaymentTerm: Record "Payment Terms";


            begin

                if not PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, "Purchase Order No.") then
                    exit;

                "PO Date" := PurchaseHeader."Order Date";
                "Vendor Code" := PurchaseHeader."Buy-from Vendor No.";
                "Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                "BU Code" := PurchaseHeader."Shortcut Dimension 1 Code";

                if not PaymentTerm.Get(PurchaseHeader."Payment Terms Code") then
                    exit;
                "Advance Due Date" := CalcDate(PaymentTerm."Due Date Calculation", WorkDate());

            end;

        }
        field(2; "Entry Type"; enum "E3 HIS Item Map. Entry Type")
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "PO Date"; Date)
        {
            Caption = 'PO Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Basic Amount"; Decimal)
        {
            Caption = 'Request Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                PurchHeader: Record "Purchase Header";
            begin
                if PurchHeader.Get(PurchHeader."Document Type"::Order, "Purchase Order No.") then begin
                    PurchHeader.CalcFields(Amount);

                    if "Basic Amount" > PurchHeader.Amount then
                        Error(
                          'Basic Amount (%1) cannot be greater than Purchase Order Amount (%2).',
                          "Basic Amount",
                          PurchHeader.Amount);
                    CalcFields("Total Applied Amount");
                    rec."Remaining Amount" := Rec."Basic Amount" - rec."Total Applied Amount";
                end;
            end;
        }
        field(7; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Total PO Amount"; Decimal)
        {
            Caption = 'Total PO Amount';
            DataClassification = ToBeClassified;
            Editable = false;
            //FieldClass = FlowField;
            //CalcFormula = lookup("Purchase Header".Amount where("No." = field("Purchase Order No.")));
        }
        field(9; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = Normal;
        }
        field(10; "Total Applied Amount"; Decimal)
        {
            Caption = 'Total Applied Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Entry Type" = filter("Initial Entry"), "Purchase Order No." = field("Purchase Order No."),
            "Advance Document No" = field("Document No")));
            Editable = false;
        }
        field(11; ValidationHISKey; Text[30])
        {
            Caption = 'ValidationHISKey';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(13; "Advance Request Date"; Date)
        {
            Caption = 'Advance Request Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Advance Due Date"; Date)
        {
            Caption = 'Advance Due Date';
            DataClassification = CustomerContent;

        }
        field(15; "BU Code"; Code[20])
        {
            Caption = 'Business Unit';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; Release; Boolean)
        {
            Caption = 'Release';
            DataClassification = CustomerContent;
            InitValue = false;
            Editable = false;
        }
        field(17; "Document No"; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Purchase Order No.", "Entry Type", "Document No")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Entry Type", "Purchase Order No.", "Document No", "Vendor Code", "Vendor Name", "Remaining Amount")
        {
        }

    }
    trigger OnInsert()
    var
        PurchOrder: Record "Purchase Header";
        VoucherType: Record "E3 Voucher Type";
        PaymentTerm: Record "Payment Terms";
        NoSeries: Codeunit "No. Series";
    begin
        rec."Advance Request Date" := WorkDate();

        PurchOrder.Reset();
        PurchOrder.SetRange("No.", "Purchase Order No.");
        if PurchOrder.FindFirst() then begin
            PurchOrder.CalcFields(Amount);
            "Total PO Amount" := PurchOrder.Amount;

            VoucherType.Reset();
            VoucherType.SetRange(Code, PurchOrder."Voucher Type");
            if VoucherType.FindFirst() then
                if "Document No" = '' then
                    "Document No" := NoSeries.GetNextNo(VoucherType."Advance Document Nos.", WorkDate(), true);
            "PO Date" := PurchOrder."Order Date";
            "Vendor Code" := PurchOrder."Buy-from Vendor No.";
            "Vendor Name" := PurchOrder."Buy-from Vendor Name";

            if not PaymentTerm.Get(PurchOrder."Payment Terms Code") then
                exit;
            "Advance Due Date" := CalcDate(PaymentTerm."Due Date Calculation", WorkDate());
            "BU Code" := PurchOrder."Shortcut Dimension 1 Code";
        end;
    end;
}
