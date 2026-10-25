codeunit 50065 "E3 Purch. Ret. Order Line Mgmt"
{
    procedure UpdateChallanDetails(ReceiptNo: Code[20]; ReceiptLineNo: Integer; var PurchLine: Record "Purchase Line")
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if ReceiptNo = '' then
            exit;

        if not PurchRcptHeader.Get(ReceiptNo) then
            exit;

        if not PurchRcptLine.Get(ReceiptNo, ReceiptLineNo) then
            exit;

        PurchLine.Validate(MRP, PurchRcptLine.MRP);
        PurchLine.Modify(true);
    end;
}