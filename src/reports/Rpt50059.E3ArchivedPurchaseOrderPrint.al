report 50059 "Archived Purchase Order Print"
{
    ApplicationArea = All;
    Caption = 'Archived Purchase Order Print';
    UsageCategory = None;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50059.E3ArchivedPurchaseOrderPrint.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(ArchiveHeader; "Purchase Header Archive")
        {
            DataItemTableView = sorting("Document Type", "No.", "Doc. No. Occurrence", "Version No.") where("Document Type" = const(Order));
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyAddress) { }
            column(ComPANNo; CompanyInfo."P.A.N. No.") { }
            column(CompInfoPicture; CompanyInfo.Picture) { }
            column(DraftPicture; CompanyInfo.DraftImage) { }
            column(PurchInvNo; "No.") { }
            column(Order_Date; Format("Order Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(W_S_DL_No_; LiveHeader."W/S DL No.") { }
            column(Retail_DL_No_; LiveHeader."Retail DL No.") { }
            column(SupplierName; DelChr("Buy-from Vendor Name" + ' ' + "Buy-from Vendor Name 2", '>', ' ')) { }
            column(SupplierAdd; "Buy-from Address" + ', ' + "Buy-from Address 2" + ', ' + "Buy-from City" + ', ' + "Buy-from Post Code") { }
            column(SupplierEmail; Vendor."E-Mail") { }
            column(SupplierPhoneNo; Vendor."Phone No.") { }
            column(SupplierGSTIN; "Vendor GST Reg. No.") { }
            column(SupplierPANNo; Vendor."P.A.N. No.") { }
            column(LocationAdd; LocationAddress) { }
            column(LocationEmail; Location."E-Mail") { }
            column(LocationPhoneNo; Location."Phone No.") { }
            column(LocationWebsite; Location."Home Page") { }
            column(LocationGSTIN; "Location GST Reg. No.") { }
            column(LocName2; Location."Name 2") { }
            column(LocName3; Location."Name 3") { }
            column(Print_Caption; LiveHeader."Print Caption") { }
            column(AmtWords; AmountWords[1]) { }
            column(Currency_Code; CurrencyCode) { }
            column(TotalAmttoVendor; TotalToVendor) { }
            column(RoundoffAmt; RoundoffAmount) { }
            column(CreatedBy; SystemCreatedByFullName) { }
            column(ApprovedBy; SystemModifiedByFullName) { }
            column(TermsAndCondition; TermsAndConditions) { }
            column(TermName; TermNames) { }
            column(CommentNote; CommentNotes) { }

            dataitem(ArchiveLine; "Purchase Line Archive")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No."),
                    "Doc. No. Occurrence" = field("Doc. No. Occurrence"), "Version No." = field("Version No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Line No.");
                column(Description; Description + ', ' + "Description 2") { }
                column(ExttxtDesc; ExtendedDescription) { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(GrossAmt; Quantity * "Direct Unit Cost") { }
                column(Inv__Discount_Amount; "Inv. Discount Amount" + "Line Discount Amount") { }
                column(Item_Make_Name; PrintItemMakeName) { }
                column(Line_Amount; "Line Amount") { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_No_; "Line No.") { }
                column(Line_Remarks; PrintLineRemarks) { }
                column(LineGSTAmount; LineGSTAmount) { }
                column(decGSTPer; GSTPercent) { }
                column(MRP; PrintMRP) { }
                column(HasLiveLine; HasLiveLine) { }
                column(Planned_Receipt_Date; "Planned Receipt Date") { }
                column(Quantity; Quantity) { }
                column(Scheme; PrintScheme) { }
                column(SNo; LineNumber) { }
                column(UOM; "Unit of Measure Code") { }

                trigger OnAfterGetRecord()
                var
                    LiveLine: Record "Purchase Line";
                begin
                    HasLiveLine := LiveLine.Get(ArchiveLine."Document Type", ArchiveLine."Document No.", ArchiveLine."Line No.");
                    if HasLiveLine then begin
                        PrintItemMakeName := LiveLine."Item Make Name";
                        PrintLineRemarks := LiveLine."Line Remarks";
                        PrintMRP := LiveLine.MRP;
                        PrintScheme := LiveLine.Scheme;
                    end else begin
                        Clear(PrintItemMakeName);
                        Clear(PrintLineRemarks);
                        Clear(PrintMRP);
                        Clear(PrintScheme);
                    end;
                    LineNumber += 1;
                    ExtendedDescription := GetExtendedDescription(ArchiveLine);
                    GetLineGST(ArchiveLine, GSTPercent, LineGSTAmount);
                end;
            }

            trigger OnPreDataItem()
            begin
                // The layout uses document-wide totals and page headers.
                if Count > 1 then
                    Error(SelectOneVersionErr);
            end;

            trigger OnAfterGetRecord()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
                PostedVoucher: Report "Posted Voucher";
            begin
                if Status <> Status::Released then
                    CompanyInfo.CalcFields(DraftImage);

                Clear(Vendor);
                if Vendor.Get("Buy-from Vendor No.") then;
                Clear(Location);
                Clear(LocationAddress);
                if Location.Get("Location Code") then
                    LocationAddress := FormatAddress(Location.Address, Location."Address 2", Location.City, Location."Post Code",
                        Location."State Code", Location."Country/Region Code");

                Clear(LiveHeader);
                HasLiveHeader := LiveHeader.Get(ArchiveHeader."Document Type", ArchiveHeader."No.");

                CurrencyCode := "Currency Code";
                if CurrencyCode = '' then begin
                    GeneralLedgerSetup.Get();
                    CurrencyCode := GeneralLedgerSetup."LCY Code";
                end;

                CalculateTotals();
                PostedVoucher.InitTextVariable();
                PostedVoucher.FormatNoText(AmountWords, TotalToVendor, "Currency Code");
                LoadTerms();
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        CompanyAddress := FormatAddress(CompanyInfo.Address, CompanyInfo."Address 2", CompanyInfo.City,
            CompanyInfo."Post Code", CompanyInfo."State Code", CompanyInfo."Country/Region Code");
        if GSTSetup.Get() then
            GSTTaxType := GSTSetup."GST Tax Type";
    end;

    var
        CompanyInfo: Record "Company Information";
        LiveHeader: Record "Purchase Header";
        PrintItemMakeName: Text[60];
        PrintLineRemarks: Text[200];
        PrintMRP: Decimal;
        HasLiveLine: Boolean;
        PrintScheme: Text[30];
        HasLiveHeader: Boolean;
        Vendor: Record Vendor;
        Location: Record Location;
        GSTSetup: Record "GST Setup";
        CompanyAddress: Text;
        LocationAddress: Text;
        CurrencyCode: Code[10];
        GSTTaxType: Code[20];
        AmountWords: array[2] of Text[500];
        TotalToVendor: Decimal;
        RoundoffAmount: Decimal;
        LineGSTAmount: Decimal;
        GSTPercent: Decimal;
        LineNumber: Integer;
        ExtendedDescription: Text;
        TermsAndConditions: Text;
        TermNames: Text;
        CommentNotes: Text;
        SelectOneVersionErr: Label 'Select one archived purchase order version to print.';

    local procedure CalculateTotals()
    var
        Line: Record "Purchase Line Archive";
        UnroundedTotal: Decimal;
        LineTax: Decimal;
        LineRate: Decimal;
    begin
        Line.SetRange("Document Type", ArchiveHeader."Document Type");
        Line.SetRange("Document No.", ArchiveHeader."No.");
        Line.SetRange("Doc. No. Occurrence", ArchiveHeader."Doc. No. Occurrence");
        Line.SetRange("Version No.", ArchiveHeader."Version No.");
        if Line.FindSet() then
            repeat
                GetLineGST(Line, LineRate, LineTax);
                UnroundedTotal += Line."Amount Including VAT";
                if not Line."GST Reverse Charge" then
                    UnroundedTotal += LineTax;
            until Line.Next() = 0;

        TotalToVendor := Round(UnroundedTotal, 1);
        RoundoffAmount := Abs(UnroundedTotal - TotalToVendor);
    end;

    local procedure GetLineGST(Line: Record "Purchase Line Archive"; var Rate: Decimal; var TaxAmount: Decimal)
    var
        TaxValue: Record "Tax Transaction Value";
    begin
        Clear(Rate);
        Clear(TaxAmount);
        if GSTTaxType = '' then
            exit;

        TaxValue.SetRange("Tax Record ID", Line.RecordId());
        TaxValue.SetRange("Tax Type", GSTTaxType);
        TaxValue.SetRange("Value Type", TaxValue."Value Type"::Component);
        TaxValue.SetRange("Visible on Interface", true);
        if TaxValue.FindSet() then
            repeat
                Rate += TaxValue.Percent;
                TaxAmount += TaxValue.Amount;
            until TaxValue.Next() = 0;
    end;

    local procedure LoadTerms()
    var
        Comment: Record "Purch. Comment Line Archive";
        LiveComment: Record "Purch. Comment Line";
        Terms: Record "E3 PO Order Terms & Conditions";
        TermsBuilder: TextBuilder;
        OrderTerm: Text[100];
    begin
        Comment.SetRange("Document Type", ArchiveHeader."Document Type");
        Comment.SetRange("No.", ArchiveHeader."No.");
        Comment.SetRange("Doc. No. Occurrence", ArchiveHeader."Doc. No. Occurrence");
        Comment.SetRange("Version No.", ArchiveHeader."Version No.");
        Comment.SetRange("Document Line No.", 0);
        if Comment.FindSet() then
            repeat
                if DelChr(Comment.Comment, '=', ' ') <> '' then begin
                    if CommentNotes <> '' then begin
                        TermNames += '\n';
                        CommentNotes += '\n';
                    end;
                    OrderTerm := Comment.Comment;
                    if HasLiveHeader then
                        if LiveComment.Get(Comment."Document Type", Comment."No.", Comment."Document Line No.", Comment."Line No.") then
                            OrderTerm := LiveComment."Order Terms";
                    TermNames += OrderTerm;
                    CommentNotes += Comment.Comment;
                end;
            until Comment.Next() = 0;

        if LiveHeader."Voucher Type" = '' then
            exit;
        Terms.SetRange("Voucher Type", LiveHeader."Voucher Type");
        Terms.SetRange(Active, true);
        Terms.SetCurrentKey(Code);
        if Terms.FindSet() then
            repeat
                if DelChr(Terms."Terms and Condition", '=', ' ') <> '' then
                    TermsBuilder.AppendLine(Terms."Terms and Condition");
            until Terms.Next() = 0;
        TermsAndConditions := TermsBuilder.ToText();
    end;

    local procedure GetExtendedDescription(Line: Record "Purchase Line Archive"): Text
    var
        TextLine: Record "Extended Text Line";
        DescriptionBuilder: TextBuilder;
    begin
        if (Line.Type <> Line.Type::Item) or (Line."Vendor Item No." = '') then
            exit('');

        TextLine.SetRange("Table Name", TextLine."Table Name"::Item);
        TextLine.SetRange("No.", Line."Vendor Item No.");
        if TextLine.FindSet() then
            repeat
                DescriptionBuilder.Append(TextLine.Text);
            until TextLine.Next() = 0;
        exit(DescriptionBuilder.ToText());
    end;

    local procedure FormatAddress(Address: Text; Address2: Text; City: Text; PostCode: Code[20]; StateCode: Code[10]; CountryCode: Code[10]): Text
    var
        State: Record State;
        Country: Record "Country/Region";
    begin
        if State.Get(StateCode) then;
        if Country.Get(CountryCode) then;
        exit(Address + ', ' + Address2 + ', ' + City + ', ' + PostCode + ', ' + State.Description + ', ' + Country.Name);
    end;
}
