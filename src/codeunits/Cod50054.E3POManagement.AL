codeunit 50054 "E3 Create PO Management"
{
    Permissions = tabledata "Sales Invoice Header" = rm;
    procedure CreatePurchaseOrderFromSalesInvoice(SalesInvHeader: Record "Sales Invoice Header")
    var
        Context: Codeunit "E3 PO Creation Context";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesInvLine: Record "Sales Invoice Line";
        NextLineNo: Integer;
        GRNWorkSheet: Record "E3 GRN Work Sheet";
        voucherType: Record "E3 Voucher Type";
        voucherTypeResp: Record "E3 Voucher Type";
    begin
        // Enable the bypass flag specifically for this execution
        Context.SetBypass(true);

        // Run creation process
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::" ");
        if SalesInvLine.IsEmpty() then begin
            Context.SetBypass(false); // Reset before error
            Error('Sales Invoice %1 contains no valid lines to process.', SalesInvHeader."No.");
        end;
        voucherType.Reset();
        voucherType.SetRange(Code, SalesInvHeader."Voucher Type");
        if voucherType.FindFirst() then;

        voucherTypeResp.Reset();
        voucherTypeResp.SetRange(Code, voucherType."Order Voucher Code");
        if voucherTypeResp.FindFirst() then;

        PurchHeader.Init();
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader.Validate("Voucher Type", voucherType."Order Voucher Code");
        if voucherTypeResp."Responsibility Center" <> '' then
            PurchHeader."Responsibility Center" := voucherTypeResp."Responsibility Center";

        PurchHeader.Insert(true); // Validation check runs here, but is bypassed by Context flag


        PurchHeader.Validate("Posting Date", SalesInvHeader."Posting Date");
        PurchHeader.Validate("Document Date", SalesInvHeader."Document Date");
        PurchHeader.Validate("Vendor Invoice No.", SalesInvHeader."No.");
        PurchHeader.Validate("Buy-from Vendor No.", voucherType."Vendor No.");
        PurchHeader.Modify(true);
        // 3. Loop Sales Invoice Lines and Create Purchase Lines
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.type::"G/L Account");
        if SalesInvLine.FindSet() then
            repeat
                NextLineNo += 10000;

                PurchLine.Init();
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := NextLineNo;
                PurchLine.Insert(true);

                // Map standard fields from Sales Invoice Line
                PurchLine.Validate(Type, ConvertSalesTypeToPurchType(SalesInvLine.Type));
                PurchLine.Validate("No.", SalesInvLine."No.");
                if SalesInvLine."Variant Code" <> '' then
                    PurchLine.Validate("Variant Code", SalesInvLine."Variant Code");

                PurchLine.Validate("Location Code", PurchHeader."Location Code");
                PurchLine.Validate("Batch No.", SalesInvLine."Batch No.");
                PurchLine.Validate("Expiry Date", SalesInvLine."Expiry Date");
                PurchLine.Validate(MRP, SalesInvLine.MRP);
                PurchLine.Validate(Quantity, SalesInvLine.Quantity);
                PurchLine.Validate("Direct Unit Cost", SalesInvLine."Unit Price");
                purchline.validate("Line Discount %", SalesInvLine."Line Discount %");
                PurchLine."Indent Line Remarks" := 'Inter-Unit Purchase Order.';
                PurchLine.Modify(true);
            until SalesInvLine.Next() = 0;

        // Check existing GRN Worksheet
        GRNWorkSheet.Reset();
        GRNWorkSheet.SetRange("PO No.", PurchHeader."No.");

        if GRNWorkSheet.IsEmpty() then begin
            GRNWorkSheet.InitFromSalesInvoiceLine(PurchLine."Document No.");
        end;
        SalesInvHeader."Purchase Order No." := PurchHeader."No.";
        SalesInvHeader."Purchase order Created" := true;
        SalesInvHeader.Modify();

        Message('Purchase Order %1 has been successfully created.', PurchHeader."No.");
    end;

    local procedure ConvertSalesTypeToPurchType(SalesType: Enum "Sales Line Type"): Enum "Purchase Line Type"
    begin
        case SalesType of
            SalesType::Item:
                exit("Purchase Line Type"::Item);
            SalesType::"G/L Account":
                exit("Purchase Line Type"::"G/L Account");
            SalesType::Resource:
                exit("Purchase Line Type"::Resource);
            SalesType::"Fixed Asset":
                exit("Purchase Line Type"::"Fixed Asset");
            else
                exit("Purchase Line Type"::" ");
        end;
    end;
}