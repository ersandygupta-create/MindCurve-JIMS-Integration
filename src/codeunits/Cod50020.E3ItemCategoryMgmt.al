codeunit 50020 "E3 Item Category Mgmt."
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
        ItemCategory: Record "E3 Item Category Master";


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

    procedure SendItemCategoryDetails(var ItemCategoryUpdateLog: Record "E3 Item Category Master"): Boolean
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

        if not E3APISetup."Item Category API Enabled" then
            exit(false);

        E3APISetup.TestField("Item Category API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('code', Format(ItemCategoryUpdateLog.Code));
        ItemObj.Add('name', Format(ItemCategoryUpdateLog.Name));
        ItemObj.Add('saleRateProffitMargine', ItemCategoryUpdateLog.SaleRateProfitMargin);
        ItemObj.Add('filterItemType', ItemCategoryUpdateLog."Filter Item Type");
        ItemObj.Add('segment1', '');
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');
        if not ItemCategoryUpdateLog."First Sent" then
            ItemObj.Add('d365_Status', 'New')
        else
            ItemObj.Add('d365_Status', 'Update');

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('D365_itemCat', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Item Category API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        ItemCategoryUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(ItemCategoryUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            if ResponseRoot.SelectToken('d365_itemCatStatus', ResponseToken) then begin

                Clear(ResponseArray);
                ResponseToken.AsArray().WriteTo(JsonResponse);
                ResponseArray.ReadFrom(JsonResponse);

                for J := 0 to ResponseArray.Count - 1 do begin
                    ResponseArray.Get(J, ResponseToken);

                    ChildObj := ResponseToken.AsObject();

                    if ChildObj.SelectToken('errorMsg', CJToken) then
                        ResponseMsg := CJToken.AsValue().AsText();

                    if ResponseMsg = 'Created Successfully' then begin
                        ItemCategoryUpdateLog.IsSent := true;
                        ItemCategoryUpdateLog."Last Sent" := CurrentDateTime;
                        ItemCategoryUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            ItemCategoryUpdateLog.IsSent := false;
            ItemCategoryUpdateLog."Last Sent" := CurrentDateTime;
            ItemCategoryUpdateLog.Modify(true);
            exit(false);

        end else begin
            ItemCategoryUpdateLog.IsSent := false;
            ItemCategoryUpdateLog."Last Sent" := CurrentDateTime;
            ItemCategoryUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}