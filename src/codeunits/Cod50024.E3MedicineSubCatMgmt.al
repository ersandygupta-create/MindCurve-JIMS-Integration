codeunit 50024 "E3 Medicine Sub-Category Mgmt."
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
        ItemMedicineSubGrp: Record "E3 Medicine Sub-Category Mast";

    procedure SendItemMedicineSubCatDetails(var MedicineSubCatUpdateLog: Record "E3 Medicine Sub-Category Mast"): Boolean
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

        if not E3APISetup."Medicine SubCat API Enabled" then
            exit(false);

        E3APISetup.TestField("Medicine SubCat API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('code', Format(MedicineSubCatUpdateLog.Code));
        ItemObj.Add('name', Format(MedicineSubCatUpdateLog.Name));
        ItemObj.Add('segment1', '');
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');
        if not MedicineSubCatUpdateLog."First Sent" then
            ItemObj.Add('d365_Status', 'New')
        else
            ItemObj.Add('d365_Status', 'Update');


        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_medicineSubCategoryMastMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Medicine SubCat API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        MedicineSubCatUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(MedicineSubCatUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_medicineSubCategoryMastStatus', ResponseToken) then begin

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
                        MedicineSubCatUpdateLog.IsSent := true;
                        MedicineSubCatUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(MedicineSubCatUpdateLog.Response));
                        MedicineSubCatUpdateLog."Last Sent" := CurrentDateTime;
                        MedicineSubCatUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            MedicineSubCatUpdateLog.IsSent := false;
            MedicineSubCatUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(MedicineSubCatUpdateLog.Response));
            MedicineSubCatUpdateLog."Last Sent" := CurrentDateTime;
            MedicineSubCatUpdateLog.Modify(true);
            exit(false);

        end else begin
            MedicineSubCatUpdateLog.IsSent := false;
            MedicineSubCatUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(MedicineSubCatUpdateLog.Response));
            MedicineSubCatUpdateLog."Last Sent" := CurrentDateTime;
            MedicineSubCatUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}