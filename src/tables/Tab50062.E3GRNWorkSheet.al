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
            trigger OnValidate()
            begin
                CalculateNetQtyReceived();

                "Shortage Qty" := "Invoice Qty" - "Receipt Qty";
            end;

        }
        field(9; "Receipt Qty"; Decimal)
        {
            Caption = 'Receipt Qty';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Shortage Qty" := "Invoice Qty" - "Receipt Qty";
                CalculateNetQtyReceived();
            end;

        }
        field(10; "Rejected Qty"; Decimal)
        {
            Caption = 'Rejected Qty';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateNetQtyReceived();
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
            trigger OnValidate()
            begin
                CalculateLandedValue();
            end;
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
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(21; "SKU Staff Sale Rate"; Decimal)
        {
            Caption = 'SKU Staff Sale Rate';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
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
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(28; "CGST %"; Decimal)
        {
            Caption = 'CGST %';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(29; "CGST Amount"; Decimal)
        {
            Caption = 'CGST Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(30; "SGST %"; Decimal)
        {
            Caption = 'SGST %';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
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
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
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
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(48; "Landed SKU Value"; Decimal)
        {
            Caption = 'Line Landed SKU Value';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
        }
        field(49; "Landed SKU Rate"; Decimal)
        {
            Caption = 'Line Landed SKU Rate';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     CalculateLandedValue();
            // end;
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
        }
        field(52; "Rec SKU QTY"; Decimal)
        {
            Caption = 'Rec SKU QTY';
            DataClassification = CustomerContent;
        }
        field(53; "UGST %"; Decimal)
        {
            Caption = 'UGST %';
            DataClassification = CustomerContent;
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
        field(65; "PO MRP"; Decimal)
        {
            Caption = 'PO MRP';
            DataClassification = CustomerContent;
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
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. per Unit of Measure';
            Editable = false;
            InitValue = 1;
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

        Rec.TestField("Invoice Qty");
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
                "Item No." := PurchLine."No.";
                "Item Name" := PurchLine.Description;
                "Unit of Measure" := PurchLine."Unit of Measure";
                "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
                "PO Qty" := PurchLine.Quantity;
                "Receipt Qty" := PurchLine."Qty. to Receive";
                "Invoice Qty" := PurchLine."Qty. to Invoice";
                "Line Gross" := PurchLine."Line Amount";
                "Outstanding Qty" := PurchLine."Quantity";
                "Quantity Received" := PurchLine."Quantity Received";
                "Rejected Qty" := PurchLine."Qty. to Reject (C.E.)";
                Validate("PO MRP", PurchLine.MRP);
                Validate(MRP, PurchLine.MRP);
                Scheme := PurchLine.Scheme;
                "Base Unit of Measure" := PurchLine."Unit of Measure Code";
                "Line Discount Amount" := PurchLine."Line Discount Amount";
                "Line Discount Percentage" := PurchLine."Line Discount %";
                "Item Make Code" := PurchLine."Item Make Code";
                "Item Make Name" := PurchLine."Item Make Name";
                "GST Type Code" := Format(PurchLine."GST Vendor Type");
                "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
                Validate("Department Code", PurchLine."Shortcut Dimension 2 Code");
                DepartmentValue.Reset();
                DepartmentValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 2 Code");
                DepartmentValue.SetRange(Code, "Department Code");
                if DepartmentValue.FindFirst() then
                    "Department Name" := DepartmentValue.Name;
                Validate("HSN Code", PurchLine."HSN/SAC Code");
                "Indent Doc ID" := PurchLine."Indent No.";
                "Indent Line No." := PurchLine."Indent Line No.";
                "Unit Code" := PurchLine."Unit of Measure";
                "Indent SKU Qty" := PurchLine.Quantity;
                "Taxable Amount" := PurchLine."Line Amount";
                "Voucher Type" := '26';
                "Department Code" := PurchLine."Shortcut Dimension 2 Code";
                "Final Discount %" := PurchLine."Line Discount %";
                "Final Discount Amount" := PurchLine."Line Discount Amount";
                Rate := PurchLine."Direct Unit Cost";

                GeneralLedgerSetup.Get();
                Clear("Department Name");
                if "Department Code" <> '' then begin
                    if DimensionValue.Get(GeneralLedgerSetup."Global Dimension 2 Code", "Department Code")
                    then
                        "Department Name" := DimensionValue.Name;
                end;
                "OH Amt Net" := PurchLine."Line Amount";
                "Indent SKU Qty" := PurchLine.Quantity;
                "Vendor Code" := PurchLine."Buy-from Vendor No.";
                if PurchLine."Buy-from Vendor No." <> '' then begin

                    Vendor.Reset();
                    Vendor.SetRange("No.", PurchLine."Buy-from Vendor No.");

                    if Vendor.FindFirst() then
                        "Supplier State" := Vendor."State Code";
                end;
                if Evaluate(GSTPercentage, PurchLine."GST Group Code") then begin
                    if "Supplier State" = PurchaseHeader."Location State Code" then begin
                        // Same State
                        "CGST %" := GSTPercentage / 2;
                        "SGST %" := GSTPercentage / 2;
                        "IGST %" := 0;
                    end else begin
                        // Inter State
                        "CGST %" := 0;
                        "SGST %" := 0;
                        "IGST %" := GSTPercentage;
                    end;
                end;
                CalculateLandedValue();

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

        "Net Qty Received" :=
            "Invoice Qty" - "Shortage Qty" - "Rejected Qty";
        "Receipt Qty" := "Invoice Qty" + "Free Qty";
    end;

    local procedure CalculateLandedValue()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, "PO No.")
        then begin
            if "Supplier State" = PurchaseHeader."Location State Code" then begin
                // Same State
                "IGST Amount" := 0;
                "CGST Amount" := "Taxable Amount" * "CGST %" / 100;
                "SGST Amount" := "Taxable Amount" * "SGST %" / 100;
            end else begin
                // Interstate
                "CGST Amount" := 0;
                "SGST Amount" := 0;
                "IGST Amount" := "Taxable Amount" * "IGST %" / 100;
            end;

            "UGST Amount" := "Taxable Amount" * "UGST %" / 100;

            "Landed SKU Value" :=
                "OH Amt Net"
                + "CGST Amount"
                + "SGST Amount"
                + "IGST Amount"
                + "UGST Amount";

            if "Rec SKU QTY" <> 0 then
                "Landed SKU Rate" := "Landed SKU Value" / "Rec SKU QTY"
            else
                "Landed SKU Rate" := 0;

            if "Indent SKU Qty" <> 0 then
                "Staff Sale Rate" := ("Taxable Amount" + "Line Discount Amount" + "CGST Amount" + "SGST Amount" + "IGST Amount" + "UGST Amount") / "Indent SKU Qty"
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
        end;
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

        // Create Purchase Line reservation/tracking entry
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

        // Set Qty. to Handle / Invoice
        CreateReservEntry.SetQtyToHandleAndInvoice(
            QtyToHandleBase,
            QtyToHandleBase);

        // Create reservation entry
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
}