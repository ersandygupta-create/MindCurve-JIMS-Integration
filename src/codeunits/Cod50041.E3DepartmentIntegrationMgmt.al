codeunit 50041 "E3 Dimension Value Mgmt."
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    procedure SendToDimensionLog(var DimensionUpdateLog: Record "E3 Dimension Value Log")
    begin
        InsertDimensionValueToLog(DimensionUpdateLog);
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";

    local procedure InsertDimensionValueToLog(var DimensionUpdateLog: Record "E3 Dimension Value Log")
    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DimLogRec: Record "E3 Dimension Value Log";
    begin
        GLSetup.Get();
        GLSetup.TestField("Global Dimension 2 Code");

        DimValue.Reset();
        DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");

        if DimValue.FindSet() then
            repeat
                DimLogRec.Reset();
                DimLogRec.SetRange("Dimension Code", DimValue."Dimension Code");
                DimLogRec.SetRange(Code, DimValue.Code);

                if not DimLogRec.FindFirst() then begin
                    DimLogRec.Init();
                    DimLogRec."Dimension Code" := DimValue."Dimension Code";
                    DimLogRec.Code := DimValue.Code;
                    DimLogRec.Name := DimValue.Name;
                    DimLogRec."Sync Status" := DimLogRec."Sync Status"::" ";
                    DimLogRec."Error Message" := '';
                    DimLogRec.Insert();
                end else begin
                    DimLogRec.Name := DimValue.Name;
                    DimLogRec.Modify();
                end;
            until DimValue.Next() = 0;
    end;

    procedure SendDimensionValueDetails(var DimensionUpdateLog: Record "E3 Dimension Value Log"): Boolean
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

        if not E3APISetup."Department API Enabled" then
            exit(false);

        E3APISetup.TestField("Department API");

        Clear(ItemObj);
        ItemObj.Add('code', DimensionUpdateLog.Code);
        ItemObj.Add('name', DimensionUpdateLog.Name);
        ItemObj.Add('segment1', '');
        ItemObj.Add('segment2', '');
        ItemObj.Add('segment3', '');
        ItemObj.Add('hiS_Code', '');
        if not DimensionUpdateLog."First Sent" then
            ItemObj.Add('d365_Status', 'New')
        else
            ItemObj.Add('d365_Status', 'Update');
        ItemObj.Add('d365_Timestamp', Format(CurrentDateTime(), 0, 9));
        ItemObj.Add('ProcessIndicator', 'P');
        ItemObj.Add('processDate', format(DT2Date(DimensionUpdateLog."Created Date Time"), 0, '<Day,2>-<Month,2>-<Year4>'));
        ItemObj.Add('processtime', format(DT2Time(DimensionUpdateLog."Created Date Time")));
        ItemObj.Add('ErrorMsg', '');

        Clear(ItemArray);
        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_Department', ItemArray);

        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request Payload:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(E3APISetup."Department API");

        ClearLastError();

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            DimensionUpdateLog."Sync Status" := DimensionUpdateLog."Sync Status"::Error;
            DimensionUpdateLog."Error Message" :=
                CopyStr(GetLastErrorText(), 1, MaxStrLen(DimensionUpdateLog."Error Message"));
            DimensionUpdateLog.Modify(true);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        if ResponseMessage.IsSuccessStatusCode then begin
            DimensionUpdateLog."Sync Status" := DimensionUpdateLog."Sync Status"::Synced;
            DimensionUpdateLog."Error Message" := 'Created Successfully';
            DimensionUpdateLog.Modify(true);
            exit(true);
        end else begin
            DimensionUpdateLog."Sync Status" := DimensionUpdateLog."Sync Status"::Error;
            DimensionUpdateLog."Error Message" :=
                CopyStr(
                    StrSubstNo('%1 - %2',
                    ResponseMessage.HttpStatusCode,
                    ResponseMessage.ReasonPhrase),
                    1,
                    MaxStrLen(DimensionUpdateLog."Error Message"));

            DimensionUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}