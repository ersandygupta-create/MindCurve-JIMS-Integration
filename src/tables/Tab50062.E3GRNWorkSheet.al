table 50062 "E3 GRN Work Sheet"
{
    Caption = 'GRN Work Sheet';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "PO No."; Code[20])
        {
            Caption = 'PO No.';
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
            DataClassification = CustomerContent;
        }

        field(4; "Item Name"; Text[100])
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
        }

        field(5; "PO Qty"; Decimal)
        {
            Caption = 'PO Qty';
            DataClassification = CustomerContent;
        }

        field(6; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
        }

        field(7; "Outstanding Qty"; Decimal)
        {
            Caption = 'Outstanding Qty';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Rec."Quantity Received" + Rec."Outstanding Qty" > rec."PO Qty") then
                    Error('Quantity received and quantity to receive shoul not more than Quantity');

            end;
        }

        field(8; "Invoice Qty"; Decimal)
        {
            Caption = 'Invoice Qty';
            DataClassification = CustomerContent;
        }

        field(9; "Receipt Qty"; Decimal)
        {
            Caption = 'Receipt Qty';
            DataClassification = CustomerContent;
        }

        field(10; "Rejected Qty"; Decimal)
        {
            Caption = 'Rejected Qty';
            DataClassification = CustomerContent;
        }

        field(11; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
        }

        field(12; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }

        field(13; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }

        field(14; "Supplier Batch No."; Code[50])
        {
            Caption = 'Supplier Batch No.';
            DataClassification = CustomerContent;
        }

        field(15; "Line Gross"; Decimal)
        {
            Caption = 'Line Gross';
            DataClassification = CustomerContent;
        }

        field(16; "MRP"; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }

        field(17; "SKU MRP"; Decimal)
        {
            Caption = 'SKU MRP';
            DataClassification = CustomerContent;
        }

        field(18; "Sale Rate"; Decimal)
        {
            Caption = 'Sale Rate';
            DataClassification = CustomerContent;
        }

        field(19; "SKU Sale Rate"; Decimal)
        {
            Caption = 'SKU Sale Rate';
            DataClassification = CustomerContent;
        }

        field(20; "Staff Sale Rate"; Decimal)
        {
            Caption = 'Staff Sale Rate';
            DataClassification = CustomerContent;
        }

        field(21; "SKU Staff Sale Rate"; Decimal)
        {
            Caption = 'SKU Staff Sale Rate';
            DataClassification = CustomerContent;
        }

        field(22; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }

        field(23; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
        }

        field(24; "GST Type Code"; Code[20])
        {
            Caption = 'GST Type Code';
            DataClassification = CustomerContent;
        }

        field(25; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;
        }

        field(26; "Line Discount Percentage"; Decimal)
        {
            Caption = 'Line Discount Percentage';
            DataClassification = CustomerContent;
        }

        field(27; "Taxable Amount"; Decimal)
        {
            Caption = 'Taxable Amount';
            DataClassification = CustomerContent;
        }

        field(28; "CGST %"; Decimal)
        {
            Caption = 'CGST %';
            DataClassification = CustomerContent;
        }

        field(29; "CGST Amount"; Decimal)
        {
            Caption = 'CGST Amount';
            DataClassification = CustomerContent;
        }

        field(30; "SGST %"; Decimal)
        {
            Caption = 'SGST %';
            DataClassification = CustomerContent;
        }

        field(31; "SGST Amount"; Decimal)
        {
            Caption = 'SGST Amount';
            DataClassification = CustomerContent;
        }

        field(32; "IGST %"; Decimal)
        {
            Caption = 'IGST %';
            DataClassification = CustomerContent;
        }

        field(33; "IGST Amount"; Decimal)
        {
            Caption = 'IGST Amount';
            DataClassification = CustomerContent;
        }

        field(34; "Final Discount %"; Decimal)
        {
            Caption = 'Final Discount %';
            DataClassification = CustomerContent;
        }

        field(35; "Final Discount Amount"; Decimal)
        {
            Caption = 'Final Discount Amount';
            DataClassification = CustomerContent;
        }
        field(36; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(37; "Quantity Received"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies how many units of the item on the line have been posted as received.';

        }
        field(38; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            ToolTip = 'Specifies how serial, lot or package numbers assigned to the item are tracked in the supply chain.';
            TableRelation = "Item Tracking Code";
            OptimizeForTextSearch = true;
        }
    }

    keys
    {
        key(PK; "PO No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure InitFromPurchaseLine(PONo: Code[20])
    var
        PurchLine: Record "Purchase Line";
        Item: Record Item;
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PONo);

        if PurchLine.FindSet() then
            repeat
                // Skip if worksheet line already exists
                if Get(PurchLine."Document No.", PurchLine."Line No.") then
                    continue;

                Init();

                "PO No." := PurchLine."Document No.";
                "Line No." := PurchLine."Line No.";
                "Item No." := PurchLine."No.";
                "Item Name" := PurchLine.Description;
                "PO Qty" := PurchLine.Quantity;
                "Outstanding Qty" := PurchLine."Outstanding Quantity";
                "Receipt Qty" := PurchLine."Qty. to Receive";
                "Quantity Received" := PurchLine."Quantity Received";
                "Invoice Qty" := PurchLine."Qty. to Invoice";
                "Rejected Qty" := PurchLine."Qty. to Reject (C.E.)";
                "Base Unit of Measure" := PurchLine."Unit of Measure Code";
                "Line Discount Amount" := PurchLine."Line Discount Amount";
                "Line Discount Percentage" := PurchLine."Line Discount %";

                if Item.Get(PurchLine."No.") then begin
                    "Lot No." := Item."Lot Nos.";
                    "Item Make Code" := Item."Medicine Company Code";
                    "GST Type Code" := Item."GST Group Code";
                    "Item Tracking Code" := Item."Item Tracking Code";
                end;

                Insert(true);
            until PurchLine.Next() = 0;
    end;
}