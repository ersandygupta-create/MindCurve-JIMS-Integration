codeunit 50058 "E3 GRN Invoice Management"
{
    Permissions = tabledata "Purch. Rcpt. Line" = m,
                  tabledata "Purch. Rcpt. Header" = m;

    /// <summary>
    /// Batch process to create 1 Purchase Invoice for EACH uninvoiced GRN.
    /// </summary>
    procedure BatchCreateInvoicesFromReceipts()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        InvoiceCount: Integer;
        CreatedInvoicesText: Text;
    begin
        // 1. Filter uninvoiced GRN headers
        PurchRcptHeader.Reset();
        PurchRcptHeader.SetRange("Purchase Invoice Created", false);
        if not PurchRcptHeader.FindSet() then begin
            Message('No uninvoiced receipt headers found.');
            exit;
        end;

        // 2. Loop through each GRN header individually
        repeat
            // Check if this GRN has valid, uninvoiced lines
            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
            PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" ");
            PurchRcptLine.SetFilter("Purchase Inv Created", '%1', false);

            if PurchRcptLine.FindSet() then begin
                // Create exactly 1 Purchase Invoice per GRN Header
                if CreateInvoiceForSingleGRN(PurchRcptHeader, PurchHeader) then begin
                    InvoiceCount += 1;

                    if CreatedInvoicesText <> '' then
                        CreatedInvoicesText += '\';
                    CreatedInvoicesText += StrSubstNo('- Inv: %1 (GRN: %2, Vendor: %3)', PurchHeader."No.", PurchRcptHeader."No.", PurchRcptHeader."Buy-from Vendor No.");
                end;
            end;
        until PurchRcptHeader.Next() = 0;

        // 3. Display summary message
        if InvoiceCount > 0 then
            Message('%1 Purchase Invoice(s) created successfully:\%2', InvoiceCount, CreatedInvoicesText)
        else
            Message('No Purchase Invoices were created.');
    end;

    /// <summary>
    /// Creates 1 Purchase Invoice for each selected GRN Header from the UI/Page.
    /// </summary>
    procedure CreateInvoicesFromSelectedReceipts(var SelectedPurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        InvoiceCount: Integer;
        CreatedInvoicesText: Text;
    begin
        if not SelectedPurchRcptHeader.FindSet() then
            exit;

        repeat
            // Verify receipt contains uninvoiced lines
            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Document No.", SelectedPurchRcptHeader."No.");
            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
            PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" ");
            PurchRcptLine.SetFilter("Purchase Inv Created", '%1', false);

            if PurchRcptLine.FindSet() then begin
                if CreateInvoiceForSingleGRN(SelectedPurchRcptHeader, PurchHeader) then begin
                    InvoiceCount += 1;

                    if CreatedInvoicesText <> '' then
                        CreatedInvoicesText += '\';
                    CreatedInvoicesText += StrSubstNo('- Inv: %1 (GRN: %2, Vendor: %3)', PurchHeader."No.", SelectedPurchRcptHeader."No.", SelectedPurchRcptHeader."Buy-from Vendor No.");
                end;
            end;
        until SelectedPurchRcptHeader.Next() = 0;

        if InvoiceCount > 0 then
            Message('%1 Purchase Invoice(s) created successfully from selected receipts:\%2', InvoiceCount, CreatedInvoicesText)
        else
            Message('No Purchase Invoices were created for selected receipts.');
    end;

    local procedure CreateInvoiceForSingleGRN(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchHeader: Record "Purchase Header"): Boolean
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        PurchGetReceipt: Codeunit "Purch.-Get Receipt";
    begin
        // Step 1: Create Purchase Invoice Header for this specific GRN
        Clear(PurchHeader);
        PurchHeader.Init();
        PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
        if PurchRcptHeader."Voucher Type" <> '' then
            PurchHeader.Validate("Voucher Type", PurchRcptHeader."Voucher Type");
        PurchHeader.Insert(true); // Generates No. from No. Series

        PurchHeader.Validate("Buy-from Vendor No.", PurchRcptHeader."Buy-from Vendor No.");
        PurchHeader."Vendor Invoice No." := PurchRcptHeader."Vendor Invoice No.";
        PurchHeader."Purchase Narration" := PurchRcptHeader."Purchase Narration";
        PurchHeader."Receipt No." := PurchRcptHeader."No.";
        PurchHeader."Receipt Date" := PurchRcptHeader."Posting Date";
        PurchHeader."Due Date" := PurchRcptHeader."Due Date";
        PurchHeader.Validate("Pay-to Vendor No.", PurchRcptHeader."Pay-to Vendor No.");
        PurchHeader."Order Date" := PurchRcptHeader."Order Date";
        if PurchRcptHeader."Location Code" <> '' then
            PurchHeader.Validate("Location Code", PurchRcptHeader."Location Code");
        PurchHeader.Validate("Posting Date", PurchRcptHeader."Posting Date");
        PurchHeader.Validate("Document Date", PurchRcptHeader."Document Date");
        PurchHeader.Validate("Currency Code", PurchRcptHeader."Currency Code");
        PurchHeader.Modify(true);

        // Step 2: Collect valid lines for this single GRN into temporary buffer
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
        PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" ");
        PurchRcptLine.SetFilter("Purchase Inv Created", '%1', false);

        if PurchRcptLine.FindSet() then begin
            repeat
                TempPurchRcptLine := PurchRcptLine;
                if TempPurchRcptLine.Insert() then;
            until PurchRcptLine.Next() = 0;

            // Step 3: Attach lines using Standard Codeunit 74
            PurchGetReceipt.SetPurchHeader(PurchHeader);
            PurchGetReceipt.CreateInvLines(TempPurchRcptLine);

            // Step 4: Mark original lines as invoiced
            if TempPurchRcptLine.FindSet() then begin
                repeat
                    if PurchRcptLine.Get(TempPurchRcptLine."Document No.", TempPurchRcptLine."Line No.") then begin
                        PurchRcptLine."Purchase Inv Created" := true;
                        PurchRcptLine.Modify();
                    end;
                until TempPurchRcptLine.Next() = 0;
            end;

            // Step 5: Mark Receipt Header as invoiced
            PurchRcptHeader."Purchase Invoice Created" := true;
            PurchRcptHeader."Purchase Invoice No" := PurchHeader."No.";
            PurchRcptHeader.Modify();

            exit(true);
        end;

        exit(false);
    end;
}