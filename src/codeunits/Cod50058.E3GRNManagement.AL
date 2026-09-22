codeunit 50058 "E3 GRN Invoice Management"
{
    Permissions = tabledata "Purch. Rcpt. Line" = m,
                  tabledata "Purch. Rcpt. Header" = m;

    procedure BatchCreateInvoicesFromReceipts()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        GroupList: List of [Text];
        KeyParts: List of [Text];
        GroupKey: Text;
        VendorNo: Code[20];
        LocationCode: Code[10];
        VoucherType: Code[20];
        InvoiceCount: Integer;
        CreatedInvoicesText: Text;
    begin
        // 1. Filter all uninvoiced GRN lines with a Location Code
        PurchRcptLine.Reset();
        PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
        PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" "); // Exclude comment/blank lines
        PurchRcptLine.SetFilter("Location Code", '<>%1', '');
        PurchRcptLine.SetFilter("Purchase Inv Created", '%1', false);

        if not PurchRcptLine.FindSet() then begin
            Message('No uninvoiced receipt lines found.');
            exit;
        end;

        // 2. Collect unique (Vendor No. + Location Code + Header Voucher Type) combinations
        repeat
            VoucherType := '';
            if PurchRcptHeader.Get(PurchRcptLine."Document No.") then
                VoucherType := PurchRcptHeader."Voucher Type";

            GroupKey := StrSubstNo('%1|%2|%3', PurchRcptLine."Pay-to Vendor No.", PurchRcptLine."Location Code", VoucherType);
            if not GroupList.Contains(GroupKey) then
                GroupList.Add(GroupKey);
        until PurchRcptLine.Next() = 0;

        // 3. Loop through each combination and create 1 Purchase Invoice
        foreach GroupKey in GroupList do begin

            // Step 3A: Extract Vendor No., Location Code, and Voucher Type from Group Key
            KeyParts := GroupKey.Split('|');
            VendorNo := CopyStr(KeyParts.Get(1), 1, MaxStrLen(VendorNo));
            LocationCode := CopyStr(KeyParts.Get(2), 1, MaxStrLen(LocationCode));
            VoucherType := CopyStr(KeyParts.Get(3), 1, MaxStrLen(VoucherType));

            // Step 3B: Create Purchase Invoice Header
            Clear(PurchHeader);
            PurchHeader.Init();
            PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
            if VoucherType <> '' then
                PurchHeader.Validate("Voucher Type", VoucherType);
            PurchHeader.Insert(true); // Generates Document No. from No. Series

            PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
            PurchHeader.Validate("Pay-to Vendor No.", VendorNo);
            if LocationCode <> '' then
                PurchHeader.Validate("Location Code", LocationCode);
            PurchHeader.Validate("Posting Date", WorkDate());
            PurchHeader.Validate("Document Date", WorkDate());
            PurchHeader.Modify(true);

            // Step 3C: Filter GRN lines for this specific Vendor and Location Code
            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Pay-to Vendor No.", VendorNo);
            PurchRcptLine.SetRange("Location Code", LocationCode);
            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
            PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" ");

            if PurchRcptLine.FindSet() then begin
                // Step 3D: Call Custom Procedure to create Purchase Lines matching this Voucher Type
                CreateInvoiceLinesCustom(PurchHeader, PurchRcptLine, VoucherType);

                InvoiceCount += 1;

                // Build summary text
                if CreatedInvoicesText <> '' then
                    CreatedInvoicesText += '\';
                CreatedInvoicesText += StrSubstNo('- %1 (Vendor: %2, Location: %3, Voucher Type: %4)', PurchHeader."No.", VendorNo, LocationCode, VoucherType);
            end;
        end;

        // 4. Display summary message with list of created invoices
        if InvoiceCount > 0 then
            Message('%1 Purchase Invoice(s) created successfully:\%2', InvoiceCount, CreatedInvoicesText)
        else
            Message('No Purchase Invoices were created.');
    end;

    procedure CreateInvoicesFromSelectedReceipts(var SelectedPurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        GroupList: List of [Text];
        KeyParts: List of [Text];
        GroupKey: Text;
        VendorNo: Code[20];
        LocationCode: Code[10];
        VoucherType: Code[20];
        InvoiceCount: Integer;
        CreatedInvoicesText: Text;
    begin
        if not SelectedPurchRcptHeader.FindSet() then
            exit;

        // 1. Loop through selected receipt headers to build line filters and unique group keys
        repeat
            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Document No.", SelectedPurchRcptHeader."No.");
            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
            PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" ");
            PurchRcptLine.SetFilter("Purchase Inv Created", '%1', false);

            if PurchRcptLine.FindSet() then begin
                repeat
                    VoucherType := SelectedPurchRcptHeader."Voucher Type";
                    GroupKey := StrSubstNo('%1|%2|%3', PurchRcptLine."Pay-to Vendor No.", PurchRcptLine."Location Code", VoucherType);
                    if not GroupList.Contains(GroupKey) then
                        GroupList.Add(GroupKey);
                until PurchRcptLine.Next() = 0;
            end;
        until SelectedPurchRcptHeader.Next() = 0;

        if GroupList.Count = 0 then begin
            Message('No uninvoiced lines found in the selected receipt(s).');
            exit;
        end;

        // 2. Loop through each combination and create Purchase Invoices for selected receipts
        foreach GroupKey in GroupList do begin
            KeyParts := GroupKey.Split('|');
            VendorNo := CopyStr(KeyParts.Get(1), 1, MaxStrLen(VendorNo));
            LocationCode := CopyStr(KeyParts.Get(2), 1, MaxStrLen(LocationCode));
            VoucherType := CopyStr(KeyParts.Get(3), 1, MaxStrLen(VoucherType));

            Clear(PurchHeader);
            PurchHeader.Init();
            PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
            if VoucherType <> '' then
                PurchHeader.Validate("Voucher Type", VoucherType);
            PurchHeader.Insert(true);

            PurchHeader.Validate("Buy-from Vendor No.", VendorNo);
            PurchHeader.Validate("Pay-to Vendor No.", VendorNo);
            if LocationCode <> '' then
                PurchHeader.Validate("Location Code", LocationCode);
            PurchHeader.Validate("Posting Date", WorkDate());
            PurchHeader.Validate("Document Date", WorkDate());
            PurchHeader.Modify(true);

            // Filter lines belonging strictly to the user-selected receipt headers
            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Pay-to Vendor No.", VendorNo);
            PurchRcptLine.SetRange("Location Code", LocationCode);
            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '>0');
            PurchRcptLine.SetFilter(Type, '<>%1', PurchRcptLine.Type::" ");
            PurchRcptLine.SetFilter("Purchase Inv Created", '%1', false);

            // Apply key filter using Selected Receipt Headers
            SelectedPurchRcptHeader.FindSet();
            PurchRcptLine.SetFilter("Document No.", GetHeaderFilterString(SelectedPurchRcptHeader));

            if PurchRcptLine.FindSet() then begin
                CreateInvoiceLinesCustom(PurchHeader, PurchRcptLine, VoucherType);
                InvoiceCount += 1;

                if CreatedInvoicesText <> '' then
                    CreatedInvoicesText += '\';
                CreatedInvoicesText += StrSubstNo('- %1 (Vendor: %2, Location: %3, Voucher Type: %4)', PurchHeader."No.", VendorNo, LocationCode, VoucherType);
            end;
        end;

        if InvoiceCount > 0 then
            Message('%1 Purchase Invoice(s) created successfully from selected receipts:\%2', InvoiceCount, CreatedInvoicesText)
        else
            Message('No Purchase Invoices were created.');
    end;

    local procedure GetHeaderFilterString(var SelectedPurchRcptHeader: Record "Purch. Rcpt. Header"): Text
    var
        FilterStr: Text;
    begin
        repeat
            if FilterStr <> '' then
                FilterStr += '|';
            FilterStr += SelectedPurchRcptHeader."No.";
        until SelectedPurchRcptHeader.Next() = 0;
        exit(FilterStr);
    end;

    local procedure CreateInvoiceLinesCustom(var PurchHeader: Record "Purchase Header"; var PurchRcptLine: Record "Purch. Rcpt. Line"; TargetVoucherType: Code[20])
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchLine: Record "Purchase Line";
        NextLineNo: Integer;
        LineVoucherType: Code[20];
    begin
        // Get starting Line No. for the Invoice
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then
            NextLineNo := PurchLine."Line No." + 10000
        else
            NextLineNo := 10000;

        // Loop through all filtered GRN lines
        repeat
            LineVoucherType := '';
            if PurchRcptHeader.Get(PurchRcptLine."Document No.") then
                LineVoucherType := PurchRcptHeader."Voucher Type";

            // Only insert line if original GRN header's Voucher Type matches target invoice group
            if LineVoucherType = TargetVoucherType then begin
                Clear(PurchLine);
                PurchLine.Init();
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := NextLineNo;
                PurchLine.Insert(true); // Insert first so field triggers execute reliably

                // Set Line Type and Item/GL Account No.
                PurchLine.Validate(Type, PurchRcptLine.Type);
                if PurchRcptLine."No." <> '' then
                    PurchLine.Validate("No.", PurchRcptLine."No.");

                // Set Variant, Location, and Unit of Measure
                if PurchRcptLine."Variant Code" <> '' then
                    PurchLine.Validate("Variant Code", PurchRcptLine."Variant Code");

                if PurchRcptLine."Location Code" <> '' then
                    PurchLine.Validate("Location Code", PurchRcptLine."Location Code");

                if PurchRcptLine."Unit of Measure Code" <> '' then
                    PurchLine.Validate("Unit of Measure Code", PurchRcptLine."Unit of Measure Code");

                // Set Quantity to remaining uninvoiced quantity
                PurchLine.Validate(Quantity, PurchRcptLine."Qty. Rcd. Not Invoiced");

                // Set Direct Unit Cost from GRN line if available
                if PurchRcptLine."Direct Unit Cost" <> 0 then
                    PurchLine.Validate("Direct Unit Cost", PurchRcptLine."Direct Unit Cost");

                // Preserve Descriptions
                PurchLine.Description := PurchRcptLine.Description;
                PurchLine."Description 2" := PurchRcptLine."Description 2";

                // Link back to original Receipt Line
                PurchLine."Receipt No." := PurchRcptLine."Document No.";
                PurchLine."Receipt Line No." := PurchRcptLine."Line No.";
                PurchLine."Purch Rcpt No." := PurchRcptLine."Document No.";
                PurchLine."Purch Rcpt Line No." := PurchRcptLine."Line No.";

                // Pass Dimensions
                PurchLine."Shortcut Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
                PurchLine."Shortcut Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
                PurchRcptLine."Purchase Inv Created" := true;
                PurchRcptHeader."Purchase Invoice Created" := true;
                PurchRcptHeader."Purchase Invoice No" := PurchLine."Document No.";
                PurchRcptHeader.Modify();
                PurchRcptLine.Modify();
                PurchLine.Modify(true);

                // Increment line number for next iteration
                NextLineNo += 10000;
            end;
        until PurchRcptLine.Next() = 0;
    end;
}