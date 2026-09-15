codeunit 50054 "E3 Create PO Management"
{
    procedure CreatePurchaseOrderFromSalesInvoice(SalesInvHeader: Record "Sales Invoice Header")
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesInvLine: Record "Sales Invoice Line";
        NextLineNo: Integer;
        GRNWorkSheet: Record "E3 GRN Work Sheet";
        voucherType: Record "E3 Voucher Type";
    begin
        // Verify invoice has lines before proceeding
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::" ");
        if SalesInvLine.IsEmpty() then
            Error('Sales Invoice %1 contains no valid lines to process.', SalesInvHeader."No.");

        voucherType.Reset();
        voucherType.SetRange(Code, SalesInvHeader."Voucher Type");
        if voucherType.FindFirst() then;

        // 1. Create Purchase Header
        PurchHeader.Init();
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader."Voucher Type" := SalesInvHeader."Voucher Type";
        PurchHeader.Insert(true); // Generates No. from No. Series

        // Update Header details (Set your designated Vendor No.)
        // PurchHeader.Validate("Buy-from Vendor No.", 'VENDOR_CODE_HERE');
        PurchHeader.Validate("Posting Date", SalesInvHeader."Posting Date");
        PurchHeader.Validate("Document Date", SalesInvHeader."Document Date");
        PurchHeader.Validate("Vendor Invoice No.", SalesInvHeader."No.");
        PurchHeader.validate("Buy-from Vendor No.", voucherType."Vendor No.");
        PurchHeader.Modify(true);

        // 2. Loop Sales Invoice Lines and Create Purchase Lines
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
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

                PurchLine.Validate("Location Code", SalesInvLine."Location Code");
                PurchLine.validate("Batch No.", SalesInvLine."Batch No.");
                PurchLine.validate("Expiry Date", SalesInvLine."Expiry Date");
                PurchLine.validate(MRP, SalesInvLine.MRP);
                PurchLine.Validate(Quantity, SalesInvLine.Quantity);
                PurchLine.Validate("Direct Unit Cost", SalesInvLine."Unit Cost");
                PurchLine.Modify(true);
            until SalesInvLine.Next() = 0;

        // Check existing GRN Worksheet
        GRNWorkSheet.Reset();
        GRNWorkSheet.SetRange("PO No.", PurchHeader."No.");

        if GRNWorkSheet.IsEmpty() then begin
            // Create GRN Worksheet only first time
            GRNWorkSheet.InitFromPurchaseLine(PurchLine."Document No.");
        end;


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