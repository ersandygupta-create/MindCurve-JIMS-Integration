codeunit 50052 "E3 Sale Shipment Cons. Mgmt."
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
        SaleShipmentHeader: Record "Sales Shipment Header";
        SaleShipmentLine: Record "Sales Shipment Line";

    procedure SendSaleShipmentDetails(DocumentID: Code[20]): Boolean
    var
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;

        RootObj: JsonObject;
        GRNObj: JsonObject;
        LineObj: JsonObject;

        LineArray: JsonArray;
        HeaderArray: JsonArray;

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
        if not E3APISetup.Get() then
            exit(false);

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."GRN Work Sheet API Enabled" then
            exit(false);

        E3APISetup.TestField("GRN Work Sheet API");

        if not SaleShipmentHeader.Get(DocumentID) then
            Error(
                'Document %1 not found.',
                DocumentID);

        Clear(GRNObj);

        GRNObj.Add('d365_DocId', SaleShipmentHeader."No.");
        GRNObj.Add('v_Type', '');
        GRNObj.Add('v_Prefix', '');
        GRNObj.Add('v_Date', Format(SaleShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('d365_departmentCode', SaleShipmentHeader."Shortcut Dimension 2 Code");
        GRNObj.Add('departmentName', 'SaleShipmentHeader."Department Name"');
        GRNObj.Add('d365_Supplier_subCode', SaleShipmentHeader."Sell-to Customer No.");
        GRNObj.Add('placeOfSupply', SaleShipmentHeader.State);
        GRNObj.Add('remark', '');
        GRNObj.Add('d365_pChallanNo', SaleShipmentHeader."External Document No.");
        GRNObj.Add('d365_pChallanDate', Format(SaleShipmentHeader."Document Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('oh_Amt_Gross', 0);
        GRNObj.Add('oh_Amt_Discount', 0);
        GRNObj.Add('oh_Amt_Taxable', 0);
        GRNObj.Add('oh_Amt_CGST', 0);
        GRNObj.Add('oh_Amt_SGST', 0);
        GRNObj.Add('oh_Amt_IGST', 0);
        GRNObj.Add('oh_Amt_UGST', 0);
        GRNObj.Add('oh_Amt_Total', 0);
        GRNObj.Add('oh_at_FinalDiscount', 0);
        GRNObj.Add('oh_Amt_FinalDiscount', 0);
        GRNObj.Add('oh_Amt_RoundOff', 0);
        GRNObj.Add('oh_Amt_Net', 0);
        GRNObj.Add('oh_Amt_LandedValue', 0);
        GRNObj.Add('d365_TimeStamp', Format(CurrentDateTime, 0, 9));
        GRNObj.Add('preparedBy', SaleShipmentHeader.SystemCreatedBy);
        GRNObj.Add('preparedDate', Format(SaleShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('approvedBy', SaleShipmentHeader.SystemCreatedBy);
        GRNObj.Add('approvalDateTime', Format(SaleShipmentHeader.SystemModifiedAt, 0,
         '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        GRNObj.Add('businessUnitCode', SaleShipmentHeader."Shortcut Dimension 1 Code");
        GRNObj.Add('businessUnitName', '');
        GRNObj.Add('rcmApplicable', 0);
        GRNObj.Add('partyType', 'Customer');
        GRNObj.Add('gsTin', SaleShipmentHeader."Customer GST Reg. No.");
        GRNObj.Add('eWayBillNo', SaleShipmentHeader."E-Way Bill No.");
        GRNObj.Add('eWayBillDt', Format(CurrentDateTime, 0, 9));
        GRNObj.Add('lrNo', '');
        GRNObj.Add('lrDate', Format(CurrentDateTime, 0, 9));
        // if SaleShipmentHeader."GST Location" = 'Intrastate' then
        //     GRNObj.Add('gsTlocation', '1')
        // else
        GRNObj.Add('gsTlocation', '1');
        GRNObj.Add('dm_Status', '');
        GRNObj.Add('dm_TimeStamp', Format(CurrentDateTime, 0, 9));
        GRNObj.Add('dm_docid', 0);
        GRNObj.Add('legalEntity', CompanyName);

        // Line

        Clear(LineArray);

        SaleShipmentLine.Reset();
        SaleShipmentLine.SetRange("Document ID", DocumentID);

        if SaleShipmentLine.FindSet() then
            repeat

                // Skip zero received quantity
                if SaleShipmentLine.Quantity <> 0 then begin

                    Clear(LineObj);

                    LineObj.Add('d365_DocId', SaleShipmentLine."Document ID");
                    LineObj.Add('v_SNo', SaleShipmentLine."Line No." DIV 10000);
                    LineObj.Add('d365_itemCode', SaleShipmentLine."No.");
                    LineObj.Add('itemName', SaleShipmentLine.Description);
                    LineObj.Add('d365_departmentCode', SaleShipmentLine."Shortcut Dimension 2 Code");
                    LineObj.Add('departmentName', '');
                    LineObj.Add('d365_unitCode', SaleShipmentLine."Unit of Measure");
                    LineObj.Add('d365_hsnCode', SaleShipmentLine."HSN/SAC Code");
                    LineObj.Add('indentSKUQty', SaleShipmentLine.Quantity);
                    LineObj.Add('issQty', SaleShipmentLine.Quantity);
                    LineObj.Add('rate', Round(SaleShipmentLine."Unit Cost"));
                    LineObj.Add('oh_Amt_Gross', SaleShipmentLine."VAT Base Amount");
                    LineObj.Add('oh_Amt_Discount', SaleShipmentLine."Line Discount %");
                    LineObj.Add('oh_at_Discount', SaleShipmentLine."Line Discount %");
                    LineObj.Add('oh_Amt_Taxable', 0);
                    LineObj.Add('oh_at_CGST', 0);
                    LineObj.Add('oh_Amt_CGST', 0);
                    LineObj.Add('oh_at_SGST', 0);
                    LineObj.Add('oh_Amt_SGST', 0);
                    LineObj.Add('oh_at_IGST', 0);
                    LineObj.Add('oh_Amt_IGST', 0);
                    LineObj.Add('oh_at_UGST', 0);
                    LineObj.Add('oh_Amt_UGST', 0);
                    LineObj.Add('oh_at_FinalDiscount', 0);
                    LineObj.Add('oh_Amt_FinalDiscount', 0);
                    LineObj.Add('oh_Amt_Net', 0);
                    LineObj.Add('landedSkuValue', 0);
                    LineObj.Add('landedSkuRate', SaleShipmentLine."Unit Cost");
                    LineObj.Add('remark', '');
                    LineObj.Add('mrp', SaleShipmentLine.MRP);
                    LineObj.Add('skuMrp', SaleShipmentLine.MRP);
                    LineObj.Add('saleRate', SaleShipmentLine."Unit Cost");
                    LineObj.Add('skuSaleRate', SaleShipmentLine."Unit Cost");
                    LineObj.Add('staffSaleRate', SaleShipmentLine."Unit Cost");
                    LineObj.Add('skuStaffSaleRate', SaleShipmentLine."Unit Cost");
                    LineObj.Add('barcode', '');
                    LineObj.Add('batchNo', SaleShipmentLine."Batch No.");
                    LineObj.Add('manufacturingDate', Format(SaleShipmentLine."Manufacturing Date", 0, '<Year4>-<Month,2>-<Day,2>T00:00:00Z'));

                    LineObj.Add('expiryDate', Format(SaleShipmentLine."Expiry Date", 0, '<Year4>-<Month,2>-<Day,2>T00:00:00Z'));

                    LineObj.Add('itemMakeCode', '');
                    LineObj.Add('gstTypeCode', '');
                    LineObj.Add('itemGSTNature', SaleShipmentLine."GST Place of Supply");
                    LineObj.Add('dm_Status', '');
                    LineObj.Add('dm_TimeStamp', Format(CurrentDateTime, 0, 9));
                    LineObj.Add('dm_docid', 0);
                    LineObj.Add('d365_DateTime', Format(CurrentDateTime, 0, 9));
                    LineObj.Add('d365_Status', 'Success');

                    LineArray.Add(LineObj);
                end;

            until SaleShipmentLine.Next() = 0;

        GRNObj.Add('lines', LineArray);

        Clear(HeaderArray);
        HeaderArray.Add(GRNObj);

        Clear(RootObj);
        RootObj.Add('header', HeaderArray);
        // Generate JSON
        RootObj.WriteTo(ReqPayload);
        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        // HTTP Request
        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."GRN Work Sheet API");
        RequestMessage.Method := 'POST';
        // Send Request
        if not HttpWebClient.Send(RequestMessage, ResponseMessage)
        then begin

            JsonResponse := GetLastErrorText();
            SaleShipmentHeader.IsSent := false;
            SaleShipmentHeader.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleShipmentHeader.Response));
            SaleShipmentHeader.Modify(true);
            SaleShipmentLine.Reset();
            SaleShipmentLine.SetRange("Document ID", DocumentID);
            if SaleShipmentLine.FindSet() then
                repeat
                    SaleShipmentLine.IsSent := false;
                    SaleShipmentLine.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleShipmentLine.Response));
                    SaleShipmentLine.Modify(true);
                until SaleShipmentLine.Next() = 0;

            exit(false);
        end;
        // Read Response
        ResponseMessage.Content.ReadAs(JsonResponse);
        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Successful Response
        if ResponseMessage.IsSuccessStatusCode then begin
            ResponseMsg := JsonResponse;

            Clear(ResponseRoot);

            if ResponseRoot.ReadFrom(JsonResponse)
            then begin
                if ResponseRoot.SelectToken('d365_GrnStatus', ResponseToken)
                then begin
                    ResponseArray := ResponseToken.AsArray();
                    for J := 0 to
                        ResponseArray.Count() - 1
                    do begin
                        ResponseArray.Get(J, ResponseToken);
                        ChildObj := ResponseToken.AsObject();
                        if ChildObj.SelectToken('errorMsg', CJToken) then
                            ResponseMsg := CJToken.AsValue().AsText();
                    end;
                end;
            end;

            // Update Header
            SaleShipmentHeader.IsSent := true;
            SaleShipmentHeader.Response := CopyStr(ResponseMsg, 1, MaxStrLen(SaleShipmentHeader.Response));
            SaleShipmentHeader.Modify(true);

            // Update Lines
            SaleShipmentLine.Reset();
            SaleShipmentLine.SetRange("Document ID", DocumentID);
            if SaleShipmentLine.FindSet() then
                repeat
                    SaleShipmentLine.IsSent := true;
                    SaleShipmentLine.Response := CopyStr(ResponseMsg, 1, MaxStrLen(SaleShipmentLine.Response));
                    SaleShipmentLine.Modify(true);
                until SaleShipmentLine.Next() = 0;
            exit(true);
        end;
        // Error Response
        SaleShipmentHeader.IsSent := false;
        SaleShipmentHeader.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleShipmentHeader.Response));
        SaleShipmentHeader.Modify(true);
        SaleShipmentLine.Reset();
        SaleShipmentLine.SetRange("Document ID", DocumentID);
        if SaleShipmentLine.FindSet() then
            repeat
                SaleShipmentLine.IsSent := false;
                SaleShipmentLine.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleShipmentLine.Response));
                SaleShipmentLine.Modify(true);
            until SaleShipmentLine.Next() = 0;
        exit(false);
    end;
}