tableextension 50020 "E3 HIS Purch. Cr. Memo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {

        field(50000; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50002; "E3 HIS Type"; Enum "E3 HIS Type")
        {
            Caption = 'HIS Type';
            DataClassification = CustomerContent;
        }
        field(50003; "Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50004; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
        field(50005; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
        }
        field(50006; "Item Make Name"; Text[60])
        {
            Caption = 'Item Make Name';
            DataClassification = CustomerContent;
        }
        field(50007; Critical; Boolean)
        {
            Caption = 'Critical';
            DataClassification = CustomerContent;
        }
        field(50008; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
        }
        field(50009; "SNo."; Integer)
        {
            Caption = 'SNo.';
            DataClassification = CustomerContent;
        }
        field(50010; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }
        field(50011; Scheme; Text[30])
        {
            Caption = 'Scheme';
            DataClassification = CustomerContent;
        }
        field(50012; "Margin Fix"; Enum "E3 Margin Fix")
        {
            Caption = 'Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50013; "Incl Free Qty in Sale Rate"; Boolean)
        {
            Caption = 'Include Free Qty in Sale Rate';
            DataClassification = CustomerContent;
        }
        field(50014; "Entry No."; Code[50])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Margin Code"; Code[20])
        {
            Caption = 'Margin Code';
            DataClassification = CustomerContent;
            tableRelation = "E3 Item Margin"."Margin Code";
        }
        field(50016; "Company Value"; Decimal)
        {
            Caption = 'Company Value';
            DataClassification = CustomerContent;
        }
        field(50017; "Patient Value"; Decimal)
        {
            Caption = 'Patient Value';
            DataClassification = CustomerContent;
        }
        field(50018; "Indent Line Remarks"; Text[200])
        {
            Caption = 'Indent Line Remarks';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Line Remarks"; Text[200])
        {
            Caption = 'Line Remarks';
            DataClassification = CustomerContent;
        }
        field(50020; "PO Qty"; Decimal)
        {
            Caption = 'PO Qty';
            DataClassification = CustomerContent;
        }
        field(50021; "Stock No"; Code[50])
        {
            Caption = 'Stock No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50022; "Stock Line No"; Integer)
        {
            Caption = 'Stock Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50023; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(50024; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50025; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }

    }
}

