codeunit 50100 "Recreate Purch Lines From Rcpt"
{
    procedure RecreateLinesFromReceipt(PurchOrderNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ExistingPurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        TempAggLine: Record "Purch. Rcpt. Line" temporary;
        NextLineNo: Integer;
        RemainingToInvoice: Decimal;
        RemainingToInvoiceBase: Decimal;
    begin
        PurchHeader.Get(PurchHeader."Document Type"::Order, PurchOrderNo);

        // Step 1: Delete any existing Purchase Lines on this Purchase Order
        DeleteExistingPurchLines(PurchHeader."No.");

        // Step 2: Aggregate all posted receipt lines by "Order Line No." (or Line No. fallback if 0)
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Order No.", PurchHeader."No.");
        if not PurchRcptLine.FindSet() then
            Error('No Posted Purchase Receipt Lines found for Purchase Order %1.', PurchHeader."No.");

        repeat
            TempAggLine.Reset();
            if PurchRcptLine."Order Line No." <> 0 then
                TempAggLine.SetRange("Order Line No.", PurchRcptLine."Order Line No.")
            else
                TempAggLine.SetRange("Line No.", PurchRcptLine."Line No.");

            if TempAggLine.FindFirst() then begin
                TempAggLine.Quantity += PurchRcptLine.Quantity;
                TempAggLine."Quantity (Base)" += PurchRcptLine."Quantity (Base)";
                TempAggLine."Qty. Invoiced (Base)" += PurchRcptLine."Qty. Invoiced (Base)";
                TempAggLine."Qty. Invoiced (Base)" += PurchRcptLine."Qty. Invoiced (Base)";
                TempAggLine.Modify();
            end else begin
                Clear(TempAggLine);
                TempAggLine := PurchRcptLine;
                if TempAggLine."Order Line No." = 0 then
                    TempAggLine."Order Line No." := PurchRcptLine."Line No.";
                TempAggLine.Insert();
            end;
        until PurchRcptLine.Next() = 0;

        NextLineNo := 10000;

        // Step 3: Recreate one Purchase Line per aggregated receipt line
        TempAggLine.Reset();
        if TempAggLine.FindSet() then begin
            repeat
                Clear(PurchLine);
                PurchLine.Init();
                PurchLine."Document Type" := PurchHeader."Document Type"::Order;
                PurchLine."Document No." := PurchHeader."No.";

                if TempAggLine."Order Line No." <> 0 then
                    PurchLine."Line No." := TempAggLine."Order Line No."
                else
                    PurchLine."Line No." := NextLineNo;

                while ExistingPurchLine.Get(PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.") do
                    PurchLine."Line No." += 10000;

                PurchLine.Validate(Type, TempAggLine.Type);
                PurchLine.Validate("No.", TempAggLine."No.");

                if TempAggLine."Variant Code" <> '' then
                    PurchLine.Validate("Variant Code", TempAggLine."Variant Code");

                if TempAggLine."Location Code" <> '' then
                    PurchLine.Validate("Location Code", TempAggLine."Location Code");

                if TempAggLine."Unit of Measure Code" <> '' then
                    PurchLine.Validate("Unit of Measure Code", TempAggLine."Unit of Measure Code");

                PurchLine.Description := TempAggLine.Description;
                PurchLine."Description 2" := TempAggLine."Description 2";

                if TempAggLine."Direct Unit Cost" <> 0 then
                    PurchLine.Validate("Direct Unit Cost", TempAggLine."Direct Unit Cost");

                PurchLine.Validate(Quantity, TempAggLine.Quantity);

                // Total received across all receipts
                PurchLine."Quantity Received" := TempAggLine.Quantity;
                PurchLine."Qty. Received (Base)" := TempAggLine."Quantity (Base)";
                PurchLine."Qty. to Receive" := 0;
                PurchLine."Qty. to Receive (Base)" := 0;

                // Total invoiced and remaining uninvoiced across all receipts
                PurchLine."Quantity Invoiced" := TempAggLine."Qty. Invoiced (Base)";
                PurchLine."Qty. Invoiced (Base)" := TempAggLine."Qty. Invoiced (Base)";

                RemainingToInvoice := TempAggLine.Quantity - TempAggLine."Qty. Invoiced (Base)";
                if RemainingToInvoice < 0 then
                    RemainingToInvoice := 0;

                RemainingToInvoiceBase := TempAggLine."Quantity (Base)" - TempAggLine."Qty. Invoiced (Base)";
                if RemainingToInvoiceBase < 0 then
                    RemainingToInvoiceBase := 0;

                PurchLine."Qty. Rcd. Not Invoiced" := RemainingToInvoice;
                PurchLine."Qty. Rcd. Not Invoiced (Base)" := RemainingToInvoiceBase;
                PurchLine."Qty. to Invoice" := RemainingToInvoice;
                PurchLine."Qty. to Invoice (Base)" := RemainingToInvoiceBase;

                if TempAggLine."Dimension Set ID" <> 0 then
                    PurchLine."Dimension Set ID" := TempAggLine."Dimension Set ID";

                PurchLine.Insert(true);
                NextLineNo := PurchLine."Line No." + 10000;
            until TempAggLine.Next() = 0;
        end;

        Message('Deleted any existing lines and recreated Purchase Lines from receipts for Purchase Order %1.', PurchHeader."No.");
    end;

    local procedure DeleteExistingPurchLines(PurchOrderNo: Code[20])
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchOrderNo);
        if PurchLine.FindSet(true) then
            PurchLine.DeleteAll(false);
    end;
}