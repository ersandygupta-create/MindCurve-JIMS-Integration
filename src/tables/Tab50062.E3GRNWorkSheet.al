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
        field(11; "Lot No."; Code[20])
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
        field(22; "Item Make Name"; Text[60])
        {
            Caption = 'Item Make Name';
            DataClassification = CustomerContent;
        }
        field(23; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
        }
        field(24; "GST Type Code"; Text[20])
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
        field(39; "Indent Doc ID"; Code[20])
        {
            Caption = 'Indent Number';
            DataClassification = CustomerContent;
        }
        field(40; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line Number';
            DataClassification = CustomerContent;
        }
        field(41; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
            Editable = true;
            trigger OnValidate()
            var
                DimValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();

                DimValue.Reset();
                DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                DimValue.SetRange(Code, "Department Code");

                if DimValue.FindFirst() then
                    "Department Name" := DimValue.Name
                else
                    "Department Name" := '';
            end;
        }
        field(42; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            DataClassification = CustomerContent;
        }
        field(43; "Unit Code"; Code[50])
        {
            Caption = 'SKU Unit of Measure (UOM)';
            DataClassification = CustomerContent;
        }
        field(44; "HSN Code"; Code[20])
        {
            Caption = 'HSN Code';
            DataClassification = CustomerContent;
            TableRelation = "HSN/SAC".Code;
        }
        field(45; "Indent SKU Qty"; Decimal)
        {
            Caption = 'Requested Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(46; "Item GST Nature"; Enum "E3 GLEN Type")
        {
            Caption = 'GST Nature';
            DataClassification = CustomerContent;
        }
        field(47; "OH Amt Net"; Decimal)
        {
            Caption = 'Line Net Amount';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(48; "Landed SKU Value"; Decimal)
        {
            Caption = 'Line Landed SKU Value';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(49; "Landed SKU Rate"; Decimal)
        {
            Caption = 'Line Landed SKU Rate';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(50; Remark; Text[250])
        {
            Caption = 'Line Remark';
            DataClassification = CustomerContent;
        }
        field(51; Rate; Decimal)
        {
            Caption = 'Purchase Rate';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(52; "Rec SKU QTY"; Decimal)
        {
            Caption = 'Rec SKU QTY';
            DataClassification = CustomerContent;
        }
        field(53; "UGST %"; Decimal)
        {
            Caption = 'UGST %';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(54; "UGST Amount"; Decimal)
        {
            Caption = 'UGST Amount';
            AutoFormatType = 1;
            DataClassification = CustomerContent;
        }
        field(55; "GRN Date"; Date)
        {
            Caption = 'GRN Date';
            DataClassification = CustomerContent;
        }
        field(56; "Challan No."; Code[30])
        {
            Caption = 'Challan No.';
            DataClassification = CustomerContent;
        }
        field(57; "Challan Date"; Date)
        {
            Caption = 'Challan Date';
            DataClassification = CustomerContent;
        }
        field(58; "Challan Qty"; Decimal)
        {
            Caption = 'Challan Qty';
            DataClassification = CustomerContent;
        }
        field(59; "Accepted Qty"; Decimal)
        {
            Caption = 'Accepted Qty';
            DataClassification = CustomerContent;
        }
        field(60; "Supplier State"; Code[20])
        {
            Caption = 'Supplier State';
            TableRelation = State.Code;
            DataClassification = CustomerContent;
        }
        field(61; "V Prefix"; Code[2])
        {
            Caption = 'V Prefix';
            DataClassification = CustomerContent;
        }
        field(62; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Voucher Type".Code;
        }
        field(63; "Vendor Code"; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(64; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
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
    trigger OnInsert()
    var
        PurchPayablesSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Rec."GRN Date" := WorkDate();
        if "Lot No." = '' then begin
            PurchPayablesSetup.Get();
            PurchPayablesSetup.TestField("Lot Nos.");
            "Lot No." := NoSeries.GetNextNo(PurchPayablesSetup."Lot Nos.", WorkDate(), true);
        end;
    end;

    procedure InitFromPurchaseLine(PONo: Code[20])
    var
        PurchLine: Record "Purchase Line";
        Item: Record Item;
        HSNSAC: Record "HSN/SAC";
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ItemUOM: Record "Item Unit of Measure";

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
                "Line Gross" := PurchLine."Line Amount";
                "Outstanding Qty" := PurchLine."Quantity";
                "Receipt Qty" := PurchLine."Qty. to Receive";
                "Invoice Qty" := PurchLine."Qty. to Invoice";
                "Quantity Received" := PurchLine."Quantity Received";
                "Invoice Qty" := PurchLine."Qty. to Invoice";
                "Rejected Qty" := PurchLine."Qty. to Reject (C.E.)";
                "Base Unit of Measure" := PurchLine."Unit of Measure Code";
                "Line Discount Amount" := PurchLine."Line Discount Amount";
                "Line Discount Percentage" := PurchLine."Line Discount %";
                "Item Make Code" := PurchLine."Item Make Code";
                "Item Make Name" := PurchLine."Item Make Name";
                "GST Type Code" := Format(PurchLine."GST Jurisdiction Type");
                Validate("Department Code", PurchLine."Shortcut Dimension 2 Code");
                Validate("HSN Code", PurchLine."HSN/SAC Code");
                "Indent Doc ID" := PurchLine."Indent No.";
                "Indent Line No." := PurchLine."Indent Line No.";
                "Unit Code" := PurchLine."Unit of Measure";
                "Indent SKU Qty" := PurchLine.Quantity;
                "Taxable Amount" := PurchLine."Line Amount";
                "Department Code" := PurchLine."Shortcut Dimension 2 Code";

                GeneralLedgerSetup.Get();
                Clear("Department Name");
                if "Department Code" <> '' then begin
                    if DimensionValue.Get(
                        GeneralLedgerSetup."Global Dimension 2 Code",
                        "Department Code")
                    then
                        "Department Name" := DimensionValue.Name;
                end;
                "OH Amt Net" := PurchLine."Line Amount";
                "Indent SKU Qty" := PurchLine.Quantity;
                "Vendor Code" := PurchLine."Buy-from Vendor No.";

                if HSNSAC.Get(PurchLine."HSN/SAC Code") then
                    "Item GST Nature" := HSNSAC.GLEN;

                if Item.Get(PurchLine."No.") then begin
                    "Lot No." := Item."Lot Nos.";
                    "Item Tracking Code" := Item."Item Tracking Code";
                end;

                if Item.Get(PurchLine."No.") then
                    if ItemUOM.Get(Item."No.", Item."Purch. Unit of Measure") then
                        "Rec SKU QTY" := PurchLine.Quantity * ItemUOM."Qty. per Unit of Measure"
                    else
                        "Rec SKU QTY" := PurchLine.Quantity;

                Insert(true);
            until PurchLine.Next() = 0;
    end;
}