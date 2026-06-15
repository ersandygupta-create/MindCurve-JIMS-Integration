codeunit 50033 "E3 Item Speciality Mgmt."
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
        ItemSpecialityMast: Record "E3 Item Speciality Master";

    procedure SendItemSpecialityDetails(var ItemSpecialityUpdateLog: Record "E3 Item Speciality Master"): Boolean
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

        if not E3APISetup."Item Speciality API Enabled" then
            exit(false);

        E3APISetup.TestField("Item Speciality API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('code', Format(ItemSpecialityUpdateLog.Code));
        ItemObj.Add('name', Format(ItemSpecialityUpdateLog.Name));
        ItemObj.Add('segment1', 'string');
        ItemObj.Add('segment2', 'string');
        ItemObj.Add('segment3', 'string');

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_itemSpecialityMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Item Speciality API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        ItemSpecialityUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(ItemSpecialityUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_itemSpecialityMastStatus', ResponseToken) then begin

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
                        ItemSpecialityUpdateLog.IsSent := true;
                        ItemSpecialityUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(ItemSpecialityUpdateLog.Response));
                        ItemSpecialityUpdateLog."Last Sent" := CurrentDateTime;
                        ItemSpecialityUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            ItemSpecialityUpdateLog.IsSent := false;
            ItemSpecialityUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(ItemSpecialityUpdateLog.Response));
            ItemSpecialityUpdateLog."Last Sent" := CurrentDateTime;
            ItemSpecialityUpdateLog.Modify(true);
            exit(false);

        end else begin
            ItemSpecialityUpdateLog.IsSent := false;
            ItemSpecialityUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(ItemSpecialityUpdateLog.Response));
            ItemSpecialityUpdateLog."Last Sent" := CurrentDateTime;
            ItemSpecialityUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}