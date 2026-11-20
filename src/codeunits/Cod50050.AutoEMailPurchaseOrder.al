codeunit 50050 "E3 Purchase Order Auto E-Mail"
{
    Permissions = tabledata "Purchase Header" = rm;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        PendingPurchaseOrder: Record "Purchase Header";
        VoucherTypeCode: Text;
        VoucherTypeFilter: Text;
        InvalidVoucherTypeErr: Label 'Enter voucher type codes of up to 20 characters separated by |, for example 1|2|3.';
    begin
        TotalSend := 0;
        PendingPurchaseOrder.SetRange("Document Type", PendingPurchaseOrder."Document Type"::Order);
        PendingPurchaseOrder.SetRange("E3 Send E-Mail", false);
        PendingPurchaseOrder.SetRange(Status, PendingPurchaseOrder.Status::Released);
        if Rec."Parameter String".Trim() <> '' then begin
            foreach VoucherTypeCode in Rec."Parameter String".Split('|') do begin
                VoucherTypeCode := UpperCase(VoucherTypeCode.Trim());
                if (VoucherTypeCode = '') or
                   (StrLen(VoucherTypeCode) > MaxStrLen(PendingPurchaseOrder."Voucher Type")) or
                   (StrPos(VoucherTypeCode, '..') > 0) or
                   (DelChr(VoucherTypeCode, '=', ',&<>*=?@()''') <> VoucherTypeCode)
                then
                    Error(InvalidVoucherTypeErr);

                if VoucherTypeFilter <> '' then
                    VoucherTypeFilter += '|';
                VoucherTypeFilter += VoucherTypeCode;
            end;
            PendingPurchaseOrder.SetFilter("Voucher Type", VoucherTypeFilter);
        end;

        if PendingPurchaseOrder.FindSet() then
            repeat
                SendMailforPurchaseOrderJob(PendingPurchaseOrder);
            until (TotalSend >= 3) or (PendingPurchaseOrder.Next() = 0);
    end;



    procedure SendMailforPurchaseOrderJob(PurchHeader: Record "Purchase Header")
    begin
        EMailSetup.Get();

        PurchaseHeader1.Reset();
        PurchaseHeader1.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseHeader1.SetRange("No.", PurchHeader."No.");

        if PurchaseHeader1.FindFirst() then begin
            if PurchaseHeader1.Status <> PurchaseHeader1.Status::Released then
                exit;

            PurchaseHeader1.TestField("Buy-from Vendor No.");
            Vendor.Get(PurchaseHeader1."Buy-from Vendor No.");
            if Vendor."Send Order Email" and (Vendor."Order Email" <> '') then begin
                DocumentNo := DelChr(PurchaseHeader1."No.", '=', '\,/,-');
                Postingdate := UpperCase(Format(PurchaseHeader1."Order Date", 0, '<Day,2>-<Month Text,3>-<Year,2>'));
                FileNameVar1 := EMailSetup."Folder Path" + DocumentNo + '-' + Postingdate;
                Subject := 'Purchase Order' + ' - ' + PurchaseHeader1."No." + ' [' + PurchaseHeader1."Buy-from Vendor No." + ' - ' +
                    PurchaseHeader1."Buy-from Vendor Name" + '] ';
                EmailMessage.Create(Vendor."Order Email", Subject, EMailSetup."Order E-Mail Body", false);
                Clear(Addcc);
                AddMakeCCEmail(PurchaseHeader1);

                AddPurchaseOrderAttachment(PurchaseHeader1, FileNameVar1 + '.pdf');
                if not Email.Send(EmailMessage, Enum::"Email Scenario"::"Hospital E-Mail") then
                    exit;
                PurchHeader."E3 Send E-Mail" := true;
                PurchHeader.Modify;

                TotalSend += 1;

                Commit;
            end;
        end;
    end;
    //end;

    procedure SendMailforPurchaseOrder(PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SetRange("E3 Send E-Mail", false);
        PurchHeader.SetRange(Status, PurchHeader.Status::Released);

        // PurchHeader.SetRange(
        //     "E3 Select E-Mail",
        //     true);

        if PurchHeader.FindFirst() then begin
            if PurchHeader.Status = PurchHeader.Status::Released then
                repeat

                    EMailSetup.Get();

                    PurchaseHeader1.Reset();
                    PurchaseHeader1.SetRange("Document Type", PurchHeader."Document Type");
                    PurchaseHeader1.SetRange("No.", PurchHeader."No.");
                    if PurchaseHeader1.FindFirst() then begin
                        if PurchaseHeader1.Status = PurchaseHeader1.Status::Released then
                            Vendor.Get(PurchaseHeader1."Buy-from Vendor No.");
                        if Vendor."Send Order Email" then //begin
                            if Vendor."Order Email" <> '' then begin
                                DocumentNo := DelChr(PurchaseHeader1."No.", '=', '\,/,-');
                                Postingdate := UpperCase(Format(PurchaseHeader1."Order Date", 0, '<Day,2>-<Month Text,3>-<Year,2>'));
                                FileNameVar1 := EMailSetup."Folder Path" + DocumentNo + '-' + Postingdate;
                                Subject := 'Purchase Order' + ' - ' + PurchaseHeader1."No." + ' [' + ' - ' + PurchaseHeader1."Buy-from Vendor Name" + '] ';
                                EmailMessage.Create(Vendor."Order Email", Subject, EMailSetup."Order E-Mail Body", false);
                                Clear(Addcc);
                                AddMakeCCEmail(PurchaseHeader1);
                                AddPurchaseOrderAttachment(PurchaseHeader1, FileNameVar1 + '.pdf');
                                Email.Send(EmailMessage, Enum::"Email Scenario"::"Hospital E-Mail");
                                PurchHeader."E3 Send E-Mail" := true;
                                PurchHeader.Modify;

                                Sleep(10000);

                                TotalSend += 1;

                                Commit;

                                dlgProgress.Open(Text002);
                                dlgProgress.Update(1, TotalSend);
                            end;
                    end;
                //end;

                until PurchHeader.Next() = 0;

            dlgProgress.Close;
        end;
    end;

    local procedure AddPurchaseOrderAttachment(PurchHeader: Record "Purchase Header"; AttachmentName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        ReportPurchaseHeader: Record "Purchase Header";
        PurchaseHeaderRef: RecordRef;
        PdfOutStream: OutStream;
        PdfInStream: InStream;
        EmptyReportErr: Label 'Report %1 generated an empty PDF for purchase order %2.', Comment = '%1 = report ID, %2 = purchase order number';
    begin
        EMailSetup.TestField("Order Report ID");
        ReportPurchaseHeader.SetRange("Document Type", PurchHeader."Document Type");
        ReportPurchaseHeader.SetRange("No.", PurchHeader."No.");
        PurchaseHeaderRef.GetTable(ReportPurchaseHeader);
        TempBlob.CreateOutStream(PdfOutStream);

        Report.SaveAs(EMailSetup."Order Report ID", '', ReportFormat::Pdf, PdfOutStream, PurchaseHeaderRef);
        if not TempBlob.HasValue() then
            Error(EmptyReportErr, EMailSetup."Order Report ID", PurchHeader."No.");

        TempBlob.CreateInStream(PdfInStream);
        EmailMessage.AddAttachment(AttachmentName, 'application/pdf', PdfInStream);
    end;

    local procedure AddMakeCCEmail(PurchHeader: Record "Purchase Header")
    var
        ItemMakeMasterRec: Record "E3 Item Make Master";
        CCMail: Text;
    begin
        if PurchHeader."Item Make Code" = '' then
            exit;

        ItemMakeMasterRec.Reset();
        ItemMakeMasterRec.SetRange(Code, PurchHeader."Item Make Code");

        if not ItemMakeMasterRec.FindFirst() then
            exit;

        if ItemMakeMasterRec.LocalEmail = '' then
            exit;

        foreach CCMail in ItemMakeMasterRec.LocalEmail.Split(';') do begin
            CCMail := DelChr(CCMail, '<>', ' ');

            if CCMail <> '' then
                EmailMessage.AddRecipient(
                    Enum::"Email Recipient Type"::Cc,
                    CCMail);
        end;
        if ItemMakeMasterRec.RegEmail <> '' then
            foreach CCMail in ItemMakeMasterRec.RegEmail.Split(';') do begin
                CCMail := DelChr(CCMail, '<>', ' ');

                if CCMail <> '' then
                    EmailMessage.AddRecipient(
                        Enum::"Email Recipient Type"::Cc,
                        CCMail);
            end;
        if ItemMakeMasterRec.NatEmail <> '' then
            foreach CCMail in ItemMakeMasterRec.NatEmail.Split(';') do begin
                CCMail := DelChr(CCMail, '<>', ' ');

                if CCMail <> '' then
                    EmailMessage.AddRecipient(
                        Enum::"Email Recipient Type"::Cc,
                        CCMail);
            end;
        if ItemMakeMasterRec.Email <> '' then
            foreach CCMail in ItemMakeMasterRec.Email.Split(';') do begin
                CCMail := DelChr(CCMail, '<>', ' ');

                if CCMail <> '' then
                    EmailMessage.AddRecipient(
                        Enum::"Email Recipient Type"::Cc,
                        CCMail);
            end;
    end;

    var
        EMailSetup: Record "E3 HIS E-Mail Setup";
        PurchaseHeader1: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
        ItemMakeMaster: Record "E3 Item Make Master";
        FileNameVar1: Text[500];
        DocumentNo: Text[20];
        Postingdate: Text;
        EmailAccount: Record "Email Account";
        Subject: Text[1000];
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Mail: Codeunit Mail;
        Vendor: Record Vendor;
        TotalSend: Integer;
        dlgProgress: Dialog;
        Text002: TextConst ENN = 'Total E-Mail Send #1',
                             ENU = 'Total E-Mail Send #1';
        Addcc: List of [Text];
        ToEmailID: List of [Text];
        EmailItem: Record "Email Item";
        CCMail: Text;
        BCCMail: Text;
}
