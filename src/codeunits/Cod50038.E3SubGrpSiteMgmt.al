codeunit 50038 "E3 Sub Group Site Mgmt."
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
        ItemSubGrpSiteMast: Record "E3 Sub Group Site List";

    procedure SendSubGroupSiteListDetails(var SubGroupSiteListUpdateLog: Record "E3 Sub Group Site List"): Boolean
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

        if not E3APISetup."Sub Group Site API Enabled" then
            exit(false);

        E3APISetup.TestField("Sub Group Site API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('subCode', Format(SubGroupSiteListUpdateLog."Sub Code"));
        ItemObj.Add('site_Code', Format(SubGroupSiteListUpdateLog."Site Code"));
        ItemObj.Add('isOpdConsultant', Format(SubGroupSiteListUpdateLog."Is Opd Consultant"));
        ItemObj.Add('allowForSite', Format(SubGroupSiteListUpdateLog."Allow For Site"));
        ItemObj.Add('isIpdConsultant', Format(SubGroupSiteListUpdateLog."Is Ipd Consultant"));
        ItemObj.Add('drugLicenseNo', SubGroupSiteListUpdateLog."Drug License No.");
        ItemObj.Add('segment1', '');
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_subGroupSiteListMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Sub Group Site API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        SubGroupSiteListUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(SubGroupSiteListUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_subGroupSiteListStatus', ResponseToken) then begin

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
                        SubGroupSiteListUpdateLog.IsSent := true;
                        SubGroupSiteListUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(SubGroupSiteListUpdateLog.Response));
                        SubGroupSiteListUpdateLog."Last Sent" := CurrentDateTime;
                        SubGroupSiteListUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            SubGroupSiteListUpdateLog.IsSent := false;
            SubGroupSiteListUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(SubGroupSiteListUpdateLog.Response));
            SubGroupSiteListUpdateLog."Last Sent" := CurrentDateTime;
            SubGroupSiteListUpdateLog.Modify(true);
            exit(false);

        end else begin
            SubGroupSiteListUpdateLog.IsSent := false;
            SubGroupSiteListUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(SubGroupSiteListUpdateLog.Response));
            SubGroupSiteListUpdateLog."Last Sent" := CurrentDateTime;
            SubGroupSiteListUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}