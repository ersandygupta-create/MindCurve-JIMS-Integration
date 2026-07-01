codeunit 50039 "E3 State Master Mgmt."
{

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    procedure SendtoStateMasterLog(var E3StateMasterLog: Record "E3 State Master Log")
    var
        E3StateLog: Record "E3 State Master Log";
    begin
        // Step 1: Create Log
        InsertStateToLog(E3StateMasterLog);
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        StateMaster: Record "E3 State Master Log";

    local procedure InsertStateToLog(var E3StateLog: Record "E3 State Master Log")
    var
        StateRec: Record State;
        StateLogRec: Record "E3 State Master Log";
    begin
        StateRec.Reset();

        if StateRec.FindSet() then
            repeat
                StateLogRec.Reset();
                StateLogRec.SetRange(Code, StateRec.Code);

                if not StateLogRec.FindFirst() then begin
                    StateLogRec.Init();
                    StateLogRec.Code := StateRec.Code;
                    StateLogRec.Description := StateRec.Description;
                    StateLogRec."State Code (GST Reg. No.)" := StateRec."State Code (GST Reg. No.)";
                    StateLogRec."Sync Status" := StateLogRec."Sync Status"::" ";
                    StateLogRec."Error Message" := '';
                    StateLogRec.Insert();
                end else begin
                    StateLogRec.Description := StateRec.Description;
                    StateLogRec."State Code (GST Reg. No.)" := StateRec."State Code (GST Reg. No.)";
                    StateLogRec.Modify();
                end;
            until StateRec.Next() = 0;
    end;

    procedure SendStateMasterDetails(var StateMasterUpdateLog: Record "E3 State Master Log"): Boolean
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

        if not E3APISetup."State Master API Enabled" then
            exit(false);

        E3APISetup.TestField("State Master API");

        // Build JSON Request
        Clear(ItemObj);
        ItemObj.Add('id', 0);
        ItemObj.Add('stateName', StateMasterUpdateLog.Description);
        ItemObj.Add('stateCode', StateMasterUpdateLog."State Code (GST Reg. No.)");
        ItemObj.Add('stateShortName', StateMasterUpdateLog.Code);
        ItemObj.Add('le', '');
        ItemObj.Add('instanceName', '');
        ItemObj.Add('isCreated', true);
        ItemObj.Add('createdDateTime',
            Format(StateMasterUpdateLog."Created Date Time", 0,
            '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        ItemObj.Add('processedDateTime',
            Format(StateMasterUpdateLog."Processed Date Time", 0,
            '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        ItemObj.Add('remarks', '');
        ItemObj.Add('segment1', StateMasterUpdateLog.Code);
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');

        Clear(ItemArray);
        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_StateMaster', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request Payload:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(E3APISetup."State Master API");

        ClearLastError();

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            StateMasterUpdateLog."Sync Status" := StateMasterUpdateLog."Sync Status"::Error;
            StateMasterUpdateLog."Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(StateMasterUpdateLog."Error Message"));
            StateMasterUpdateLog.Modify(true);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        if ResponseMessage.IsSuccessStatusCode then begin
            StateMasterUpdateLog."Sync Status" := StateMasterUpdateLog."Sync Status"::Synced;
            StateMasterUpdateLog."Error Message" := 'Created Successfully';
            StateMasterUpdateLog."Processed Date Time" := CurrentDateTime;
            StateMasterUpdateLog.Modify(true);
            exit(true);
        end else begin
            StateMasterUpdateLog."Sync Status" := StateMasterUpdateLog."Sync Status"::Error;
            StateMasterUpdateLog."Error Message" :=
                CopyStr(StrSubstNo('%1 - %2',
                    ResponseMessage.HttpStatusCode,
                    ResponseMessage.ReasonPhrase),
                    1,
                    MaxStrLen(StateMasterUpdateLog."Error Message"));
            StateMasterUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}