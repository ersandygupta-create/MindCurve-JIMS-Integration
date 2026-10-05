report 50032 "E3 Purchase Return Order"
{
    Caption = 'Purchase Return Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rpt50032.PurchaseReturnOrder.rdl';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const("Return Order"));
            RequestFilterFields = "No.";

            column(CompPicture; CompanyInfo.Picture) { }
            column(CompName; CompanyInfo.Name) { }
            column(CompAdd; CompanyInfo.Address + ' ' + CompanyInfo."Address 2") { }
            column(CompCityPostCode; CompanyInfo.City + '' + CompanyInfo."Post Code") { }
            column(CompEmail; CompanyInfo."E-Mail") { }
            column(CompGSTIN; CompanyInfo."GST Registration No.") { }

            column(DocumentNo; "No.") { }
            column(DocumentDate; "Document Date") { }
            column(PostingDate; "Posting Date") { }

            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }

            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }

            column(LocationCode; "Location Code") { }
            column(PaymentTermsCode; "Payment Terms Code") { }

            column(Location_Name; LocationName) { }
            column(LocationName2; LocationName2) { }
            column(LocationName3; LocationName3) { }
            column(LocationFullAddress; LocationFullAddress) { }

            column(Location_Address; LocationAddress)
            {
            }

            column(Location_Address_2; LocationAddress2)
            {
            }

            column(Location_City; LocationCity)
            {
            }

            column(Location_Post_Code; LocationPostCode)
            {
            }

            column(Location_State; LocationState)
            {
            }

            column(Location_Country; LocationCountry)
            {
            }

            column(Location_Phone; LocationPhone)
            {
            }

            column(Location_Email; LocationEmail)
            {
            }

            column(LocationGSTIN; LocationGSTIN) { }

            column(GSTAmount; GSTAmount) { }

            column(VendorPAN; VendorPAN) { }
            column(VendorGSTIN; VendorGSTIN) { }
            column(VendorEmail; VendorEmail) { }
            column(VendorPhone; VendorPhone) { }

            // Amount to Vendor Details
            column(AmtWords; AmtWords[1]) { }
            column(TotalAmttoVendor; TotalAmttoVendor) { }
            column(RoundoffAmt; RoundoffAmt) { }
            column(TotalGSTAmount; TotalInclTaxAmount) { }
            column(TotalTDS; TotalTDS) { }
            column(Currency_Code; CdCurrencyCode) { }
            column(PreparedByUserName; PreparedByUserName) { }
            column(ApprovedByUserName; ApprovedByUserName) { }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink =
                    "Document Type" = field("Document Type"),
                    "Document No." = field("No.");

                DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                    where(Type = filter(<> " "));

                column(LineNo; "Line No.") { }
                column(SerialNo; SerialNo) { }
                column(Type; Type) { }
                column(No; "No.") { }
                column(Description; Description) { }
                column(Description2; "Description 2") { }
                column(UnitofMeasure; "Unit of Measure") { }
                column(Quantity; Quantity) { }
                column(UnitPrice; "Direct Unit Cost") { }
                column(GST_Group_Code; "GST Group Code") { }
                column(LineDiscountPer; "Line Discount %") { }
                column(LineDiscountAmount; "Line Discount Amount") { }
                column(LineAmount; "Line Amount") { }
                column(Amount; Amount) { }
                column(MRP; MRP) { }
                column(Batch_No_; "Batch No.") { }
                column(Expiry_Date; "Expiry Date") { }

                trigger OnAfterGetRecord()
                begin
                    SerialNo += 1;
                    GSTPercent := 0;

                    if Evaluate(GSTPercent, "GST Group Code") then
                        GSTAmount := "Line Amount" * GSTPercent / 100;

                    if PurchaseLine."Location Code" <> '' then
                        if Location.Get(PurchaseLine."Location Code") then begin
                            LocationName := Location.Name;
                            LocationName2 := Location."Name 2";
                            LocationName3 := Location."Name 3";
                            LocationAddress := Location.Address;
                            LocationAddress2 := Location."Address 2";
                            LocationCity := Location.City;
                            LocationPostCode := Location."Post Code";
                            LocationState := Location.County;
                            LocationCountry := Location."Country/Region Code";
                            LocationPhone := Location."Phone No.";
                            LocationEmail := Location."E-Mail";
                            LocationGSTIN := Location."GST Registration No.";

                            LocationFullAddress := Location.Address;

                            if Location."Address 2" <> '' then
                                LocationFullAddress += ' ' + Location."Address 2";

                            if Location.City <> '' then
                                LocationFullAddress += ' ' + Location.City;

                            if Location."Post Code" <> '' then
                                LocationFullAddress += ' - ' + Location."Post Code";
                        end;

                    Clear(VendorPAN);
                    Clear(VendorGSTIN);
                    Clear(VendorEmail);
                    Clear(VendorPhone);

                    if "Buy-from Vendor No." <> '' then
                        if Vendor.Get("Buy-from Vendor No.") then begin
                            VendorPAN := Vendor."P.A.N. No.";
                            VendorGSTIN := Vendor."GST Registration No.";
                            VendorEmail := Vendor."E-Mail";
                            VendorPhone := Vendor."Phone No.";
                        end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // Currency Code
                CdCurrencyCode := "Currency Code";

                // Reset amount variables
                Clear(TotalAmttoVendor);
                Clear(TotalInclTaxAmount);
                Clear(TotalTDS);
                Clear(RoundoffAmt);
                Clear(decAmountoVendor);
                Clear(CGST_Amt);
                Clear(SGST_Amt);
                Clear(IGST_Amt);
                Clear(AmtWords);

                Clear(PreparedByUserName);

                if PreparedByUser.Get(SystemCreatedBy) then
                    PreparedByUserName := PreparedByUser."User Name";

                Clear(ApprovedByUserName);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
                ApprovalEntry.SetRange("Document No.", "No.");
                ApprovalEntry.SetRange("Document Type", "Document Type");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SetCurrentKey("Sequence No.");
                ApprovalEntry.SetAscending("Sequence No.", false);

                if ApprovalEntry.FindFirst() then begin
                    Clear(ApprovedByUser);

                    if ApprovedByUser.Get(ApprovalEntry."Approver ID") then
                        ApprovedByUserName := ApprovedByUser."User Name"
                    else
                        ApprovedByUserName := ApprovalEntry."Approver ID";
                end;

                decAmountoVendor := 0;

                recPurchaseLine.Reset();
                recPurchaseLine.SetRange("Document Type", "Document Type");
                recPurchaseLine.SetRange("Document No.", "No.");

                if recPurchaseLine.FindSet() then
                    repeat
                        decAmountoVendor += recPurchaseLine.Amount;
                    until recPurchaseLine.Next() = 0;

                CalcStatistics.GetPurchaseStatisticsAmount(PurchaseHeader, TotalAmttoVendor);
                CalcStatistics.OnGetPurchaseHeaderGSTAmount(PurchaseHeader, TotalInclTaxAmount);
                CalcStatistics.OnGetPurchaseHeaderTDSAmount(PurchaseHeader, TotalTDS);

                if TotalInclTaxAmount = 0 then begin
                    GetGSTAmounts(PurchaseHeader);

                    TotalInclTaxAmount :=
                        CGST_Amt +
                        SGST_Amt +
                        IGST_Amt;

                    if TotalInclTaxAmount <> 0 then
                        TotalAmttoVendor += TotalInclTaxAmount;
                end;

                // Get total Line Amount
                recPurchaseLine.Reset();
                recPurchaseLine.SetRange("Document Type", "Document Type");
                recPurchaseLine.SetRange("Document No.", "No.");
                recPurchaseLine.CalcSums("Line Amount");

                // Same rounding logic as Purchase Order
                if Vendor.Get("Buy-from Vendor No.") then begin
                    if Vendor."GST Registration No." = '' then begin
                        TotalAmttoVendor :=
                            Round(recPurchaseLine."Line Amount", 1);

                        RoundoffAmt :=
                            Abs(
                                recPurchaseLine."Line Amount" -
                                Round(TotalAmttoVendor, 1)
                            );
                    end else
                        RoundoffAmt :=
                            Abs(
                                TotalAmttoVendor -
                                Round(TotalAmttoVendor, 1)
                            );
                end;

                // Final amount to vendor
                TotalAmttoVendor :=
                    Round(TotalAmttoVendor, 1);

                // Amount in Words
                PostedVoucher.InitTextVariable();

                PostedVoucher.FormatNoText(
                    AmtWords,
                    TotalAmttoVendor,
                    "Currency Code");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";

        Location: Record Location;

        LocationName2: Text[100];
        LocationName3: Text[100];
        LocationName: Text[100];
        SerialNo: Integer;
        LocationAddress: Text[100];
        LocationAddress2: Text[100];
        LocationCity: Text[30];
        LocationPostCode: Code[20];
        LocationState: Text[30];
        LocationCountry: Code[10];
        LocationPhone: Text[30];
        LocationEmail: Text[80];
        LocationGSTIN: Code[20];
        LocationFullAddress: Text[250];

        GSTPercent: Decimal;
        GSTAmount: Decimal;

        Vendor: Record Vendor;
        VendorPAN: Code[20];
        VendorGSTIN: Code[20];
        VendorEmail: Text[80];
        VendorPhone: Text[30];

        PurchLine: Record "Purchase Line";
        recPurchaseLine: Record "Purchase Line";

        CalcStatistics: Codeunit "Calculate Statistics";
        PostedVoucher: Report "Posted Voucher";

        AmtWords: array[2] of Text[500];

        TotalAmttoVendor: Decimal;
        RoundoffAmt: Decimal;
        TotalInclTaxAmount: Decimal;
        TotalTDS: Decimal;
        decAmountoVendor: Decimal;
        CGST_Amt: Decimal;
        SGST_Amt: Decimal;
        IGST_Amt: Decimal;
        CdCurrencyCode: Code[20];
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        PreparedByUserName: Text[100];
        ApprovedByUserName: Text[100];
        ApprovalEntry: Record "Approval Entry";
        PreparedByUser: Record User;
        ApprovedByUser: Record User;


    local procedure GetGSTAmounts(PurchHeader: Record "Purchase Header")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        Clear(IGST_Amt);
        Clear(SGST_Amt);
        Clear(CGST_Amt);

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
                    ComponentName := GetComponentName(PurchaseLine, GSTSetup);

                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
                    TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            case TaxTransactionValue."Value ID" of
                                6:
                                    SGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                2:
                                    CGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                3:
                                    IGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                            end;
                        until TaxTransactionValue.Next() = 0;
                end;
            until PurchaseLine.Next() = 0;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl
        else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;


}