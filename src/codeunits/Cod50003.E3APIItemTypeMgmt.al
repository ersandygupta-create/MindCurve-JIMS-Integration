codeunit 50003 "E3 API Integration Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin

    end;

    var
        E3ApiSetup: Record "E3 Integration API Setup";


    [NonDebuggable]
    local procedure GetAuthorizationText(): Text
    var
        Base64Converter: Codeunit "Base64 Convert";
        Authorization: Text;
        BasicCred: Text;
    begin
        E3ApiSetup.get();
        E3ApiSetup.TestField(Username);
        E3ApiSetup.TestField(Password);

        BasicCred := E3ApiSetup.Username + ':' + E3ApiSetup.Password;
        Authorization := 'Basic ' + Base64Converter.ToBase64(BasicCred);

        exit(Authorization);
    end;

    procedure SendItemTypeDetails(Var E3ItemType: Record "E3 Item Type"): Boolean
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
        E3ApiSetup.Get();
        if not E3ApiSetup."Integration Enabled" then
            exit;

        if not E3ApiSetup."Item Type API Enabled" then
            exit;

        E3ApiSetup.TestField("Item Type API");

        Clear(JObject);
        Clear(JChildObj);
        Clear(JArray);

        JChildObj.Add('Code', E3ItemType.Code);
        JChildObj.Add('Name', E3ItemType.Name);
        JChildObj.Add('ManualCode', E3ItemType."Manual Code");
        JChildObj.Add('IsSent', E3ItemType.IsSent);
        JChildObj.Add('Response', E3ItemType.Response);
        JChildObj.Add('LastSent', E3ItemType."Last Sent");
        JArray.Add(JChildObj);
        JObject.Add('ItemType', JArray);
        JObject.WriteTo(ReqPayload);
        if GuiAllowed then
            Message(ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpWebClient.DefaultRequestHeaders().Add('Authorization', GetAuthorizationText());
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3ApiSetup."Item Type API");
        RequestMessage.Method := 'POST';
        HttpWebClient.Send(RequestMessage, ResponseMessage);

        if not ResponseMessage.IsSuccessStatusCode then
            E3ItemType.Response := CopyStr(ResponseMessage.ReasonPhrase, 1, 30)
        else begin
            HttpWebContent := ResponseMessage.Content;
            HttpWebContent.ReadAs(JsonResponse);

            if GuiAllowed then
                Message(JsonResponse);

            Clear(JObject);
            JObject.ReadFrom(JsonResponse);
            if JObject.SelectToken('ItemTypesStatus', JToken) then
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
                IF JObject.SelectToken('Response', CJToken) then
                    IsSuccess := CJToken.AsValue().AsText();

                if IsSuccess = 'Item Type Created Successfully' then begin
                    E3ItemType.IsSent := true;
                    exit(true);
                end;
            end;
        end;

        exit(false);
    end;
}
