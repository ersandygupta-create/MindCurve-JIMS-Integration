codeunit 50037 "E3 Item Property List Mgmt."
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
        ItemPropertyMast: Record "E3 Property List";

    procedure SendItemPropertyListDetails(var ItemPropertyListUpdateLog: Record "E3 Property List"): Boolean
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

        if not E3APISetup."Item Property API Enabled" then
            exit(false);

        E3APISetup.TestField("Item Property API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('code', Format(ItemPropertyListUpdateLog.Code));
        ItemObj.Add('name', Format(ItemPropertyListUpdateLog.Name));
        ItemObj.Add('manualCode', ItemPropertyListUpdateLog."Manual Code");
        ItemObj.Add('segment1', 'string');
        ItemObj.Add('segment2', 'string');
        ItemObj.Add('segment3', 'string');

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_itemProperty', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Item Property API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        ItemPropertyListUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(ItemPropertyListUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_itemPropertyStatus', ResponseToken) then begin

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
                        ItemPropertyListUpdateLog.IsSent := true;
                        ItemPropertyListUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(ItemPropertyListUpdateLog.Response));
                        ItemPropertyListUpdateLog."Last Sent" := CurrentDateTime;
                        ItemPropertyListUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            ItemPropertyListUpdateLog.IsSent := false;
            ItemPropertyListUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(ItemPropertyListUpdateLog.Response));
            ItemPropertyListUpdateLog."Last Sent" := CurrentDateTime;
            ItemPropertyListUpdateLog.Modify(true);
            exit(false);

        end else begin
            ItemPropertyListUpdateLog.IsSent := false;
            ItemPropertyListUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(ItemPropertyListUpdateLog.Response));
            ItemPropertyListUpdateLog."Last Sent" := CurrentDateTime;
            ItemPropertyListUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}