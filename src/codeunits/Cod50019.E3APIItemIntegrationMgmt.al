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
        CheckItemLog: Record "E3 API Item Update Log";
    begin
        // Step 1: Create Log
        CreateItemLog(E3Item);

        // Step 2: Get latest pending log
        E3ItemLog.Reset();
        E3ItemLog.SetRange("No.", E3Item."No.");
        E3ItemLog.SetRange("Sync Status", E3ItemLog."Sync Status"::" ");

        if E3ItemLog.FindLast() then begin
            CheckItemLog.Reset();
            CheckItemLog.SetRange("No.", E3Item."No.");
            if CheckItemLog.FindFirst() then begin
                if CheckItemLog."Sync Status" = CheckItemLog."Sync Status"::Synced then
                    E3ItemLog.D365_Status := 'Update'
                else
                    E3ItemLog.D365_Status := 'New';
            end else
                E3ItemLog.D365_Status := 'New';

            E3ItemLog.Modify(true);
            // Step 3: Send via Job Queue
            EnqueueItemJobEntry(E3ItemLog);
            Message('Item Log created and queued to send to JIMS.');
        end else
            Message('No pending log found.');
    end;

    procedure MultipleSendToJIMS(var E3Item: Record Item)
    var
        E3ItemLog: Record "E3 API Item Update Log";
        CheckItemLog: Record "E3 API Item Update Log";
    begin
        // Create Log
        CreateItemLog(E3Item);

        E3ItemLog.Reset();
        E3ItemLog.SetRange("No.", E3Item."No.");
        E3ItemLog.SetRange("Sync Status", E3ItemLog."Sync Status"::" ");

        if E3ItemLog.FindLast() then begin
            CheckItemLog.Reset();
            CheckItemLog.SetRange("No.", E3Item."No.");
            CheckItemLog.SetRange("Sync Status", CheckItemLog."Sync Status"::Synced);

            if CheckItemLog.FindFirst() then
                E3ItemLog.D365_Status := 'Update'
            else
                E3ItemLog.D365_Status := 'New';

            E3ItemLog.Modify(true);

        end;
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        ItemUOM: Record "Item Unit of Measure";
        JValue: JsonValue;


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
        ItemUOM: Record "Item Unit of Measure";
        UniqueID: Integer;
    begin
        LastLog.Reset();
        LastLog.SetRange("No.", ItemRec."No.");
        LastLog.SetRange("Sync Status", LastLog."Sync Status"::" ");


        if LastLog.FindFirst() then begin
            ItemLog := LastLog;
            ItemLog.TransferFields(ItemRec);

            // Purchase UOM Qty
            Clear(ItemUOM);
            if ItemUOM.Get(ItemRec."No.", ItemRec."Purch. Unit of Measure") then
                ItemLog."Purch. Qty. Per Rate" := ItemUOM."Qty. per Unit of Measure"
            else
                ItemLog."Purch. Qty. Per Rate" := 0;

            // Sales UOM Qty
            Clear(ItemUOM);
            if ItemUOM.Get(ItemRec."No.", ItemRec."Sales Unit of Measure") then
                ItemLog."Sale Qty. Per Rate" := ItemUOM."Qty. per Unit of Measure"
            else
                ItemLog."Sale Qty. Per Rate" := 0;

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

            // Purchase UOM Qty
            Clear(ItemUOM);
            if ItemUOM.Get(ItemRec."No.", ItemRec."Purch. Unit of Measure") then
                ItemLog."Purch. Qty. Per Rate" := ItemUOM."Qty. per Unit of Measure"
            else
                ItemLog."Purch. Qty. Per Rate" := 0;

            // Sales UOM Qty
            Clear(ItemUOM);
            if ItemUOM.Get(ItemRec."No.", ItemRec."Sales Unit of Measure") then
                ItemLog."Sale Qty. Per Rate" := ItemUOM."Qty. per Unit of Measure"
            else
                ItemLog."Sale Qty. Per Rate" := 0;

            ItemLog."Unique Log No." := UniqueID;
            ItemLog."Entry Type" := ItemLog."Entry Type"::Update;
            ItemLog.Insert(false);
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
        JChildObj.Add('code', Format(ItemUpdateLog."No."));
        JChildObj.Add('name', Format(ItemUpdateLog.Description));
        JChildObj.Add('displayName', Format(ItemUpdateLog.Name));
        JChildObj.Add('manualCode', Format(ItemUpdateLog."Manual Code"));
        JChildObj.Add('itemGroup', Format(ItemUpdateLog."Item Group Code"));
        JChildObj.Add('itemGroupName', Format(ItemUpdateLog."Item Group"));
        JChildObj.Add('itemMakeCode', Format(ItemUpdateLog."Item Make Code"));
        JChildObj.Add('itemMakeName', Format(ItemUpdateLog.Make));
        JChildObj.Add('itemCategoryCode', Format(ItemUpdateLog."Category Code"));
        JChildObj.Add('itemCategoryName', Format(ItemUpdateLog.Category));
        JChildObj.Add('allowNegativeStock', ItemUpdateLog."Allow Negative Stock");
        JChildObj.Add('purchaseUnit', Format(ItemUpdateLog."Purch. Unit of Measure"));
        JChildObj.Add('purchaseUnitName', Format(ItemUpdateLog."Purch. Unit of Measure Name"));
        JChildObj.Add('saleUnit', Format(ItemUpdateLog."Sales Unit of Measure"));
        JChildObj.Add('saleUnitName', Format(ItemUpdateLog."Sales Unit of Measure Name"));
        JChildObj.Add('purchaseUnitConversionRate', Format(ItemUpdateLog."Purch. Qty. Per Rate"));
        JChildObj.Add('saleUnitConversionRate', Format(ItemUpdateLog."Sale Qty. Per Rate"));
        JChildObj.Add('itemGSTNature', Format(ItemUpdateLog."HSN/SAC Type"));
        JChildObj.Add('propertyList', Format(ItemUpdateLog."Property List Code"));
        JChildObj.Add('propertyListName', Format(ItemUpdateLog."Property List Name"));
        JChildObj.Add('hsnCode', Format(ItemUpdateLog."HSN/SAC Code"));
        JChildObj.Add('subCode', '');
        JChildObj.Add('purchaseAc', '');
        JChildObj.Add('purchaseReturnAc', '');
        JChildObj.Add('salesAc', '');
        JChildObj.Add('salesReturnAc', '');
        JChildObj.Add('grIrAc', '');
        JChildObj.Add('consumptionAc', '');
        JChildObj.Add('cogsAc', '');
        JChildObj.Add('inTransitAc', '');
        JChildObj.Add('filterItemType', Format(ItemUpdateLog."Filter Item Type Code"));
        JChildObj.Add('filterItemTypeName', Format(ItemUpdateLog."Filter Item Type Name"));
        JChildObj.Add('itemType', Format(ItemUpdateLog."Item Type"));
        JChildObj.Add('itemTypeName', Format(ItemUpdateLog."Item Type Name"));
        JChildObj.Add('sku', Format(ItemUpdateLog."Base Unit of Measure"));
        JChildObj.Add('skuName', Format(ItemUpdateLog.SkuName));
        JChildObj.Add('itemPacking', Format(ItemUpdateLog.Packing));
        JChildObj.Add('isIndentMandatory', ItemUpdateLog."Is Indent Mandatory");
        JChildObj.Add('isCommon', ItemUpdateLog."Is Common");
        JChildObj.Add('isActive', ItemUpdateLog.IsActive);
        JChildObj.Add('preparedBy', Format(ItemUpdateLog."Prepared By"));
        JChildObj.Add('mrp', Format(ItemUpdateLog.MRP));
        JChildObj.Add('saleRate', Format(ItemUpdateLog."Sale Rate"));
        JChildObj.Add('purchaseRate', Format(ItemUpdateLog."Purchase Rate"));
        JChildObj.Add('schemeOnQty', Format(ItemUpdateLog."Scheme On Qty"));
        JChildObj.Add('schemeFreeQty', Format(ItemUpdateLog."Scheme Free Qty"));
        JChildObj.Add('purchaseDiscountPer', Format(ItemUpdateLog."Purchase Discount %"));
        JChildObj.Add('saleDiscountPer', Format(ItemUpdateLog."Sale Discount %"));
        JChildObj.Add('restrictGroup', Format(ItemUpdateLog."Res. Group Code"));
        JChildObj.Add('restrictGroupName', Format(ItemUpdateLog."Res. Group Name"));
        JChildObj.Add('isBarcodeActive', ItemUpdateLog."BarCode Active");
        JChildObj.Add('isLifeSaving', ItemUpdateLog."Is Life Saving");
        JChildObj.Add('isHighValue', ItemUpdateLog."Is High Value");
        JChildObj.Add('isFlowThrough', ItemUpdateLog."Is Flow Through");
        JChildObj.Add('isNarcotics', ItemUpdateLog."Narcotics Control Substances");
        JChildObj.Add('isConsignment', ItemUpdateLog."Consignment Item");
        JChildObj.Add('isReturnableItem', ItemUpdateLog."Sale Returnable Item");
        JChildObj.Add('isBilledItem', ItemUpdateLog."Is Billed Item");
        JChildObj.Add('isSaleRateEditable', ItemUpdateLog."Sale Rate Editable");
        JChildObj.Add('isIncludeFreeQtyInSaleRate', ItemUpdateLog."Incl Free Qty in Sale Rate");
        JChildObj.Add('isDiscountAllow', ItemUpdateLog."Sale Discount Allow");
        JChildObj.Add('isQuotationMandatory', ItemUpdateLog."Quatation Required");
        JChildObj.Add('itemSpecialityCode', Format(ItemUpdateLog."Item Speciality Code"));
        JChildObj.Add('itemSpecialityName', Format(ItemUpdateLog."Speciality Name"));
        JChildObj.Add('divisionCode', Format(ItemUpdateLog."Division Code"));
        JChildObj.Add('divisionName', Format(ItemUpdateLog."Division Name"));
        JChildObj.Add('manufacturerCode', Format(ItemUpdateLog."Medicine Manufacturer Code"));
        JChildObj.Add('manufacturerName', Format(ItemUpdateLog."Medicine Manufacturer Name"));
        JChildObj.Add('instruction', Format(ItemUpdateLog.Instruction));
        JChildObj.Add('regionalInstruction', Format(ItemUpdateLog."Regional Instruction"));
        JChildObj.Add('materialCategoryCode', Format(ItemUpdateLog."Material Category Code"));
        JChildObj.Add('materialCategoryName', Format(ItemUpdateLog."Material Category"));
        JChildObj.Add('marketingCompany', Format(ItemUpdateLog."Marketing Company Code"));
        JChildObj.Add('marketingCompanyName', Format(ItemUpdateLog."Marketing Company Name"));
        //JChildObj.Add('statusChangedDate', Format(CurrentDateTime(), 0, 9));
        JChildObj.Add('materialTypeCode', Format(ItemUpdateLog."Material Type Code"));
        JChildObj.Add('materialTypeName', Format(ItemUpdateLog."Material Type"));
        JChildObj.Add('model', Format(ItemUpdateLog.Model));
        JChildObj.Add('modelName', Format(ItemUpdateLog."Model Name"));
        JChildObj.Add('strength', Format(ItemUpdateLog."Strength Code"));
        JChildObj.Add('strengthName', Format(ItemUpdateLog.Strength));
        JChildObj.Add('remark', Format(ItemUpdateLog.Remarks));
        JChildObj.Add('taxPerc', Format(ItemUpdateLog."GST Group Code"));
        JChildObj.Add('subCategoryCode', Format(ItemUpdateLog."Medicine SubCategory Code"));
        JChildObj.Add('subCategoryCodeName', Format(ItemUpdateLog."Medicine SubCategory Name"));
        JChildObj.Add('allowMRPDiscPattern', ItemUpdateLog."Allow MRP Discount");
        JChildObj.Add('marginRateFix', Format(ItemUpdateLog."Margin Fix"));
        JChildObj.Add('segment1', '');
        JChildObj.Add('segment2', '');
        JChildObj.Add('segment3', '');
        JChildObj.Add('segment4', '');
        JChildObj.Add('segment5', '');
        JChildObj.Add('d365_Status', ItemUpdateLog.D365_Status);
        JChildObj.Add('hisCode', '');
        JValue.SetValueToNull();
        JChildObj.Add('hisTimestamp', JValue);
        JChildObj.Add('jpCode', '');
        JChildObj.Add('jpTimestamp', JValue);
        JChildObj.Add('ProcessIndicator', 'P');
        JChildObj.Add('processDatetime', Format(DT2Time(ItemUpdateLog."Last Modified Date Time")));
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
