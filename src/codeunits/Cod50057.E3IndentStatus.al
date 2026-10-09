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
        //IndentLine.SetRange("No.", IndentLineUpdateLog."No.");
        IndentLine.SetRange(IsSent, false);

        if IndentLine.FindSet() then
            repeat
                // Skip only a matching Free Qty line.
                if (not ShouldSkipFreeQtyLine(IndentLine)) and
                   (IndentLine.Remarks <> '') then begin
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

                    if (IndentLine."Document No." <> '') and
                       (IndentLine."Short Qty Requisition" = 0) and
                       (IndentLine.Remarks = 'PO Qty') and
                       (IndentLine."Qty Per Purch. Unit of Measure" <> 0) then begin

                        ItemObj.Add('status', 'Completed');
                        ItemObj.Add(
                            'remark',
                            GetPOQtyRemark(IndentLine));

                    end else
                        if (IndentLine."Document No." <> '') and
                           (IndentLine."Short Qty Requisition" <> 0) and
                           (IndentLine.Remarks = 'PO Qty') and
                           (IndentLine."Qty Per Purch. Unit of Measure" <> 0) then begin

                            ItemObj.Add('status', 'Completed');
                            ItemObj.Add('remark', GetPOQtyRemark(IndentLine));

                        end else begin
                            ItemObj.Add(
                                'status',
                                GetIndentStatus(IndentLine));
                            ItemObj.Add(
                                'remark',
                                GetIndentRemark(IndentLine));
                        end;

                    ItemObj.Add('uom', IndentLine."Unit of Measure");
                    ItemObj.Add('qty', GetIndentQty(IndentLine));
                    ItemObj.Add('indentnumber', IndentLine."Document No.");
                    ItemObj.Add(
                        'indentserialnumber',
                        Format(IndentLine."Entry No."));

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

    local procedure GetIndentStatus(
        var IndentLine: Record "E3 Indent Line"): Text
    begin
        if IndentLine."Document No." <> '' then
            exit('Completed');

        exit('Pending');
    end;

    local procedure GetIndentRemark(
        var IndentLine: Record "E3 Indent Line"): Text
    var
        FreeQty: Decimal;
        RemarkText: Text;
    begin
        if (IndentLine."Document No." <> '') and
           (IndentLine.Remarks = 'PO Qty') then begin

            RemarkText :=
                Format(IndentLine."Requested Qty") + ' PO QTY';

            FreeQty := GetMatchingFreeQty(IndentLine);

            if FreeQty <> 0 then
                RemarkText +=
                    ' * ' + Format(FreeQty) + ' Free QTY';

            if IndentLine."Short Qty Requisition" <> 0 then
                RemarkText +=
                    ' + ' +
                    Format(IndentLine."Short Qty Requisition") +
                    ' Short Qty';

            exit(RemarkText);
        end;

        exit(IndentLine.Remarks);
    end;

    local procedure GetPOQtyRemark(
        var IndentLine: Record "E3 Indent Line"): Text
    var
        FreeQty: Decimal;
        RemarkText: Text;
        RejectQty: Decimal;
    begin
        RemarkText :=
            Format(IndentLine."Qty Per Purch. Unit of Measure") +
            '*' +
            Format(IndentLine."Requested Qty") +
            ' PO QTY';

        FreeQty := GetMatchingFreeQty(IndentLine);

        if FreeQty <> 0 then
            RemarkText +=
                ' + ' + Format(FreeQty) + ' Free QTY';

        if IndentLine."Short Qty Requisition" <> 0 then
            RemarkText +=
                ' + ' +
                Format(IndentLine."Short Qty Requisition") +
                ' Short Qty';
        RejectQty := GetMatchingRejectQty(IndentLine);

        if RejectQty <> 0 then
            RemarkText += ' + ' + Format(RejectQty) + ' Reject Qty';
        exit(RemarkText);
    end;

    local procedure GetMatchingFreeQty(
        var IndentLine: Record "E3 Indent Line"): Decimal
    var
        IndentLine2: Record "E3 Indent Line";
        FreeQty: Decimal;
    begin
        IndentLine2.Reset();
        IndentLine2.SetRange("Document No.", IndentLine."Document No.");
        IndentLine2.SetRange("SNo.", IndentLine."SNo.");
        IndentLine2.SetRange(Remarks, 'Free Qty');

        if IndentLine2.FindSet() then
            repeat
                FreeQty += IndentLine2."Requested Qty";
            until IndentLine2.Next() = 0;

        exit(FreeQty);
    end;

    local procedure GetIndentQty(
        var IndentLine: Record "E3 Indent Line"): Decimal
    begin
        // Combine quantities only for the PO Qty line.
        if (IndentLine.Remarks = 'PO Qty') and
           (IndentLine."Document No." <> '') then
            exit(
                IndentLine."Requested Qty" +
                GetMatchingFreeQty(IndentLine));

        // Keep existing quantity for all other lines.
        exit(IndentLine."Requested Qty");
    end;

    local procedure ShouldSkipFreeQtyLine(
    var IndentLine: Record "E3 Indent Line"): Boolean
    var
        IndentLine2: Record "E3 Indent Line";
    begin
        if ((IndentLine.Remarks <> 'Free Qty') and
            (IndentLine.Remarks <> 'Reject Qty')) or
           (IndentLine."Document No." = '') then
            exit(false);

        IndentLine2.Reset();
        IndentLine2.SetRange("Document No.", IndentLine."Document No.");
        IndentLine2.SetRange("SNo.", IndentLine."SNo.");
        IndentLine2.SetRange(Remarks, 'PO Qty');

        exit(IndentLine2.FindFirst());
    end;

    local procedure GetMatchingRejectQty(
    var IndentLine: Record "E3 Indent Line"): Decimal
    var
        IndentLine2: Record "E3 Indent Line";
        RejectQty: Decimal;
    begin
        IndentLine2.Reset();
        IndentLine2.SetRange("Document No.", IndentLine."Document No.");
        IndentLine2.SetRange("SNo.", IndentLine."SNo.");
        IndentLine2.SetRange(Remarks, 'Reject Qty');

        if IndentLine2.FindSet() then
            repeat
                RejectQty += IndentLine2."Requested Qty";
            until IndentLine2.Next() = 0;

        exit(RejectQty);
    end;

}