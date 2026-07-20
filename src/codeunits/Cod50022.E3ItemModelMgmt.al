codeunit 50022 "E3 Item Model Mgmt."
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
        ItemModel: Record "E3 Item Model Master";

    procedure SendItemModelDetails(var ItemModelUpdateLog: Record "E3 Item Model Master"): Boolean
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

        if not E3APISetup."Item Model API Enabled" then
            exit(false);

        E3APISetup.TestField("Item Model API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('code', Format(ItemModelUpdateLog.Code));
        ItemObj.Add('name', Format(ItemModelUpdateLog.Name));
        ItemObj.Add('segment1', '');
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');
        if not ItemModelUpdateLog."First Sent" then
            ItemObj.Add('d365_Status', 'New')
        else
            ItemObj.Add('d365_Status', 'Update');

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_itemModelMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Item Model API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        ItemModelUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(ItemModelUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_itemModelMastStatus', ResponseToken) then begin

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
                        ItemModelUpdateLog.IsSent := true;
                        ItemModelUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(ItemModelUpdateLog.Response));
                        ItemModelUpdateLog."Last Sent" := CurrentDateTime;
                        ItemModelUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            ItemModelUpdateLog.IsSent := false;
            ItemModelUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(ItemModelUpdateLog.Response));
            ItemModelUpdateLog."Last Sent" := CurrentDateTime;
            ItemModelUpdateLog.Modify(true);
            exit(false);

        end else begin
            ItemModelUpdateLog.IsSent := false;
            ItemModelUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(ItemModelUpdateLog.Response));
            ItemModelUpdateLog."Last Sent" := CurrentDateTime;
            ItemModelUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}