codeunit 50050 "E3 Purchase Order Auto E-Mail"
{
    Permissions = tabledata "Purchase Header" = rm;

    trigger OnRun()
    begin
        for i := 1 to 3 do begin
            PurchaseHeader1.Reset();
            PurchaseHeader1.SetRange("Document Type", PurchaseHeader1."Document Type"::Order);
            PurchaseHeader1.SetRange("E3 Send E-Mail", false);
            PurchaseHeader1.SetRange(Status, PurchaseHeader1.Status::Released);

            if PurchaseHeader1.FindSet() then
                repeat
                    SendMailforPurchaseOrderJob(PurchaseHeader1);

                    i := i + 1;

                    if i = 3 then
                        break;

                until PurchaseHeader1.Next() = 0;
        end;
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

            Vendor.Get(PurchaseHeader1."Buy-from Vendor No.");
            if Vendor."Send Order Email" then begin
                if Vendor."Order Email" <> '' then //begin

                    DocumentNo := DelChr(PurchaseHeader1."No.", '=', '\,/,-');
                Postingdate := UpperCase(Format(PurchaseHeader1."Order Date", 0, '<Day,2>-<Month Text,3>-<Year,2>'));
                FileNameVar1 := EMailSetup."Folder Path" + DocumentNo + '-' + Postingdate;
                RecRef.GetTable(PurchaseHeader1);
                TempBlob.CreateOutStream(Out);
                TempBlob.CreateInStream(InStr);

                Report.SaveAs(EMailSetup."Order Report ID", FileNameVar1, ReportFormat::Pdf, Out, RecRef);
                Subject := 'Purchase Order' + ' - ' + PurchaseHeader1."No." + ' [' + PurchaseHeader1."Buy-from Vendor No." + ' - ' +
                    PurchaseHeader1."Buy-from Vendor Name" + '] ';
                EmailMessage.Create(Vendor."Order Email", Subject, EMailSetup."Order E-Mail Body", false);
                Clear(Addcc);
                AddMakeCCEmail(PurchaseHeader1);

                EmailMessage.AddAttachment(FileNameVar1 + '.pdf', 'PDF', InStr);
                Email.Send(EmailMessage, Enum::"Email Scenario"::"Hospital E-Mail");
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
                                RecRef.GetTable(PurchaseHeader1);
                                TempBlob.CreateOutStream(Out);
                                TempBlob.CreateInStream(InStr);

                                Report.SaveAs(EMailSetup."Order Report ID", FileNameVar1, ReportFormat::Pdf, Out, RecRef);
                                Subject := 'Purchase Order' + ' - ' + PurchaseHeader1."No." + ' [' + ' - ' + PurchaseHeader1."Buy-from Vendor Name" + '] ';
                                EmailMessage.Create(Vendor."Order Email", Subject, EMailSetup."Order E-Mail Body", false);
                                Clear(Addcc);
                                AddMakeCCEmail(PurchaseHeader1);
                                EmailMessage.AddAttachment(FileNameVar1 + '.pdf', 'PDF', InStr);
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
        TempBlob: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
        InStr: InStream;
        Addcc: List of [Text];
        ToEmailID: List of [Text];
        EmailItem: Record "Email Item";
        i: Integer;
        CCMail: Text;
        BCCMail: Text;
}