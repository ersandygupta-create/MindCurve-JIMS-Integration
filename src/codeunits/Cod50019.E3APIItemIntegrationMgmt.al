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
        ItemUOM: Record "Item Unit of Measure";


    //[NonDebuggable]
    // local procedure GetAuthorizationText(): Text
    // var
    //     Base64Converter: Codeunit "Base64 Convert";
    //     Authorization: Text;
    //     BasicCred: Text;
    // begin
    //     E3APISetup.get();
    //     E3APISetup.TestField(Username);
    //     E3APISetup.TestField(Password);

    //     BasicCred := E3APISetup.Username + ':' + E3APISetup.Password;
    //     Authorization := 'Basic ' + Base64Converter.ToBase64(BasicCred); //, TextEncoding::UTF8);

    //     exit(Authorization);
    // end;

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
        itemUOM: Record "Item Unit of Measure";
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
            // itemUOM.Get(ItemRec."Purch. Unit of Measure");
            // ItemLog."Purch. Qty. Per Rate" := itemUOM."Qty. per Unit of Measure";
            // ItemLog.Get(ItemRec."Sales Unit of Measure");
            // ItemLog."Sale Qty. Per Rate" := itemUOM."Qty. per Unit of Measure";
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

        JChildObj.Add('code', ItemUpdateLog."No.");
        JChildObj.Add('name', ItemUpdateLog.Description);
        JChildObj.Add('displayName', ItemUpdateLog."Description 2");
        JChildObj.Add('manualCode', ItemUpdateLog."Manual Code");
        JChildObj.Add('itemDesc', ItemUpdateLog."Description 2");
        JChildObj.Add('itemType', Format(ItemUpdateLog.Type));
        JChildObj.Add('skuName', ItemUpdateLog."Base Unit of Measure");
        JChildObj.Add('purchaseUnitName', ItemUpdateLog."Purch. Unit of Measure");
        JChildObj.Add('saleUnitName', ItemUpdateLog."Sales Unit of Measure");
        JChildObj.Add('itemPacking', ItemUpdateLog.Packing);
        JChildObj.Add('purchaseUnitConversionRate', 0);
        JChildObj.Add('saleUnitConversionRate', 0);
        JChildObj.Add('hsnCode', Format(ItemUpdateLog."HSN/SAC Code"));
        JChildObj.Add('modelName', ItemUpdateLog.Model);
        JChildObj.Add('strengthName', ItemUpdateLog.Strength);
        JChildObj.Add('propertyList', ItemUpdateLog."Property List");
        JChildObj.Add('itemCategoryCodeName', ItemUpdateLog.Category);
        JChildObj.Add('subCategoryCodeName', ItemUpdateLog."Medicine SubCategory");
        JChildObj.Add('compositionCodeName', ItemUpdateLog."Medicine Composition");
        JChildObj.Add('materialCategoryCodeName', ItemUpdateLog."Material Category");
        JChildObj.Add('materialTypeCodeName', ItemUpdateLog."Material Type");
        JChildObj.Add('marketingCompanyName', ItemUpdateLog."Medicine Company");
        JChildObj.Add('itemGroupName', ItemUpdateLog."Item Group");
        JChildObj.Add('itemMakeCodeName', ItemUpdateLog.Make);
        JChildObj.Add('filterItemType', ItemUpdateLog."Filter Item Type");
        JChildObj.Add('manufacturerCodeName', ItemUpdateLog.Make);
        JChildObj.Add('isActive', ItemUpdateLog.Blocked);
        JChildObj.Add('isBarcodeActive', ItemUpdateLog."BarCode Active");
        JChildObj.Add('isConsignment', ItemUpdateLog."Consignment Item");
        JChildObj.Add('isNarcotics', ItemUpdateLog."Narcotics Control Substances");
        JChildObj.Add('isReturnableItem', ItemUpdateLog."Sale Returnable Item");
        JChildObj.Add('isSaleRateEditable', ItemUpdateLog."Sale Rate Editable");
        JChildObj.Add('isIncludeFreeQtyInSaleRate', ItemUpdateLog."Incl Free Qty in Sale Rate");
        JChildObj.Add('isDiscountAllow', ItemUpdateLog."Sale Discount Allow");
        JChildObj.Add('isQuotationMandatory', ItemUpdateLog."Quatation Required");
        JChildObj.Add('allowMRPDiscPattern', Format(ItemUpdateLog."Allow MRP Discount"));
        JChildObj.Add('marginRateFix', Format(ItemUpdateLog."Margin Fix"));
        JChildObj.Add('remark', '');
        JChildObj.Add('tl_ExcessPer', Format(ItemUpdateLog."Tolerance excess"));
        JChildObj.Add('tl_ShortagePer', Format(ItemUpdateLog."Tolerance Shortage"));
        JChildObj.Add('isStatus', '');
        JChildObj.Add('segment1', '');
        JChildObj.Add('segment2', '');
        JChildObj.Add('segment3', '');
        JChildObj.Add('segment4', '');
        JChildObj.Add('segment5', '');
        JChildObj.Add('ProcessIndicator', 'P');
        JChildObj.Add('processDatetime', format(DT2Time(ItemUpdateLog."Last Modified Date Time")));
        JChildObj.Add('ErrorMsg', '');
        JArray.Add(JChildObj);
        JObject.Add('d365_itemCat', JArray);

        JObject.WriteTo(ReqPayload);

        if GuiAllowed then
            Message(ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        //HttpWebClient.DefaultRequestHeaders().Add('Authorization', GetAuthorizationText());
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Item Master API");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then begin
            ItemUpdateLog."Sync Status" := ItemUpdateLog."Sync Status"::Error;
            ItemUpdateLog."Error Message" := CopyStr(ResponseMessage.ReasonPhrase, 1, MaxStrLen(ItemUpdateLog."Error Message"));
            ItemUpdateLog.Modify();
        end else begin
            HttpWebContent := ResponseMessage.Content;
            HttpWebContent.ReadAs(JsonResponse);

            if GuiAllowed then
                Message(JsonResponse);

            Clear(JObject);
            JObject.ReadFrom(JsonResponse);

            if JObject.SelectToken('d365_itemStatus', JToken) then
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

                    ItemUpdateLog."Sync Status" := ItemUpdateLog."Sync Status"::Synced;
                    ItemUpdateLog."Error Message" := 'Created Successfully';
                    ItemUpdateLog.Modify();

                    exit(true);
                end else begin
                    ItemUpdateLog."Sync Status" := ItemUpdateLog."Sync Status"::Error;

                    if IsSuccess <> '' then
                        ItemUpdateLog."Error Message" :=
                            CopyStr(IsSuccess, 1, MaxStrLen(ItemUpdateLog."Error Message"))
                    else
                        ItemUpdateLog."Error Message" := 'Unknown Error';

                    ItemUpdateLog.Modify();
                end;
            end;
        end;

        exit(false);
    end;
}
