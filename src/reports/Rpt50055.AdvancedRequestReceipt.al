report 50055 "E3 Advance Request Receipt"
{
    Caption = 'Advance Request Receipt';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rpt50055.AdvanceRequestReceipt.rdl';

    dataset
    {
        dataitem(AdvanceRequest; "Vendor Adv. Pay. Ag. PO")
        {
            DataItemTableView = sorting("Document No");

            RequestFilterFields = "Document No", "Vendor Code", "Purchase Order No.";

            column(DocumentNo; "Document No")
            {
                IncludeCaption = false;
            }
            column(VendorCode; "Vendor Code")
            {
                IncludeCaption = false;
            }
            column(VendorName; "Vendor Name")
            {
                IncludeCaption = false;
            }
            column(RequestAmount; "Basic Amount")
            {
                IncludeCaption = false;
            }
            column(AdvanceRequestDate; "Advance Request Date")
            {
                IncludeCaption = false;
            }
            column(AdvanceDueDate; "Advance Due Date")
            {
                IncludeCaption = false;
            }
            column(Remarks; Remarks)
            {
                IncludeCaption = false;
            }
            column(TotalPOAmount; "Total PO Amount")
            {
                IncludeCaption = false;
            }
            column(GST_Amount; "GST Amount")
            {
                IncludeCaption = false;
            }
            column(TotalAppliedAmount; "Total Applied Amount")
            {
                IncludeCaption = false;
            }
            column(RemainingAmount; "Remaining Amount")
            {
                IncludeCaption = false;
            }
            column(PurchaseOrderNo; "Purchase Order No.")
            {
                IncludeCaption = false;
            }
            column(PODate; "PO Date")
            {
                IncludeCaption = false;
            }
            column(CompanyName; CompanyInfo.Name)
            {
                IncludeCaption = false;
            }

            column(CompanyAddress; CompanyInfo.Address)
            {
                IncludeCaption = false;
            }

            column(CompanyAddress2; CompanyInfo."Address 2")
            {
                IncludeCaption = false;
            }

            column(CompanyCity; CompanyInfo.City)
            {
                IncludeCaption = false;
            }

            column(CompanyPostCode; CompanyInfo."Post Code")
            {
                IncludeCaption = false;
            }

            column(CompanyPhone; CompanyInfo."Phone No.")
            {
                IncludeCaption = false;
            }

            column(CompanyEMail; CompanyInfo."E-Mail")
            {
                IncludeCaption = false;
            }

            column(CompanyPicture; CompanyInfo.Picture)
            {
                IncludeCaption = false;
            }

            dataitem(DetailedVendorLedgEntry; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Advance Document No" = field("Document No");
                DataItemTableView =
                    sorting("Vendor Ledger Entry No.", "Entry No.")
                    where(
                        "Document Type" = const(Invoice),
                        Unapplied = const(false)
                    );
                column(BillPostingDate; "Posting Date")
                {
                    IncludeCaption = false;
                }
                column(BillDocumentNo; "Document No.") { IncludeCaption = false; }
                column(BillVendorCode; BillVendorCode) { IncludeCaption = false; }
                column(BillVendorName; BillVendorName) { IncludeCaption = false; }
                column(BillAppliedAmount; BillAppliedAmount) { IncludeCaption = false; }
                column(BillVendorLedgerEntryNo; "Vendor Ledger Entry No.") { IncludeCaption = false; }
                column(BillDocumentType; Format("Document Type")) { IncludeCaption = false; }
                trigger OnAfterGetRecord()
                begin
                    ClearBillDetails();
                    GetBillVendorDetails();
                    BillAppliedAmount := Abs(Amount);
                end;
            }
            dataitem(AdvancePaymentEntry; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Advance Document No" = field("Document No");
                DataItemTableView = sorting("Vendor Ledger Entry No.", "Entry No.") where("Document Type" = const(Payment), Unapplied = const(false));
                column(AdvPaymentPostingDate; "Posting Date")
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentEntryType; Format("Entry Type"))
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentDocumentType; Format("Document Type"))
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentDocumentNo; "Document No.")
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentVendorNo; AdvPaymentVendorNo)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentCurrencyCode; AdvPaymentCurrencyCode)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentAmount; AdvPaymentAmount)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentAmountLCY; AdvPaymentAmountLCY)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentDueDate; AdvPaymentDueDate)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentEntryNo; "Entry No.")
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentMode; AdvPaymentMode) { IncludeCaption = false; }
                column(AdvPaymentBankName; AdvPaymentBankName)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentChequeNo; AdvPaymentChequeNo)
                {
                    IncludeCaption = false;
                }
                column(AdvPaymentChequeDate; AdvPaymentChequeDate)
                {
                    IncludeCaption = false;
                }
                trigger OnAfterGetRecord()
                begin
                    ClearAdvPaymentDetails();
                    GetAdvPaymentDetails();

                    AdvPaymentAmount := Abs(Amount);
                    AdvPaymentAmountLCY := Abs("Amount (LCY)");
                end;
            }

            // ---------------------------------------------------------
            // PURCHASE HEADER
            // ---------------------------------------------------------

            dataitem(PurchaseHeader; "Purchase Header")
            {
                DataItemLink =
                    "No." = field("Purchase Order No.");

                DataItemTableView = sorting("Document Type", "No.");

                column(PHNo; "No.")
                {
                    IncludeCaption = false;
                }

                column(PHOrderDate; "Order Date")
                {
                    IncludeCaption = false;
                }

                column(PHDocumentDate; "Document Date")
                {
                    IncludeCaption = false;
                }

                column(PHVendorNo; "Buy-from Vendor No.")
                {
                    IncludeCaption = false;
                }

                column(PHVendorName; "Buy-from Vendor Name")
                {
                    IncludeCaption = false;
                }

                column(PHVendorAddress; "Buy-from Address")
                {
                    IncludeCaption = false;
                }

                column(PHVendorAddress2; "Buy-from Address 2")
                {
                    IncludeCaption = false;
                }

                column(PHVendorCity; "Buy-from City")
                {
                    IncludeCaption = false;
                }

                column(PHVendorPostCode; "Buy-from Post Code")
                {
                    IncludeCaption = false;
                }

                // -----------------------------------------------------
                // PO LINES
                // -----------------------------------------------------

                dataitem(PurchaseLine; "Purchase Line")
                {
                    DataItemLink =
                        "Document Type" = field("Document Type"),
                        "Document No." = field("No.");

                    DataItemTableView =
                        sorting("Document Type", "Document No.", "Line No.")
                        where(Type = const(Item));

                    column(LineNo; "Line No.")
                    {
                        IncludeCaption = false;
                    }

                    column(ItemNo; "No.")
                    {
                        IncludeCaption = false;
                    }

                    column(ItemName; Description)
                    {
                        IncludeCaption = false;
                    }

                    column(Unit; "Unit of Measure")
                    {
                        IncludeCaption = false;
                    }

                    column(Quantity; Quantity)
                    {
                        IncludeCaption = false;
                    }

                    column(UnitPrice; "Direct Unit Cost")
                    {
                        IncludeCaption = false;
                    }

                    column(LineAmount; "Line Amount")
                    {
                        IncludeCaption = false;
                    }

                    column(LineAmountInclVAT; "Amount Including VAT")
                    {
                        IncludeCaption = false;
                    }
                }
                dataitem(PurchRcptLine; "Purch. Rcpt. Line")
                {
                    DataItemLink = "Order No." = field("No.");

                    DataItemTableView = sorting("Order No.", "Order Line No.", "Document No.", "Line No.")
                        where(Type = const(Item));

                    // -------------------------------------------------
                    // GRN HEADER DETAILS
                    // -------------------------------------------------

                    column(GRNNo; PurchRcptHeader."No.")
                    {
                        IncludeCaption = false;
                    }

                    column(GRNDate; PurchRcptHeader."Posting Date")
                    {
                        IncludeCaption = false;
                    }

                    column(GRNChallanNo; PurchRcptHeader."Vendor Shipment No.")
                    {
                        IncludeCaption = false;
                    }

                    column(GRNChallanDate; PurchRcptHeader."Document Date")
                    {
                        IncludeCaption = false;
                    }

                    column(GRNStatus; GRNStatus)
                    {
                        IncludeCaption = false;
                    }

                    column(GRNEnteredBy; PurchRcptHeader."User ID")
                    {
                        IncludeCaption = false;
                    }

                    // -------------------------------------------------
                    // GRN LINE DETAILS
                    // -------------------------------------------------

                    column(GRNLineNo; "Line No.")
                    {
                        IncludeCaption = false;
                    }
                    column(GRNQuantity; Quantity)
                    {
                        IncludeCaption = false;
                    }

                    column(GRNRate; "Direct Unit Cost")
                    {
                        IncludeCaption = false;
                    }
                    column(GRNOrderNo; "Order No.")
                    {
                        IncludeCaption = false;
                    }
                    column(GRNOrderLineNo; "Order Line No.")
                    {
                        IncludeCaption = false;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(PurchRcptHeader);

                        if not PurchRcptHeader.Get("Document No.") then
                            CurrReport.Skip();

                        GRNStatus := 'Posted';
                    end;
                }

            }
        }

    }
    local procedure GetBillVendorDetails()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
    begin
        Clear(BillVendorCode);
        Clear(BillVendorName);
        if not VendorLedgerEntry.Get(DetailedVendorLedgEntry."Vendor Ledger Entry No.") then
            exit;
        BillVendorCode := VendorLedgerEntry."Vendor No.";
        if Vendor.Get(BillVendorCode) then BillVendorName := Vendor.Name;
    end;

    local procedure ClearBillDetails()
    begin
        Clear(BillVendorCode);
        Clear(BillVendorName);
        Clear(BillAppliedAmount);
    end;

    local procedure GetAdvPaymentDetails()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccount: Record "Bank Account";

    begin
        Clear(AdvPaymentVendorNo);
        Clear(AdvPaymentCurrencyCode);
        Clear(AdvPaymentDueDate);

        if not VendorLedgerEntry.Get(
            AdvancePaymentEntry."Vendor Ledger Entry No.")
        then
            exit;
        AdvPaymentVendorNo := VendorLedgerEntry."Vendor No.";
        AdvPaymentMode := Format(VendorLedgerEntry."Payment Method Code");

        BankAccountLedgerEntry.Reset();

        BankAccountLedgerEntry.SetRange(
            "Posting Date",
            VendorLedgerEntry."Posting Date");

        BankAccountLedgerEntry.SetRange(
            "Document No.",
            VendorLedgerEntry."Document No.");

        if BankAccountLedgerEntry.FindFirst() then begin
            if BankAccount.Get(BankAccountLedgerEntry."Bank Account No.")
            then
                AdvPaymentBankName := BankAccount.Name;
            AdvPaymentChequeNo := BankAccountLedgerEntry."Cheque No.";
            AdvPaymentChequeDate := BankAccountLedgerEntry."Cheque Date";
        end;
    end;

    local procedure ClearAdvPaymentDetails()
    begin
        Clear(AdvPaymentVendorNo);
        Clear(AdvPaymentCurrencyCode);
        Clear(AdvPaymentAmount);
        Clear(AdvPaymentAmountLCY);
        Clear(AdvPaymentDueDate);
        Clear(AdvPaymentMode);
        Clear(AdvPaymentBankName);
        Clear(AdvPaymentChequeNo);
        Clear(AdvPaymentChequeDate);

    end;


    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        GRNStatus: Text[20];
        BillVendorCode: Code[20];
        BillVendorName: Text[100];
        BillAppliedAmount: Decimal;
        AdvPaymentVendorNo: Code[20];
        AdvPaymentCurrencyCode: Code[10];
        AdvPaymentAmount: Decimal;
        AdvPaymentAmountLCY: Decimal;
        AdvPaymentDueDate: Date;
        AdvPaymentMode: Text[50];
        AdvPaymentBankName: Text[100];
        AdvPaymentChequeNo: Code[20];
        AdvPaymentChequeDate: Date;





}