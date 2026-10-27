codeunit 50065 "E3 Purch. Ret. Order Line Mgmt"
{
    Permissions =
        tabledata "Purchase Line" = rm,
        tabledata "Purch. Rcpt. Header" = r,
        tabledata "Purch. Rcpt. Line" = r;

    procedure UpdateChallanDetails(
        ReceiptNo: Code[20];
        ReceiptLineNo: Integer;
        var PurchLine: Record "Purchase Line")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        // Validate receipt number.
        if ReceiptNo = '' then
            Error('Receipt No. must not be blank.');

        // Get posted purchase receipt header.
        if not PurchRcptHeader.Get(ReceiptNo) then
            Error(
                'Posted Purchase Receipt %1 was not found.',
                ReceiptNo);

        // Get posted purchase receipt line.
        if not PurchRcptLine.Get(ReceiptNo, ReceiptLineNo) then
            Error(
                'Posted Purchase Receipt Line was not found. Receipt No.: %1, Line No.: %2',
                ReceiptNo,
                ReceiptLineNo);

        // Update Challan No. from Vendor Invoice No.
        PurchLine.Validate(
            "Challan No.",
            CopyStr(
                PurchRcptHeader."Vendor Invoice No.",
                1,
                MaxStrLen(PurchLine."Challan No.")));

        // Update Challan Date from Document Date.
        PurchLine.Validate(
            "Challan Date",
            PurchRcptHeader."Document Date");

        // Update MRP from posted receipt line.
        PurchLine.Validate(
            MRP,
            PurchRcptLine.MRP);

        // Save updated Purchase Return Order line.
        PurchLine.Modify(true);
    end;
}