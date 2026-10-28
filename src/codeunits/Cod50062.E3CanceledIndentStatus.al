codeunit 50062 "E3 Canceled Indent Status Mgmt"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;

        if not E3APISetup."Indent Status API Enabled" then
            exit;

        IndentLine.Reset();
        IndentLine.SetRange(IsSent, false);
        IndentLine.SetRange("PO Created", false);
        IndentLine.SetRange("SO Created", false);
        IndentLine.SetFilter("Cancel Indent Remark", '<>%1', '');
        IndentLine.SetFilter("SNo.", '<>%1', 0);

        if IndentLine.FindSet(true) then
            repeat
                ClearLastError();
                SendIndentCancelLineDetails(IndentLine);
            until IndentLine.Next() = 0;
    end;


    var
        E3APISetup: Record "E3 Integration API Setup";
        IndentLine: Record "E3 Indent Line";
        EntryNoText: Text;

    procedure SendIndentCancelLineDetails(var IndentLineUpdateLog: Record "E3 Indent Line"): Boolean
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
        HasData: Boolean;
    begin
        if not E3APISetup.Get() then
            exit(false);

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."Indent Status API Enabled" then
            exit(false);

        E3APISetup.TestField("Indent Status API");

        Clear(ItemArray);
        HasData := false;

        IndentLine.Reset();
        IndentLine.SetRange("Document No.", IndentLineUpdateLog."Document No.");
        IndentLine.SetRange("SNo.", IndentLineUpdateLog."SNo.");
        IndentLine.SetRange("PO Created", false);
        IndentLine.SetRange("SO Created", false);
        IndentLine.SetRange(IsSent, false);

        if IndentLine.FindSet() then
            repeat
                if (IndentLine."Cancel Indent Remark" <> '') and
                    (IndentLine."SNo." <> 0) then begin
                    Clear(ItemObj);

                    EntryNoText := Format(IndentLine."Entry No.");

                    if CopyStr(
                        EntryNoText,
                        1,
                        StrLen(IndentLine."Shortcut Dimension 1 Code")
                    ) = IndentLine."Shortcut Dimension 1 Code" then
                        EntryNoText :=
                            CopyStr(
                                EntryNoText,
                                StrLen(IndentLine."Shortcut Dimension 1 Code") + 1
                            );

                    ItemObj.Add('docId', EntryNoText);
                    ItemObj.Add('v_SNo', IndentLine."SNo.");
                    ItemObj.Add('businessUnitCode', IndentLine."Shortcut Dimension 1 Code");
                    ItemObj.Add('itemCode', IndentLine."No.");
                    ItemObj.Add('dm_itemCode', 0);
                    ItemObj.Add('status', 'Cancelled');
                    ItemObj.Add('remark', IndentLine."Cancel Indent Remark");
                    ItemObj.Add('uom', IndentLine."Unit of Measure");
                    ItemObj.Add('qty', IndentLine."Requested Qty");
                    ItemObj.Add('indentnumber', IndentLine."Document No.");
                    ItemObj.Add('indentserialnumber', Format(IndentLine."Entry No."));

                    ItemArray.Add(ItemObj);
                    HasData := true;
                end;
            until IndentLine.Next() = 0;

        if not HasData then
            exit(false);

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

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            IndentLineUpdateLog.IsSent := false;
            IndentLineUpdateLog.Response :=
                CopyStr(
                    'HTTP request failed.',
                    1,
                    MaxStrLen(IndentLineUpdateLog.Response));
            IndentLineUpdateLog.Modify(true);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        IndentLineUpdateLog.Response :=
            CopyStr(
                JsonResponse,
                1,
                MaxStrLen(IndentLineUpdateLog.Response));

        if ResponseMessage.IsSuccessStatusCode then begin
            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            if ResponseRoot.SelectToken(
                'd365_IndentStatusStatus',
                ResponseToken) then begin

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
                            CopyStr(
                                ResponseMsg,
                                1,
                                MaxStrLen(IndentLineUpdateLog.Response));
                        IndentLineUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            IndentLineUpdateLog.IsSent := false;
            IndentLineUpdateLog.Response :=
                CopyStr(
                    JsonResponse,
                    1,
                    MaxStrLen(IndentLineUpdateLog.Response));
            IndentLineUpdateLog.Modify(true);
            exit(false);
        end else begin
            IndentLineUpdateLog.IsSent := false;
            IndentLineUpdateLog.Response :=
                CopyStr(
                    JsonResponse,
                    1,
                    MaxStrLen(IndentLineUpdateLog.Response));
            IndentLineUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}