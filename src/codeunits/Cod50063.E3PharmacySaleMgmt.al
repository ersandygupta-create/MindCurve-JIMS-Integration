
codeunit 50063 "E3 Pharmacy Sales Posting"
{
    Permissions =
        tabledata "E3 Pharmacy Sale Header" = rm,
        tabledata "E3 Pharmacy Sale Lines" = r,
        tabledata "E3 Pharmacy Sale Setup" = r,
        tabledata "Sales Header" = rimd,
        tabledata "Sales Line" = rimd,
        tabledata "Sales Invoice Header" = r,
        tabledata "Reservation Entry" = rimd;

    trigger OnRun()
    begin
        ProcessPendingSalesInvoices();
    end;

    procedure ProcessPendingSalesInvoices()
    var
        PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
        IntegrationSetup: Record "E3 HIS Integartion Setup";
    begin
        // Get Integration Setup.
        if not IntegrationSetup.FindFirst() then
            Error('E3 HIS Integration Setup not found.');

        // Process only when Auto Pharmacy Posting is enabled.
        if not IntegrationSetup."Auto Pharmacy Posting Enabled" then
            exit;

        PharmacySaleHeader.Reset();
        PharmacySaleHeader.SetRange("Is Created", false);

        if PharmacySaleHeader.FindSet() then
            repeat
                if PharmacySaleHeader."Document Number" <> '' then
                    ProcessPharmacySaleDocument(
                        PharmacySaleHeader."Entry Type",
                        PharmacySaleHeader."Document Type",
                        PharmacySaleHeader."Document Number");
            until PharmacySaleHeader.Next() = 0;
    end;

    local procedure ProcessPharmacySaleDocument(
        EntryType: Option;
        DocumentType: Text[50];
        DocumentNo: Code[20])
    var
        PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ErrorDescription: Text;
    begin
        // Lock and re-read the source header to avoid
        // two Job Queue sessions processing the same document.
        PharmacySaleHeader.LockTable();

        PharmacySaleHeader.Reset();
        PharmacySaleHeader.SetRange("Entry Type", EntryType);
        PharmacySaleHeader.SetRange("Document Type", DocumentType);
        PharmacySaleHeader.SetRange("Document Number", DocumentNo);

        if not PharmacySaleHeader.FindFirst() then
            exit;

        // Never process a completed document.
        if PharmacySaleHeader."Is Created" then
            exit;

        // FIRST CHECK: Has the invoice already been posted?
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", DocumentNo);

        if SalesInvoiceHeader.FindFirst() then begin
            // Invoice is already posted.
            // Update source status and do not post again.
            PharmacySaleHeader."Is Created" := true;
            PharmacySaleHeader."Error Description" := '';
            PharmacySaleHeader.Modify(true);
            exit;
        end;

        // Check whether an unposted invoice already exists.
        // Do not create a duplicate or delete an existing invoice.
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", DocumentNo);

        if SalesHeader.FindFirst() then begin
            UpdatePharmacySaleError(
                EntryType,
                DocumentType,
                DocumentNo,
                StrSubstNo(
                    'Unposted Sales Invoice %1 already exists. Please verify or remove the existing invoice before retrying.',
                    DocumentNo));
            exit;
        end;

        // Clear previous error before retry.
        if PharmacySaleHeader."Error Description" <> '' then begin
            PharmacySaleHeader."Error Description" := '';
            PharmacySaleHeader.Modify(true);
        end;

        ClearLastError();

        // Create and post invoice.
        if TryProcessSalesInvoice(
            EntryType,
            DocumentType,
            DocumentNo)
        then begin
            // Confirm that invoice is actually posted.
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", DocumentNo);

            if SalesInvoiceHeader.FindFirst() then
                UpdatePharmacySaleStatus(
                    EntryType,
                    DocumentType,
                    DocumentNo,
                    true,
                    '')
            else begin
                // Posting did not produce a posted invoice.
                CleanupIncompleteSalesInvoice(DocumentNo);

                UpdatePharmacySaleError(
                    EntryType,
                    DocumentType,
                    DocumentNo,
                    'Sales Invoice posting could not be verified.');
            end;

        end else begin
            ErrorDescription := GetLastErrorText();

            // Check again because posting may have completed
            // even if a later operation raised an error.
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", DocumentNo);

            if SalesInvoiceHeader.FindFirst() then begin
                // Already posted. Never retry posting.
                UpdatePharmacySaleStatus(
                    EntryType,
                    DocumentType,
                    DocumentNo,
                    true,
                    '');
            end else begin
                // Remove only the incomplete invoice created
                // by this processing attempt.
                CleanupIncompleteSalesInvoice(DocumentNo);

                // Keep Is Created = FALSE and save error.
                UpdatePharmacySaleError(
                    EntryType,
                    DocumentType,
                    DocumentNo,
                    ErrorDescription);
            end;
        end;
    end;

    [TryFunction]
    local procedure TryProcessSalesInvoice(
        EntryType: Option;
        DocumentType: Text[50];
        DocumentNo: Code[20])
    begin
        InitSalesInvoice(EntryType, DocumentType, DocumentNo);
    end;

    procedure InitSalesInvoice(
        EntryType: Option;
        DocumentType: Text[50];
        DocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
        PharmacySaleLine: Record "E3 Pharmacy Sale Lines";
        PharmacySaleSetup: Record "E3 Pharmacy Sale Setup";
        IntegrationSetup: Record "E3 HIS Integartion Setup";
        LineNo: Integer;
        InvoiceNo: Code[20];
    begin
        // Find Pharmacy Sales Header.
        PharmacySaleHeader.Reset();
        PharmacySaleHeader.SetRange("Entry Type", EntryType);
        PharmacySaleHeader.SetRange("Document Type", DocumentType);
        PharmacySaleHeader.SetRange("Document Number", DocumentNo);

        if not PharmacySaleHeader.FindFirst() then
            Error(
                'Pharmacy Sales Header not found. Entry Type: %1, Document Type: %2, Document No.: %3.',
                EntryType,
                DocumentType,
                DocumentNo);

        // Never process completed source documents.
        if PharmacySaleHeader."Is Created" then
            exit;

        PharmacySaleHeader.TestField("Document Number");
        InvoiceNo := PharmacySaleHeader."Document Number";

        // Duplicate posting protection.
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", InvoiceNo);

        if SalesInvoiceHeader.FindFirst() then begin
            UpdatePharmacySaleStatus(
                EntryType,
                DocumentType,
                DocumentNo,
                true,
                '');
            exit;
        end;

        // Do not create another unposted invoice.
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", InvoiceNo);

        if SalesHeader.FindFirst() then
            Error(
                'Unposted Sales Invoice %1 already exists.',
                InvoiceNo);

        // Find Customer from E3 Pharmacy Sale Setup.
        PharmacySaleSetup.Reset();
        PharmacySaleSetup.SetRange("Entry Type", PharmacySaleHeader."Entry Type");
        PharmacySaleSetup.SetRange("Document Type", PharmacySaleHeader."Document Type");
        PharmacySaleSetup.SetRange("Shortcut Dimension 1 Code", PharmacySaleHeader."Business Unit");
        PharmacySaleSetup.SetRange("Account Type", PharmacySaleSetup."Account Type"::Customer);

        if not PharmacySaleSetup.FindFirst() then
            Error(
                'Pharmacy Sale Setup not found. Entry Type: %1, Document Type: %2, BU Code: %3, Account Type: Customer.',
                PharmacySaleHeader."Entry Type",
                PharmacySaleHeader."Document Type",
                PharmacySaleHeader."Business Unit");

        PharmacySaleSetup.TestField("Account No.");

        // Find Pharmacy Sales Lines.
        PharmacySaleLine.Reset();
        PharmacySaleLine.SetRange("Entry Type", PharmacySaleHeader."Entry Type");
        PharmacySaleLine.SetRange("Document Type", PharmacySaleHeader."Document Type");
        PharmacySaleLine.SetRange("Document Number", PharmacySaleHeader."Document Number");

        if not PharmacySaleLine.FindSet() then
            Error('Pharmacy Sales Lines not found for Document No. %1.', InvoiceNo);

        // Validate all source lines before creating invoice.
        repeat
            PharmacySaleLine.TestField("D365 Item Code");
            PharmacySaleLine.TestField("D365 Unit Code");

            if PharmacySaleLine.Quantity <= 0 then
                Error(
                    'Quantity must be greater than zero on line %1. Document No. %2.',
                    PharmacySaleLine."Line Number",
                    InvoiceNo);

            if PharmacySaleLine."Batch No." <> '' then begin
                // Batch tracking is handled by CreateLotTracking.
                // The item must have the corresponding tracking setup.
            end;
        until PharmacySaleLine.Next() = 0;

        // Create Sales Invoice Header.
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader."No." := InvoiceNo;
        SalesHeader.Insert(true);

        // Assign Customer.
        SalesHeader.Validate("Sell-to Customer No.", PharmacySaleSetup."Account No.");

        // Assign Posting Date and Document Date.
        if PharmacySaleHeader."Bill Date" <> 0D then begin
            SalesHeader.Validate("Posting Date", PharmacySaleHeader."Bill Date");
            SalesHeader.Validate("Document Date", PharmacySaleHeader."Bill Date");
        end;

        if PharmacySaleHeader."Location Code" <> '' then
            SalesHeader.Validate(
                "Location Code",
                PharmacySaleHeader."Location Code");

        if PharmacySaleHeader."Business Unit" <> '' then
            SalesHeader.Validate("Shortcut Dimension 1 Code", PharmacySaleHeader."Business Unit");

        if PharmacySaleHeader."Bill No." <> '' then
            SalesHeader.Validate(
                "External Document No.",
                CopyStr(
                    PharmacySaleHeader."Bill No.",
                    1,
                    MaxStrLen(SalesHeader."External Document No.")));
        SalesHeader."Pharmacy Amount" := PharmacySaleHeader."OH Amt Net";
        SalesHeader."Pharmacy Integration" := true;
        SalesHeader.Validate("Invoice Type", PharmacySaleSetup."Invoice Type");

        SalesHeader.Modify(true);

        // Find Pharmacy Sales Lines again.
        PharmacySaleLine.Reset();
        PharmacySaleLine.SetRange("Entry Type", PharmacySaleHeader."Entry Type");
        PharmacySaleLine.SetRange("Document Type", PharmacySaleHeader."Document Type");
        PharmacySaleLine.SetRange("Document Number", PharmacySaleHeader."Document Number");

        if not PharmacySaleLine.FindSet() then
            Error(
                'Pharmacy Sales Lines not found for Document No. %1.',
                InvoiceNo);

        // Create Sales Invoice Lines.
        LineNo := 0;

        repeat
            LineNo += 10000;

            SalesLine.Init();
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");

            SalesLine."Line No." := LineNo;
            SalesLine.Insert(true);

            SalesLine.Validate(Type, SalesLine.Type::Item);
            SalesLine.Validate("No.", PharmacySaleLine."D365 Item Code");
            SalesLine.Validate("Unit of Measure Code", PharmacySaleLine."D365 Unit Code");
            SalesLine.Validate(Quantity, PharmacySaleLine.Quantity);
            if PharmacySaleLine.Quantity = 0 then
                Error(
                    'Quantity cannot be zero on line %1.',
                    PharmacySaleLine."Line Number");

            SalesLine.Validate("Price Inclusive of Tax", PharmacySaleSetup."Price Inclusive of Tax");
            SalesLine.Validate("Unit Price Incl. of Tax", PharmacySaleLine."OH Amt Gross" / PharmacySaleLine.Quantity);
            SalesLine.Validate(Exempted, PharmacySaleSetup.Exempted);
            SalesLine.Validate("Unit Price", PharmacySaleLine."OH Amt Gross" / PharmacySaleLine.Quantity);

            if PharmacySaleLine."Business Unit" <> '' then
                SalesLine.Validate("Shortcut Dimension 1 Code", PharmacySaleLine."Business Unit");

            if PharmacySaleHeader."Location Code" <> '' then
                SalesLine.Validate("Location Code", PharmacySaleHeader."Location Code");
            if PharmacySaleLine."OH Amt Discount" < 0 then
                Error(
                    'Discount Amount cannot be negative on Pharmacy Sale Line %1.',
                    PharmacySaleLine."Line Number");

            if PharmacySaleLine."OH Amt Discount" <> 0 then
                SalesLine.Validate("Line Discount Amount", PharmacySaleLine."OH Amt Discount");

            SalesLine.Modify(true);

            // Create Item Tracking using existing Pharmacy Batch No.
            if PharmacySaleLine."Batch No." <> '' then
                CreateLotTracking(SalesLine, PharmacySaleLine."Batch No.");

        until PharmacySaleLine.Next() = 0;

        // Check Integration Setup.
        if not IntegrationSetup.FindFirst() then
            Error('E3 HIS Integration Setup not found.');

        // Automatically post only when enabled.
        if IntegrationSetup."Auto Pharmacy Posting Enabled" then begin
            PostSalesInvoice(InvoiceNo);

            // Verify posted invoice.
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", InvoiceNo);

            if not SalesInvoiceHeader.FindFirst() then
                Error(
                    'Sales Invoice %1 was not posted successfully.',
                    InvoiceNo);
        end;

        // Mark source Pharmacy Sale Header as Created.
        UpdatePharmacySaleStatus(
            EntryType,
            DocumentType,
            DocumentNo,
            true,
            '');
    end;

    local procedure CreateLotTracking(
        SalesLine: Record "Sales Line";
        BatchNo: Code[50])
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
    begin
        if BatchNo = '' then
            Error(
                'Batch No. must have a value for Item No. %1.',
                SalesLine."No.");

        if SalesLine."No." = '' then
            Error('Item No. must not be blank for tracking.');

        if SalesLine.Quantity <= 0 then
            Error(
                'Quantity must be greater than zero for Item No. %1.',
                SalesLine."No.");

        // Assign existing Batch No.
        TempReservationEntry.Init();
        TempReservationEntry."Lot No." := BatchNo;

        // Create Item Tracking for Sales Invoice Line.
        CreateReservEntry.CreateReservEntryFor(
            Database::"Sales Line",
            SalesLine."Document Type".AsInteger(),
            SalesLine."Document No.",
            '',
            0,
            SalesLine."Line No.",
            SalesLine."Qty. per Unit of Measure",
            SalesLine.Quantity,
            SalesLine."Quantity (Base)",
            TempReservationEntry);

        // Create tracking entry using existing Lot No.
        CreateReservEntry.CreateEntry(
            SalesLine."No.",
            SalesLine."Variant Code",
            SalesLine."Location Code",
            SalesLine.Description,
            0D,
            SalesLine."Shipment Date",
            0,
            Enum::"Reservation Status"::Surplus);
    end;

    local procedure PostSalesInvoice(InvoiceNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        // FIRST CHECK: Never post an already-posted invoice.
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", InvoiceNo);

        if SalesInvoiceHeader.FindFirst() then
            exit;

        // Find unposted Sales Invoice.
        SalesHeader.Reset();
        SalesHeader.SetRange(
            "Document Type",
            SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", InvoiceNo);

        if not SalesHeader.FindFirst() then
            Error(
                'Sales Invoice %1 not found for posting.',
                InvoiceNo);

        SalesHeader.TestField("Sell-to Customer No.");
        SalesHeader.TestField("Posting Date");

        // Post Sales Invoice.
        SalesPost.Run(SalesHeader);

        // Verify successful posting.
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", InvoiceNo);

        if not SalesInvoiceHeader.FindFirst() then
            Error(
                'Sales Invoice %1 was not posted successfully.',
                InvoiceNo);
    end;

    local procedure CleanupIncompleteSalesInvoice(
        InvoiceNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReservationEntry: Record "Reservation Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        // Never delete or modify a posted invoice.
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", InvoiceNo);

        if SalesInvoiceHeader.FindFirst() then
            exit;

        // Find incomplete Sales Invoice Lines.
        SalesLine.Reset();
        SalesLine.SetRange(
            "Document Type",
            SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Document No.", InvoiceNo);

        if SalesLine.FindSet(true) then
            repeat
                // Delete tracking entries belonging to this line only.
                ReservationEntry.Reset();
                ReservationEntry.SetRange(
                    "Source Type",
                    Database::"Sales Line");
                ReservationEntry.SetRange(
                    "Source Subtype",
                    SalesLine."Document Type".AsInteger());
                ReservationEntry.SetRange(
                    "Source ID",
                    SalesLine."Document No.");
                ReservationEntry.SetRange(
                    "Source Batch Name",
                    '');
                ReservationEntry.SetRange(
                    "Source Ref. No.",
                    SalesLine."Line No.");

                if not ReservationEntry.IsEmpty() then
                    ReservationEntry.DeleteAll(true);

                SalesLine.Delete(true);
            until SalesLine.Next() = 0;

        // Delete incomplete Sales Invoice Header.
        SalesHeader.Reset();
        SalesHeader.SetRange(
            "Document Type",
            SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", InvoiceNo);

        if SalesHeader.FindFirst() then
            SalesHeader.Delete(true);
    end;

    local procedure UpdatePharmacySaleStatus(
        EntryType: Option;
        DocumentType: Text[50];
        DocumentNo: Code[20];
        IsCreated: Boolean;
        ErrorText: Text)
    var
        PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
    begin
        PharmacySaleHeader.Reset();
        PharmacySaleHeader.SetRange("Entry Type", EntryType);
        PharmacySaleHeader.SetRange("Document Type", DocumentType);
        PharmacySaleHeader.SetRange("Document Number", DocumentNo);

        if PharmacySaleHeader.FindFirst() then begin
            PharmacySaleHeader."Is Created" := IsCreated;
            PharmacySaleHeader."Error Description" :=
                CopyStr(
                    ErrorText,
                    1,
                    MaxStrLen(PharmacySaleHeader."Error Description"));

            PharmacySaleHeader.Modify(true);
        end;
    end;

    local procedure UpdatePharmacySaleError(
        EntryType: Option;
        DocumentType: Text[50];
        DocumentNo: Code[20];
        ErrorText: Text)
    begin
        UpdatePharmacySaleStatus(
            EntryType,
            DocumentType,
            DocumentNo,
            false,
            ErrorText);
    end;

    procedure ManualCreateSalesInvoice(
    EntryType: Option;
    DocumentType: Text[50];
    DocumentNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ErrorDescription: Text;
    begin
        ClearLastError();

        if TryProcessSalesInvoice(
            EntryType,
            DocumentType,
            DocumentNo)
        then begin
            Message(
                'Sales Invoice %1 created successfully.',
                DocumentNo);
        end else begin
            // Capture actual error.
            ErrorDescription := GetLastErrorText();

            // Check whether invoice was posted despite an error.
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.SetRange("No.", DocumentNo);

            if SalesInvoiceHeader.FindFirst() then begin
                UpdatePharmacySaleStatus(
                    EntryType,
                    DocumentType,
                    DocumentNo,
                    true,
                    '');

                Message(
                    'Sales Invoice %1 is already posted.',
                    DocumentNo);
            end else begin
                // Clean up incomplete invoice.
                CleanupIncompleteSalesInvoice(DocumentNo);

                // Save error description.
                UpdatePharmacySaleError(
                    EntryType,
                    DocumentType,
                    DocumentNo,
                    ErrorDescription);

                Message(
                    'Sales Invoice %1 could not be created.\Error: %2',
                    DocumentNo,
                    ErrorDescription);
            end;
        end;
    end;
}
