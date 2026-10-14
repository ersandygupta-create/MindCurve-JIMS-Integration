table 50084 "E3 Allocation Receipt"
{
    Caption = 'Allocation Receipt';
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
        field(2; "HIS Document Type"; Text[50])
        {
            Caption = 'HIS Document Type';
            DataClassification = CustomerContent;
        }
        field(3; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer';
            DataClassification = CustomerContent;
        }
        field(5; "Receipt No."; Code[50])
        {
            Caption = 'Receipt No.';
            DataClassification = CustomerContent;
            // TableRelation = "E3 Organization Receipt"."Document No." where("HIS Document Type" = const('Settlement'));

            // trigger OnValidate()
            // var
            //     PostedOrgReceipt: Record "E3 Organization Receipt";
            // begin
            //     if "Receipt No." = '' then
            //         exit;

            //     if PostedOrgReceipt.Get("Receipt No.") then begin
            //         // Automatically fill header details
            //         Rec."Receipt No." := PostedOrgReceipt."Document No.";
            //         Rec."Receipt Date" := PostedOrgReceipt."Document Date";
            //         Rec."HIS Document Type" := PostedOrgReceipt."HIS Document Type";
            //     end;
            // end;
        }
        field(6; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
            DataClassification = CustomerContent;
        }
        field(7; "Receipt Amount"; Decimal)
        {
            Caption = 'Receipt Amount';
            DataClassification = CustomerContent;
        }
        field(8; "Allocated Amount"; Decimal)
        {
            Caption = 'Allocated Amount';
            DataClassification = CustomerContent;
        }
        field(9; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Organization Receipt";
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}