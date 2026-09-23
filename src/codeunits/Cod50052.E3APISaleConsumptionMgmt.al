codeunit 50052 "E3 Sale Invoice Cons. Mgmt."
{
    TableNo = "Job Queue Entry";
    Permissions = tabledata "Sales Invoice Header" = rm,
                  tabledata "Sales Invoice Line" = rm;

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        SaleInvoiceHeader: Record "Sales Invoice Header";
        SaleInvoiceLine: Record "Sales Invoice Line";
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Location: Record Location;
        Item: Record Item;
        GRNWorkSheetLine: Record "E3 GRN Work Sheet Line";
        ExpiryDate: Date;

    procedure SendSaleInvoiceDetails(DocumentID: Code[20]): Boolean
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
        FYYear: Integer;
    begin
        if not E3APISetup.Get() then
            exit(false);

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."Sale Consumption API Enabled" then
            exit(false);

        E3APISetup.TestField("Sale Consumption API");

        if not SaleInvoiceHeader.Get(DocumentID) then
            Error('Document %1 not found.', DocumentID);

        Clear(GRNObj);

        GRNObj.Add('d365_DocId', SaleInvoiceHeader."No.");
        GRNObj.Add('v_Type', SaleInvoiceHeader."GRN Voucher Type Name");
        if Date2DMY(Today(), 2) >= 4 then
            FYYear := Date2DMY(Today(), 3)
        else
            FYYear := Date2DMY(Today(), 3) - 1;

        GRNObj.Add('v_Prefix', Format(FYYear MOD 100));
        GRNObj.Add('v_Date', Format(SaleInvoiceHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('d365_departmentCode', SaleInvoiceHeader."Location Code");

        Clear(Location);
        if (SaleInvoiceHeader."Location Code" <> '') and
           Location.Get(SaleInvoiceHeader."Location Code")
        then
            GRNObj.Add('departmentName', Location.Name)
        else
            GRNObj.Add('departmentName', '');

        GRNObj.Add('d365_Supplier_subCode', SaleInvoiceHeader."Sell-to Customer No.");
        GRNObj.Add('placeOfSupply', 'HR');
        GRNObj.Add('remark', '');
        GRNObj.Add('d365_pChallanNo', SaleInvoiceHeader."External Document No.");
        GRNObj.Add('d365_pChallanDate', Format(SaleInvoiceHeader."Document Date", 0, '<Year4>-<Month,2>-<Day,2>'));
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
        GRNObj.Add('preparedDate', Format(SaleInvoiceHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('approvedBy', 'D365');
        GRNObj.Add('approvalDateTime', Format(SaleInvoiceHeader.SystemModifiedAt, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        GLSetup.Get();
        GRNObj.Add('businessUnitCode', SaleInvoiceHeader."Shortcut Dimension 1 Code");
        Clear(DimensionValue);
        if DimensionValue.Get(
            GLSetup."Global Dimension 1 Code", SaleInvoiceHeader."Shortcut Dimension 1 Code")
        then
            GRNObj.Add('businessUnitName', DimensionValue.Name)
        else
            GRNObj.Add('businessUnitName', '');
        GRNObj.Add('rcmApplicable', 0);
        GRNObj.Add('partyType', 'Customer');
        GRNObj.Add('gsTin', SaleInvoiceHeader."Customer GST Reg. No.");
        GRNObj.Add('eWayBillNo', SaleInvoiceHeader."E-Way Bill No.");
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
        SaleInvoiceLine.Reset();
        SaleInvoiceLine.SetRange("Document No.", DocumentID);
        SaleInvoiceLine.SetRange(Type, SaleInvoiceLine.Type::Item);

        if SaleInvoiceLine.FindSet() then
            repeat
                if SaleInvoiceLine.Quantity <> 0 then begin
                    Clear(LineObj);
                    LineObj.Add('d365_DocId', SaleInvoiceLine."Document No.");
                    LineObj.Add('v_SNo', SaleInvoiceLine."Line No." DIV 10000);
                    LineObj.Add('d365_itemCode', SaleInvoiceLine."No.");
                    LineObj.Add('itemName', SaleInvoiceLine.Description);
                    LineObj.Add('d365_departmentCode', SaleInvoiceLine."Location Code");
                    Clear(Location);
                    if (SaleInvoiceHeader."Location Code" <> '') and
                       Location.Get(SaleInvoiceHeader."Location Code")
                    then
                        LineObj.Add('departmentName', Location.Name)
                    else
                        LineObj.Add('departmentName', '');
                    LineObj.Add('d365_unitCode', SaleInvoiceLine."Unit of Measure");
                    LineObj.Add('d365_hsnCode', SaleInvoiceLine."HSN/SAC Code");
                    LineObj.Add('indentSKUQty', SaleInvoiceLine.Quantity);
                    LineObj.Add('issQty', SaleInvoiceLine.Quantity);
                    LineObj.Add('rate', Round(SaleInvoiceLine."Unit Cost"));
                    LineObj.Add('oh_Amt_Gross', SaleInvoiceLine."VAT Base Amount");
                    LineObj.Add('oh_Amt_Discount', SaleInvoiceLine."Line Discount %");
                    LineObj.Add('oh_at_Discount', SaleInvoiceLine."Line Discount %");
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
                    LineObj.Add('landedSkuRate', SaleInvoiceLine."Unit Cost");
                    LineObj.Add('remark', '');
                    Clear(GRNWorkSheetLine);

                    if GetPostedGRNLine(SaleInvoiceLine."No.", SaleInvoiceLine."Batch No.", SaleInvoiceLine."Shortcut Dimension 1 Code",
                        GRNWorkSheetLine)
                    then begin
                        LineObj.Add('mrp', GRNWorkSheetLine.MRP);
                        LineObj.Add('saleRate', GRNWorkSheetLine."Sale Rate");
                        LineObj.Add('staffSaleRate', GRNWorkSheetLine."Staff Sale Rate");
                        LineObj.Add('skuMrp', GRNWorkSheetLine."SKU MRP");
                        LineObj.Add('skuSaleRate', GRNWorkSheetLine."SKU Sale Rate");
                        LineObj.Add('skuStaffSaleRate', GRNWorkSheetLine."SKU Staff Sale Rate");
                        LineObj.Add('barcode', GRNWorkSheetLine.Barcode);
                        LineObj.Add('batchNo', GRNWorkSheetLine."Batch No.");
                        LineObj.Add('manufacturingDate', Format(WorkDate(), 0, 9));
                        LineObj.Add('expiryDate', Format(GRNWorkSheetLine."Expiry Date", 0, 9));

                    end else begin
                        // No Posted GRN Worksheet Line found
                        LineObj.Add('mrp', 0);
                        LineObj.Add('saleRate', 0);
                        LineObj.Add('staffSaleRate', 0);
                        LineObj.Add('skuMrp', 0);
                        LineObj.Add('skuSaleRate', 0);
                        LineObj.Add('skuStaffSaleRate', 0);
                        LineObj.Add('barcode', '');
                        LineObj.Add('batchNo', '');
                        LineObj.Add('manufacturingDate', Format(WorkDate(), 0, 9));
                        ExpiryDate := CalcDate('<1Y>', SaleInvoiceHeader."Posting Date");
                        LineObj.Add('expiryDate', Format(ExpiryDate, 0, '<Year4>-<Month,2>-<Day,2>'));

                    end;
                    Clear(Item);
                    if (SaleInvoiceLine.Type = SaleInvoiceLine.Type::Item) and
                       (SaleInvoiceLine."No." <> '') and
                       Item.Get(SaleInvoiceLine."No.")
                    then
                        LineObj.Add('itemMakeCode', Item."Item Make Code")
                    else
                        LineObj.Add('itemMakeCode', '');

                    LineObj.Add('gstTypeCode', format(SaleInvoiceHeader."GST Customer Type"));
                    LineObj.Add('itemGSTNature', 'G');
                    LineObj.Add('dm_Status', '');
                    LineObj.Add('dm_TimeStamp', Format(CurrentDateTime(), 0, 9));
                    LineObj.Add('dm_docid', 0);
                    LineObj.Add('d365_DateTime', Format(CurrentDateTime(), 0, 9));
                    LineObj.Add('d365_Status', 'Success');

                    LineArray.Add(LineObj);
                end;
            until SaleInvoiceLine.Next() = 0;

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
        RequestMessage.SetRequestUri(E3APISetup."Sale Consumption API");
        RequestMessage.Method := 'POST';
        // Send Request
        if not HttpWebClient.Send(RequestMessage, ResponseMessage)
        then begin

            JsonResponse := GetLastErrorText();
            SaleInvoiceHeader.IsSent := false;
            SaleInvoiceHeader.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleInvoiceHeader.Response));
            SaleInvoiceHeader.Modify(true);
            SaleInvoiceLine.Reset();
            SaleInvoiceLine.SetRange("Document No.", DocumentID);
            if SaleInvoiceLine.FindSet() then
                repeat
                    SaleInvoiceLine.IsSent := false;
                    SaleInvoiceLine.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleInvoiceLine.Response));
                    SaleInvoiceLine.Modify(true);
                until SaleInvoiceLine.Next() = 0;

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
                if ResponseRoot.SelectToken('d365_ConsumptionStatus', ResponseToken)
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
            SaleInvoiceHeader.IsSent := true;
            SaleInvoiceHeader.Response := CopyStr(ResponseMsg, 1, MaxStrLen(SaleInvoiceHeader.Response));
            SaleInvoiceHeader.Modify(true);

            // Update Lines
            SaleInvoiceLine.Reset();
            SaleInvoiceLine.SetRange("Document No.", DocumentID);
            if SaleInvoiceLine.FindSet() then
                repeat
                    SaleInvoiceLine.IsSent := true;
                    SaleInvoiceLine.Response := CopyStr(ResponseMsg, 1, MaxStrLen(SaleInvoiceLine.Response));
                    SaleInvoiceLine.Modify(true);
                until SaleInvoiceLine.Next() = 0;
            exit(true);
        end;
        // Error Response
        SaleInvoiceHeader.IsSent := false;
        SaleInvoiceHeader.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleInvoiceHeader.Response));
        SaleInvoiceHeader.Modify(true);
        SaleInvoiceLine.Reset();
        SaleInvoiceLine.SetRange("Document No.", DocumentID);
        if SaleInvoiceLine.FindSet() then
            repeat
                SaleInvoiceLine.IsSent := false;
                SaleInvoiceLine.Response := CopyStr(JsonResponse, 1, MaxStrLen(SaleInvoiceLine.Response));
                SaleInvoiceLine.Modify(true);
            until SaleInvoiceLine.Next() = 0;
        exit(false);
    end;


    local procedure GetPostedGRNLine(
    ItemNo: Code[20];
    BatchNo: Code[50];
    UnitCode: Code[20];
    var GRNLine: Record "E3 GRN Work Sheet Line"): Boolean
    var
        GRNWorkSheetHeader: Record "E3 GRN Work Sheet Header";
    begin
        Clear(GRNLine);

        GRNLine.Reset();
        GRNLine.SetRange("Item Code", ItemNo);
        GRNLine.SetRange("Batch No.", BatchNo);

        // Oldest GRN line first
        GRNLine.SetCurrentKey(SystemCreatedAt);
        GRNLine.SetAscending(SystemCreatedAt, true);

        if GRNLine.FindSet() then
            repeat
                // Find GRN Header for the line
                GRNWorkSheetHeader.Reset();
                GRNWorkSheetHeader.SetRange(
                    "Document ID",
                    GRNLine."Document ID");

                if GRNWorkSheetHeader.FindFirst() then begin

                    // Unit comes from GRN Work Sheet Header
                    if GRNWorkSheetHeader."Business Unit Code" = UnitCode then
                        exit(true);

                end;

            until GRNLine.Next() = 0;

        Clear(GRNLine);
        exit(false);
    end;

}