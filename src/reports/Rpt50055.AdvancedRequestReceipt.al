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
                DataItemTableView = sorting("Vendor Ledger Entry No.", "Entry No.") where(Unapplied = const(false));
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



}