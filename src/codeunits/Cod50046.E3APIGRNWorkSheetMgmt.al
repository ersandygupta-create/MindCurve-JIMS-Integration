codeunit 50046 "E3 GRN Work Sheet Mgmt."
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
        GRNWorkSheetHeader: Record "E3 GRN Work Sheet Header";
        GRNWorkSheetLine: Record "E3 GRN Work Sheet Line";

    procedure SendGRNWorkSheetDetails(DocumentID: Code[20]): Boolean
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

        if not GRNWorkSheetHeader.Get(DocumentID) then
            Error('Document %1 not found.', DocumentID);
        //=========================
        // Header
        //=========================
        Clear(GRNObj);

        //=========================
        // Header
        //=========================
        GRNObj.Add('d365_DocId', GRNWorkSheetHeader."Document ID");
        GRNObj.Add('v_Type', GRNWorkSheetHeader."Voucher Type");
        GRNObj.Add('v_Prefix', GRNWorkSheetHeader.Prefix);
        GRNObj.Add('v_Date', GRNWorkSheetHeader."Voucher Date");
        GRNObj.Add('d365_departmentCode', GRNWorkSheetHeader."Department Code");
        GRNObj.Add('departmentName', GRNWorkSheetHeader."Department Name");
        GRNObj.Add('d365_Supplier_subCode', GRNWorkSheetHeader."Supplier Code");
        GRNObj.Add('placeOfSupply', GRNWorkSheetHeader."Place of Supply");
        GRNObj.Add('remark', GRNWorkSheetHeader.Remark);
        GRNObj.Add('d365_pChallanNo', GRNWorkSheetHeader."Purchase Challan No.");
        GRNObj.Add('d365_pChallanDate', GRNWorkSheetHeader."Purchase Challan Date");
        GRNObj.Add('oh_Amt_Gross', GRNWorkSheetHeader."OH Amount Gross");
        GRNObj.Add('oh_Amt_Discount', GRNWorkSheetHeader."OH Amount Discount");
        GRNObj.Add('oh_Amt_Taxable', GRNWorkSheetHeader."OH Amount Taxable");
        GRNObj.Add('oh_Amt_CGST', GRNWorkSheetHeader."OH Amount CGST");
        GRNObj.Add('oh_Amt_SGST', GRNWorkSheetHeader."OH Amount SGST");
        GRNObj.Add('oh_Amt_IGST', GRNWorkSheetHeader."OH Amount IGST");
        GRNObj.Add('oh_Amt_UGST', GRNWorkSheetHeader."OH Amount UGST");
        GRNObj.Add('oh_Amt_Total', GRNWorkSheetHeader."OH Amount Total");
        GRNObj.Add('oh_at_FinalDiscount', GRNWorkSheetHeader."OH Final Discount %");
        GRNObj.Add('oh_Amt_FinalDiscount', GRNWorkSheetHeader."OH Final Discount Amount");
        GRNObj.Add('oh_Amt_RoundOff', GRNWorkSheetHeader."OH Round Off");
        GRNObj.Add('oh_Amt_Net', GRNWorkSheetHeader."OH Net Amount");
        GRNObj.Add('oh_Amt_LandedValue', GRNWorkSheetHeader."OH Landed Value");
        GRNObj.Add('d365_TimeStamp', CurrentDateTime);
        GRNObj.Add('preparedBy', GRNWorkSheetHeader."Prepared By");
        GRNObj.Add('preparedDate', GRNWorkSheetHeader."Prepared Date");
        GRNObj.Add('approvedBy', GRNWorkSheetHeader."Approved By");
        GRNObj.Add('approvalDateTime', GRNWorkSheetHeader."Approval Date Time");
        GRNObj.Add('businessUnitCode', GRNWorkSheetHeader."Business Unit Code");
        GRNObj.Add('businessUnitName', GRNWorkSheetHeader."Business Unit Name");
        GRNObj.Add('rcmApplicable', GRNWorkSheetHeader."RCM Applicable");
        GRNObj.Add('partyType', GRNWorkSheetHeader."Party Type");
        GRNObj.Add('gsTin', GRNWorkSheetHeader.GSTIN);
        GRNObj.Add('eWayBillNo', GRNWorkSheetHeader."E-Way Bill No.");
        GRNObj.Add('eWayBillDt', GRNWorkSheetHeader."E-Way Bill Date");
        GRNObj.Add('lrNo', GRNWorkSheetHeader."LR No.");
        GRNObj.Add('lrDate', GRNWorkSheetHeader."LR Date");
        GRNObj.Add('gsTlocation', GRNWorkSheetHeader."GST Location");
        GRNObj.Add('dm_Status', GRNWorkSheetHeader.Status);
        GRNObj.Add('dm_TimeStamp', CurrentDateTime);
        GRNObj.Add('dm_docid', GRNWorkSheetHeader."DM Doc ID");
        GRNObj.Add('legalEntity', GRNWorkSheetHeader."Legal Entity");
        //=========================
        // Line
        //=========================
        Clear(LineArray);

        GRNWorkSheetLine.Reset();
        GRNWorkSheetLine.SetRange("Document ID", DocumentID);

        if GRNWorkSheetLine.FindSet() then
            repeat
                Clear(LineObj);

                LineObj.Add('d365_DocId', GRNWorkSheetLine."Document ID");
                LineObj.Add('v_SNo', GRNWorkSheetLine."Line No.");
                LineObj.Add('indentDocId', GRNWorkSheetLine."Indent Document ID");
                LineObj.Add('indentV_SNo', GRNWorkSheetLine."Indent Line No.");
                LineObj.Add('d365_itemCode', GRNWorkSheetLine."Item Code");
                LineObj.Add('dm_ItemCode', GRNWorkSheetLine."DM Item Code");
                LineObj.Add('itemName', GRNWorkSheetLine."Item Name");
                LineObj.Add('d365_departmentCode', GRNWorkSheetLine."Department Code");
                LineObj.Add('dm_departmentCode', GRNWorkSheetLine."DM Department Code");
                LineObj.Add('departmentName', GRNWorkSheetLine."Department Name");
                LineObj.Add('d365_unitCode', GRNWorkSheetLine."Unit Code");
                LineObj.Add('dm_unitCode', GRNWorkSheetLine."DM Unit Code");
                LineObj.Add('d365_hsnCode', GRNWorkSheetLine."HSN Code");
                LineObj.Add('dm_hsnCode', GRNWorkSheetLine."DM HSN Code");
                LineObj.Add('indentSKUQty', GRNWorkSheetLine."Indent SKU Qty");
                LineObj.Add('recSKUQty', GRNWorkSheetLine."Received SKU Qty");
                LineObj.Add('rate', GRNWorkSheetLine.Rate);
                LineObj.Add('oh_Amt_Gross', GRNWorkSheetLine."Gross Amount");
                LineObj.Add('oh_Amt_Discount', GRNWorkSheetLine."Discount Amount");
                LineObj.Add('oh_at_Discount', GRNWorkSheetLine."Discount %");
                LineObj.Add('oh_Amt_Taxable', GRNWorkSheetLine."Taxable Amount");
                LineObj.Add('oh_at_CGST', GRNWorkSheetLine."CGST %");
                LineObj.Add('oh_Amt_CGST', GRNWorkSheetLine."CGST Amount");
                LineObj.Add('oh_at_SGST', GRNWorkSheetLine."SGST %");
                LineObj.Add('oh_Amt_SGST', GRNWorkSheetLine."SGST Amount");
                LineObj.Add('oh_at_IGST', GRNWorkSheetLine."IGST %");
                LineObj.Add('oh_Amt_IGST', GRNWorkSheetLine."IGST Amount");
                LineObj.Add('oh_at_UGST', GRNWorkSheetLine."UGST %");
                LineObj.Add('oh_Amt_UGST', GRNWorkSheetLine."UGST Amount");
                LineObj.Add('oh_at_FinalDiscount', GRNWorkSheetLine."Final Discount %");
                LineObj.Add('oh_Amt_FinalDiscount', GRNWorkSheetLine."Final Discount Amount");
                LineObj.Add('oh_Amt_Net', GRNWorkSheetLine."Net Amount");
                LineObj.Add('landedSkuValue', GRNWorkSheetLine."Landed SKU Value");
                LineObj.Add('landedSkuRate', GRNWorkSheetLine."Landed SKU Rate");
                LineObj.Add('remark', GRNWorkSheetLine.Remark);
                LineObj.Add('mrp', GRNWorkSheetLine.MRP);
                LineObj.Add('skuMrp', GRNWorkSheetLine."SKU MRP");
                LineObj.Add('saleRate', GRNWorkSheetLine."Sale Rate");
                LineObj.Add('skuSaleRate', GRNWorkSheetLine."SKU Sale Rate");
                LineObj.Add('staffSaleRate', GRNWorkSheetLine."Staff Sale Rate");
                LineObj.Add('skuStaffSaleRate', GRNWorkSheetLine."SKU Staff Sale Rate");
                LineObj.Add('barcode', GRNWorkSheetLine.Barcode);
                LineObj.Add('batchNo', GRNWorkSheetLine."Batch No.");
                LineObj.Add('manufacturingDate', GRNWorkSheetLine."Manufacturing Date");
                LineObj.Add('expiryDate', GRNWorkSheetLine."Expiry Date");
                LineObj.Add('itemMakeCode', GRNWorkSheetLine."Item Make Code");
                LineObj.Add('gstTypeCode', GRNWorkSheetLine."GST Type Code");
                LineObj.Add('itemGSTNature', GRNWorkSheetLine."Item GST Nature");
                LineObj.Add('dm_Status', GRNWorkSheetLine.Status);
                LineObj.Add('dm_TimeStamp', GRNWorkSheetLine."DM TimeStamp");
                LineObj.Add('dm_docid', GRNWorkSheetLine."DM Document ID");
                LineObj.Add('d365_DateTime', CurrentDateTime);
                LineObj.Add('d365_Status', 'Success');

                LineArray.Add(LineObj);
            until GRNWorkSheetLine.Next() = 0;

        GRNObj.Add('lines', LineArray);

        Clear(RootObj);
        RootObj.Add('header', GRNObj);

        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."GRN Work Sheet API");
        RequestMessage.Method := 'POST';

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            JsonResponse := GetLastErrorText();

            //Header
            GRNWorkSheetHeader.IsSent := false;
            GRNWorkSheetHeader.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(GRNWorkSheetHeader.Response));
            GRNWorkSheetHeader.Modify(true);

            //Lines
            GRNWorkSheetLine.Reset();
            GRNWorkSheetLine.SetRange("Document ID", GRNWorkSheetHeader."Document ID");
            if GRNWorkSheetLine.FindSet() then
                repeat
                    GRNWorkSheetLine.IsSent := false;
                    GRNWorkSheetLine.Response :=
                        CopyStr(JsonResponse, 1, MaxStrLen(GRNWorkSheetLine.Response));
                    GRNWorkSheetLine.Modify(true);
                until GRNWorkSheetLine.Next() = 0;

            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        if ResponseMessage.IsSuccessStatusCode then begin
            ResponseMsg := JsonResponse;

            Clear(ResponseRoot);
            if ResponseRoot.ReadFrom(JsonResponse) then
                if ResponseRoot.SelectToken('d365_GrnStatus', ResponseToken) then begin
                    ResponseArray := ResponseToken.AsArray();

                    for J := 0 to ResponseArray.Count() - 1 do begin
                        ResponseArray.Get(J, ResponseToken);
                        ChildObj := ResponseToken.AsObject();

                        if ChildObj.SelectToken('errorMsg', CJToken) then
                            ResponseMsg := CJToken.AsValue().AsText();
                    end;
                end;

            //Header
            GRNWorkSheetHeader.IsSent := true;
            GRNWorkSheetHeader.Response :=
                CopyStr(ResponseMsg, 1, MaxStrLen(GRNWorkSheetHeader.Response));
            GRNWorkSheetHeader.Modify(true);

            //Lines
            GRNWorkSheetLine.Reset();
            GRNWorkSheetLine.SetRange("Document ID", GRNWorkSheetHeader."Document ID");
            if GRNWorkSheetLine.FindSet() then
                repeat
                    GRNWorkSheetLine.IsSent := true;
                    GRNWorkSheetLine.Response :=
                        CopyStr(ResponseMsg, 1, MaxStrLen(GRNWorkSheetLine.Response));
                    GRNWorkSheetLine.Modify(true);
                until GRNWorkSheetLine.Next() = 0;

            exit(true);
        end else begin
            //Header
            GRNWorkSheetHeader.IsSent := false;
            GRNWorkSheetHeader.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(GRNWorkSheetHeader.Response));
            GRNWorkSheetHeader.Modify(true);

            //Lines
            GRNWorkSheetLine.Reset();
            GRNWorkSheetLine.SetRange("Document ID", GRNWorkSheetHeader."Document ID");
            if GRNWorkSheetLine.FindSet() then
                repeat
                    GRNWorkSheetLine.IsSent := false;
                    GRNWorkSheetLine.Response :=
                        CopyStr(JsonResponse, 1, MaxStrLen(GRNWorkSheetLine.Response));
                    GRNWorkSheetLine.Modify(true);
                until GRNWorkSheetLine.Next() = 0;

            exit(false);
        end;
    end;
}