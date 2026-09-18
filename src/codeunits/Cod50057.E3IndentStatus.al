codeunit 50057 "E3 Indent Status Mgmt."
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
        IndentLine: Record "E3 Indent Line";

    procedure SendIndentLineDetails(var IndentLineUpdateLog: Record "E3 Indent Line"): Boolean
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

        if not E3APISetup."Indent Status API Enabled" then
            exit(false);

        E3APISetup.TestField("Indent Status API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('docId', 0);
        ItemObj.Add('v_SNo', Format(IndentLineUpdateLog."SNo."));
        ItemObj.Add('businessUnitCode', IndentLineUpdateLog."Shortcut Dimension 1 Code");
        ItemObj.Add('itemCode', IndentLineUpdateLog."No.");
        ItemObj.Add('dm_itemCode', 0);
        ItemObj.Add('status', IndentLineUpdateLog.Status);
        ItemObj.Add('remark', IndentLineUpdateLog.Remarks);
        ItemObj.Add('uom', IndentLineUpdateLog."Unit of Measure");
        ItemObj.Add('qty', IndentLineUpdateLog."Approved Qty");
        ItemObj.Add('indentnumber', IndentLineUpdateLog."Document No.");
        ItemObj.Add('indentserialnumber', IndentLineUpdateLog."Entry No.");

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('header', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Indent Status API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        IndentLineUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(IndentLineUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_IndentStatusStatus', ResponseToken) then begin

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
                        IndentLineUpdateLog.IsSent := true;
                        IndentLineUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(IndentLineUpdateLog.Response));
                        IndentLineUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            IndentLineUpdateLog.IsSent := false;
            IndentLineUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(IndentLineUpdateLog.Response));
            IndentLineUpdateLog.Modify(true);
            exit(false);

        end else begin
            IndentLineUpdateLog.IsSent := false;
            IndentLineUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(IndentLineUpdateLog.Response));
            IndentLineUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}