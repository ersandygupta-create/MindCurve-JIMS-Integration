codeunit 50053 "Shipment Line Processing"
{
    // Elevate privileges to allow modifying posted Sales Shipment Lines
    Permissions = tabledata "Sales Shipment Line" = m;

    procedure InsertPurchaseLineFromShipment(PurchHeader: Record "Purchase Header"; var SalesShipmentLine: Record "Sales Shipment Line")
    var
        PurchLine: Record "Purchase Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        NextLineNo: Integer;
    begin
        // 1. Trace and update Vendor Invoice details on Purchase Header
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");

        if SalesInvLine.FindFirst() then
            if SalesInvHeader.Get(SalesInvLine."Document No.") then begin
                // Update Purchase Header fields with Invoice No and Posting/Document Date
                PurchHeader.Validate("Vendor Invoice No.", SalesInvHeader."No.");
                PurchHeader.Validate("Posting Date", SalesInvHeader."Posting Date");
                PurchHeader.Validate("Document Date", SalesInvHeader."Document Date");
                PurchHeader.Modify(true);
            end;
        // Find the last existing Line No. on the Purchase Order
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then
            NextLineNo := PurchLine."Line No." + 10000
        else
            NextLineNo := 10000;

        // Initialize new Purchase Line
        PurchLine.Init();
        PurchLine."Document Type" := PurchHeader."Document Type";
        PurchLine."Document No." := PurchHeader."No.";
        PurchLine."Line No." := NextLineNo;
        PurchLine.Insert(true);

        // Populate line fieldss
        PurchLine.Validate(Type, ConvertShipmentTypeToPurchaseType(SalesShipmentLine.Type));
        PurchLine.Validate("No.", SalesShipmentLine."No.");

        if SalesShipmentLine."Variant Code" <> '' then
            PurchLine.Validate("Variant Code", SalesShipmentLine."Variant Code");

        PurchLine.Validate("Location Code", PurchHeader."Location Code");
        //PurchLine.Validate(Quantity, SalesShipmentLine."Qty. Shipped Not Invoiced");
        purchline.Validate(MRP, SalesShipmentLine.MRP);
        purchline.validate(Quantity, SalesShipmentLine.Quantity);

        if SalesShipmentLine."Unit of Measure Code" <> '' then
            PurchLine.Validate("Unit of Measure Code", SalesShipmentLine."Unit of Measure Code");

        PurchLine.Description := SalesShipmentLine.Description;
        PurchLine.Modify(true);

        // Mark the Sales Shipment Line as processed
        SalesShipmentLine."Purchase Line Created" := true;
        SalesShipmentLine.Modify(false); // Pass false to bypass standard table modification triggers
    end;

    local procedure ConvertShipmentTypeToPurchaseType(ShipmentType: Enum "Sales Line Type"): Enum "Purchase Line Type"
    begin
        case ShipmentType of
            ShipmentType::Item:
                exit(Enum::"Purchase Line Type"::Item);
            ShipmentType::"G/L Account":
                exit(Enum::"Purchase Line Type"::"G/L Account");
            ShipmentType::Resource:
                exit(Enum::"Purchase Line Type"::Resource);
            ShipmentType::"Fixed Asset":
                exit(Enum::"Purchase Line Type"::"Fixed Asset");
            ShipmentType::"Charge (Item)":
                exit(Enum::"Purchase Line Type"::"Charge (Item)");
            else
                exit(Enum::"Purchase Line Type"::" ");
        end;
    end;
}