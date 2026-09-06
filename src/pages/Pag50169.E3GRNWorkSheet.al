page 50169 "E3 GRN Work Sheet"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 GRN Work Sheet";
    Caption = 'GRN Work Sheet';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order number.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item name.';
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchase order quantity.';
                }
                field("Free Qty"; Rec."Free Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase Free quantity.';
                }
                field("Outstanding Qty"; Rec."Outstanding Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the outstanding quantity.';
                }
                field("Invoice Qty"; Rec."Invoice Qty")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the invoice quantity.';
                    ShowMandatory = true;
                }
                field("Receipt Qty"; Rec."Receipt Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Qty. to Receive';
                    ToolTip = 'Specifies the receipt quantity.';
                    ShowMandatory = true;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortage Qty"; Rec."Shortage Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies a value Shortage Qty';
                }
                field("Rejected Qty"; Rec."Rejected Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rejected quantity.';
                    ShowMandatory = true;
                }
                field("Net Qty Received"; Rec."Net Qty Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final Net Qty Received';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the lot number.';
                    trigger OnAssistEdit()
                    var
                        PurchSetup: Record "Purchases & Payables Setup";
                        NoSeries: Codeunit "No. Series";
                    begin
                        PurchSetup.Get();
                        PurchSetup.TestField("Lot Nos.");

                        if Rec."Lot No." = '' then begin
                            Rec."No. Series" := PurchSetup."Lot Nos.";
                            Rec."Lot No." := NoSeries.GetNextNo(Rec."No. Series", WorkDate(), true);
                            CurrPage.Update();
                        end;
                    end;
                }
                field("Mfg Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the manufacturing date.';
                    trigger OnValidate()
                    begin
                        if Rec."Manufacturing Date" > WorkDate() then
                            Error(
                                'Manufacturing Date cannot be greater than Work Date %1.',
                                WorkDate());
                    end;
                }
                field("Exp. Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                    Editable = true;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        PurchPaySetup: Record "Purchases & Payables Setup";
                        AllowedExpiryFormula: DateFormula;
                        MinimumExpiryDate: Date;
                    begin
                        if Rec."Expiry Date" = 0D then
                            exit;

                        PurchPaySetup.Get();

                        if PurchPaySetup."Allowed Expiry Date" = '' then
                            exit;

                        if not Evaluate(
                            AllowedExpiryFormula,
                            PurchPaySetup."Allowed Expiry Date")
                        then
                            Error(
                                'Invalid Allowed Expiry Date formula %1 in Purchases & Payables Setup. Example: 90D.',
                                PurchPaySetup."Allowed Expiry Date");

                        // Replace "GRN Date" with your actual GRN Worksheet Date field
                        MinimumExpiryDate :=
                            CalcDate(AllowedExpiryFormula, Rec."GRN Date");

                        if Rec."Expiry Date" < MinimumExpiryDate then
                            Error(
                                'Expiry Date cannot be earlier than %1. Allowed expiry period is %2 from the GRN Date %3.',
                                MinimumExpiryDate,
                                PurchPaySetup."Allowed Expiry Date",
                                Rec."GRN Date");
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Qty. per Unit of Measure';
                }
                field("Indent Doc ID"; Rec."Indent Doc ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the indent number.';
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the indent line number.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SKU unit of measure (UOM).';
                }
                field("HSN Code"; Rec."HSN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN code.';
                }
                field("Indent SKU Qty"; Rec."Indent SKU Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested quantity from the indent.';
                }
                field("Item GST Nature"; Rec."Item GST Nature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST nature of the item.';
                }
                field("Supplier Batch No."; Rec."Supplier Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier batch number.';
                    ShowMandatory = true;
                }
                field("Line Gross"; Rec."Line Gross")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the gross amount for the line.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum retail price.';
                    ShowMandatory = true;
                }
                field("PO MRP"; Rec."PO MRP")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the maximum retail PO MRP.';
                }
                field(Scheme; Rec.Scheme)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the maximum retail Scheme.';
                }
                field(skuMrp; Rec."SKU MRP")
                {
                    ApplicationArea = All;
                    Caption = 'SKU MRP';
                    ToolTip = 'Specifies the SKU MRP.';
                }
                field(saleRate; Rec."Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Rate';
                    ToolTip = 'Specifies the sale rate.';
                }
                field(skuSaleRate; Rec."SKU Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'SKU Sale Rate';
                    ToolTip = 'Specifies the SKU sale rate.';
                }
                field(staffSaleRate; Rec."Staff Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Staff Sale Rate';
                    ToolTip = 'Specifies the staff sale rate.';
                }
                field(skuStaffSaleRate; Rec."SKU Staff Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'SKU Staff Sale Rate';
                    ToolTip = 'Specifies the SKU staff sale rate.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the line net amount.';
                }
                field("Landed SKU Value"; Rec."Landed SKU Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line landed SKU value.';
                }
                field("Landed SKU Rate"; Rec."Landed SKU Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line landed SKU rate.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line remark.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase rate.';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the item make.';
                }
                field(itemMakeCode; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Code';
                    Editable = false;
                    ToolTip = 'Specifies the item make code.';
                }
                field(gstTypeCode; Rec."GST Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'GST Type Code';
                    ToolTip = 'Specifies the GST type code.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount amount.';
                    Editable = false;
                }
                field("Line Discount Percentage"; Rec."Line Discount Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the line discount percentage.';
                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the taxable amount.';
                }
                field("GST group Code"; Rec."GST group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST group code.';
                }
                field("GST Jurisdiction Type"; Rec."GST Jurisdiction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST Jurisdiction Type.';
                }
                field("CGST %"; Rec."CGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST percentage.';
                }
                field("CGST Amount"; Rec."CGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST amount.';
                }
                field("SGST %"; Rec."SGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST percentage.';
                }
                field("SGST Amount"; Rec."SGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST amount.';
                }
                field("IGST %"; Rec."IGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST percentage.';
                }
                field("IGST Amount"; Rec."IGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST amount.';
                }
                field("Final Discount %"; Rec."Final Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount percentage.';
                }
                field("Final Discount Amount"; Rec."Final Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount amount.';
                }
                field("Rec SKU QTY"; Rec."Rec SKU QTY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the received SKU quantity.';
                }
                field("UGST %"; Rec."UGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the UGST percentage.';
                }
                field("UGST Amount"; Rec."UGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the UGST amount.';
                }
                field("GRN Date"; Rec."GRN Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GRN date.';
                }
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the challan number.';
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the challan date.';
                }
                field("Challan Qty"; Rec."Challan Qty")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the challan quantity.';
                }
                field("Accepted Qty"; Rec."Accepted Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the accepted quantity.';
                }
                field("Supplier State"; Rec."Supplier State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier state.';
                }
                field("V Prefix"; Rec."V Prefix")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher prefix.';
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type.';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Shortcut Dimension 1 Code.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Receive")
            {
                ApplicationArea = All;
                Caption = 'Receive';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GRNWorksheet: Record "E3 GRN Work Sheet";
                    PurchHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    SelectedGRNWorksheet: Record "E3 GRN Work Sheet";
                    POList: Record "Purchase Header";
                    LastReceiptNo: Code[20];
                    POListNo: Code[20];
                    PostedGRNHeader: Record "E3 GRN Work Sheet Header";
                begin
                    CurrPage.SetSelectionFilter(SelectedGRNWorksheet);

                    if SelectedGRNWorksheet.IsEmpty() then
                        Error('Please select at least one GRN Worksheet line.');

                    if SelectedGRNWorksheet.FindSet() then
                        repeat
                            if SelectedGRNWorksheet."Receipt Qty" > 0 then begin

                                if not PurchHeader.Get(
                                    PurchHeader."Document Type"::Order,
                                    SelectedGRNWorksheet."PO No.")
                                then
                                    Error(
                                        'Purchase Order %1 does not exist.',
                                        SelectedGRNWorksheet."PO No.");

                                if PurchHeader."Vendor Invoice No." = '' then
                                    Error('Vendor Invoice No. cannot be blank for Purchase Order %1.', PurchHeader."No.");

                                // PostedGRNHeader.Reset();
                                // PostedGRNHeader.SetRange("Purchase Challan No.", PurchHeader."Vendor Invoice No.");

                                // if PostedGRNHeader.FindFirst() then
                                //     Error(
                                //         'Purchase Challan No. %1 already exists in Posted GRN %2. Cannot receive this Purchase Order.',
                                //         PurchHeader."Vendor Invoice No.",
                                //         PostedGRNHeader."Document ID");
                                if not PurchLine.Get(PurchHeader."Document Type", PurchHeader."No.", SelectedGRNWorksheet."Orig. Line No.") then
                                    Error('Purchase Order Line %1 does not exist for PO %2.', SelectedGRNWorksheet."Orig. Line No.", PurchHeader."No.");
                                PurchLine."Qty. to Receive" := SelectedGRNWorksheet."Receipt Qty";
                                // PurchLine.Validate("Qty. to Receive", SelectedGRNWorksheet."Receipt Qty");
                                PurchLine.Validate("Qty. to Receive");
                                PurchLine.Modify(true);
                            end;

                        until SelectedGRNWorksheet.Next() = 0;

                    /*
                    Post Purchase Receipt
                    */
                    POList.Reset();
                    POList.SetRange("Document Type", POList."Document Type"::Order);

                    if SelectedGRNWorksheet.FindSet() then
                        repeat
                            if POListNo <> SelectedGRNWorksheet."PO No." then begin
                                POListNo := SelectedGRNWorksheet."PO No.";
                                if POList.Get(POList."Document Type"::Order, SelectedGRNWorksheet."PO No.")
                                then begin

                                    POList.Receive := true;
                                    POList.Invoice := false;

                                    Codeunit.Run(Codeunit::"Purch.-Post", POList);

                                end;
                            end;

                        until SelectedGRNWorksheet.Next() = 0;

                    CopyPostedReceiptToGRN(SelectedGRNWorksheet);
                    CurrPage.Update(false);

                    Message('Purchase Receipt posted successfully and GRN data has been created.');
                end;
            }
            action(Split)
            {
                Caption = 'Split';
                ApplicationArea = All;
                Image = Split;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Splits the selected GRN worksheet line into a new line.';

                trigger OnAction()
                var
                    SplitQtyPage: Page "E3 Split Qty";
                    SplitQty: Decimal;
                begin
                    // Open Split Quantity dialog
                    if SplitQtyPage.RunModal() <> Action::OK then
                        exit;

                    SplitQty := SplitQtyPage.GetSplitQty();

                    if SplitQty <= 0 then
                        exit;

                    // Split selected line
                    Rec.SplitGRNLine(Rec, SplitQty);

                    CurrPage.Update(false);
                end;
            }
            action("Assign Lot No.")
            {
                Caption = 'Assign Lot No.';
                Image = ItemTrackingLines;
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Assigns the Lot No. and Expiry Date from the GRN Work Sheet to the related Purchase Line item tracking.';

                trigger OnAction()
                begin
                    // Rec.AssignLotNoToPurchaseLine();
                    Rec.CreateItemTrackingForPurchLine();

                    Message(
                        'Lot No. %1 assigned successfully to Purchase Order %2, Line %3.',
                        Rec."Lot No.",
                        Rec."PO No.",
                        Rec."Line No.");
                end;
            }
            action("Assign Batch No.")
            {
                Caption = 'Assign Batch No.';
                Image = ItemTrackingLines;
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Assigns all Supplier Batch Nos., Lot Nos. and Expiry Dates from the GRN Work Sheet to the related Purchase Line item tracking.';

                trigger OnAction()
                var
                    SelectedGRNLine: Record "E3 GRN Work Sheet";
                    SelectedCount: Integer;
                    SkippedCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedGRNLine);

                    if SelectedGRNLine.FindSet() then
                        repeat
                            // Do not create Lot Information if Receipt Qty is 0
                            if SelectedGRNLine."Receipt Qty" = 0 then begin
                                SkippedCount += 1;
                                continue;
                            end;

                            SelectedGRNLine.CreateItemTrackingForPurchLine();
                            SelectedCount += 1;
                        until SelectedGRNLine.Next() = 0;

                    if SkippedCount > 0 then
                        Message(
                            '%1 GRN line(s) processed successfully.\%2 GRN line(s) skipped because Receipt Qty is 0.',
                            SelectedCount,
                            SkippedCount)
                    else
                        Message('%1 GRN line(s) processed successfully.', SelectedCount);
                end;
            }

        }
    }
    local procedure CopyPostedReceiptToGRN(var SelectedGRNWorksheet: Record "E3 GRN Work Sheet")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        GRNHeader: Record "E3 GRN Work Sheet Header";
        GRNLine: Record "E3 GRN Work Sheet Line";
        POHeader: Record "Purchase Header";
        GRNWorksheet: Record "E3 GRN Work Sheet";
        NewDocumentID: Code[20];
        LineNo: Integer;
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Location: Record Location;
    begin
        if SelectedGRNWorksheet.FindSet() then
            repeat
                if not POHeader.Get(
                    POHeader."Document Type"::Order, SelectedGRNWorksheet."PO No.")
                then
                    continue;

                PurchRcptHeader.Reset();
                PurchRcptHeader.SetRange("Order No.", SelectedGRNWorksheet."PO No.");
                if PurchRcptHeader.FindLast() then begin

                    NewDocumentID := PurchRcptHeader."No.";

                    // Check Purchase Challan already exists
                    // if POHeader."Vendor Invoice No." <> '' then begin
                    //     GRNHeader.Reset();
                    //     GRNHeader.SetRange("Purchase Challan No.", POHeader."Vendor Invoice No.");
                    //     if GRNHeader.FindFirst() then
                    //         Error('Purchase Challan No. %1 already exists in GRN %2. Cannot create duplicate GRN.',
                    //             POHeader."Vendor Invoice No.",
                    //             GRNHeader."Document ID");
                    // end;

                    // Create GRN Header
                    if not GRNHeader.Get(NewDocumentID) then begin
                        GRNHeader.Init();
                        GRNHeader."Document ID" := NewDocumentID;
                        GRNHeader."Voucher Date" := PurchRcptHeader."Posting Date";
                        GRNHeader."Supplier Code" := PurchRcptHeader."Buy-from Vendor No.";
                        GRNHeader."Purchase Challan No." := POHeader."Vendor Invoice No.";
                        GRNHeader."Department Code" := PurchRcptHeader."Location Code";
                        GRNHeader."Department Name" := PurchRcptHeader."Ship-to Name";
                        GRNHeader."Place of Supply" := PurchRcptHeader."Location State Code";
                        GRNHeader."Purchase Challan Date" := PurchRcptHeader."Document Date";
                        GRNHeader."Business Unit Code" := PurchRcptHeader."Shortcut Dimension 1 Code";
                        GeneralLedgerSetup.Get();

                        if GRNHeader."Business Unit Code" <> '' then begin
                            DimensionValue.Reset();
                            DimensionValue.SetRange("Dimension Code", GeneralLedgerSetup."Global Dimension 1 Code");
                            DimensionValue.SetRange(Code, GRNHeader."Business Unit Code");

                            if DimensionValue.FindFirst() then
                                GRNHeader."Business Unit Name" := DimensionValue.Name
                            else
                                GRNHeader."Business Unit Name" := '';
                        end else
                            GRNHeader."Business Unit Name" := '';

                        GRNHeader."Party Type" := Format(PurchRcptHeader."GST Vendor Type");
                        GRNHeader.GSTIN := PurchRcptHeader."Vendor GST Reg. No.";
                        GRNHeader."E-Way Bill No." := PurchRcptHeader."E-Way Bill No.";
                        GRNHeader."E-Way Bill Date" := PurchRcptHeader."Bill of Entry Date";
                        //GRNHeader."GST Location" := PurchRcptHeader."Location GST Reg. No.";
                        GRNHeader."RCM Applicable" := PurchRcptHeader."RCM Exempt";
                        GRNHeader."Legal Entity" := GRNHeader."Business Unit Name";
                        GRNHeader."Prepared By" := CopyStr(UserId(), 1, MaxStrLen(GRNHeader."Prepared By"));
                        GRNHeader."Prepared Date" := CurrentDateTime();
                        GRNHeader."Approved By" := CopyStr(UserId(), 1, MaxStrLen(GRNHeader."Approved By"));
                        GRNHeader."Approval Date Time" := CurrentDateTime();
                        GRNHeader.Status := 'Posted';
                        GRNHeader."Voucher Type" := SelectedGRNWorksheet."Voucher Type";
                        GRNHeader.Prefix := SelectedGRNWorksheet."V Prefix";
                        GRNHeader."GST Location" := Format(SelectedGRNWorksheet."GST Jurisdiction Type");
                        GRNHeader."OH Final Discount %" := SelectedGRNWorksheet."Final Discount %";
                        GRNHeader."OH Final Discount Amount" := SelectedGRNWorksheet."Final Discount Amount";
                        GRNHeader.Insert(true);
                    end;

                    // Find posted receipt lines
                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
                    if PurchRcptLine.FindSet() then begin

                        LineNo := 10000;

                        repeat
                            if PurchRcptLine.Type = PurchRcptLine.Type::Item then begin
                                Clear(GRNWorksheet);

                                if not GRNWorksheet.Get(SelectedGRNWorksheet."PO No.", PurchRcptLine."Order Line No.")
                                then begin
                                    LineNo += 10000;
                                    continue;
                                end;

                                //Prevent duplicate GRN lines

                                GRNLine.Reset();
                                GRNLine.SetRange("Document ID", NewDocumentID);
                                GRNLine.SetRange("Line No.", LineNo);

                                if not GRNLine.FindFirst() then begin

                                    GRNLine.Init();
                                    GRNLine."Document ID" := NewDocumentID;
                                    GRNLine."Line No." := LineNo;
                                    GRNLine."Indent Document ID" := PurchRcptLine."Indent No.";
                                    GRNLine."Indent Line No." := PurchRcptLine."Indent Line No.";
                                    GRNLine."Item Code" := PurchRcptLine."No.";
                                    GRNLine."Item Name" := PurchRcptLine.Description;
                                    GRNLine."Department Code" := PurchRcptLine."Location Code";
                                    if Location.Get(PurchRcptLine."Location Code") then
                                        GRNLine."Department Name" := Location.Name
                                    else
                                        GRNLine."Department Name" := '';
                                    GRNLine."Unit Code" := PurchRcptLine."Unit of Measure Code";
                                    GRNLine."Received SKU Qty" := PurchRcptLine.Quantity;
                                    GRNLine."Indent SKU Qty" := GRNWorksheet."Indent SKU Qty";
                                    GRNLine."Received SKU Qty" := GRNWorksheet."Rec SKU QTY";
                                    GRNLine.Rate := GRNWorksheet.Rate;
                                    GRNLine."Gross Amount" := GRNWorksheet."Line Gross";
                                    GRNLine."Discount Amount" := GRNWorksheet."Line Discount Amount";
                                    GRNLine."Discount %" := GRNWorksheet."Line Discount Percentage";
                                    GRNLine."Taxable Amount" := GRNWorksheet."Taxable Amount";
                                    GRNLine."CGST %" := GRNWorksheet."CGST %";
                                    GRNLine."CGST Amount" := GRNWorksheet."CGST Amount";
                                    GRNLine."SGST %" := GRNWorksheet."SGST %";
                                    GRNLine."SGST Amount" := GRNWorksheet."SGST Amount";
                                    GRNLine."IGST %" := GRNWorksheet."IGST %";
                                    GRNLine."IGST Amount" := GRNWorksheet."IGST Amount";
                                    GRNLine."UGST %" := GRNWorksheet."UGST %";
                                    GRNLine."UGST Amount" := GRNWorksheet."UGST Amount";
                                    GRNLine."Final Discount %" := GRNWorksheet."Final Discount %";
                                    GRNLine."Final Discount Amount" := GRNWorksheet."Final Discount Amount";
                                    GRNLine."Net Amount" := GRNWorksheet."OH Amt Net";
                                    GRNLine."Landed SKU Value" := GRNWorksheet."Landed SKU Value";
                                    GRNLine."Landed SKU Rate" := GRNWorksheet."Landed SKU Rate";
                                    GRNLine.Remark := GRNWorksheet.Remark;
                                    GRNLine.MRP := GRNWorksheet.MRP;
                                    GRNLine."SKU MRP" := GRNWorksheet."SKU MRP";
                                    GRNLine."Sale Rate" := GRNWorksheet."Sale Rate";
                                    GRNLine."SKU Sale Rate" := GRNWorksheet."SKU Sale Rate";
                                    GRNLine."Staff Sale Rate" := GRNWorksheet."Staff Sale Rate";
                                    GRNLine."SKU Staff Sale Rate" := GRNWorksheet."SKU Staff Sale Rate";
                                    GRNLine.Barcode := GRNWorksheet."Supplier Batch No.";
                                    GRNLine."Batch No." := GRNWorksheet."Supplier Batch No.";
                                    GRNLine."Manufacturing Date" := GRNWorksheet."Manufacturing Date";
                                    GRNLine."Expiry Date" := GRNWorksheet."Expiry Date";
                                    GRNLine."Item Make Code" := GRNWorksheet."Item Make Code";
                                    GRNLine."GST Type Code" := GRNWorksheet."GST Type Code";
                                    GRNLine."Item GST Nature" := Format(GRNWorksheet."Item GST Nature");
                                    GRNLine."HSN Code" := GRNWorksheet."HSN Code";

                                    GRNLine.Status := 'Posted';

                                    GRNLine.Insert(true);
                                end;

                                LineNo += 10000;
                            end;

                        until PurchRcptLine.Next() = 0;
                    end;
                end;

                UpdateGRNHeaderAmounts(NewDocumentID);

            until SelectedGRNWorksheet.Next() = 0;
    end;

    local procedure UpdateGRNHeaderAmounts(DocumentID: Code[20])
    var
        GRNHeader: Record "E3 GRN Work Sheet Header";
        GRNLine: Record "E3 GRN Work Sheet Line";
    begin
        if not GRNHeader.Get(DocumentID) then
            exit;

        // Reset Header Amounts
        GRNHeader."OH Amount Gross" := 0;
        GRNHeader."OH Amount Discount" := 0;
        GRNHeader."OH Amount Taxable" := 0;
        GRNHeader."OH Amount CGST" := 0;
        GRNHeader."OH Amount SGST" := 0;
        GRNHeader."OH Amount IGST" := 0;
        GRNHeader."OH Amount UGST" := 0;
        GRNHeader."OH Amount Total" := 0;
        GRNHeader."OH Final Discount Amount" := 0;
        GRNHeader."OH Net Amount" := 0;
        GRNHeader."OH Landed Value" := 0;

        GRNLine.Reset();
        GRNLine.SetRange("Document ID", DocumentID);
        GRNLine.SetFilter("Received SKU Qty", '>%1', 0);

        if GRNLine.FindSet() then
            repeat
                GRNHeader."OH Amount Gross" += GRNLine."Gross Amount";
                GRNHeader."OH Amount Discount" += GRNLine."Discount Amount";
                GRNHeader."OH Amount Taxable" += GRNLine."Taxable Amount";
                GRNHeader."OH Amount CGST" += GRNLine."CGST Amount";
                GRNHeader."OH Amount SGST" += GRNLine."SGST Amount";
                GRNHeader."OH Amount IGST" += GRNLine."IGST Amount";
                GRNHeader."OH Amount UGST" += GRNLine."UGST Amount";
                GRNHeader."OH Final Discount Amount" += GRNLine."Final Discount Amount";
                GRNHeader."OH Amount Total" += GRNLine."Taxable Amount" + GRNLine."CGST Amount" + GRNLine."SGST Amount" + GRNLine."IGST Amount" + GRNLine."UGST Amount";
                GRNHeader."OH Net Amount" += GRNLine."Net Amount";
                GRNHeader."OH Landed Value" += GRNLine."Landed SKU Value";

            until GRNLine.Next() = 0;

        GRNHeader.Modify(true);
    end;
}