codeunit 50059 "E3 Invoice Cleanup Management"
{
    Permissions = tabledata "Purch. Rcpt. Header" = m,
                  tabledata "Purch. Rcpt. Line" = m,
                  tabledata "Purchase Header" = d,
                  tabledata "Purchase Line" = d;

    /// <summary>
    /// Reverts custom flags on Purchase Receipts/Receipt Lines linked to specified Purchase Invoice 
    /// and forcefully deletes the Purchase Invoice header and lines.
    /// </summary>
    procedure DeleteInvoiceAndRevertReceiptFlags(InvoiceNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if not PurchHeader.Get(PurchHeader."Document Type"::Invoice, InvoiceNo) then
            exit;

        // 1. Find linked Purchase Lines and reset original Purchase Receipt Lines
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then begin
            repeat
                // Reset Receipt Line status
                if (PurchLine."Receipt No." <> '') and (PurchLine."Receipt Line No." <> 0) then begin
                    if PurchRcptLine.Get(PurchLine."Receipt No.", PurchLine."Receipt Line No.") then begin
                        PurchRcptLine."Purchase Inv Created" := false;
                        PurchRcptLine.Modify();
                    end;

                    // Reset Receipt Header status
                    if PurchRcptHeader.Get(PurchLine."Receipt No.") then begin
                        PurchRcptHeader."Purchase Invoice Created" := false;
                        PurchRcptHeader."Purchase Invoice No" := '';
                        PurchRcptHeader.Modify();
                    end;
                end;
            until PurchLine.Next() = 0;

            // Delete Purchase Lines forcefully
            PurchLine.DeleteAll();
        end;

        // 2. Delete Purchase Header forcefully
        PurchHeader.Delete();
    end;

    /// <summary>
    /// Forcefully deletes ALL unposted Purchase Invoices and resets all custom Receipt flags.
    /// </summary>
    procedure DeleteAllPurchaseInvoicesForcefully()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        DeletedCount: Integer;
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);

        if PurchHeader.FindSet() then begin
            repeat
                DeleteInvoiceAndRevertReceiptFlags(PurchHeader."No.");
                DeletedCount += 1;
            until PurchHeader.Next() = 0;
        end;

        // Safety Catch: Reset any remaining flagged receipt lines/headers in case orphan flags exist
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Purchase Inv Created", true);
        if PurchRcptLine.FindSet() then begin
            PurchRcptLine.ModifyAll("Purchase Inv Created", false);
        end;

        PurchRcptHeader.Reset();
        PurchRcptHeader.SetRange("Purchase Invoice Created", true);
        if PurchRcptHeader.FindSet() then begin
            PurchRcptHeader.ModifyAll("Purchase Invoice Created", false);
            PurchRcptHeader.ModifyAll("Purchase Invoice No", '');
        end;

        Message('%1 Purchase Invoice(s) deleted forcefully and receipt flags successfully reverted.', DeletedCount);
    end;
}