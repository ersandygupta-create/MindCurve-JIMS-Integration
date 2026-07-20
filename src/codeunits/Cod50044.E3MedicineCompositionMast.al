codeunit 50044 "E3 Medicine Composition Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        MedicineCompositionMast: Record "E3 Medicine Composition";
        JValue: JsonValue;
        ItemLog: Record "E3 API Item Update Log";

    procedure SendMedicineCompositionMastDetails(var MedicineCompositionMastUpdateLog: Record "E3 Medicine Composition"): Boolean
    var
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;

        RootObj: JsonObject;
        ItemArray: JsonArray;
        ItemObj: JsonObject;

        ResponseRoot: JsonObject;
        ResponseArray: JsonArray;
        ResponseToken: JsonToken;
        ChildObj: JsonObject;
        CJToken: JsonToken;

        ReqPayload: Text;
        JsonResponse: Text;
        ResponseMsg: Text;
        J: Integer;
    begin
        E3APISetup.Get();

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."Medi Composition API Enabled" then
            exit(false);

        E3APISetup.TestField("Medicine Composition API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('code', MedicineCompositionMastUpdateLog.Code);
        ItemObj.Add('lineNo', MedicineCompositionMastUpdateLog."Line No.");
        ItemObj.Add('medicineComponentCode', Format(MedicineCompositionMastUpdateLog."Medicine Component Code"));
        ItemObj.Add('isBase', MedicineCompositionMastUpdateLog.IsBase);
        ItemObj.Add('power', MedicineCompositionMastUpdateLog.Power);
        ItemObj.Add('isSent', MedicineCompositionMastUpdateLog.IsBase);
        ItemObj.Add('unitOfMeasure', MedicineCompositionMastUpdateLog."Unit Of Measure");
        ItemObj.Add('itemName', MedicineCompositionMastUpdateLog."Item Name");
        ItemObj.Add('medicineComponentName', MedicineCompositionMastUpdateLog."Medicine Component Name");
        if not MedicineCompositionMastUpdateLog."First Sent" then
            ItemObj.Add('d365_Status', 'New')
        else
            ItemObj.Add('d365_Status', 'Update');

        ItemObj.Add('d365_Timestamp', JValue);
        ItemObj.Add('hisCode', '');
        JValue.SetValueToNull();
        ItemObj.Add('hisTimestamp', JValue);
        ItemObj.Add('jpCode', '');
        ItemObj.Add('jpTimestamp', JValue);
        ItemObj.Add('segment1', '');
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');
        ItemObj.Add('segment4', '');
        ItemObj.Add('segment5', '');

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_itemCat', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Medicine Composition API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save Compositionlete response initially
        MedicineCompositionMastUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(MedicineCompositionMastUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_ItemMedicineComponentStatus', ResponseToken) then begin

                Clear(ResponseArray);
                ResponseToken.AsArray().WriteTo(JsonResponse);
                ResponseArray.ReadFrom(JsonResponse);

                for J := 0 to ResponseArray.Count - 1 do begin
                    ResponseArray.Get(J, ResponseToken);

                    ChildObj := ResponseToken.AsObject();

                    Clear(ResponseMsg);
                    if ChildObj.SelectToken('errorMsg', CJToken) then
                        ResponseMsg := CJToken.AsValue().AsText();

                    if ResponseMsg = 'Created Successfully' then begin
                        MedicineCompositionMastUpdateLog.IsSent := true;
                        MedicineCompositionMastUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(MedicineCompositionMastUpdateLog.Response));
                        MedicineCompositionMastUpdateLog."Last Sent" := CurrentDateTime;
                        MedicineCompositionMastUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            MedicineCompositionMastUpdateLog.IsSent := false;
            MedicineCompositionMastUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(MedicineCompositionMastUpdateLog.Response));
            MedicineCompositionMastUpdateLog."Last Sent" := CurrentDateTime;
            MedicineCompositionMastUpdateLog.Modify(true);
            exit(false);

        end else begin
            MedicineCompositionMastUpdateLog.IsSent := false;
            MedicineCompositionMastUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(MedicineCompositionMastUpdateLog.Response));
            MedicineCompositionMastUpdateLog."Last Sent" := CurrentDateTime;
            MedicineCompositionMastUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}