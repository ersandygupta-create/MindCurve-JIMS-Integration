report 50055 "Advance Request Receipt"
{
    Caption = 'Advance Request Receipt';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rpt50055.AdvancedRequestReceipt.rdl';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Order));

            RequestFilterFields = "No.", "Buy-from Vendor No.", "Order Date";

            column(CompPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }

            column(CompanyAddress; CompanyInfo.Address)
            {
            }

            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }

            column(CompanyCity; CompanyInfo.City)
            {
            }

            column(CompanyPostCode; CompanyInfo."Post Code")
            {
            }

            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompEmail; CompanyInfo."E-Mail")
            {
            }
            column(ComGSTIN; CompanyInfo."GST Registration No.")
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }

            // -----------------------------
            // Request / PO Details
            // -----------------------------

            column(ReqNo; "No.")
            {
            }

            column(ReqDate; "Order Date")
            {
            }

            column(PONo; "No.")
            {
            }

            column(PODate; "Order Date")
            {
            }

            column(SupplierNo; "Buy-from Vendor No.")
            {
            }

            column(SupplierName; "Buy-from Vendor Name")
            {
            }

            column(PaymentTerms; "Payment Terms Code")
            {
            }

            column(CurrencyCode; "Currency Code")
            {
            }

            column(POAmount; POAmount)
            {
            }

            // -----------------------------
            // Purchase Lines
            // -----------------------------

            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink =
                    "Document Type" = field("Document Type"),
                    "Document No." = field("No.");

                DataItemTableView =
                    sorting("Document Type", "Document No.", "Line No.");

                column(LineNo; "Line No.")
                {
                }

                column(ItemNo; "No.")
                {
                }

                column(ItemName; Description)
                {
                }

                column(Unit; "Unit of Measure Code")
                {
                }

                column(Qty; Quantity)
                {
                }

                column(Rate; "Direct Unit Cost")
                {
                }

                column(LineAmount; "Line Amount")
                {
                }

                column(LineAmountInclVAT; "Amount Including VAT")
                {
                }
            }

            dataitem(GRN; "Purch. Rcpt. Header")
            {
                DataItemLink = "Order No." = field("No.");

                DataItemTableView =
                    sorting("No.");

                column(GRNDate; "Posting Date")
                {
                }

                column(GRNNo; "No.")
                {
                }

                column(ChallanNo; "Vendor Shipment No.")
                {
                }

                column(ChallanDate; "Document Date")
                {
                }

                column(GRNValue; GRNValue)
                {
                }

                column(GRNStatus; GRNStatus)
                {
                }

                column(GRNEnteredBy; GRNEnteredBy)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalculateGRNValue();
                end;
            }
            dataitem(Bill; "Purch. Inv. Header")
            {
                DataItemLink = "Order No." = field("No.");

                DataItemTableView =
                    sorting("No.");

                column(BillDate; "Posting Date")
                {
                }

                column(BillNo; "No.")
                {
                }

                column(PartyNo; "Buy-from Vendor No.")
                {
                }

                column(PartyName; "Buy-from Vendor Name")
                {
                }

                column(PartyDate; "Document Date")
                {
                }

                column(BillValue; BillValue)
                {
                }

                column(TDS; TDSAmount)
                {
                }

                column(NetPayable; NetPayable)
                {
                }

                column(BillStatus; BillStatus)
                {
                }

                column(LastLocation; LastLocation)
                {
                }

                column(PaymentDueDate; PaymentDueDate)
                {
                }

                column(BillEnteredBy; BillEnteredBy)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalculateBillValue();
                end;
            }

            // -----------------------------
            // Purchase Header trigger
            // -----------------------------

            trigger OnAfterGetRecord()
            begin
                CalculatePOAmount();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(PurchaseOrderNo; PurchaseHeader."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Order No.';
                        Editable = false;
                    }
                }
            }
        }
    }

    labels
    {
        ReqNoLbl = 'Req No.';
        ReqDateLbl = 'Req. Date';
        PONoLbl = 'P.O. No.';
        PODateLbl = 'P.O. Date';

        SupplierLbl = 'Supplier';
        AmountLbl = 'Amount';

        ItemNameLbl = 'Item Name';
        UnitLbl = 'Unit';
        QtyLbl = 'Qty.';
        RateLbl = 'Rate';
        LineAmountLbl = 'Amount';

        GRNDetailsLbl = 'GRN Details';
        GRNDateLbl = 'GRN Date';
        GRNNoLbl = 'GRN No.';
        ChallanNoLbl = 'Challan No.';
        ChallanDateLbl = 'Challan Date';
        ValueLbl = 'Value';
        StatusLbl = 'Status';
        EnteredByLbl = 'Entered By';

        BillDetailsLbl = 'Bill Details';
        BillDateLbl = 'Bill Dt.';
        BillNoLbl = 'Bill No.';
        PartyNoLbl = 'Party No.';
        PartyDateLbl = 'Party Dt.';
        TDSLbl = 'TDS';
        NetPayableLbl = 'Net Pay.';
        LastLocationLbl = 'Last loc.';
        PaymentDueDateLbl = 'Pay.DueDt.';

        AdvancePaymentDetailsLbl = 'Adv. Payment Details';
        FinalPaymentDetailsLbl = 'Final Payment Details';
    }

    var
        CompanyInfo: Record "Company Information";
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PaymentTerms: Record "Payment Terms";

        POAmount: Decimal;
        GRNValue: Decimal;
        BillValue: Decimal;
        TDSAmount: Decimal;
        NetPayable: Decimal;

        GRNStatus: Text[50];
        GRNEnteredBy: Text[100];

        BillStatus: Text[50];
        LastLocation: Text[100];
        PaymentDueDate: Date;
        BillEnteredBy: Text[100];

        ReportTitleLbl: Label 'Advance Request Receipt';

        ReqNoLbl: Label 'Req No.';
        ReqDateLbl: Label 'Req. Date';
        PONoLbl: Label 'P.O. No.';
        PODateLbl: Label 'P.O. Date';

        SupplierLbl: Label 'Supplier';
        AmountLbl: Label 'Amount';

        ItemNameLbl: Label 'Item Name';
        UnitLbl: Label 'Unit';
        QtyLbl: Label 'Qty.';
        RateLbl: Label 'Rate';
        LineAmountLbl: Label 'Amount';

        GRNDetailsLbl: Label 'GRN Details';
        GRNDateLbl: Label 'GRN Date';
        GRNNoLbl: Label 'GRN No.';
        ChallanNoLbl: Label 'Challan No.';
        ChallanDateLbl: Label 'Challan Date';
        ValueLbl: Label 'Value';
        StatusLbl: Label 'Status';
        EnteredByLbl: Label 'Entered By';

        BillDetailsLbl: Label 'Bill Details';
        BillDateLbl: Label 'Bill Dt.';
        BillNoLbl: Label 'Bill No.';
        PartyNoLbl: Label 'Party No.';
        PartyDateLbl: Label 'Party Dt.';
        TDSLbl: Label 'TDS';
        NetPayableLbl: Label 'Net Pay.';
        LastLocationLbl: Label 'Last loc.';
        PaymentDueDateLbl: Label 'Pay.DueDt.';

        AdvancePaymentDetailsLbl: Label 'Adv. Payment Details';
        FinalPaymentDetailsLbl: Label 'Final Payment Details';


    // =========================================================
    // PO AMOUNT
    // =========================================================

    local procedure CalculatePOAmount()
    begin
        POAmount := 0;

        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");

        if PurchLine.FindSet() then
            repeat
                POAmount += PurchLine."Line Amount";
            until PurchLine.Next() = 0;
    end;


    // =========================================================
    // GRN AMOUNT
    // =========================================================

    local procedure CalculateGRNValue()
    begin
        GRNValue := 0;

        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", GRN."No.");

        if PurchRcptLine.FindSet() then
            repeat
                GRNValue += PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost";
            until PurchRcptLine.Next() = 0;

        GRNStatus := 'Received';

        GRNEnteredBy := UserId;
    end;


    // =========================================================
    // BILL AMOUNT
    // =========================================================

    local procedure CalculateBillValue()
    begin
        BillValue := 0;
        TDSAmount := 0;

        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", Bill."No.");

        if PurchInvLine.FindSet() then
            repeat
                BillValue += PurchInvLine."Line Amount";
            until PurchInvLine.Next() = 0;

        NetPayable := BillValue - TDSAmount;

        BillStatus := 'Posted';
        BillEnteredBy := UserId;

        PaymentDueDate := CalcDate(
            '<30D>',
            Bill."Posting Date"
        );
    end;


    // =========================================================
    // REPORT INITIALIZATION
    // =========================================================

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
