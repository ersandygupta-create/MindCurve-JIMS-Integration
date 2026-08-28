table 50073 "E3 RC Discount Line"
{
    Caption = 'RC Discount Line';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 RC Discount Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Product Type"; Option)
        {
            Caption = 'Product Type';
            OptionMembers = Make;
            OptionCaption = 'Make';
            DataClassification = CustomerContent;
        }
        field(4; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = "E3 Item Make Master".Code where("Make Type" = filter("Medicine/Marketing"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Make: Record "E3 Item Make Master";
                RCDiscountHeader: Record "E3 RC Discount Header";
            begin
                Clear(Description);

                if "Make Code" = '' then
                    exit;
                if RCDiscountHeader.Get("Document No.") then
                    "Vendor Code" := RCDiscountHeader."Vendor Code";

                Make.Reset();
                Make.SetRange(Code, "Make Code");

                if Make.FindFirst() then
                    Description := Make."Company Name";
            end;
        }
        field(5; Description; Text[60])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Line Discount %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Line Discount %';
            ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(7; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(8; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor."No.";
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
}