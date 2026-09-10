tableextension 50023 "E3 HIS Sales Header" extends "Sales Header"
{
    fields
    {
        field(50000; "E3 RCM"; Boolean)
        {
            Caption = 'RCM';
            DataClassification = CustomerContent;
        }
        field(50001; "E3 HIS Module"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'HIS Module';
        }
        field(50002; "E3 HIS Document Type"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'HIS Document Type';
        }
        field(50003; "E3 Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Receipt No.';
        }
        field(50004; "E3 UHID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'UHID';
        }
        field(50005; "E3 Patient Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Patient Name';
        }
        field(50100; "E3 Encounter No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Encounter No.';
        }
        field(50102; "E3 Doctor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Doctor Name';
        }
        field(50103; "E3 Speciality"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Speciality';
        }
        field(50104; "E3 Sponsor Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sponsor Code';
        }
        field(50105; "E3 Sponsor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sponsor Name';
        }
        field(50106; "E3 Payer Code"; Code[16])
        {
            DataClassification = CustomerContent;
            Caption = 'Payer Code';
        }
        field(50107; "E3 Payer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Payer Name';
        }
        field(50108; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Voucher Type".Code where("Entry Type" = const(Order));
            trigger OnValidate()
            var
                VoucherType: Record "E3 Voucher Type";
                NoSeries: Codeunit "No. Series";
            begin
                if "Voucher Type" = '' then
                    exit;

                VoucherType.Get("Voucher Type");

                "GRN Voucher Type Name" := VoucherType."GRN Voucher Type Name";
                Sync := VoucherType.Sync;

                case "Document Type" of
                    "Document Type"::Order:
                        begin
                            VoucherType.TestField("Sale Order Nos.");
                            if "No." = '' then
                                "No." := NoSeries.GetNextNo(VoucherType."Sale Order Nos.", WorkDate(), true);
                        end;

                    "Document Type"::Invoice:
                        begin
                            VoucherType.TestField("Sale Invoice Nos.");

                            if "No." = '' then
                                "No." := NoSeries.GetNextNo(VoucherType."Sale Invoice Nos.", WorkDate(), true);
                        end;

                    "Document Type"::"Return Order":
                        begin
                            VoucherType.TestField("Sale Return Order");

                            if "No." = '' then
                                "No." := NoSeries.GetNextNo(VoucherType."Sale Return Order", WorkDate(), true);
                        end;
                end;
            end;
        }
        field(50109; "GRN Voucher Type Name"; Text[60])
        {
            Caption = 'GRN Voucher Type Name';
            DataClassification = CustomerContent;
        }
        field(50110; Sync; Boolean)
        {
            Caption = 'Sync';
            DataClassification = CustomerContent;
        }
    }
}
