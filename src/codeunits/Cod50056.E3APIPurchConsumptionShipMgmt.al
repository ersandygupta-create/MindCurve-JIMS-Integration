codeunit 50056 "E3 Purch. Shipment Cons. Mgmt."
{

    TableNo = "Job Queue Entry";
    Permissions = tabledata "Return Shipment Header" = rm,
    tabledata "Return Shipment Line" = rm;

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    var
        E3APISetup: Record "E3 Integration API Setup";
        PurchaseShipmentHeader: Record "Return Shipment Header";
        PurchaseShipmentLine: Record "Return Shipment Line";
        GLSetup: Record "General Ledger Setup";
        DimensionValue: Record "Dimension Value";
        Location: Record Location;
        Item: Record Item;
        Vendor: Record Vendor;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ExpiryDate: Date;

    procedure SendPurchaseShipmentDetails(DocumentID: Code[20]): Boolean
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

        if not PurchaseShipmentHeader.Get(DocumentID) then
            Error(
                'Document %1 not found.',
                DocumentID);

        Clear(GRNObj);

        GRNObj.Add('d365_DocId', PurchaseShipmentHeader."No.");
        GRNObj.Add('v_Type', PurchaseShipmentHeader."GRN Voucher Type Name");
        if Date2DMY(Today(), 2) >= 4 then
            FYYear := Date2DMY(Today(), 3)
        else
            FYYear := Date2DMY(Today(), 3) - 1;
        GRNObj.Add('v_Prefix', Format(FYYear MOD 100));
        GRNObj.Add('v_Date', Format(PurchaseShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('d365_departmentCode', PurchaseShipmentHeader."Location Code");

        Clear(Location);
        if (PurchaseShipmentHeader."Location Code" <> '') and
           Location.Get(PurchaseShipmentHeader."Location Code")
        then
            GRNObj.Add('departmentName', Location.Name)
        else
            GRNObj.Add('departmentName', '');
        GRNObj.Add('d365_Supplier_subCode', PurchaseShipmentHeader."Buy-from Vendor No.");
        GRNObj.Add('placeOfSupply', 'HR');
        GRNObj.Add('remark', '');
        GRNObj.Add('d365_pChallanNo', PurchaseShipmentHeader."Return Order No.");
        GRNObj.Add('d365_pChallanDate', Format(PurchaseShipmentHeader."Document Date", 0, '<Year4>-<Month,2>-<Day,2>'));
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
        GRNObj.Add('preparedBy', 'D365');
        GRNObj.Add('preparedDate', Format(PurchaseShipmentHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'));
        GRNObj.Add('approvedBy', 'D365');
        GRNObj.Add('approvalDateTime', Format(PurchaseShipmentHeader.SystemModifiedAt, 0,
         '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        GLSetup.Get();
        GRNObj.Add('businessUnitCode', PurchaseShipmentHeader."Shortcut Dimension 1 Code");
        Clear(DimensionValue);
        if DimensionValue.Get(
            GLSetup."Global Dimension 1 Code", PurchaseShipmentHeader."Shortcut Dimension 1 Code")
        then
            GRNObj.Add('businessUnitName', DimensionValue.Name)
        else
            GRNObj.Add('businessUnitName', '');
        GRNObj.Add('rcmApplicable', 0);
        GRNObj.Add('partyType', 'Vendor');
        if PurchaseShipmentHeader."Buy-from Vendor No." <> '' then begin
            if Vendor.Get(PurchaseShipmentHeader."Buy-from Vendor No.") then
                GRNObj.Add('gsTin', Vendor."GST Registration No.")
            else
                GRNObj.Add('gsTin', '');
        end else
            GRNObj.Add('gsTin', '');
        GRNObj.Add('eWayBillNo', PurchaseShipmentHeader."No.");
        GRNObj.Add('eWayBillDt', Format(CurrentDateTime, 0, 9));
        GRNObj.Add('lrNo', '');
        GRNObj.Add('lrDate', Format(CurrentDateTime, 0, 9));
        // if PurchaseShipmentHeader."GST Location" = 'Intrastate' then
        //     GRNObj.Add('gsTlocation', '1')
        // else
        GRNObj.Add('gsTlocation', '1');
        GRNObj.Add('dm_Status', '');
        GRNObj.Add('dm_TimeStamp', Format(CurrentDateTime, 0, 9));
        GRNObj.Add('dm_docid', 0);
        GRNObj.Add('legalEntity', CompanyName);
        GRNObj.Add('ProcessIndicator', 'E');
        GRNObj.Add('processDatetime', Format(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
        GRNObj.Add('ErrorMsg', '');

        // Line

        Clear(LineArray);

        PurchaseShipmentLine.Reset();
        PurchaseShipmentLine.SetRange("Document No.", DocumentID);

        if PurchaseShipmentLine.FindSet() then
            repeat

                // Skip zero received quantity
                if PurchaseShipmentLine.Quantity <> 0 then begin

                    Clear(LineObj);

                    LineObj.Add('d365_DocId', PurchaseShipmentLine."Document No.");
                    LineObj.Add('v_SNo', PurchaseShipmentLine."Line No." DIV 10000);
                    LineObj.Add('d365_itemCode', PurchaseShipmentLine."No.");
                    LineObj.Add('itemName', PurchaseShipmentLine.Description);
                    LineObj.Add('d365_departmentCode', PurchaseShipmentLine."Location Code");

                    Clear(Location);
                    if (PurchaseShipmentLine."Location Code" <> '') and
                       Location.Get(PurchaseShipmentLine."Location Code")
                    then
                        LineObj.Add('departmentName', Location.Name)
                    else
                        LineObj.Add('departmentName', '');
                    LineObj.Add('d365_unitCode', PurchaseShipmentLine."Unit of Measure");
                    if PurchaseShipmentLine."No." <> '' then begin
                        if Item.Get(PurchaseShipmentLine."No.") then
                            LineObj.Add('d365_hsnCode', Format(Item."HSN/SAC Code"))
                        else
                            LineObj.Add('d365_hsnCode', '');
                    end else
                        LineObj.Add('d365_hsnCode', '');
                    LineObj.Add('indentSKUQty', PurchaseShipmentLine.Quantity);
                    LineObj.Add('issQty', PurchaseShipmentLine.Quantity);
                    LineObj.Add('rate', Round(PurchaseShipmentLine."Unit Cost"));
                    LineObj.Add('oh_Amt_Gross', PurchaseShipmentLine."VAT Base Amount");
                    LineObj.Add('oh_Amt_Discount', PurchaseShipmentLine."Line Discount %");
                    LineObj.Add('oh_at_Discount', PurchaseShipmentLine."Line Discount %");
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
                    LineObj.Add('landedSkuRate', PurchaseShipmentLine."Unit Cost");
                    LineObj.Add('remark', '');
                    LineObj.Add('mrp', PurchaseShipmentLine.MRP);
                    LineObj.Add('skuMrp', PurchaseShipmentLine.MRP);
                    LineObj.Add('saleRate', PurchaseShipmentLine."Unit Cost");
                    LineObj.Add('skuSaleRate', PurchaseShipmentLine."Unit Cost");
                    LineObj.Add('staffSaleRate', PurchaseShipmentLine."Unit Cost");
                    LineObj.Add('skuStaffSaleRate', PurchaseShipmentLine."Unit Cost");
                    LineObj.Add('barcode', PurchaseShipmentLine."Document No.");
                    LineObj.Add('batchNo', PurchaseShipmentLine."Batch No.");
                    LineObj.Add('manufacturingDate', PurchaseShipmentLine."Manufacturing Date");
                    if PurchaseShipmentLine."Expiry Date" <> 0D then
                        ExpiryDate := PurchaseShipmentLine."Expiry Date"
                    else
                        ExpiryDate := GetExpiryDateFromLotInformation(
                            PurchaseShipmentLine."Document No.",
                            PurchaseShipmentLine."No.",
                            PurchaseShipmentHeader."Posting Date");

                    LineObj.Add(
                        'expiryDate',
                        Format(ExpiryDate, 0, 9));
                    LineObj.Add('itemMakeCode', PurchaseShipmentLine."Item Make Code");
                    if PurchaseShipmentHeader."Buy-from Vendor No." <> '' then begin
                        if Vendor.Get(PurchaseShipmentHeader."Buy-from Vendor No.") then
                            LineObj.Add('gstTypeCode', Format(Vendor."GST Vendor Type"))
                        else
                            LineObj.Add('gstTypeCode', '');
                    end else
                        LineObj.Add('gstTypeCode', '');
                    if PurchaseShipmentLine."No." <> '' then begin
                        if Item.Get(PurchaseShipmentLine."No.") then
                            LineObj.Add('itemGSTNature', Format(Item.GLEN))
                        else
                            LineObj.Add('itemGSTNature', '');
                    end else
                        LineObj.Add('itemGSTNature', '');
                    LineObj.Add('dm_Status', '');
                    LineObj.Add('dm_TimeStamp', Format(CurrentDateTime, 0, 9));
                    LineObj.Add('dm_docid', 0);
                    LineObj.Add('d365_DateTime', Format(CurrentDateTime, 0, 9));
                    LineObj.Add('d365_Status', 'Success');

                    LineArray.Add(LineObj);
                end;

            until PurchaseShipmentLine.Next() = 0;

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
            PurchaseShipmentHeader.IsSent := false;
            PurchaseShipmentHeader.Response := CopyStr(JsonResponse, 1, MaxStrLen(PurchaseShipmentHeader.Response));
            PurchaseShipmentHeader.Modify(true);
            PurchaseShipmentLine.Reset();
            PurchaseShipmentLine.SetRange("Document No.", DocumentID);
            if PurchaseShipmentLine.FindSet() then
                repeat
                    PurchaseShipmentLine.IsSent := false;
                    PurchaseShipmentLine.Response := CopyStr(JsonResponse, 1, MaxStrLen(PurchaseShipmentLine.Response));
                    PurchaseShipmentLine.Modify(true);
                until PurchaseShipmentLine.Next() = 0;

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
            PurchaseShipmentHeader.IsSent := true;
            PurchaseShipmentHeader.Response := CopyStr(ResponseMsg, 1, MaxStrLen(PurchaseShipmentHeader.Response));
            PurchaseShipmentHeader.Modify(true);

            // Update Lines
            PurchaseShipmentLine.Reset();
            PurchaseShipmentLine.SetRange("Document No.", DocumentID);
            if PurchaseShipmentLine.FindSet() then
                repeat
                    PurchaseShipmentLine.IsSent := true;
                    PurchaseShipmentLine.Response := CopyStr(ResponseMsg, 1, MaxStrLen(PurchaseShipmentLine.Response));
                    PurchaseShipmentLine.Modify(true);
                until PurchaseShipmentLine.Next() = 0;
            exit(true);
        end;
        // Error Response
        PurchaseShipmentHeader.IsSent := false;
        PurchaseShipmentHeader.Response := CopyStr(JsonResponse, 1, MaxStrLen(PurchaseShipmentHeader.Response));
        PurchaseShipmentHeader.Modify(true);
        PurchaseShipmentLine.Reset();
        PurchaseShipmentLine.SetRange("Document No.", DocumentID);
        if PurchaseShipmentLine.FindSet() then
            repeat
                PurchaseShipmentLine.IsSent := false;
                PurchaseShipmentLine.Response := CopyStr(JsonResponse, 1, MaxStrLen(PurchaseShipmentLine.Response));
                PurchaseShipmentLine.Modify(true);
            until PurchaseShipmentLine.Next() = 0;
        exit(false);
    end;

    local procedure GetExpiryDateFromLotInformation(
    DocumentNo: Code[20];
    ItemNo: Code[20];
    DefaultDate: Date): Date
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotInformation: Record "Lot No. Information";
    begin
        Clear(ExpiryDate);

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Document No.", DocumentNo);
        ItemLedgerEntry.SetRange("Item No.", ItemNo);

        if ItemLedgerEntry.FindFirst() then begin
            if ItemLedgerEntry."Lot No." <> '' then begin
                LotInformation.Reset();
                LotInformation.SetRange("Item No.", ItemLedgerEntry."Item No.");
                LotInformation.SetRange("Lot No.", ItemLedgerEntry."Lot No.");

                if LotInformation.FindFirst() then
                    if LotInformation."Expairy Date" <> 0D then
                        exit(LotInformation."Expairy Date");
            end;
        end;

        if DefaultDate <> 0D then
            exit(CalcDate('<+1Y>', DefaultDate));

        exit(CalcDate('<+1Y>', Today()));
    end;
}