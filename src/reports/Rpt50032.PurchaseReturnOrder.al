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
            column(Location_Name; LocationName)
            {
            }
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
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink =
                    "Document Type" = field("Document Type"),
                    "Document No." = field("No.");

                DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                    where(Type = filter(<> " "));

                column(LineNo; "Line No.") { }
                column(Type; Type) { }
                column(No; "No.") { }
                column(Description; Description) { }
                column(Description2; "Description 2") { }
                column(UnitofMeasure; "Unit of Measure") { }
                column(Quantity; Quantity) { }
                column(UnitPrice; "Direct Unit Cost") { }
                column(GST_Group_Code; "GST Group Code") { }
                column(LineDiscountPer; "Line Discount %") { }
                column(LineAmount; "Line Amount") { }
                column(Amount; Amount) { }
                column(MRP; MRP) { }
                column(Batch_No_; "Batch No.") { }
                column(Expiry_Date; "Expiry Date") { }

                trigger OnAfterGetRecord()
                begin
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

                end;
            }
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


}