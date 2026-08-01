codeunit 50018 "E3 Supplier Integration Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        case Rec."Parameter String" of
            'Supplier', 'supplier', 'SUPPLIER':
                if E3APISetup."Vendor Master API Enabled" then
                    SyncSupplier(Rec);
            'FailOverSupplier', 'failoversupplier', 'FAILOVERSUPPLIER':
                if E3APISetup."Vendor Master API Enabled" then
                    SupplierUpdateToHIS();
        end;
    end;

    procedure ManualSendToHIS(var Vend: Record "Order Address")
    var
        E3SupplierLog: Record "E3 API Supplier Update Log";
    begin
        // Step 1: Create Log
        CreateSupplierLog(Vend);

        // Step 2: Get latest pending log
        E3SupplierLog.Reset();
        E3SupplierLog.SetRange("No.", Vend."Vendor No.");
        E3SupplierLog.SetRange("Sync Status", E3SupplierLog."Sync Status"::" ");

        if E3SupplierLog.FindLast() then begin
            // Step 3: Send via Job Queue
            EnqueueVendorJobEntry(E3SupplierLog);
            Message('Supplier Log created and queued to send to HIS.');
        end else
            Message('No pending log found.');
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', false, false)]
    local procedure E3SupplierOnModify(var xRec: Record Vendor; var Rec: Record Vendor; RunTrigger: Boolean)
    var
        E3VendAddress: Record "Order Address";
        E3SupplierLog: Record "E3 API Supplier Update Log";
        E3VendBank: Record "Vendor Bank Account";
        E3UpdateNeeded: Boolean;
        E3UniqueID: Integer;
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Vendor Master API Enabled" then
            exit;

        E3UpdateNeeded :=
          (Rec.Name <> xRec.Name) or
          (Rec."Name 2" <> xRec."Name 2") or
          (Rec."Phone No." <> xRec."Phone No.") or
          (Rec."Mobile Phone No." <> xRec."Mobile Phone No.") or
          (Rec."Fax No." <> xRec."Fax No.") or
          (Rec."E-Mail" <> xRec."E-Mail") or
          (Rec."P.A.N. No." <> xRec."P.A.N. No.") or
          (Rec."Vendor Posting Group" <> xRec."Vendor Posting Group") or
          (Rec."Payment Terms Code" <> xRec."Payment Terms Code") or
          (Rec."Preferred Bank Account Code" <> xRec."Preferred Bank Account Code") or
          (Rec."GST Vendor Type" <> xRec."GST Vendor Type") or
          (Rec."DL No." <> xRec."DL No.");

        if E3UpdateNeeded then begin
            E3VendAddress.Reset();
            E3VendAddress.SetRange("Vendor No.", Rec."No.");
            if E3VendAddress.FindSet() then
                repeat
                    CreateSupplierLog(E3VendAddress);
                until E3VendAddress.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Order Address", 'OnAfterModifyEvent', '', false, false)]
    local procedure E3SupplierAddressOnModify(var xRec: Record "Order Address"; var Rec: Record "Order Address"; RunTrigger: Boolean)
    var

        E3UpdateNeeded: Boolean;
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Vendor Master API Enabled" then
            exit;

        E3UpdateNeeded :=
          (Rec.Name <> xRec.Name) or
          (Rec."Name 2" <> xRec."Name 2") or
          (Rec.Address <> xRec.Address) or
          (Rec."Address 2" <> xRec."Address 2") or
          (Rec.City <> xRec.City) or
          (Rec."Country/Region Code" <> xRec."Country/Region Code") or
          (Rec."Post Code" <> xRec."Post Code") or
          (Rec.State <> xRec.State) or
          (Rec."GST Registration No." <> xRec."GST Registration No.");

        if E3UpdateNeeded then
            CreateSupplierLog(Rec);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterModifyEvent', '', false, false)]
    local procedure E3SupplierBankAccOnModify(var xRec: Record "Vendor Bank Account"; var Rec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    var
        E3VendAddress: Record "Order Address";
        E3Vend: Record Vendor;
        E3VendBank: Record "Vendor Bank Account";
        E3UpdateNeeded: Boolean;
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Vendor Master API Enabled" then
            exit;

        E3Vend.Get(Rec."Vendor No.");
        if E3Vend."Preferred Bank Account Code" <> Rec.Code then
            exit;

        E3UpdateNeeded :=
          (Rec.Name <> xRec.Name) or
          (Rec.City <> xRec.City) or
          (Rec."Post Code" <> xRec."Post Code") or
          (Rec."Bank Account No." <> xRec."Bank Account No.") or
          (Rec."Bank Branch No." <> xRec."Bank Branch No.") or
          (Rec."E3 IFSC Code" <> xRec."E3 IFSC Code");

        if E3UpdateNeeded then begin
            E3VendAddress.Reset();
            E3VendAddress.SetRange("Vendor No.", Rec."Vendor No.");
            if E3VendAddress.FindSet() then
                repeat
                    CreateSupplierLog(E3VendAddress);
                until E3VendAddress.Next() = 0;
        end;
    end;

    procedure SupplierSyncAll(var VendRec: Record Vendor)
    var
        E3SupplierLog: Record "E3 API Supplier Update Log";
        xE3SupplierLog: Record "E3 API Supplier Update Log";
    begin
        CreateSupplierLog(VendRec);
        xE3SupplierLog.SetRange("No.", VendRec."No.");
        xE3SupplierLog.SetRange("Entry Type", xE3SupplierLog."Entry Type"::Update);
        xE3SupplierLog.SetRange("Sync Status", xE3SupplierLog."Sync Status"::" ");
        if xE3SupplierLog.FindFirst() then begin
            SendSupplierDetails(xE3SupplierLog);
            E3SupplierLog := xE3SupplierLog;
            E3SupplierLog.Modify(false);
        end;

    end;

    local procedure CreateSupplierLog(VendRec: Record Vendor)
    var
        E3SupplierLog: Record "E3 API Supplier Update Log";
        xE3SupplierLog: Record "E3 API Supplier Update Log";
        E3VendBank: Record "Vendor Bank Account";
        E3UniqueID: Integer;
    begin
        xE3SupplierLog.SetRange("No.", VendRec."No.");
        xE3SupplierLog.SetRange("Sync Status", xE3SupplierLog."Sync Status"::" ");
        if xE3SupplierLog.FindFirst() then begin
            E3SupplierLog.TransferFields(VendRec);
            E3SupplierLog."Unique Log No." := xE3SupplierLog."Unique Log No.";
        end else begin
            E3SupplierLog.SetRange("No.", VendRec."No.");
            if E3SupplierLog.FindLast() then
                E3UniqueID := E3SupplierLog."Unique Log No." + 1
            else
                E3UniqueID := 1;

            E3SupplierLog.Init();
            E3SupplierLog.TransferFields(VendRec);
            E3SupplierLog."Unique Log No." := E3UniqueID;
            E3SupplierLog."Entry Type" := E3SupplierLog."Entry Type"::Update;
            E3SupplierLog.Insert();
        end;

        if VendRec."Preferred Bank Account Code" <> '' then begin
            E3VendBank.get(VendRec."No.", VendRec."Preferred Bank Account Code");
            E3SupplierLog.BankAccountNo := E3VendBank."Bank Account No.";
            E3SupplierLog.BankAccountName := E3VendBank.Name;
            E3SupplierLog.BankBranchNo := E3VendBank."Bank Branch No.";
            E3SupplierLog.BankCity := E3VendBank.City;
            E3SupplierLog.BankPostCode := E3VendBank."Post Code";
            E3SupplierLog.IFSCCode := E3VendBank."E3 IFSC Code";
        end else begin
            E3SupplierLog.BankAccountNo := '';
            E3SupplierLog.BankAccountName := '';
            E3SupplierLog.BankBranchNo := '';
            E3SupplierLog.BankCity := '';
            E3SupplierLog.BankPostCode := '';
            E3SupplierLog.IFSCCode := '';
        end;
        E3SupplierLog.Modify(false);

        //EnqueueVendorJobEntry(E3SupplierLog);
    end;

    local procedure CreateSupplierLog(VendAddRec: Record "Order Address")
    var
        E3SupplierLog: Record "E3 API Supplier Update Log";
        xE3SupplierLog: Record "E3 API Supplier Update Log";
        TempVendRec: Record Vendor temporary;
        VendRec: Record Vendor;
        E3VendBank: Record "Vendor Bank Account";
        E3UniqueID: Integer;
    begin
        VendRec.get(VendAddRec."Vendor No.");

        TempVendRec.DeleteAll();
        TempVendRec.Init();
        TempVendRec := VendRec;
        TempVendRec.Insert(false);
        TempVendRec.Name := VendAddRec.Name;
        TempVendRec.Address := VendAddRec.Address;
        TempVendRec."Address 2" := VendAddRec."Address 2";
        TempVendRec.City := VendAddRec.City;
        TempVendRec."Post Code" := VendAddRec."Post Code";
        TempVendRec."Country/Region Code" := VendAddRec."Country/Region Code";
        TempVendRec."E-Mail" := VendAddRec."E-Mail";
        TempVendRec."State Code" := VendAddRec.State;
        TempVendRec."GST Registration No." := VendAddRec."GST Registration No.";
        TempVendRec.Modify(false);

        xE3SupplierLog.SetRange("No.", VendRec."No.");
        xE3SupplierLog.SetRange("Address Code", VendAddRec."Code");
        xE3SupplierLog.SetRange("Sync Status", xE3SupplierLog."Sync Status"::" ");
        if xE3SupplierLog.FindFirst() then begin
            E3SupplierLog.TransferFields(TempVendRec);
            E3SupplierLog.Name := VendAddRec.Name;
            E3SupplierLog."Unique Log No." := xE3SupplierLog."Unique Log No.";
            E3SupplierLog."Address Code" := VendAddRec."Code";
            E3SupplierLog."Address Name" := VendAddRec.Name;
            E3SupplierLog."E-Mail" := VendAddRec."E-Mail";
        end else begin
            E3SupplierLog.SetRange("No.", VendRec."No.");
            if E3SupplierLog.FindLast() then
                E3UniqueID := E3SupplierLog."Unique Log No." + 1
            else
                E3UniqueID := 1;

            E3SupplierLog.Init();
            E3SupplierLog.TransferFields(TempVendRec);
            E3SupplierLog."Unique Log No." := E3UniqueID;
            E3SupplierLog."Entry Type" := E3SupplierLog."Entry Type"::Update;
            E3SupplierLog."Address Code" := VendAddRec."Code";
            E3SupplierLog."Address Name" := VendAddRec.Name;
            E3SupplierLog.Insert();
        end;

        if VendRec."Preferred Bank Account Code" <> '' then begin
            E3VendBank.get(VendRec."No.", VendRec."Preferred Bank Account Code");
            E3SupplierLog.BankAccountNo := E3VendBank."Bank Account No.";
            E3SupplierLog.BankAccountName := E3VendBank.Name;
            E3SupplierLog.BankBranchNo := E3VendBank."Bank Branch No.";
            E3SupplierLog.BankCity := E3VendBank.City;
            E3SupplierLog.BankPostCode := E3VendBank."Post Code";
            E3SupplierLog.IFSCCode := E3VendBank."E3 IFSC Code";
        end else begin
            E3SupplierLog.BankAccountNo := '';
            E3SupplierLog.BankAccountName := '';
            E3SupplierLog.BankBranchNo := '';
            E3SupplierLog.BankCity := '';
            E3SupplierLog.BankPostCode := '';
            E3SupplierLog.IFSCCode := '';
        end;
        E3SupplierLog.Modify(false);

        //EnqueueVendorJobEntry(E3SupplierLog);
    end;

    procedure EnqueueVendorJobEntry(APIVendorUpdateLog: Record "E3 API Supplier Update Log"): Guid
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobDesLbl: Label 'Vendor %1 - Update %2 ', Locked = true;
    begin
        Clear(JobQueueEntry.ID);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"E3 Supplier Integration Mgmt.";
        JobQueueEntry."Parameter String" := 'SUPPLIER';
        JobQueueEntry."Record ID to Process" := APIVendorUpdateLog.RecordId;
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime + 30000;
        JobQueueEntry."Notify On Success" := true;
        JobQueueEntry."Job Queue Category Code" := '';
        JobQueueEntry.Description := StrSubstNo(JobDesLbl, APIVendorUpdateLog."No.", Format(APIVendorUpdateLog."Unique Log No."));
        JobQueueEntry."User Session ID" := SessionId();
        CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        exit(JobQueueEntry.ID)
    end;

    local procedure SyncSupplier(var JobQueueEntry: Record "Job Queue Entry")
    var
        E3SupplierLog: Record "E3 API Supplier Update Log";
        RecRef: RecordRef;
        SavedLockTimeout: Boolean;
    begin
        JobQueueEntry.TestField("Record ID to Process");
        RecRef.Get(JobQueueEntry."Record ID to Process");
        RecRef.SetTable(E3SupplierLog);
        E3SupplierLog.Find;

        if E3SupplierLog."Sync Status" <> E3SupplierLog."Sync Status"::" " then
            exit;

        SavedLockTimeout := LockTimeout;
        if not SendSupplierDetails(E3SupplierLog) then
            Error(GetLastErrorText())
        else
            E3SupplierLog.Modify(false);
        LockTimeout(SavedLockTimeout);
    end;

    local procedure SupplierUpdateToHIS()
    var
        SupplierUpdateLog: Record "E3 API Supplier Update Log";
        xSupplierUpdateLog: Record "E3 API Supplier Update Log";
    begin
        if not E3APISetup."Vendor Master API Enabled" then
            exit;

        xSupplierUpdateLog.Reset();
        xSupplierUpdateLog.SetRange("Sync Status", xSupplierUpdateLog."Sync Status"::" ");
        if xSupplierUpdateLog.FindSet() then
            repeat
                if SendSupplierDetails(xSupplierUpdateLog) then begin
                    SupplierUpdateLog := xSupplierUpdateLog;
                    SupplierUpdateLog.Modify(false);
                end;
            until xSupplierUpdateLog.Next() = 0;
    end;

    procedure SendSupplierDetails(var SupplierUpdateLog: Record "E3 API Supplier Update Log"): Boolean
    var
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        J: Integer;
        JArray: JsonArray;
        JChildObj: JsonObject;
        JObject: JsonObject;
        CJToken: JsonToken;
        JToken: JsonToken;
        ConnectionMsg: Label 'The web service returned an error message:\\Status code: %1\Description: %2';
        Authoriztion: Text;
        IsSuccess: Text;
        JsonResponse: Text;
        ReqPayload: Text;
        VendorBankAccount: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        PostCodeInt: Integer;
    begin
        E3APISetup.Get();
        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Vendor Master API Enabled" then
            exit;
        E3APISetup.TestField("Vendor Master API");

        Clear(VendorBankAccount);

        if Vendor.Get(SupplierUpdateLog."No.") then begin
            if Vendor."Preferred Bank Account Code" <> '' then begin
                VendorBankAccount.Reset();
                VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
                VendorBankAccount.SetRange(Code, Vendor."Preferred Bank Account Code");
                VendorBankAccount.FindFirst();
            end else begin
                VendorBankAccount.Reset();
                VendorBankAccount.SetRange("Vendor No.", Vendor."No.");
                VendorBankAccount.FindFirst();
            end;
        end;

        Clear(JObject);
        Clear(JChildObj);
        Clear(JArray);

        JChildObj.Add('supplierID', SupplierUpdateLog."Supplier ID");
        JChildObj.Add('supplierName', SupplierUpdateLog.Name);
        JChildObj.Add('supplierName2', SupplierUpdateLog."Name 2");
        JChildObj.Add('supplierAddress1', SupplierUpdateLog.Address);
        JChildObj.Add('supplierAddress2', SupplierUpdateLog."Address 2");
        if Evaluate(PostCodeInt, SupplierUpdateLog."Post Code") then
            JChildObj.Add('postCode', PostCodeInt)
        else
            JChildObj.Add('postCode', 0);
        JChildObj.Add('city', SupplierUpdateLog.City);
        JChildObj.Add('stateGSTCode', 0);
        JChildObj.Add('countryCode', SupplierUpdateLog."Country/Region Code");
        JChildObj.Add('country', SupplierUpdateLog."Country/Region Code");
        JChildObj.Add('contactNo', 0);
        JChildObj.Add('mobileNo', SupplierUpdateLog."Mobile Phone No.");
        JChildObj.Add('emailID', SupplierUpdateLog."E-Mail");
        JChildObj.Add('genBusPostingGroup', '');
        JChildObj.Add('vendorPostingGroup', SupplierUpdateLog."Vendor Posting Group");
        JChildObj.Add('gstVendorType', Format(SupplierUpdateLog."GST Vendor Type"));
        JChildObj.Add('gstNo', SupplierUpdateLog."GST Registration No.");
        JChildObj.Add('panno', SupplierUpdateLog."P.A.N. No.");
        JChildObj.Add('paymentTermCode', SupplierUpdateLog."Payment Terms Code");
        JChildObj.Add('facilityID', 0);
        JChildObj.Add('msmeType', '');
        JChildObj.Add('applicationMethod', Format(SupplierUpdateLog."Application Method"));
        JChildObj.Add('bankAccountNo', VendorBankAccount."Bank Account No.");
        JChildObj.Add('vcBankAccountName', VendorBankAccount.Name);
        JChildObj.Add('bankBranchNo', VendorBankAccount."Bank Branch No.");
        JChildObj.Add('ifscCode', VendorBankAccount."E3 IFSC Code");
        JChildObj.Add('bankPostCode', VendorBankAccount."Post Code");
        JChildObj.Add('bankCity', VendorBankAccount.City);
        JChildObj.Add('errorRemark', '');
        JChildObj.Add('navVendorCode', SupplierUpdateLog."No.");
        JChildObj.Add('msmeNo', '');
        JChildObj.Add('le', '');
        JChildObj.Add('instanceName', '');
        JChildObj.Add('isCreated', true);
        JChildObj.Add('createdDate', Format(SupplierUpdateLog."Last Modified Date Time", 0, 9));
        JChildObj.Add('processedDateTime', Format(CurrentDateTime, 0, 9));
        JChildObj.Add('remarks', '');
        JChildObj.Add('segment1', '');
        JChildObj.Add('segment2', '');
        JChildObj.Add('segment3', '');
        if SupplierUpdateLog."Sync Status" = SupplierUpdateLog."Sync Status"::" " then
            JChildObj.Add('d365_Status', 'New')
        else
            JChildObj.Add('d365_Status', 'Update');
        JChildObj.Add('ProcessIndicator', 'P');
        JChildObj.Add('CreationDate', format(DT2Date(SupplierUpdateLog."Last Modified Date Time"), 0, '<Day,2>-<Month,2>-<Year4>'));
        JChildObj.Add('CreationTime', format(DT2Time(SupplierUpdateLog."Last Modified Date Time")));
        JChildObj.Add('ErrorMsg', '');

        JArray.Add(JChildObj);
        JObject.Add('d365_VendorCat', JArray);

        JObject.WriteTo(ReqPayload);

        if GuiAllowed then
            Message(ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Vendor Master API");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);


        if not ResponseMessage.IsSuccessStatusCode then begin
            SupplierUpdateLog."Sync Status" := SupplierUpdateLog."Sync Status"::Error;
            SupplierUpdateLog."Error Message" := CopyStr(ResponseMessage.ReasonPhrase, 1, MaxStrLen(SupplierUpdateLog."Error Message"));
            SupplierUpdateLog.Modify();
        end else begin
            HttpWebContent := ResponseMessage.Content;
            HttpWebContent.ReadAs(JsonResponse);

            if GuiAllowed then
                Message(JsonResponse);

            Clear(JObject);
            JObject.ReadFrom(JsonResponse);

            if JObject.SelectToken('d365_VendorStatus', JToken) then
                if JToken.IsArray then
                    JToken.AsArray().WriteTo(JsonResponse)
                else
                    JsonResponse := JToken.AsValue().AsText();

            Clear(JArray);
            JArray.ReadFrom(JsonResponse);

            for J := 0 to JArray.Count - 1 do begin
                JArray.Get(J, JToken);
                JObject := JToken.AsObject();

                Clear(IsSuccess);

                // API returns errorMsg
                if JObject.SelectToken('errorMsg', CJToken) then
                    IsSuccess := CJToken.AsValue().AsText();

                if GuiAllowed then
                    Message('API Message: %1', IsSuccess);

                if (StrPos(UpperCase(IsSuccess), 'CREATED') > 0) or
                   (StrPos(UpperCase(IsSuccess), 'SUCCESS') > 0) then begin

                    SupplierUpdateLog."Sync Status" := SupplierUpdateLog."Sync Status"::Synced;
                    SupplierUpdateLog."Error Message" := 'Created Successfully';
                    SupplierUpdateLog.Modify();

                    exit(true);
                end else begin
                    SupplierUpdateLog."Sync Status" := SupplierUpdateLog."Sync Status"::Error;

                    if IsSuccess <> '' then
                        SupplierUpdateLog."Error Message" :=
                            CopyStr(IsSuccess, 1, MaxStrLen(SupplierUpdateLog."Error Message"))
                    else
                        SupplierUpdateLog."Error Message" := 'Unknown Error';

                    SupplierUpdateLog.Modify();
                end;
            end;
        end;

        exit(false);
    end;
}
