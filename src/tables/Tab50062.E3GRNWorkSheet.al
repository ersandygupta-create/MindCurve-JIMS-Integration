table 50062 "E3 GRN Work Sheet"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "PO No."; Code[20])
        {
            Caption = 'PO No.';
            //TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(4; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }
        field(5; "PO Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Outstanding Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Invoice Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Receipt Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Rejected Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Lot No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Mfg Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(12; "Exp. Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(13; "Supplier Batch No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Line Gross"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; MRP; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; skuMrp; Decimal)
        {
            Caption = 'SKU MRP';
            DataClassification = CustomerContent;
        }
        field(17; saleRate; Decimal)
        {
            Caption = 'Sale Rate';
            DataClassification = CustomerContent;
        }
        field(18; skuSaleRate; Decimal)
        {
            Caption = 'SKU Sale Rate';
            DataClassification = CustomerContent;
        }
        field(19; staffSaleRate; Decimal)
        {
            Caption = 'Staff Sale Rate';
            DataClassification = CustomerContent;
        }
        field(20; skuStaffSaleRate; Decimal)
        {
            Caption = 'SKU Staff Sale Rate';
            DataClassification = CustomerContent;
        }
        field(21; batchNo; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(22; manufacturingDate; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(23; expiryDate; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(24; itemMakeCode; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
        }
        field(25; gstTypeCode; Code[20])
        {
            Caption = 'GST Type Code';
            DataClassification = CustomerContent;
        }
        field(26; "Line Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(27; "Line Discount Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(28; "Taxable Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(29; "CGST %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(30; "CGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(31; "SGST %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(32; "SGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(33; "IGST %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(34; "IGST Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(35; "Final Discount %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(36; "Final Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(37; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "PO No.", "Line No.")
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