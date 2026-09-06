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
            DecimalPlaces = 2 : 2;
        }
        field(6; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(7; "Outstanding Qty"; Decimal)
        {
            Caption = 'Outstanding Qty';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
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
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateNetQtyReceived();
                CalculateLandedValue();

                "Shortage Qty" := "Invoice Qty" - "Receipt Qty";
            end;

        }
        field(9; "Receipt Qty"; Decimal)
        {
            Caption = 'Receipt Qty';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin

                CalculateNetQtyReceived();
                CalculateLandedValue();
            end;

        }
        field(10; "Rejected Qty"; Decimal)
        {
            Caption = 'Rejected Qty';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateNetQtyReceived();
                CalculateLandedValue();
            end;
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
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(16; "MRP"; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
                if "Sale Rate" > MRP then begin
                    "Sale Rate" := MRP;

                    if "Qty. per Unit of Measure" <> 0 then
                        "SKU Sale Rate" := "Sale Rate" / "Qty. per Unit of Measure"
                    else
                        "SKU Sale Rate" := 0;

                    Message(
                        'MRP has been changed. Sale Rate has been updated to MRP %1.',
                        MRP);
                end;
            end;
        }
        field(17; "SKU MRP"; Decimal)
        {
            Caption = 'SKU MRP';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(18; "Sale Rate"; Decimal)
        {
            Caption = 'Sale Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                if "Sale Rate" > MRP then begin
                    "Sale Rate" := MRP;

                    Message(
                        'Sale Rate cannot be greater than MRP. Sale Rate has been updated to MRP %1.',
                        MRP);
                end;

                CalculateLandedValue();
            end;
        }
        field(19; "SKU Sale Rate"; Decimal)
        {
            Caption = 'SKU Sale Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(20; "Staff Sale Rate"; Decimal)
        {
            Caption = 'Staff Sale Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(21; "SKU Staff Sale Rate"; Decimal)
        {
            Caption = 'SKU Staff Sale Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
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
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(26; "Line Discount Percentage"; Decimal)
        {
            Caption = 'Line Discount Percentage';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(27; "Taxable Amount"; Decimal)
        {
            Caption = 'Taxable Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(28; "CGST %"; Decimal)
        {
            Caption = 'CGST %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(29; "CGST Amount"; Decimal)
        {
            Caption = 'CGST Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(30; "SGST %"; Decimal)
        {
            Caption = 'SGST %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(31; "SGST Amount"; Decimal)
        {
            Caption = 'SGST Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(32; "IGST %"; Decimal)
        {
            Caption = 'IGST %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(33; "IGST Amount"; Decimal)
        {
            Caption = 'IGST Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(34; "Final Discount %"; Decimal)
        {
            Caption = 'Final Discount %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(35; "Final Discount Amount"; Decimal)
        {
            Caption = 'Final Discount Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
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
            Editable = false;
            ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
            DecimalPlaces = 2 : 2;

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
            TableRelation = Location.Code;
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
            Editable = true;
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
            trigger OnValidate()
            var
                HSNSAC: Record "HSN/SAC";
            begin
                Clear("Item GST Nature");

                if "HSN Code" = '' then
                    exit;

                if HSNSAC.Get("HSN Code") then
                    "Item GST Nature" := HSNSAC.GLEN;
            end;
        }
        field(45; "Indent SKU Qty"; Decimal)
        {
            Caption = 'Requested Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(46; "Item GST Nature"; Enum "E3 GLEN Type")
        {
            Caption = 'GST Nature';
            DataClassification = CustomerContent;
        }
        field(47; "OH Amt Net"; Decimal)
        {
            Caption = 'Line Net Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(48; "Landed SKU Value"; Decimal)
        {
            Caption = 'Line Landed SKU Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(49; "Landed SKU Rate"; Decimal)
        {
            Caption = 'Line Landed SKU Rate';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(50; Remark; Text[250])
        {
            Caption = 'Line Remark';
            DataClassification = CustomerContent;
        }
        field(51; Rate; Decimal)
        {
            Caption = 'Purchase Rate';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(52; "Rec SKU QTY"; Decimal)
        {
            Caption = 'Rec SKU QTY';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(53; "UGST %"; Decimal)
        {
            Caption = 'UGST %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                "UGST Amount" := "Taxable Amount" * "UGST %" / 100;
            end;
        }
        field(54; "UGST Amount"; Decimal)
        {
            Caption = 'UGST Amount';
            AutoFormatType = 1;
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
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
            DecimalPlaces = 2 : 2;
        }
        field(59; "Accepted Qty"; Decimal)
        {
            Caption = 'Accepted Qty';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
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
        field(62; "Voucher Type"; Text[60])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
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
        field(65; "PO MRP"; Decimal)
        {
            Caption = 'PO MRP';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(66; Scheme; Text[30])
        {
            Caption = 'Scheme';
            DataClassification = CustomerContent;
        }
        field(67; "Net Qty Received"; Decimal)
        {
            Caption = 'Net Qty Received';
            Editable = false;
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateNetQtyReceived();
            end;
        }
        field(68; "Shortage Qty"; Decimal)
        {
            Caption = 'Shortage Qty';
            DataClassification = CustomerContent;
        }
        field(69; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            ToolTip = 'Specifies the unit of measure.';
        }
        field(70; Split; Boolean)
        {
            Caption = 'Split';
            DataClassification = CustomerContent;
        }
        field(71; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(72; "Entry No."; Code[50])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(73; "Margin Code"; Code[20])
        {
            Caption = 'Margin Code';
            DataClassification = CustomerContent;
            tableRelation = "E3 Item Margin"."Margin Code";
        }
        field(74; "Company Value"; Decimal)
        {
            Caption = 'Company Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(75; "Patient Value"; Decimal)
        {
            Caption = 'Patient Value';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(76; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = CustomerContent;
        }
        field(18080; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            TableRelation = "GST Group";
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. per Unit of Measure';
            Editable = false;
            InitValue = 1;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
        }
        field(18083; "GST Jurisdiction Type"; enum "GST Jurisdiction Type")
        {
            Caption = 'GST Jurisdiction Type';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
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
        if "GRN Date" = 0D then
            "GRN Date" := Today;

        if "V Prefix" = '' then
            "V Prefix" := CopyStr(Format(Date2DMY("GRN Date", 3)), 3, 2);

        //Rec.TestField("Invoice Qty");
        Rec."GRN Date" := WorkDate();
        if "Lot No." = '' then begin
            PurchPayablesSetup.Get();
            PurchPayablesSetup.TestField("Lot Nos.");
            "Lot No." := NoSeries.GetNextNo(PurchPayablesSetup."Lot Nos.", WorkDate(), true);
        end;
    end;

    procedure InitFromPurchaseLine(PONo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Item: Record Item;
        HSNSAC: Record "HSN/SAC";
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ItemUOM: Record "Item Unit of Measure";
        GSTPercentage: Decimal;
        DepartmentValue: Record "Dimension Value";
        LocationRec: Record Location;
        CompanyInformation: Record "Company Information";
        Vendor: Record Vendor;

    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PONo);

        if PurchLine.FindSet() then
            repeat
                if Get(PurchLine."Document No.", PurchLine."Line No.") then
                    continue;

                Init();

                "PO No." := PurchLine."Document No.";
                "Line No." := PurchLine."Line No.";
                "Entry No." := PurchLine."Entry No.";
                "Item No." := PurchLine."No.";
                "Item Name" := PurchLine.Description;
                "Unit of Measure" := PurchLine."Unit of Measure";
                "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
                "PO Qty" := PurchLine.Quantity;
                Validate("Receipt Qty", PurchLine."Qty. to Receive");
                Validate("Invoice Qty", PurchLine."Qty. to Invoice");
                //"Line Gross" := PurchLine."Line Amount";
                "Outstanding Qty" := PurchLine."Quantity";
                "Quantity Received" := PurchLine."Quantity Received";
                //"Rejected Qty" := PurchLine."Qty. to Reject (C.E.)";
                Validate("PO MRP", PurchLine.MRP);
                //Validate(MRP, PurchLine.MRP);
                Scheme := PurchLine.Scheme;
                "Base Unit of Measure" := PurchLine."Unit of Measure Code";
                //"Line Discount Amount" := PurchLine."Line Discount Amount";
                "Line Discount Percentage" := PurchLine."Line Discount %";
                "GST Group Code" := PurchLine."GST Group Code";
                "GST Jurisdiction Type" := PurchLine."GST Jurisdiction Type";
                "Item Make Code" := PurchLine."Item Make Code";
                "Item Make Name" := PurchLine."Item Make Name";
                "GST Type Code" := Format(PurchLine."GST Vendor Type");
                "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
                Validate("Department Code", PurchLine."Location Code");
                Clear(LocationRec);
                if LocationRec.Get(PurchLine."Location Code") then
                    "Department Name" := LocationRec.Name
                else
                    "Department Name" := '';
                Validate("HSN Code", PurchLine."HSN/SAC Code");
                "Indent Doc ID" := PurchLine."Indent No.";
                "Indent Line No." := PurchLine."Indent Line No.";
                "Unit Code" := PurchLine."Unit of Measure";
                "Indent SKU Qty" := PurchLine.Quantity;
                //"Taxable Amount" := PurchLine."Line Amount";
                "Final Discount %" := PurchLine."Line Discount %";
                "Final Discount Amount" := PurchLine."Line Discount Amount";
                Rate := PurchLine."Direct Unit Cost";
                "OH Amt Net" := PurchLine."Line Amount";
                "Indent SKU Qty" := PurchLine.Quantity;
                "Margin Code" := PurchLine."Margin Code";
                "Company Value" := PurchLine."Company Value";
                "Patient Value" := PurchLine."Patient Value";
                PurchaseHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
                "Voucher Type" := PurchaseHeader."GRN Voucher Type Name";
                "Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
                "Vendor Code" := PurchLine."Buy-from Vendor No.";
                if PurchLine."Buy-from Vendor No." <> '' then begin

                    Vendor.Reset();
                    Vendor.SetRange("No.", PurchLine."Buy-from Vendor No.");

                    if Vendor.FindFirst() then
                        "Supplier State" := Vendor."State Code";
                end;

                "CGST %" := 0;
                "CGST Amount" := 0;
                "SGST %" := 0;
                "SGST Amount" := 0;
                "IGST %" := 0;
                "IGST Amount" := 0;

                if Evaluate(GSTPercentage, PurchLine."GST Group Code") then
                    if PurchLine."GST Jurisdiction Type" = PurchLine."GST Jurisdiction Type"::Interstate then begin
                        "IGST %" := GSTPercentage;
                        "IGST Amount" := Round(
                            "Taxable Amount" * "IGST %" / 100,
                            0.01);
                    end else begin
                        "CGST %" := GSTPercentage / 2;
                        "SGST %" := GSTPercentage / 2;

                        "CGST Amount" := Round(
                            "Taxable Amount" * "CGST %" / 100,
                            0.01);

                        "SGST Amount" := Round(
                            "Taxable Amount" * "SGST %" / 100,
                            0.01);
                    end;


                if PurchLine."HSN/SAC Code" <> '' then begin
                    "HSN Code" := PurchLine."HSN/SAC Code";
                    HSNSAC.Reset();
                    HSNSAC.SetRange(Code, PurchLine."HSN/SAC Code");
                    if HSNSAC.FindFirst() then begin
                        if PurchLine."GST Group Code" <> '' then
                            "Item GST Nature" := HSNSAC.GLEN;
                    end;
                end;

                if Item.Get(PurchLine."No.") then begin
                    "Lot No." := Item."Lot Nos.";
                    "Item Tracking Code" := Item."Item Tracking Code";
                end;

                if Item.Get(PurchLine."No.") then
                    if ItemUOM.Get(Item."No.", Item."Purch. Unit of Measure") then
                        "Rec SKU QTY" := PurchLine.Quantity * ItemUOM."Qty. per Unit of Measure"
                    else
                        "Rec SKU QTY" := PurchLine.Quantity;
                CalculateLandedValue();

                Insert(true);
            until PurchLine.Next() = 0;
    end;

    local procedure CalculateNetQtyReceived()
    begin
        "Shortage Qty" := "Invoice Qty" - "Receipt Qty";
        "Net Qty Received" := "Receipt Qty" - "Rejected Qty";
    end;

    local procedure CalculateMarginSaleRate()
    var
        ItemMargin: Record "E3 Item Margin";
    begin
        Clear("Sale Rate");

        if ("Margin Code" = '') or ("Department Code" = '') then
            exit;

        ItemMargin.Reset();
        ItemMargin.SetRange("Margin Code", "Margin Code");
        ItemMargin.SetRange("Business Unit Code", "Shortcut Dimension 1 Code");

        if not ItemMargin.FindFirst() then
            exit;

        case ItemMargin."Margin Type" of

            ItemMargin."Margin Type"::Percentage:
                begin
                    "Sale Rate" :=
                        "Staff Sale Rate"
                        + (
                            "Staff Sale Rate"
                            * ItemMargin."Company Value"
                            / 100
                        );
                end;

            ItemMargin."Margin Type"::Markup:
                begin
                    "Sale Rate" :=
                        "Staff Sale Rate"
                        + (
                            ("MRP" - "Staff Sale Rate")
                            * ItemMargin."Company Value"
                            / 100
                        );
                end;
        end;

        if "Qty. per Unit of Measure" <> 0 then
            "SKU Sale Rate" :=
                "Sale Rate" / "Qty. per Unit of Measure"
        else
            "SKU Sale Rate" := 0;
    end;

    local procedure CalculateLandedValue()
    var
        TaxableBase: Decimal;
    begin
        "Net Qty Received" := "Receipt Qty" - "Rejected Qty";

        if "Qty. per Unit of Measure" <> 0 then
            "Rec SKU QTY" := "Net Qty Received" * "Qty. per Unit of Measure"
        else
            "Rec SKU QTY" := 0;

        if "Net Qty Received" <> 0 then
            "Line Gross" := Rate * "Net Qty Received"
        else
            "Line Gross" := 0;

        if "Line Gross" <> 0 then
            "Line Discount Amount" := "Line Gross" * "Line Discount Percentage" / 100
        else
            "Line Discount Amount" := 0;

        "Taxable Amount" := "Line Gross" - "Line Discount Amount";
        TaxableBase := "Taxable Amount";
        "CGST Amount" := Round(TaxableBase * "CGST %" / 100, 0.01);
        "SGST Amount" := Round(TaxableBase * "SGST %" / 100, 0.01);
        "IGST Amount" := Round(TaxableBase * "IGST %" / 100, 0.01);
        "UGST Amount" := Round(TaxableBase * "UGST %" / 100, 0.01);

        // 9. Landed SKU Value
        "Landed SKU Value" :=
            "Taxable Amount"
            + "CGST Amount"
            + "SGST Amount"
            + "IGST Amount"
            + "UGST Amount";
        "OH Amt Net" := "Taxable Amount" + "CGST Amount" + "SGST Amount"
            + "IGST Amount"
            + "UGST Amount";

        if "Rec SKU QTY" <> 0 then
            "Landed SKU Rate" := "Landed SKU Value" / "Rec SKU QTY"
        else
            "Landed SKU Rate" := 0;

        if "Indent SKU Qty" <> 0 then
            "Staff Sale Rate" := Rate + ((Rate * ("CGST %" + "SGST %" + "IGST %" + "UGST %")) / 100)
        else
            "Staff Sale Rate" := 0;

        if "Qty. per Unit of Measure" <> 0 then
            "SKU Staff Sale Rate" := "Staff Sale Rate" / "Qty. per Unit of Measure"
        else
            "SKU Staff Sale Rate" := 0;

        if "Qty. per Unit of Measure" <> 0 then
            "SKU MRP" := MRP / "Qty. per Unit of Measure"
        else
            "SKU MRP" := 0;

        CalculateMarginSaleRate();
    end;

    procedure AssignLotNoToPurchaseLine()
    var
        PurchLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Item: Record Item;
        QtyToHandle: Decimal;
        QtyToHandleBase: Decimal;
        Vendor: Record Vendor;
        LotInformation: Record "Lot No. Information";
    begin
        // Get Purchase Line
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", "PO No.");
        PurchLine.SetRange("Line No.", "Line No.");

        if not PurchLine.FindFirst() then
            Error('Purchase Line not found for PO %1, Line %2.', "PO No.", "Line No.");

        PurchLine.TestField(Type, PurchLine.Type::Item);
        PurchLine.TestField("No.");

        Item.Get(PurchLine."No.");

        if Item."Item Tracking Code" = '' then
            Error('Item %1 does not have an Item Tracking Code.', Item."No.");

        TestField("Lot No.");

        // Check quantity
        if "Receipt Qty" <= 0 then
            Error(
                'Receipt Qty must be greater than zero for Item %1.',
                "Item No.");

        if "Receipt Qty" > PurchLine."Qty. to Receive" then
            Error(
                'Receipt Qty %1 cannot be greater than Purchase Line Qty. to Receive %2.',
                "Receipt Qty",
                PurchLine."Qty. to Receive");

        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", PurchLine."Document Type");
        ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");

        if not ReservationEntry.IsEmpty() then
            ReservationEntry.DeleteAll(true);

        QtyToHandle := "Receipt Qty";

        if "Rec SKU QTY" <> 0 then
            QtyToHandleBase := "Rec SKU QTY"
        else
            QtyToHandleBase :=
                Round(
                    QtyToHandle * PurchLine."Qty. per Unit of Measure",
                    0.00001);

        Clear(ReservationEntry);

        ReservationEntry.Init();
        ReservationEntry."Lot No." := "Lot No.";
        ReservationEntry.Quantity := QtyToHandle;
        ReservationEntry."Quantity (Base)" := QtyToHandleBase;

        if "Expiry Date" <> 0D then
            ReservationEntry."Expiration Date" := "Expiry Date";

        CreateReservEntry.SetDates(
            0D,
            ReservationEntry."Expiration Date");

        CreateReservEntry.CreateReservEntryFor(
            Database::"Purchase Line",
            PurchLine."Document Type",
            PurchLine."Document No.",
            '',
            0,
            PurchLine."Line No.",
            PurchLine."Qty. per Unit of Measure",
            QtyToHandle,
            QtyToHandleBase,
            ReservationEntry);

        CreateReservEntry.SetQtyToHandleAndInvoice(
            QtyToHandleBase,
            QtyToHandleBase);

        CreateReservEntry.CreateEntry(
            PurchLine."No.",
            PurchLine."Variant Code",
            PurchLine."Location Code",
            PurchLine.Description,
            PurchLine."Expected Receipt Date",
            0D,
            0,
            ReservationEntry."Reservation Status"::Surplus);

        LotInformation.Reset();
        LotInformation.SetRange("Item No.", PurchLine."No.");
        LotInformation.SetRange("Lot No.", "Lot No.");

        if not LotInformation.FindFirst() then begin
            LotInformation.Init();
            LotInformation."Item No." := PurchLine."No.";
            LotInformation."Lot No." := "Lot No.";
            LotInformation.Insert(true);
        end;

        LotInformation."Item Name" := Item.Description;
        LotInformation."Vendor Code" := PurchLine."Buy-from Vendor No.";
        if Vendor.Get(PurchLine."Buy-from Vendor No.") then
            LotInformation."Vendor Name" := Vendor.Name;
        LotInformation."Manufacturing Date" := "Manufacturing Date";
        LotInformation."Expairy Date" := "Expiry Date";

        LotInformation.Modify(true);

    end;

    procedure SplitGRNLine(
        var SelectedLine: Record "E3 GRN Work Sheet";
        SplitQty: Decimal)
    var
        NewLine: Record "E3 GRN Work Sheet";
        LastLine: Record "E3 GRN Work Sheet";
        NextLineNo: Integer;
        RemainingQty: Decimal;
    begin
        if SplitQty <= 0 then
            Error('Split Quantity must be greater than zero.');

        if SplitQty >= SelectedLine."Receipt Qty" then
            Error('Split Quantity %1 must be less than Receipt Quantity %2.', SplitQty, SelectedLine."Receipt Qty");
        LastLine.Reset();
        LastLine.SetRange("PO No.", SelectedLine."PO No.");

        if LastLine.FindLast() then
            NextLineNo := LastLine."Line No." + 10000
        else
            NextLineNo := 10000;
        RemainingQty := SelectedLine."Receipt Qty" - SplitQty;
        NewLine := SelectedLine;
        NewLine."Line No." := NextLineNo;
        NewLine."Receipt Qty" := SplitQty;
        NewLine."Invoice Qty" := 0;
        NewLine."Net Qty Received" := NewLine."Receipt Qty" - NewLine."Rejected Qty";
        NewLine."Shortage Qty" := NewLine."Invoice Qty" - NewLine."Receipt Qty";
        NewLine.Split := true;
        NewLine.Insert(true);
        SelectedLine."Receipt Qty" := RemainingQty;
        SelectedLine."Net Qty Received" := SelectedLine."Receipt Qty" - SelectedLine."Rejected Qty";
        SelectedLine."Shortage Qty" := SelectedLine."Invoice Qty" - SelectedLine."Receipt Qty";

        SelectedLine.Split := true;
        SelectedLine.Modify(true);
    end;

    procedure CalculateNetQtyReceived1()
    begin
        "Net Qty Received" := "Receipt Qty" - "Rejected Qty";
    end;

    procedure AssignBatchNoToPurchaseLine()
    var
        PurchLine: Record "Purchase Line";
        GRNWorkSheet: Record "E3 GRN Work Sheet";
        ReservationEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Item: Record Item;
        Vendor: Record Vendor;
        LotInformation: Record "Lot No. Information";
        QtyToHandle: Decimal;
        QtyToHandleBase: Decimal;
        BatchQty: Decimal;
        BatchQtyBase: Decimal;
        TotalBatchQty: Decimal;
        TotalBatchQtyBase: Decimal;
        LotNoToUse: Code[50];
        BatchCount: Integer;
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", "PO No.");
        PurchLine.SetRange("Line No.", "Line No.");

        if not PurchLine.FindFirst() then
            Error('Purchase Line not found for PO %1, Line %2.', "PO No.", "Line No.");

        PurchLine.TestField(Type, PurchLine.Type::Item);
        PurchLine.TestField("No.");

        Item.Get(PurchLine."No.");

        if Item."Item Tracking Code" = '' then
            Error('Item %1 does not have an Item Tracking Code.', Item."No.");

        GRNWorkSheet.Reset();
        GRNWorkSheet.SetRange("PO No.", "PO No.");
        GRNWorkSheet.SetRange("Line No.", "Line No.");

        if GRNWorkSheet.IsEmpty() then
            Error('No GRN Work Sheet records found for PO %1, Line %2.', "PO No.", "Line No.");

        //ak

        GRNWorkSheet.FindSet();
        repeat
            if GRNWorkSheet."Receipt Qty" <= 0 then
                Error(
                    'Batch cannot be assigned for PO %1, Line %2 because Receipt Qty is %3.',
                    "PO No.",
                    "Line No.",
                    GRNWorkSheet."Receipt Qty");

            if GRNWorkSheet."Invoice Qty" <= 0 then
                Error(
                    'Batch cannot be assigned for PO %1, Line %2 because Invoice Qty is %3.',
                    "PO No.",
                    "Line No.",
                    GRNWorkSheet."Invoice Qty");
        until GRNWorkSheet.Next() = 0;
        //ak

        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Purchase Line");
        ReservationEntry.SetRange("Source Subtype", PurchLine."Document Type");
        ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
        if not ReservationEntry.IsEmpty() then
            ReservationEntry.DeleteAll(true);


        QtyToHandle := "Receipt Qty";

        if QtyToHandle <= 0 then
            Error(
                'Receipt Qty must be greater than zero for Item %1.',
                PurchLine."No.");

        if QtyToHandle > PurchLine."Qty. to Receive" then
            Error(
                'Receipt Qty %1 cannot be greater than Purchase Line Qty. to Receive %2.',
                QtyToHandle,
                PurchLine."Qty. to Receive");

        if "Rec SKU QTY" <> 0 then
            QtyToHandleBase := "Rec SKU QTY"
        else
            QtyToHandleBase :=
                Round(
                    QtyToHandle *
                    PurchLine."Qty. per Unit of Measure",
                    0.00001);

        GRNWorkSheet.FindSet();

        repeat
            if GRNWorkSheet."Supplier Batch No." = '' then
                Error(
                    'Supplier Batch No. is blank for PO %1, Line %2.',
                    GRNWorkSheet."PO No.",
                    GRNWorkSheet."Line No.");

            if GRNWorkSheet."Receipt Qty" <= 0 then
                Error(
                    'Receipt Qty must be greater than zero for Batch %1.',
                    GRNWorkSheet."Supplier Batch No.");

            TotalBatchQty += GRNWorkSheet."Receipt Qty";

            if GRNWorkSheet."Rec SKU QTY" <> 0 then
                TotalBatchQtyBase += GRNWorkSheet."Rec SKU QTY"
            else
                TotalBatchQtyBase +=
                    Round(
                        GRNWorkSheet."Receipt Qty" *
                        PurchLine."Qty. per Unit of Measure",
                        0.00001);

            BatchCount += 1;

        until GRNWorkSheet.Next() = 0;
        if Round(TotalBatchQty, 0.00001) <>
           Round(QtyToHandle, 0.00001) then
            Error(
                'Total quantity of supplier batches %1 does not match Receipt Qty %2 for PO %3, Line %4.',
                TotalBatchQty,
                QtyToHandle,
                "PO No.",
                "Line No.");
        GRNWorkSheet.FindSet();

        repeat
            LotNoToUse := GRNWorkSheet."Supplier Batch No.";

            BatchQty := GRNWorkSheet."Receipt Qty";

            if GRNWorkSheet."Rec SKU QTY" <> 0 then
                BatchQtyBase := GRNWorkSheet."Rec SKU QTY"
            else
                BatchQtyBase :=
                    Round(
                        BatchQty *
                        PurchLine."Qty. per Unit of Measure",
                        0.00001);
            Clear(ReservationEntry);
            ReservationEntry.Init();

            ReservationEntry."Lot No." := LotNoToUse;
            ReservationEntry.Quantity := BatchQty;
            ReservationEntry."Quantity (Base)" := BatchQtyBase;

            if GRNWorkSheet."Expiry Date" <> 0D then
                ReservationEntry."Expiration Date" :=
                    GRNWorkSheet."Expiry Date";

            CreateReservEntry.SetDates(
                0D,
                ReservationEntry."Expiration Date");

            CreateReservEntry.CreateReservEntryFor(
                Database::"Purchase Line",
                PurchLine."Document Type",
                PurchLine."Document No.",
                '',
                0,
                PurchLine."Line No.",
                PurchLine."Qty. per Unit of Measure",
                BatchQty,
                BatchQtyBase,
                ReservationEntry);

            CreateReservEntry.SetQtyToHandleAndInvoice(
                BatchQtyBase,
                BatchQtyBase);

            CreateReservEntry.CreateEntry(
                PurchLine."No.",
                PurchLine."Variant Code",
                PurchLine."Location Code",
                PurchLine.Description,
                PurchLine."Expected Receipt Date",
                0D,
                0,
                ReservationEntry."Reservation Status"::Surplus);
            LotInformation.Reset();
            LotInformation.SetRange(
                "Item No.",
                PurchLine."No.");
            LotInformation.SetRange(
                "Lot No.",
                LotNoToUse);

            if not LotInformation.FindFirst() then begin
                LotInformation.Init();

                LotInformation."Item No." :=
                    PurchLine."No.";

                LotInformation."Lot No." :=
                    LotNoToUse;

                LotInformation.Insert(true);
            end;

            LotInformation."Item Name" :=
                Item.Description;

            LotInformation.Description :=
                Item.Description;

            LotInformation."Vendor Code" :=
                PurchLine."Buy-from Vendor No.";

            if Vendor.Get(PurchLine."Buy-from Vendor No.") then
                LotInformation."Vendor Name" :=
                    Vendor.Name;

            LotInformation."Manufacturing Date" :=
                GRNWorkSheet."Manufacturing Date";

            LotInformation."Expairy Date" :=
                GRNWorkSheet."Expiry Date";

            LotInformation.Modify(true);

        until GRNWorkSheet.Next() = 0;

        // Message(
        //     '%1 supplier batch(es) assigned successfully to Purchase Order %2, Line %3.',
        //     BatchCount,
        //     "PO No.",
        //     "Line No.");
    end;
}