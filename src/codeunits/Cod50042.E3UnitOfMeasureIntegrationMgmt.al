codeunit 50042 "E3 Unit Of Measure Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    procedure SendtoUOMLog(var E3UOMUpdateLog: Record "E3 Unit Of Measure Update Log")
    var
        E3UOMLog: Record "E3 Unit Of Measure Update Log";
    begin
        // Step 1: Create Log
        InsertUOMToLog(E3UOMUpdateLog);
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        UOMLog: Record "E3 Unit Of Measure Update Log";

    local procedure InsertUOMToLog(var InsertUOMToLog: Record "E3 Unit Of Measure Update Log")
    var
        UOMRec: Record "Unit of Measure";
        UOMLogRec: Record "E3 Unit Of Measure Update Log";
    begin
        UOMRec.Reset();

        if UOMRec.FindSet() then
            repeat
                UOMLogRec.Reset();
                UOMLogRec.SetRange(Code, UOMRec.Code);

                if not UOMLogRec.FindFirst() then begin
                    UOMLogRec.Init();
                    UOMLogRec.Code := UOMRec.Code;
                    UOMLogRec.Description := UOMRec.Description;
                    UOMLogRec."Sync Status" := UOMLogRec."Sync Status"::" ";
                    UOMLogRec."Error Message" := '';
                    UOMLogRec.Insert(true);
                end else begin
                    UOMLogRec.Description := UOMRec.Description;
                    UOMLogRec.Modify(true);
                end;
            until UOMRec.Next() = 0;
    end;

    procedure SendUOMDetails(var UOMUpdateLog: Record "E3 Unit Of Measure Update Log"): Boolean
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

        if not E3APISetup."UOM API Enabled" then
            exit(false);

        E3APISetup.TestField("UOM API");

        // Build JSON Request
        Clear(ItemObj);
        ItemObj.Add('code', 0);
        ItemObj.Add('unit', UOMUpdateLog.Code);
        ItemObj.Add('decimalPlaces', 0);
        ItemObj.Add('segment1', UOMUpdateLog.Description);
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');

        Clear(ItemArray);
        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_unitMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request Payload:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(E3APISetup."UOM API");

        ClearLastError();

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            UOMUpdateLog."Sync Status" := UOMUpdateLog."Sync Status"::Error;
            UOMUpdateLog."Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(UOMUpdateLog."Error Message"));
            UOMUpdateLog.Modify(true);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        if ResponseMessage.IsSuccessStatusCode then begin
            UOMUpdateLog."Sync Status" := UOMUpdateLog."Sync Status"::Synced;
            UOMUpdateLog."Error Message" := 'Created Successfully';
            UOMUpdateLog.Modify(true);
            exit(true);
        end else begin
            UOMUpdateLog."Sync Status" := UOMUpdateLog."Sync Status"::Error;
            UOMUpdateLog."Error Message" :=
                CopyStr(StrSubstNo('%1 - %2',
                    ResponseMessage.HttpStatusCode,
                    ResponseMessage.ReasonPhrase),
                    1,
                    MaxStrLen(UOMUpdateLog."Error Message"));
            UOMUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}