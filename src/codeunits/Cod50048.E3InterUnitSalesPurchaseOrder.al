codeunit 50048 "E3 InterUnit Sale/Purch Mgt."
{
    procedure InitPurchaseOrder(EntryType: Enum "E3 Entry Type"; NatureType: Enum "E3 Nature Type"; DocumentNo: Code[50])
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        StockTransferSetup: Record "E3 Stock Transfer Setup";
        LineNo: Integer;
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled");
        IntegrationSetup.TESTFIELD("Inter Unit Purchase Enabled");

        IF NOT IntegrationSetup."Integration Enabled" THEN
            EXIT;

        //OrderValidation(EntryType, NatureType, DocumentNo);

        HISPurchaseSaleHeader.RESET();
        HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
        HISPurchaseSaleHeader.SETRANGE("Entry Type", EntryType);
        HISPurchaseSaleHeader.SETRANGE("Nature Type", NatureType);
        HISPurchaseSaleHeader.SETRANGE("Create PO", FALSE);
        HISPurchaseSaleHeader.SETFILTER("Error Description", '%1', '');
        HISPurchaseSaleHeader.SETFILTER("No. of Lines", '<>%1', 0);

        IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN

            StockTransferSetup.RESET();
            StockTransferSetup.SETRANGE("Nature Type", NatureType);
            StockTransferSetup.SETRANGE("Entry Type", EntryType);
            StockTransferSetup.SETRANGE("From BU", HISPurchaseSaleHeader."Unit Code");
            StockTransferSetup.SETRANGE("From Dept", HISPurchaseSaleHeader."Dept Code");
            StockTransferSetup.SETRANGE("From Location", HISPurchaseSaleHeader."Location Code");

            IF NOT StockTransferSetup.FINDFIRST() THEN
                ERROR(
                    'Stock Transfer Setup not found for Nature Type %1, Entry Type %2, From BU %3, From Dept %4 and From Location %5.',
                    NatureType,
                    EntryType,
                    HISPurchaseSaleHeader."Unit Code",
                    HISPurchaseSaleHeader."Dept Code",
                    HISPurchaseSaleHeader."Location Code");

            StockTransferSetup.TESTFIELD("Vendor Code");
            StockTransferSetup.TESTFIELD("To Location");

            PurchHeader.INIT();
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader."No." := COPYSTR(HISPurchaseSaleHeader."Document No.", 1, 20);
            PurchHeader.SetHideValidationDialog(TRUE);
            PurchHeader.INSERT(TRUE);

            PurchHeader.VALIDATE("Buy-from Vendor No.", StockTransferSetup."Vendor Code");
            PurchHeader.VALIDATE("Order Date", HISPurchaseSaleHeader."Document Date");
            PurchHeader.VALIDATE("Posting Date", HISPurchaseSaleHeader."Posting Date");

            PurchHeader.VALIDATE("Location Code", StockTransferSetup."To Location");

            IF HISPurchaseSaleHeader."Unit Code" <> '' THEN
                PurchHeader.VALIDATE("Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Unit Code");

            PurchHeader.VALIDATE("Posting No. Series", '');
            PurchHeader."Integration PO" := TRUE;
            PurchHeader.MODIFY(TRUE);

            LineNo := 0;

            HISPurchaseSaleLine.RESET();
            HISPurchaseSaleLine.SETRANGE("Nature Type", HISPurchaseSaleHeader."Nature Type");
            HISPurchaseSaleLine.SETRANGE("Entry Type", HISPurchaseSaleHeader."Entry Type");
            HISPurchaseSaleLine.SETRANGE("Document No.", HISPurchaseSaleHeader."Document No.");

            IF HISPurchaseSaleLine.FINDSET() THEN
                REPEAT
                    LineNo += 10000;

                    PurchLine.INIT();
                    PurchLine.VALIDATE("Document Type", PurchHeader."Document Type");
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine.VALIDATE("Line No.", LineNo);
                    PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                    PurchLine.VALIDATE("No.", HISPurchaseSaleLine."Item ID");

                    IF HISPurchaseSaleLine."Shipped Qty" <> 0 THEN
                        PurchLine.VALIDATE(Quantity, HISPurchaseSaleLine."Shipped Qty");

                    PurchLine.VALIDATE("Direct Unit Cost", HISPurchaseSaleLine."Unit Cost");
                    PurchLine.VALIDATE("Location Code", StockTransferSetup."To Location");

                    IF HISPurchaseSaleHeader."Unit Code" <> '' THEN
                        PurchLine.VALIDATE("Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Unit Code");

                    PurchLine.Description := COPYSTR(HISPurchaseSaleLine."Item Name", 1, 100);
                    PurchLine.VALIDATE("Line Discount Amount", HISPurchaseSaleLine.Discount);
                    PurchLine.VALIDATE("HSN/SAC Code", HISPurchaseSaleLine."HSN/SAC Code");
                    PurchLine."Vendor Item No." := HISPurchaseSaleLine."Item ID";
                    PurchLine.INSERT(TRUE);

                UNTIL HISPurchaseSaleLine.NEXT() = 0;

            HISPurchaseSaleHeader."Create PO" := TRUE;
            HISPurchaseSaleHeader.MODIFY(TRUE);
        END;
    end;

    procedure InitSalesOrder(EntryType: Enum "E3 Entry Type"; NatureType: Enum "E3 Nature Type"; DocumentNo: Code[50])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        StockTransferSetup: Record "E3 Stock Transfer Setup";
        LineNo: Integer;
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled");
        IntegrationSetup.TESTFIELD("Inter Unit Sales Enabled");

        IF NOT IntegrationSetup."Integration Enabled" THEN
            EXIT;

        //OrderValidation(EntryType, NatureType, DocumentNo);

        HISPurchaseSaleHeader.RESET();
        HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
        HISPurchaseSaleHeader.SETRANGE("Entry Type", EntryType);
        HISPurchaseSaleHeader.SETRANGE("Nature Type", NatureType);
        HISPurchaseSaleHeader.SETRANGE("Create PO", FALSE);
        HISPurchaseSaleHeader.SETFILTER("Error Description", '%1', '');
        HISPurchaseSaleHeader.SETFILTER("No. of Lines", '<>%1', 0);

        IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN

            StockTransferSetup.RESET();
            StockTransferSetup.SETRANGE("Nature Type", NatureType);
            StockTransferSetup.SETRANGE("Entry Type", EntryType);
            StockTransferSetup.SETRANGE("From BU", HISPurchaseSaleHeader."Unit Code");
            StockTransferSetup.SETRANGE("From Dept", HISPurchaseSaleHeader."Dept Code");
            StockTransferSetup.SETRANGE("From Location", HISPurchaseSaleHeader."Location Code");

            IF NOT StockTransferSetup.FINDFIRST() THEN
                ERROR(
                    'Stock Transfer Setup not found for Nature Type %1, Entry Type %2, From BU %3, From Dept %4 and From Location %5.',
                    NatureType,
                    EntryType,
                    HISPurchaseSaleHeader."Unit Code",
                    HISPurchaseSaleHeader."Dept Code",
                    HISPurchaseSaleHeader."Location Code");

            StockTransferSetup.TESTFIELD("Customer Code");
            StockTransferSetup.TESTFIELD("To Location");

            SalesHeader.INIT();
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            SalesHeader."No." := COPYSTR(HISPurchaseSaleHeader."Document No.", 1, 20);
            SalesHeader.SetHideValidationDialog(TRUE);
            SalesHeader.INSERT(TRUE);

            SalesHeader.VALIDATE("Sell-to Customer No.", StockTransferSetup."Customer Code");
            SalesHeader.VALIDATE("Order Date", HISPurchaseSaleHeader."Document Date");
            SalesHeader.VALIDATE("Posting Date", HISPurchaseSaleHeader."Posting Date");

            SalesHeader.VALIDATE("Location Code", StockTransferSetup."To Location");

            IF HISPurchaseSaleHeader."Unit Code" <> '' THEN
                SalesHeader.VALIDATE("Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Unit Code");

            SalesHeader.MODIFY(TRUE);

            LineNo := 0;

            HISPurchaseSaleLine.RESET();
            HISPurchaseSaleLine.SETRANGE("Nature Type", HISPurchaseSaleHeader."Nature Type");
            HISPurchaseSaleLine.SETRANGE("Entry Type", HISPurchaseSaleHeader."Entry Type");
            HISPurchaseSaleLine.SETRANGE("Document No.", HISPurchaseSaleHeader."Document No.");

            IF HISPurchaseSaleLine.FINDSET() THEN
                REPEAT
                    LineNo += 10000;

                    SalesLine.INIT();
                    SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine.VALIDATE("Line No.", LineNo);
                    SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                    SalesLine.VALIDATE("No.", HISPurchaseSaleLine."Item ID");

                    IF HISPurchaseSaleLine."Shipped Qty" <> 0 THEN
                        SalesLine.VALIDATE(Quantity, HISPurchaseSaleLine."Shipped Qty");

                    SalesLine.VALIDATE("Unit Price", HISPurchaseSaleLine."Unit Cost");
                    SalesLine.VALIDATE("Location Code", StockTransferSetup."To Location");

                    IF HISPurchaseSaleHeader."Unit Code" <> '' THEN
                        SalesLine.VALIDATE("Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Unit Code");

                    SalesLine.Description := COPYSTR(HISPurchaseSaleLine."Item Name", 1, 100);
                    SalesLine.VALIDATE("Line Discount Amount", HISPurchaseSaleLine.Discount);
                    SalesLine.VALIDATE("HSN/SAC Code", HISPurchaseSaleLine."HSN/SAC Code");
                    SalesLine.INSERT(TRUE);

                UNTIL HISPurchaseSaleLine.NEXT() = 0;

            HISPurchaseSaleHeader."Create PO" := TRUE;
            HISPurchaseSaleHeader.MODIFY(TRUE);
        END;
    end;

    procedure InitInterUnitSalePurchase(
        EntryType: Enum "E3 Entry Type";
        NatureType: Enum "E3 Nature Type";
        DocumentNo: Code[50])
    var
        Header: Record "E3 Indent Sale/Purchase Header";
    begin
        Header.RESET();
        Header.SETRANGE("Document No.", DocumentNo);
        Header.SETRANGE("Entry Type", EntryType);
        Header.SETRANGE("Nature Type", NatureType);

        IF NOT Header.FINDFIRST() THEN
            ERROR(
                'Inter Unit Header not found for Document No. %1.',
                DocumentNo);

        OrderValidation(EntryType, NatureType, DocumentNo);

        CASE Header.Type OF
            Header.Type::Vendor:
                InitPurchaseOrder(EntryType, NatureType, DocumentNo);

            Header.Type::Customer:
                InitSalesOrder(EntryType, NatureType, DocumentNo);

            ELSE
                ERROR(
                    'Vendor/Customer Type is not defined for Document No. %1.',
                    DocumentNo);
        END;
    end;


    local procedure OrderValidation(EntryType: Enum "E3 Entry Type"; NatureType: Enum "E3 Nature Type"; DocumentNo: Code[50])
    var
        Header: Record "E3 Indent Sale/Purchase Header";
        Line: Record "E3 Indent Sale/Purchase Line";
        Item: Record Item;
    begin
        Header.RESET();
        Header.SETRANGE("Document No.", DocumentNo);
        Header.SETRANGE("Entry Type", EntryType);
        Header.SETRANGE("Nature Type", NatureType);

        IF NOT Header.FINDFIRST() THEN
            ERROR('Header not found for Document No. %1.', DocumentNo);

        //Header.TESTFIELD("Vendor/Customer No.");
        Header.TESTFIELD("Location Code");
        Header.TESTFIELD("No. of Lines");

        Line.RESET();
        Line.SETRANGE("Entry No.", Header."Entry No.");
        Line.SetRange("Nature Type", NatureType);
        Line.SetRange("Entry Type", EntryType);
        Line.SETRANGE("Document No.", Header."Document No.");

        IF NOT Line.FINDSET() THEN
            ERROR('No lines found for Document No. %1.', DocumentNo);

        REPEAT
            Line.TESTFIELD("Item ID");

            IF NOT Item.GET(Line."Item ID") THEN
                ERROR('Item %1 does not exist for Document No. %2.', Line."Item ID", DocumentNo);

            Line.TESTFIELD("Shipped Qty");

            IF Line."Shipped Qty" <= 0 THEN
                ERROR('Shipped Qty must be greater than zero for Item %1 in Document No. %2.', Line."Item ID", DocumentNo);

        UNTIL Line.NEXT() = 0;
    end;

    var
        HISPurchaseSaleHeader: Record "E3 Indent Sale/Purchase Header";
        HISPurchaseSaleLine: Record "E3 Indent Sale/Purchase Line";
        IntegrationSetup: Record "E3 HIS Integartion Setup";
}