codeunit 50019 "E3 Item Integration Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        case Rec."Parameter String" of
            'Item', 'item', 'ITEM':
                if E3APISetup."Item Master API Enabled" then
                    SyncItem(Rec);
            'FailOverItem', 'failoveritem', 'FAILOVERITEM':
                if E3APISetup."Item Master API Enabled" then
                    ItemUpdateToHIS();
        end;
    end;

    procedure ManualSendToJIMS(var E3Item: Record Item)
    var
        E3ItemLog: Record "E3 API Item Update Log";
    begin
        // Step 1: Create Log
        CreateItemLog(E3Item);

        // Step 2: Get latest pending log
        E3ItemLog.Reset();
        E3ItemLog.SetRange("No.", E3Item."No.");
        E3ItemLog.SetRange("Sync Status", E3ItemLog."Sync Status"::" ");

        if E3ItemLog.FindLast() then begin
            // Step 3: Send via Job Queue
            EnqueueItemJobEntry(E3ItemLog);
            Message('Item Log created and queued to send to JIMS.');
        end else
            Message('No pending log found.');
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";


    //[NonDebuggable]
    local procedure GetAuthorizationText(): Text
    var
        Base64Converter: Codeunit "Base64 Convert";
        Authorization: Text;
        BasicCred: Text;
    begin
        E3APISetup.get();
        E3APISetup.TestField(Username);
        E3APISetup.TestField(Password);

        BasicCred := E3APISetup.Username + ':' + E3APISetup.Password;
        Authorization := 'Basic ' + Base64Converter.ToBase64(BasicCred); //, TextEncoding::UTF8);

        exit(Authorization);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    local procedure E3ItemOnModify(var xRec: Record Item; var Rec: Record Item; RunTrigger: Boolean)
    var
        E3ItemLog: Record "E3 API Item Update Log";
        E3UpdateNeeded: Boolean;
        E3UniqueID: Integer;
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Item Master API Enabled" then
            exit;

        E3UpdateNeeded :=
          (Rec.Description <> xRec.Description) or
            (Rec."Description 2" <> xRec."Description 2") or
            (Rec."Base Unit of Measure" <> xRec."Base Unit of Measure") or
            (Rec."Item Category Code" <> xRec."Item Category Code") or
            (Rec."Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group") or
            (Rec.Blocked <> xRec.Blocked);


        if E3UpdateNeeded then
            CreateItemLog(Rec);
    end;

    local procedure CreateItemLog(ItemRec: Record Item)
    var
        ItemLog: Record "E3 API Item Update Log";
        LastLog: Record "E3 API Item Update Log";
        UniqueID: Integer;
    begin
        LastLog.Reset();
        LastLog.SetRange("No.", ItemRec."No.");
        LastLog.SetRange("Sync Status", LastLog."Sync Status"::" ");

        if LastLog.FindFirst() then begin
            ItemLog := LastLog;
            ItemLog.TransferFields(ItemRec);
            ItemLog.Modify(false);
        end else begin

            LastLog.Reset();
            LastLog.SetRange("No.", ItemRec."No.");

            if LastLog.FindLast() then
                UniqueID := LastLog."Unique Log No." + 1
            else
                UniqueID := 1;

            ItemLog.Init();
            ItemLog.TransferFields(ItemRec);
            ItemLog."Unique Log No." := UniqueID;
            ItemLog."Entry Type" := ItemLog."Entry Type"::Update;
            ItemLog.Insert();
        end;
    end;

    procedure EnqueueItemJobEntry(APIItemUpdateLog: Record "E3 API Item Update Log"): Guid
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobDesLbl: Label 'Item %1 - Update %2 ', Locked = true;
    begin
        Clear(JobQueueEntry.ID);
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"E3 Item Integration Mgmt.";
        JobQueueEntry."Parameter String" := 'Item';
        JobQueueEntry."Record ID to Process" := APIItemUpdateLog.RecordId;
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime + 30000;
        JobQueueEntry."Notify On Success" := true;
        JobQueueEntry."Job Queue Category Code" := '';
        JobQueueEntry.Description := StrSubstNo(JobDesLbl, APIItemUpdateLog."No.", Format(APIItemUpdateLog."Unique Log No."));
        JobQueueEntry."User Session ID" := SessionId();
        CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
        exit(JobQueueEntry.ID)
    end;

    local procedure SyncItem(var JobQueueEntry: Record "Job Queue Entry")
    var
        ItemLog: Record "E3 API Item Update Log";
        RecRef: RecordRef;
    begin
        JobQueueEntry.TestField("Record ID to Process");

        RecRef.Get(JobQueueEntry."Record ID to Process");
        RecRef.SetTable(ItemLog);

        ItemLog.Find();

        if ItemLog."Sync Status" <> ItemLog."Sync Status"::" " then
            exit;

        if SendItemDetails(ItemLog) then
            ItemLog.Modify(false)
        else
            Error(GetLastErrorText());
    end;

    local procedure ItemUpdateToHIS()
    var
        ItemUpdateLog: Record "E3 API Item Update Log";
        xItemUpdateLog: Record "E3 API Item Update Log";
    begin
        if not E3APISetup."Item Master API Enabled" then
            exit;

        xItemUpdateLog.Reset();
        xItemUpdateLog.SetRange("Sync Status", xItemUpdateLog."Sync Status"::" ");
        if xItemUpdateLog.FindSet() then
            repeat
                if SendItemDetails(xItemUpdateLog) then begin
                    ItemUpdateLog := xItemUpdateLog;
                    ItemUpdateLog.Modify(false);
                end;
            until xItemUpdateLog.Next() = 0;
    end;

    procedure SendItemDetails(var ItemUpdateLog: Record "E3 API Item Update Log"): Boolean
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
    begin
        E3APISetup.Get();
        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Item Master API Enabled" then
            exit;

        E3APISetup.TestField("Item Master API");

        Clear(JObject);
        Clear(JChildObj);
        Clear(JArray);

        JChildObj.Add('UniqueID', ItemUpdateLog."No.");
        JChildObj.Add('No. 2', ItemUpdateLog."No. 2");
        JChildObj.Add('ItemName', ItemUpdateLog.Description);
        JChildObj.Add('ItemName2', ItemUpdateLog."Description 2");
        JChildObj.Add('Type', ItemUpdateLog.Type);
        JChildObj.Add('BaseUnitofMeasure', ItemUpdateLog."Base Unit of Measure");
        JChildObj.Add('GST Group Code', ItemUpdateLog."GST Group Code");
        JChildObj.Add('HSN/SAC Code', ItemUpdateLog."HSN/SAC Code");
        JChildObj.Add('SalesUnitofMeasure', ItemUpdateLog."Sales Unit of Measure");
        JChildObj.Add('PurchUnitofMeasure', ItemUpdateLog."Purch. Unit of Measure");
        JChildObj.Add('ItemType', ItemUpdateLog."Item Type");
        JChildObj.Add('MaterialCategory', ItemUpdateLog."Material Category");
        JChildObj.Add('Strength', ItemUpdateLog."Strength");
        JChildObj.Add('MedicineGroup', ItemUpdateLog."Medicine Group");
        JChildObj.Add('MedicineCompany', ItemUpdateLog."Medicine Company");
        JChildObj.Add('RateMarginFix', ItemUpdateLog."Rate Margin Fix");
        JChildObj.Add('Model', ItemUpdateLog.Model);
        JChildObj.Add('Category', ItemUpdateLog.Category);
        JChildObj.Add('MedicineSubcategory', ItemUpdateLog."Medicine Subcategory");
        JChildObj.Add('MedicineManufacturer', ItemUpdateLog."Medicine Manufacturer");
        JChildObj.Add('Res.Group', ItemUpdateLog."Res. Group");
        JChildObj.Add('ItemProperty', ItemUpdateLog."Item Property");
        JChildObj.Add('SubGroupNature', ItemUpdateLog."Sub Group Nature");
        JChildObj.Add('Maker', ItemUpdateLog.Make);
        JChildObj.Add(('MedicineComponent'), ItemUpdateLog."Medicine Component");
        JChildObj.Add('Speciality', ItemUpdateLog.Speciality);
        JChildObj.Add('MaterialType', ItemUpdateLog."Material Type");
        JChildObj.Add('MedicineComposition', ItemUpdateLog."Medicine Composition");
        JChildObj.Add('SubGroupSite', ItemUpdateLog."Sub Group Site");
        JChildObj.Add('Packing', ItemUpdateLog.Packing);
        JChildObj.Add('Scheme', ItemUpdateLog.Scheme);
        JChildObj.Add('NarcoticsControlSubstances', ItemUpdateLog."Narcotics Control Substances");
        JChildObj.Add('IncudeinFreeQtyinSales', ItemUpdateLog."Incl Free Qty in Sale Rate");
        JChildObj.Add('SaleDiscountAllow', ItemUpdateLog."Sale Discount Allow");
        JChildObj.Add('SaleRateEditable', ItemUpdateLog."Sale Rate Editable");
        JChildObj.Add('AllowMRPDiscount', ItemUpdateLog."Allow MRP Discount");
        JChildObj.Add('ConsignmentItem', ItemUpdateLog."Consignment Item");
        JChildObj.Add('SaleReturnableItem', ItemUpdateLog."Sale Returnable Item");
        JChildObj.Add('QuatationRequired', ItemUpdateLog."Quatation Required");
        JChildObj.Add('Active', ItemUpdateLog.Active);
        JChildObj.Add('BarCodeActive', ItemUpdateLog."BarCode Active");
        JChildObj.Add('ProcessIndicator', 'R');
        JChildObj.Add('CreationDate', format(DT2Date(ItemUpdateLog."Last Modified Date Time"), 0, '<Day,2>-<Month,2>-<Year4>'));
        JChildObj.Add('CreationTime', format(DT2Time(ItemUpdateLog."Last Modified Date Time")));
        JChildObj.Add('ErrorMsg', '');
        JArray.Add(JChildObj);
        JObject.Add('ItemMaster', JArray);

        JObject.WriteTo(ReqPayload);

        if GuiAllowed then
            Message(ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpWebClient.DefaultRequestHeaders().Add('Authorization', GetAuthorizationText());
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Item Master API");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then begin
            ItemUpdateLog."Sync Status" := ItemUpdateLog."Sync Status"::Error;
            ItemUpdateLog."Error Message" := CopyStr(ResponseMessage.ReasonPhrase, 1, 250);
        end else begin
            HttpWebContent := ResponseMessage.Content;
            HttpWebContent.ReadAs(JsonResponse);

            if GuiAllowed then
                Message(JsonResponse);

            Clear(JObject);
            JObject.ReadFrom(JsonResponse);
            if JObject.SelectToken('ItemMasterStatus', JToken) then
                if JToken.IsArray then
                    JToken.AsArray().WriteTo(JsonResponse)
                else
                    JsonResponse := JToken.AsValue().AsText();

            Clear(JArray);
            Clear(JObject);
            Clear(JToken);
            JArray.ReadFrom(JsonResponse);
            for J := 0 to JArray.Count - 1 do begin
                JArray.Get(J, JToken);

                JObject := JToken.AsObject();
                IF JObject.SelectToken('ErrorMsg', CJToken) then
                    IsSuccess := CJToken.AsValue().AsText();

                if IsSuccess = 'Item Created Successfully' then begin
                    ItemUpdateLog."Sync Status" := ItemUpdateLog."Sync Status"::Synced;
                    exit(true);
                end;
            end;
        end;

        exit(false);
    end;
}
