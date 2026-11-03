
codeunit 50063 "E3 Pharmacy Sales Posting"
{
    Permissions =
        tabledata "E3 Pharmacy Sale Header" = rm,
        tabledata "E3 Pharmacy Sale Lines" = r,
        tabledata "E3 Pharmacy Sale Setup" = r,
        tabledata "Sales Header" = rim,
        tabledata "Sales Line" = rim;

    trigger OnRun()
    begin
        ProcessPendingSalesInvoices();
    end;

    procedure ProcessPendingSalesInvoices()
    var
        PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
        ProcessedCount: Integer;
        IntegrationSetup: Record "E3 HIS Integartion Setup";
    begin
        // Check Integration Setup
        if not IntegrationSetup.FindFirst() then
            Error('E3 HIS Integration Setup not found.');

        // Process only when Auto Pharmacy Posting is enabled
        if not IntegrationSetup."Auto Pharmacy Posting Enabled" then
            exit;

        PharmacySaleHeader.Reset();
        PharmacySaleHeader.SetRange("Is Created", false);

        if PharmacySaleHeader.FindSet() then
            repeat
                if PharmacySaleHeader."Document Number" <> '' then begin
                    InitSalesInvoice(
                        PharmacySaleHeader."Entry Type",
                        PharmacySaleHeader."Document Type",
                        PharmacySaleHeader."Document Number");

                    ProcessedCount += 1;
                end;
            until PharmacySaleHeader.Next() = 0;
    end;

    procedure InitSalesInvoice(EntryType: Option; DocumentType: Text[50]; DocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
        PharmacySaleLine: Record "E3 Pharmacy Sale Lines";
        PharmacySaleSetup: Record "E3 Pharmacy Sale Setup";
        LineNo: Integer;
        InvoiceNo: Code[20];
        LinesFound: Boolean;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
        IntegrationSetup: Record "E3 HIS Integartion Setup";
    begin
        // Find Pharmacy Sales Header
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

        if PharmacySaleHeader."Is Created" then
            Error(
                'Sales Invoice has already been created for Document No. %1.',
                PharmacySaleHeader."Document Number");

        PharmacySaleHeader.TestField("Document Number");
        InvoiceNo := PharmacySaleHeader."Document Number";

        // Find Customer from E3 Pharmacy Sale Setup
        PharmacySaleSetup.Reset();
        PharmacySaleSetup.SetRange(
            "Entry Type",
            PharmacySaleHeader."Entry Type");
        PharmacySaleSetup.SetRange(
            "Document Type",
            PharmacySaleHeader."Document Type");
        PharmacySaleSetup.SetRange(
            "Account Type",
            PharmacySaleSetup."Account Type"::Customer);

        if not PharmacySaleSetup.FindFirst() then
            Error(
                'Customer setup not found in E3 Pharmacy Sale Setup. Entry Type: %1, Document Type: %2, Account Type: Customer.',
                PharmacySaleHeader."Entry Type",
                PharmacySaleHeader."Document Type");

        PharmacySaleSetup.TestField("Account No.");

        // Check whether Sales Invoice already exists
        SalesHeader.Reset();
        SalesHeader.SetRange(
            "Document Type",
            SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", InvoiceNo);

        if SalesHeader.FindFirst() then
            Error('Sales Invoice %1 already exists.', InvoiceNo);

        // Find Pharmacy Sales Lines
        PharmacySaleLine.Reset();
        PharmacySaleLine.SetRange(
            "Entry Type",
            PharmacySaleHeader."Entry Type");
        PharmacySaleLine.SetRange(
            "Document Type",
            PharmacySaleHeader."Document Type");
        PharmacySaleLine.SetRange(
            "Document Number",
            PharmacySaleHeader."Document Number");

        LinesFound := PharmacySaleLine.FindSet();

        if not LinesFound then
            Error(
                'Pharmacy Sales Lines not found for Document No. %1.',
                InvoiceNo);

        // Validate source lines before creating the invoice
        repeat
            PharmacySaleLine.TestField("D365 Item Code");
            PharmacySaleLine.TestField("D365 Unit Code");
            PharmacySaleLine.TestField(Quantity);

            if PharmacySaleLine.Quantity < 0 then
                Error(
                    'Quantity cannot be negative on line %1.',
                    PharmacySaleLine."Line Number");
        until PharmacySaleLine.Next() = 0;

        // Create Sales Invoice Header
        SalesHeader.Init();
        SalesHeader.Validate(
            "Document Type",
            SalesHeader."Document Type"::Invoice);
        SalesHeader."No." := InvoiceNo;
        SalesHeader.Insert(true);

        // Pick Customer No. from E3 Pharmacy Sale Setup
        SalesHeader.Validate(
            "Sell-to Customer No.",
            PharmacySaleSetup."Account No.");

        if PharmacySaleHeader."Bill Date" <> 0D then begin
            SalesHeader.Validate(
                "Posting Date",
                PharmacySaleHeader."Bill Date");
            SalesHeader.Validate(
                "Document Date",
                PharmacySaleHeader."Bill Date");
        end else begin
            SalesHeader.Validate("Posting Date", PharmacySaleHeader."Bill Date");
            SalesHeader.Validate("Document Date", PharmacySaleHeader."Bill Date");
        end;

        if PharmacySaleHeader."Location Code" <> '' then
            SalesHeader.Validate(
                "Location Code",
                PharmacySaleHeader."Location Code");

        if PharmacySaleHeader."Business Unit" <> '' then
            SalesHeader.Validate(
                "Shortcut Dimension 1 Code",
                PharmacySaleHeader."Business Unit");

        if PharmacySaleHeader."Bill No." <> '' then
            SalesHeader.Validate(
                "External Document No.",
                CopyStr(
                    PharmacySaleHeader."Bill No.",
                    1,
                    MaxStrLen(SalesHeader."External Document No.")));

        SalesHeader.Modify(true);

        // Find Pharmacy Sales Lines again
        PharmacySaleLine.Reset();
        PharmacySaleLine.SetRange(
            "Entry Type",
            PharmacySaleHeader."Entry Type");
        PharmacySaleLine.SetRange(
            "Document Type",
            PharmacySaleHeader."Document Type");
        PharmacySaleLine.SetRange(
            "Document Number",
            PharmacySaleHeader."Document Number");

        if not PharmacySaleLine.FindSet() then
            Error(
                'Pharmacy Sales Lines not found for Document No. %1.',
                InvoiceNo);

        // Create Sales Invoice Lines
        LineNo := 0;

        repeat
            LineNo += 10000;

            SalesLine.Init();
            SalesLine.Validate(
                "Document Type",
                SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine."Line No." := LineNo;
            SalesLine.Insert(true);
            SalesLine.Validate(Type, SalesLine.Type::Item);
            SalesLine.Validate("No.", PharmacySaleLine."D365 Item Code");
            SalesLine.Validate("Unit of Measure Code", PharmacySaleLine."D365 Unit Code");
            SalesLine.Validate(Quantity, PharmacySaleLine.Quantity);
            SalesLine.Validate("Unit Price", PharmacySaleLine."OH Amt Net");
            if PharmacySaleLine."Business Unit" <> '' then
                SalesLine.Validate("Shortcut Dimension 1 Code", PharmacySaleLine."Business Unit");
            if PharmacySaleHeader."Location Code" <> '' then
                SalesLine.Validate("Location Code", PharmacySaleHeader."Location Code");
            if PharmacySaleLine."OH Amt Discount" <> 0 then
                SalesLine.Validate("Line Discount Amount", PharmacySaleLine."OH Amt Discount");

            SalesLine.Modify(true);
            // Create Item Tracking using existing Pharmacy Batch No.
            if PharmacySaleLine."Batch No." <> '' then
                CreateLotTracking(
                    SalesLine,
                    PharmacySaleLine."Batch No.");

        until PharmacySaleLine.Next() = 0;

        // Check Integration Setup
        if not IntegrationSetup.FindFirst() then
            Error('E3 HIS Integration Setup not found.');

        // Automatically Post Sales Invoice if enabled
        if IntegrationSetup."Auto Pharmacy Posting Enabled" then begin
            PostSalesInvoice(InvoiceNo);
        end;

        // Mark source Pharmacy Sales Header as Created
        PharmacySaleHeader."Is Created" := true;
        PharmacySaleHeader.Modify(true);
    end;

    local procedure CreateLotTracking(
    SalesLine: Record "Sales Line";
    BatchNo: Code[50])
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        TempReservationEntry: Record "Reservation Entry" temporary;
    begin
        // Validate existing Batch No.
        if BatchNo = '' then
            Error(
                'Batch No. must have a value for Item No. %1.',
                SalesLine."No.");

        // Assign existing Batch No. to Item Tracking
        TempReservationEntry.Init();
        TempReservationEntry."Lot No." := BatchNo;

        // Create Item Tracking for Sales Invoice Line
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
        // Find Sales Invoice
        SalesHeader.Reset();
        SalesHeader.SetRange(
            "Document Type",
            SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", InvoiceNo);

        if not SalesHeader.FindFirst() then
            Error(
                'Sales Invoice %1 not found for posting.',
                InvoiceNo);

        // Validate Sales Invoice
        SalesHeader.TestField("Sell-to Customer No.");
        SalesHeader.TestField("Posting Date");

        // Post Sales Invoice using Base Business Central Posting Engine
        SalesPost.Run(SalesHeader);

        // Verify Posted Sales Invoice
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", InvoiceNo);

        if not SalesInvoiceHeader.FindFirst() then
            Error(
                'Sales Invoice %1 was not posted successfully.',
                InvoiceNo);
    end;
}
