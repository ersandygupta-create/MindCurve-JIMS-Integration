codeunit 50040 "E3 HSN/SAC Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    procedure SendtoHSNLog(var E3HSNUpdateLog: Record "E3 HSN/SAC Log")
    var
        E3HSNLog: Record "E3 HSN/SAC Log";
    begin
        // Step 1: Create Log
        InsertHSNSACToLog(E3HSNUpdateLog);
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        HSNSACLog: Record "E3 HSN/SAC Log";

    local procedure InsertHSNSACToLog(var InsertHSNSACToLog: Record "E3 HSN/SAC Log")
    var
        HSNRec: Record "HSN/SAC";
        HSNLogRec: Record "E3 HSN/SAC Log";
    begin
        HSNRec.Reset();

        if HSNRec.FindSet() then
            repeat
                HSNLogRec.Reset();
                HSNLogRec.SetRange("GST Group Code", HSNRec."GST Group Code");
                HSNLogRec.SetRange(Code, HSNRec.Code);

                if not HSNLogRec.FindFirst() then begin
                    HSNLogRec.Init();
                    HSNLogRec."GST Group Code" := HSNRec."GST Group Code";
                    HSNLogRec.Code := HSNRec.Code;
                    HSNLogRec.Type := HSNRec.Type;
                    HSNLogRec.Description := HSNRec.Description;
                    HSNLogRec."Sync Status" := HSNLogRec."Sync Status"::" ";
                    HSNLogRec."Error Message" := '';
                    HSNLogRec.Insert(true);
                end else begin
                    HSNLogRec.Description := HSNRec.Description;
                    HSNLogRec.Modify(true);
                end;
            until HSNRec.Next() = 0;
    end;

    procedure SendHSNSACDetails(var HSNSACUpdateLog: Record "E3 HSN/SAC Log"): Boolean
    var
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RootObj: JsonObject;
        ItemArray: JsonArray;
        ItemObj: JsonObject;
        ReqPayload: Text;
        JsonResponse: Text;
    begin
        if not E3APISetup.Get() then
            exit(false);

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."HSN/SAC API Enabled" then
            exit(false);

        E3APISetup.TestField("HSN/SAC API");

        // Build JSON Request
        Clear(ItemObj);
        ItemObj.Add('code', HSNSACUpdateLog."GST Group Code");
        ItemObj.Add('name', HSNSACUpdateLog.Description);
        ItemObj.Add('hsn', HSNSACUpdateLog.Code);
        ItemObj.Add('segment1', Format(HSNSACUpdateLog.Type));
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');
        if HSNSACUpdateLog."Sync Status" = HSNSACUpdateLog."Sync Status"::Synced then
            ItemObj.Add('d365_Status', 'Update')
        else
            ItemObj.Add('d365_Status', 'New');


        Clear(ItemArray);
        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_hsnMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request Payload:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(E3APISetup."HSN/SAC API");

        ClearLastError();

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            HSNSACUpdateLog."Sync Status" := HSNSACUpdateLog."Sync Status"::Error;
            HSNSACUpdateLog."Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(HSNSACUpdateLog."Error Message"));
            HSNSACUpdateLog.Modify(true);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        if ResponseMessage.IsSuccessStatusCode then begin
            HSNSACUpdateLog."Sync Status" := HSNSACUpdateLog."Sync Status"::Synced;
            HSNSACUpdateLog."Error Message" := 'Created Successfully';
            HSNSACUpdateLog.Modify(true);
            exit(true);
        end else begin
            HSNSACUpdateLog."Sync Status" := HSNSACUpdateLog."Sync Status"::Error;
            HSNSACUpdateLog."Error Message" :=
                CopyStr(StrSubstNo('%1 - %2',
                    ResponseMessage.HttpStatusCode,
                    ResponseMessage.ReasonPhrase),
                    1,
                    MaxStrLen(HSNSACUpdateLog."Error Message"));
            HSNSACUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}