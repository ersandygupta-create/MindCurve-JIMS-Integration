codeunit 50052 "E3 Sale Shipment Cons. Mgmt."
{
    TableNo = "Job Queue Entry";
    Permissions = tabledata "Sales Shipment Header" = rm,
                  tabledata "Sales Shipment Line" = rm;

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
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Location: Record Location;
        Item: Record Item;

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

        if not E3APISetup."Sale Consumption API Enabled" then
            exit(false);

        E3APISetup.TestField("Sale Consumption API");

        if not SaleShipmentHeader.Get(DocumentID) then
            Error('Document %1 not found.', DocumentID);

        Clear(GRNObj);

        GRNObj.Add('d365_DocId', SaleShipmentHeader."No.");
        GRNObj.Add('v_Type', '');
        GRNObj.Add('v_Prefix', '');
        GRNObj.Add('v_Date', Format(SaleShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('d365_departmentCode', SaleShipmentHeader."Location Code");

        Clear(Location);
        if (SaleShipmentHeader."Location Code" <> '') and
           Location.Get(SaleShipmentHeader."Location Code")
        then
            GRNObj.Add('departmentName', Location.Name)
        else
            GRNObj.Add('departmentName', '');

        GRNObj.Add('d365_Supplier_subCode', SaleShipmentHeader."Sell-to Customer No.");
        GRNObj.Add('placeOfSupply', 'ABC');
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
        GRNObj.Add('d365_TimeStamp', Format(CurrentDateTime(), 0, 9));
        GRNObj.Add('preparedBy', 'D365');
        GRNObj.Add('preparedDate', Format(SaleShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('approvedBy', 'D365');
        GRNObj.Add('approvalDateTime', Format(SaleShipmentHeader.SystemModifiedAt, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        GLSetup.Get();
        GRNObj.Add('businessUnitCode', SaleShipmentHeader."Shortcut Dimension 1 Code");
        Clear(DimensionValue);
        if DimensionValue.Get(
            GLSetup."Global Dimension 1 Code", SaleShipmentHeader."Shortcut Dimension 1 Code")
        then
            GRNObj.Add('businessUnitName', DimensionValue.Name)
        else
            GRNObj.Add('businessUnitName', '');
        GRNObj.Add('rcmApplicable', 0);
        GRNObj.Add('partyType', 'Customer');
        GRNObj.Add('gsTin', SaleShipmentHeader."Customer GST Reg. No.");
        GRNObj.Add('eWayBillNo', SaleShipmentHeader."E-Way Bill No.");
        GRNObj.Add('eWayBillDt', Format(CurrentDateTime(), 0, 9));
        GRNObj.Add('lrNo', '');
        GRNObj.Add('lrDate', Format(CurrentDateTime(), 0, 9));
        GRNObj.Add('gsTlocation', '1');
        GRNObj.Add('dm_Status', '');
        GRNObj.Add('dm_TimeStamp', Format(CurrentDateTime(), 0, 9));
        GRNObj.Add('dm_docid', 0);
        GRNObj.Add('legalEntity', CompanyName);
        GRNObj.Add('ProcessIndicator', 'E');
        GRNObj.Add('processDatetime', Format(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        GRNObj.Add('ErrorMsg', '');

        // Lines Construction
        Clear(LineArray);
        SaleShipmentLine.Reset();
        SaleShipmentLine.SetRange("Document No.", DocumentID);

        if SaleShipmentLine.FindSet() then
            repeat
                if SaleShipmentLine.Quantity <> 0 then begin
                    Clear(LineObj);
                    LineObj.Add('d365_DocId', SaleShipmentLine."Document No.");
                    LineObj.Add('v_SNo', SaleShipmentLine."Line No." DIV 10000);
                    LineObj.Add('d365_itemCode', SaleShipmentLine."No.");
                    LineObj.Add('itemName', SaleShipmentLine.Description);
                    LineObj.Add('d365_departmentCode', SaleShipmentLine."Location Code");
                    Clear(Location);
                    if (SaleShipmentHeader."Location Code" <> '') and
                       Location.Get(SaleShipmentHeader."Location Code")
                    then
                        LineObj.Add('departmentName', Location.Name)
                    else
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
                    LineObj.Add('manufacturingDate', Format(SaleShipmentLine."Manufacturing Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                    LineObj.Add('expiryDate', Format(SaleShipmentLine."Expiry Date", 0, '<Year4>-<Month,2>-<Day,2>'));
                    Clear(Item);

                    if (SaleShipmentLine.Type = SaleShipmentLine.Type::Item) and
                       (SaleShipmentLine."No." <> '') and
                       Item.Get(SaleShipmentLine."No.")
                    then
                        LineObj.Add('itemMakeCode', Item."Item Make Code")
                    else
                        LineObj.Add('itemMakeCode', '');

                    LineObj.Add('gstTypeCode', '');
                    LineObj.Add('itemGSTNature', 'G');
                    LineObj.Add('dm_Status', '');
                    LineObj.Add('dm_TimeStamp', Format(CurrentDateTime(), 0, 9));
                    LineObj.Add('dm_docid', 0);
                    LineObj.Add('d365_DateTime', Format(CurrentDateTime(), 0, 9));
                    LineObj.Add('d365_Status', 'Success');

                    LineArray.Add(LineObj);
                end;
            until SaleShipmentLine.Next() = 0;

        GRNObj.Add('lines', LineArray);

        Clear(HeaderArray);
        HeaderArray.Add(GRNObj);

        Clear(RootObj);
        RootObj.Add('header', HeaderArray);
        RootObj.WriteTo(ReqPayload);

        // HTTP Request Headers
        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        // FIX 2: Set explicit Content-Length to avoid chunked transfer rejection
        ContentHeaders.Add('Content-Length', Format(StrLen(ReqPayload)));

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Sale Consumption API");
        RequestMessage.Method := 'POST';

        // Add standard User-Agent header
        HttpWebClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics365BusinessCentral');

        // Send HTTP Call
        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            JsonResponse := GetLastErrorText();
            UpdateShipmentStatus(DocumentID, false, JsonResponse);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if ResponseMessage.IsSuccessStatusCode then begin
            ResponseMsg := JsonResponse;

            Clear(ResponseRoot);
            if ResponseRoot.ReadFrom(JsonResponse) then
                if ResponseRoot.SelectToken('d365_ConsumptionStatus', ResponseToken) then begin
                    ResponseArray := ResponseToken.AsArray();
                    for J := 0 to ResponseArray.Count() - 1 do begin
                        ResponseArray.Get(J, ResponseToken);
                        ChildObj := ResponseToken.AsObject();
                        if ChildObj.SelectToken('errorMsg', CJToken) then
                            ResponseMsg := CJToken.AsValue().AsText();
                    end;
                end;

            UpdateShipmentStatus(DocumentID, true, ResponseMsg);
            exit(true);
        end;

        UpdateShipmentStatus(DocumentID, false, JsonResponse);
        exit(false);
    end;

    local procedure UpdateShipmentStatus(DocumentID: Code[20]; SentStatus: Boolean; ResponseMessage: Text)
    var
        HeaderRec: Record "Sales Shipment Header";
        LineRec: Record "Sales Shipment Line";
    begin
        if HeaderRec.Get(DocumentID) then begin
            HeaderRec.IsSent := SentStatus;
            HeaderRec.Response := CopyStr(ResponseMessage, 1, MaxStrLen(HeaderRec.Response));
            HeaderRec.Modify(true);
        end;

        LineRec.Reset();
        LineRec.SetRange("Document No.", DocumentID);
        if LineRec.FindSet() then
            repeat
                LineRec.IsSent := SentStatus;
                LineRec.Response := CopyStr(ResponseMessage, 1, MaxStrLen(LineRec.Response));
                LineRec.Modify(true);
            until LineRec.Next() = 0;
    end;
}