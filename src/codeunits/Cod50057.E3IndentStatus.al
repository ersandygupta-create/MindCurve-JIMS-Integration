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
        EntryNoText: Text;

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
        HasData: Boolean;
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
        Clear(ItemArray);

        IndentLine.Reset();
        IndentLine.SetRange("Purchase Order No.", IndentLineUpdateLog."Purchase Order No.");
        //IndentLine.SetRange("Line No.", IndentLineUpdateLog."Line No.");
        IndentLine.SetRange(IsSent, false);
        //IndentLine.SetFilter("Short Qty Requisition", '<>%1', 0);
        if IndentLine.FindSet() then //begin
            repeat
                Clear(ItemObj);

                EntryNoText := Format(IndentLine."Entry No.");

                if CopyStr(EntryNoText, 1,
                    StrLen(IndentLine."Shortcut Dimension 1 Code")
                ) = IndentLine."Shortcut Dimension 1 Code" then
                    EntryNoText :=
                        CopyStr(
                            EntryNoText,
                            StrLen(IndentLine."Shortcut Dimension 1 Code") + 1
                        );
                ItemObj.Add('docId', EntryNoText);
                ItemObj.Add('v_SNo', Format(IndentLine."Line No."));
                ItemObj.Add('businessUnitCode', IndentLine."Shortcut Dimension 1 Code");
                ItemObj.Add('itemCode', IndentLine."No.");
                ItemObj.Add('dm_itemCode', 0);
                if (IndentLine."Purchase Order No." <> '') and
                (IndentLine."Short Qty Requisition" = 0) and
                (IndentLine.Remarks = 'PO Qty') and
                (IndentLine."Qty Per Purch. Unit of Measure" <> 0) then begin

                    ItemObj.Add('status', 'Completed');
                    ItemObj.Add(
                        'remark',
                        Format(IndentLine."Qty Per Purch. Unit of Measure") +
                        ' * Qty Per Purch. Unit of Measure ' +
                        Format(IndentLine."Requested Qty") +
                        ' PO QTY'
                    );
                end
                else begin
                    ItemObj.Add('status', GetIndentStatus(IndentLine));
                    ItemObj.Add('remark', GetIndentRemark(IndentLine));
                end;
                ItemObj.Add('uom', IndentLine."Unit of Measure");
                ItemObj.Add('qty', GetIndentQty(IndentLine));
                ItemObj.Add('indentnumber', IndentLine."Document No.");
                ItemObj.Add('indentserialnumber', Format(IndentLine."Entry No."));

                ItemArray.Add(ItemObj);

                HasData := true;

            until IndentLine.Next() = 0;
        //end;

        if not HasData then
            exit(false);


        //ItemArray.Add(ItemObj);

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

    local procedure GetIndentStatus(var IndentLine: Record "E3 Indent Line"): Text
    begin
        if IndentLine."Purchase Order No." <> '' then
            exit('Completed');

        exit('Pending');
    end;


    local procedure GetIndentRemark(var IndentLine: Record "E3 Indent Line"): Text
    begin
        if (IndentLine."Purchase Order No." <> '') and
           (IndentLine."Short Qty Requisition" = 0) and
           (IndentLine.Remarks = 'PO Qty') and
           (IndentLine."Qty Per Purch. Unit of Measure" <> 0) then
            exit('Qty Per Purch. Unit of Measure * Requested QTY PO QTY');

        exit(IndentLine.Remarks);
    end;

    local procedure GetIndentQty(var IndentLine: Record "E3 Indent Line"): Decimal
    var
        IndentLine2: Record "E3 Indent Line";
        TotalQty: Decimal;
    begin
        TotalQty := IndentLine."Requested Qty";

        if IndentLine.Remarks = 'Free Qty' then begin
            IndentLine2.Reset();
            IndentLine2.SetRange("Purchase Order No.", IndentLine."Purchase Order No.");
            //IndentLine2.SetRange("No.", IndentLine."No.");
            IndentLine2.SetRange(Remarks, 'Free Qty');

            if IndentLine2.FindSet() then
                repeat
                    TotalQty += IndentLine2."Requested Qty";
                until IndentLine2.Next() = 0;
        end;

        exit(TotalQty);
    end;
}