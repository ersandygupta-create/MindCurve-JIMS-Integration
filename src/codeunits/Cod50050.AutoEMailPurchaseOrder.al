codeunit 50050 "E3 Purchase Order Auto E-Mail"
{
    Permissions = tabledata "Purchase Header" = rm;

    trigger OnRun()
    begin
        for i := 1 to 3 do begin
            PurchaseHeader1.Reset();
            PurchaseHeader1.SetRange("Document Type", PurchaseHeader1."Document Type"::Order);
            PurchaseHeader1.SetRange("E3 Send E-Mail", false);

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
                AddMakeEmail(PurchaseHeader1);
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

        // PurchHeader.SetRange(
        //     "E3 Select E-Mail",
        //     true);

        if PurchHeader.FindFirst() then begin
            repeat

                EMailSetup.Get();

                PurchaseHeader1.Reset();
                PurchaseHeader1.SetRange("Document Type", PurchHeader."Document Type");
                PurchaseHeader1.SetRange("No.", PurchHeader."No.");
                if PurchaseHeader1.FindFirst() then begin
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
                            AddMakeEmail(PurchaseHeader1);
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

    local procedure AddMakeEmail(PurchHeader: Record "Purchase Header")
    begin
        if PurchHeader."Item Make Code" = '' then
            exit;

        if not ItemMakeMaster.Get(
            PurchHeader."Item Make Code")
        then
            exit;

        if ItemMakeMaster.LocalEmail <> '' then
            foreach CCMail in
                ItemMakeMaster.LocalEmail.Split(';')
            do begin
                CCMail := DelChr(CCMail, '<>', ' ');

                if CCMail <> '' then
                    EmailMessage.AddRecipient(
                        Enum::"Email Recipient Type"::Cc,
                        CCMail);
            end;

        if ItemMakeMaster.RegEmail <> '' then
            foreach CCMail in
                ItemMakeMaster.RegEmail.Split(';')
            do begin
                CCMail := DelChr(CCMail, '<>', ' ');

                if CCMail <> '' then
                    EmailMessage.AddRecipient(
                        Enum::"Email Recipient Type"::Cc,
                        CCMail);
            end;

        // National Email - CC
        if ItemMakeMaster.NatEmail <> '' then
            foreach CCMail in
                ItemMakeMaster.NatEmail.Split(';')
            do begin
                CCMail := DelChr(CCMail, '<>', ' ');

                if CCMail <> '' then
                    EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, CCMail);
            end;

        if ItemMakeMaster.Email <> '' then
            foreach BCCMail in
                ItemMakeMaster.Email.Split(';')
            do begin
                BCCMail := DelChr(BCCMail, '<>', ' ');

                if BCCMail <> '' then
                    EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Bcc, BCCMail);
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