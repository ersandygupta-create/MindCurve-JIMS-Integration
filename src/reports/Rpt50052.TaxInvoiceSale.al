report 50052 "E3 Tax Invoice"
{
    RDLCLayout = './src/reports/Rpt50052.TaxInvoiceSale.rdl';
    Caption = 'Tax Invoice - Sale';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            dataitem(CopyLoop; Integer)
            {
                dataitem(PageLoop; Integer)
                {
                    dataitem(DimensionLoop1; Integer)
                    {
                        column(DimText; 'Text[120]')
                        {
                        }
                        column(Number_Integer; 'Integer')
                        {
                        }
                        column(HeaderDimensionsCaption; 'Label')
                        {
                        }
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        dataitem("Sales Shipment Buffer"; Integer)
                        {
                            column(SalesShpBufferPostingDate; 'Text')
                            {
                            }
                            column(SalesShipmentBufferQty; 'Decimal')
                            {
                            }
                            column(ShipmentCaption; 'Label')
                            {
                            }
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            column(DimText_DimensionLoop2; 'Text[120]')
                            {
                            }
                            column(LineDimensionsCaption; 'Label')
                            {
                            }
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            column(TempPostedAsmLineNo; 'Text')
                            {
                            }
                            column(TempPostedAsmLineDesc; 'Text')
                            {
                            }
                            column(TempPostedAsmLineVariantCode; 'Text')
                            {
                            }
                            column(TempPostedAsmLineQuantity; 'Decimal')
                            {
                            }
                            column(TempPostedAsmLineUOMCode; 'Text[10]')
                            {
                            }
                        }
                        column(LineAmount_SalesInvLine; 'Decimal')
                        {
                        }
                        column(Desc_SalesInvLine; 'Text[100]')
                        {
                        }
                        column(No_SalesInvLine; 'Code[20]')
                        {
                        }
                        column(Qty_SalesInvLine; 'Decimal')
                        {
                        }
                        column(UOM_SalesInvoiceLine; 'Code[10]')
                        {
                        }
                        column(HSN_SAC_Code; 'Code[10]')
                        {
                        }
                        column(UnitPrice_SalesInvLine; 'Decimal')
                        {
                        }
                        column(LineDiscount_SalesInvLine; 'Decimal')
                        {
                        }
                        column(LineDiscount_SalesInvLineAmount; 'Decimal')
                        {
                        }
                        column(PostedShipmentDate; 'Text')
                        {
                        }
                        column(SalesLineType; 'Text')
                        {
                        }
                        column(DirectDebitPLARG_SalesInvLine; 'Text')
                        {
                        }
                        column(SourceDocNo_SalesInvLine; 'Text')
                        {
                        }
                        column(Supplementary; 'Text')
                        {
                        }
                        column(InvDiscountAmount; 'Decimal')
                        {
                        }
                        column(TotalSubTotal; 'Decimal')
                        {
                        }
                        column(TotalInvoiceDiscAmount; 'Decimal')
                        {
                        }
                        column(TotalText; 'Text[50]')
                        {
                        }
                        column(SalesInvoiceLineAmount; 'Decimal')
                        {
                        }
                        column(TotalAmount; 'Decimal')
                        {
                        }
                        column(AmtInclVAT_SalesInvLine; 'Decimal')
                        {
                        }
                        column(TotalInclVATText; 'Text[50]')
                        {
                        }
                        column(TotalAmountInclVAT; 'Decimal')
                        {
                        }
                        column(TaxAmount_SalesInvLine; 'Text')
                        {
                        }
                        column(ChargesAmount; 'Decimal')
                        {
                        }
                        column(OtherTaxesAmount; 'Decimal')
                        {
                        }
                        column(SalesInvLineTotalTDSTCSInclSHECESS; 'Decimal')
                        {
                        }
                        column(VATBaseDisc_SalesInvHdr; 'Decimal')
                        {
                        }
                        column(TotalPaymentDiscountOnVAT; 'Decimal')
                        {
                        }
                        column(VATAmtLineVATAmtText; 'Text[30]')
                        {
                        }
                        column(TotalExclVATText; 'Text[50]')
                        {
                        }
                        column(TotalAmountVAT; 'Decimal')
                        {
                        }
                        column(LineNo_SalesInvLine; 'Integer')
                        {
                        }
                        column(UnitPriceCaption; 'Label')
                        {
                        }
                        column(DiscountCaption; 'Label')
                        {
                        }
                        column(AmountCaption; 'Label')
                        {
                        }
                        column(LineDiscountCaption; 'Label')
                        {
                        }
                        column(PostedShipmentDateCaption; 'Label')
                        {
                        }
                        column(SubtotalCaption; 'Label')
                        {
                        }
                        column(ChargesAmountCaption; 'Label')
                        {
                        }
                        column(OtherTaxesAmountCaption; 'Label')
                        {
                        }
                        column(TCSAmountCaption; 'Label')
                        {
                        }
                        column(PaymentDiscVATCaption; 'Label')
                        {
                        }
                        column(Description_SalesInvLineCaption; 'Text')
                        {
                        }
                        column(No_SalesInvoiceLineCaption; 'Text')
                        {
                        }
                        column(Quantity_SalesInvoiceLineCaption; 'Text')
                        {
                        }
                        column(UOM_SalesInvoiceLineCaption; 'Text')
                        {
                        }
                        column(DirectDebitPLARG_SalesInvLineCaption; 'Text')
                        {
                        }
                        column(CGSTAmt; 'Decimal')
                        {
                        }
                        column(SGSTAmt; 'Decimal')
                        {
                        }
                        column(IGSTAmt; 'Decimal')
                        {
                        }
                        column(CessAmt; 'Decimal')
                        {
                        }
                        column(TCSAmt; 'Decimal')
                        {
                        }
                    }
                    dataitem("Detailed GST Ledger Entry"; "Detailed GST Ledger Entry")
                    {
                        column(DGLE_HSN_SAC_Code; 'Code[10]')
                        {
                        }
                        column(GST_Component_Code; 'Code[30]')
                        {
                        }
                        column(GST_Base_Amount; 'Decimal')
                        {
                        }
                        column(GST__; 'Decimal')
                        {
                        }
                        column(GST_Amount; 'Decimal')
                        {
                        }
                    }
                    dataitem(VATCounter; Integer)
                    {
                        column(VATAmtLineVATBase; 'Integer')
                        {
                        }
                        column(VATAmountLineVATAmount; 'Integer')
                        {
                        }
                        column(VATAmountLineLineAmount; 'Integer')
                        {
                        }
                        column(VATAmtLineInvDiscBaseAmt; 'Integer')
                        {
                        }
                        column(VATAmtLineInvDiscAmt; 'Integer')
                        {
                        }
                        column(VATAmtLineVAT_VATCounter; 'Integer')
                        {
                        }
                        column(VATAmtLineVATIdentifier_VATCounter; 'Integer')
                        {
                        }
                        column(VATAmountSpecificationCaption; 'Label')
                        {
                        }
                        column(InvDiscBaseAmtCaption; 'Label')
                        {
                        }
                        column(LineAmountCaption; 'Label')
                        {
                        }
                    }
                    dataitem(VatCounterLCY; Integer)
                    {
                        column(VALSpecLCYHeader; 'Text[80]')
                        {
                        }
                        column(VALExchRate; 'Text[50]')
                        {
                        }
                        column(VALVATBaseLCY; 'Decimal')
                        {
                        }
                        column(VALVATAmountLCY; 'Decimal')
                        {
                        }
                        column(VATAmtLineVAT_VatCounterLCY; 'Integer')
                        {
                        }
                        column(VATAmtLineVATIdentifier_VatCounterLCY; 'Code[20]')
                        {
                        }
                    }
                    dataitem(Total; Integer)
                    {
                    }
                    column(CompanyInfo1Picture; 'Blob')
                    {
                    }
                    column(CompanyInfoName; 'Text[100]')
                    {
                    }
                    column(DocumentCaptionCopyText; 'Text')
                    {
                    }
                    column(CompanyRegistrationLbl; 'Label')
                    {
                    }
                    column(CompanyInfo_GST_RegistrationNo; 'Text')
                    {
                    }
                    column(CustomerRegistrationLbl; 'Label')
                    {
                    }
                    column(Customer_GST_RegistrationNo; 'Text')
                    {
                    }
                    column(GSTComponentCode1; 'Text')
                    {
                    }
                    column(GSTComponentCode2; 'Text')
                    {
                    }
                    column(GSTComponentCode3; 'Text')
                    {
                    }
                    column(GSTComponentCode4; 'Text')
                    {
                    }
                    column(GSTCompAmount1; 'Decimal')
                    {
                    }
                    column(GSTCompAmount2; 'Decimal')
                    {
                    }
                    column(GSTCompAmount3; 'Decimal')
                    {
                    }
                    column(GSTCompAmount4; 'Decimal')
                    {
                    }
                    column(IsGSTApplicable; 'Boolean')
                    {
                    }
                    column(CustAddr1; 'Text[50]')
                    {
                    }
                    column(CompanyAddr1; 'Text[50]')
                    {
                    }
                    column(CustAddr2; 'Text[50]')
                    {
                    }
                    column(CompanyAddr2; 'Text[100]')
                    {
                    }
                    column(CustAddr3; 'Text[50]')
                    {
                    }
                    column(CompanyAddr3; 'Text[50]')
                    {
                    }
                    column(CustAddr4; 'Text')
                    {
                    }
                    column(CompanyAddr4; 'Text[50]')
                    {
                    }
                    column(CustAddr5; 'Text[50]')
                    {
                    }
                    column(CompanyInfoPhoneNo; 'Text[30]')
                    {
                    }
                    column(CustAddr6; 'Text[50]')
                    {
                    }
                    column(PaymentTermsDescription; 'Text[100]')
                    {
                    }
                    column(ShipmentMethodDescription; 'Text[100]')
                    {
                    }
                    column(CompanyInfoHomePage; 'Text[80]')
                    {
                    }
                    column(CompanyInfoEMail; 'Text')
                    {
                    }
                    column(CompanyInfoVATRegNo; 'Text[20]')
                    {
                    }
                    column(CompanyInfoGiroNo; 'Text[20]')
                    {
                    }
                    column(CIN; 'Text')
                    {
                    }
                    column(CompanyInfoBankName; 'Text[100]')
                    {
                    }
                    column(CompanyInfoBankAccountNo; 'Text[30]')
                    {
                    }
                    column(BillToCustNo_SalesInvHdr; 'Code[20]')
                    {
                    }
                    column(PostingDate_SalesInvHdr; 'Text')
                    {
                    }
                    column(VATNoText; 'Text[80]')
                    {
                    }
                    column(VATRegNo_SalesInvHdr; 'Text[20]')
                    {
                    }
                    column(DueDate_SalesInvoiceHdr; 'Text')
                    {
                    }
                    column(SalesPersonText; 'Text[30]')
                    {
                    }
                    column(SalesPurchPersonName; 'Text[50]')
                    {
                    }
                    column(ReferenceText; 'Text[80]')
                    {
                    }
                    column(YourReference_SalesInvHdr; 'Text[35]')
                    {
                    }
                    column(OrderNoText; 'Text[80]')
                    {
                    }
                    column(OrderNo_SalesInvoiceHdr; 'Code[20]')
                    {
                    }
                    column(CustAddr7; 'Text[50]')
                    {
                    }
                    column(CustAddr8; 'Text[50]')
                    {
                    }
                    column(CompanyAddr5; 'Text[50]')
                    {
                    }
                    column(CompanyAddr6; 'Text[50]')
                    {
                    }
                    column(ShipToAddr1; 'Text[50]')
                    {
                    }
                    column(ShipToAddr2; 'Text[50]')
                    {
                    }
                    column(ShipToAddr3; 'Text[50]')
                    {
                    }
                    column(ShipToAddr4; 'Text[50]')
                    {
                    }
                    column(ShipToAddr5; 'Text[50]')
                    {
                    }
                    column(ShipToAddr6; 'Text[50]')
                    {
                    }
                    column(ShipToAddr7; 'Text[50]')
                    {
                    }
                    column(ShipToAddr8; 'Text')
                    {
                    }
                    column(SellerState; 'Text')
                    {
                    }
                    column(BuyerState; 'Text')
                    {
                    }
                    column(ShiptoState; 'Text')
                    {
                    }
                    column(AmountToText; 'Text')
                    {
                    }
                    column(TotalGSTAmount; 'Decimal')
                    {
                    }
                    column(GSTAmtToText; 'Text')
                    {
                    }
                    column(DocDate_SalesInvHeader; 'Text')
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; 'Boolean')
                    {
                    }
                    column(OutputNo; 'Integer')
                    {
                    }
                    column(PricesInclVATYesNo; 'Text')
                    {
                    }
                    column(PageCaption; 'Label')
                    {
                    }
                    column(PLAEntryNo_SalesInvHdr; 'Text')
                    {
                    }
                    column(SupplementaryText; 'Text[30]')
                    {
                    }
                    column(RG23AEntryNo_SalesInvHdr; 'Text')
                    {
                    }
                    column(RG23CEntryNo_SalesInvHdr; 'Text')
                    {
                    }
                    column(PhoneNoCaption; 'Label')
                    {
                    }
                    column(HomePageCaption; 'Label')
                    {
                    }
                    column(VATRegNoCaption; 'Label')
                    {
                    }
                    column(GiroNoCaption; 'Label')
                    {
                    }
                    column(BankNameCaption; 'Label')
                    {
                    }
                    column(BankAccNoCaption; 'Label')
                    {
                    }
                    column(DueDateCaption; 'Label')
                    {
                    }
                    column(InvoiceNoCaption; 'Label')
                    {
                    }
                    column(PostingDateCaption; 'Label')
                    {
                    }
                    column(PLAEntryNoCaption; 'Label')
                    {
                    }
                    column(RG23AEntryNoCaption; 'Label')
                    {
                    }
                    column(RG23CEntryNoCaption; 'Label')
                    {
                    }
                    column(ServiceTaxRegistrationNoCaption; 'Label')
                    {
                    }
                    column(ServiceTaxRegistrationNo; 'Code[20]')
                    {
                    }
                    column(BillToCustNo_SalesInvHdrCaption; 'Text')
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; 'Text')
                    {
                    }
                    column(Acknowledgement_No_; 'Text[30]')
                    {
                    }
                    column(Acknowledgement_Date; 'DateTime')
                    {
                    }
                    column(IRN_Hash; 'Text[64]')
                    {
                    }
                    column(QRCode; 'Text')
                    {
                    }
                    column(eWayBillNo; 'Text[50]')
                    {
                    }
                }
            }
            column(No_SalesInvHdr; 'Code[20]')
            {
            }
            column(InvDiscountAmountCaption; 'Label')
            {
            }
            column(VATPercentageCaption; 'Label')
            {
            }
            column(VATAmountCaption; 'Label')
            {
            }
            column(VATIdentifierCaption; 'Label')
            {
            }
            column(TotalCaption; 'Label')
            {
            }
            column(VATBaseCaption; 'Label')
            {
            }
            column(PaymentTermsCaption; 'Label')
            {
            }
            column(ShipmentMethodCaption; 'Label')
            {
            }
            column(EMailCaption; 'Label')
            {
            }
            column(DocumentDateCaption; 'Label')
            {
            }
            column(DisplayAdditionalFeeNote; 'Boolean')
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NoOfCopies; NoOfCopy)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of copies to print.';
                    }
                    field(DescriptionPrint; DescriptionPrint)
                    {
                        Caption = 'Line Description Print';
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether the line description is printed.';
                    }
                    field(LogInteraction; LogIntaction)
                    {
                        Caption = 'Log Interaction';
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether the interaction is logged.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether assembly components are shown.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAddFeeNote)
                    {
                        Caption = 'Show Additional Fee Note';
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether the additional fee note is shown.';
                    }
                }
            }
        }
    }
    var
        TextTotalAmount: Decimal;
        TotLineAmount: Decimal;
        GSTAmtToText: array[2] of Text[80];
        EMailID: Text[200];
        Loc: Record Location;
        SellerState: Text;
        BuyerState: Text;
        ShiptoState: Text;
        ShiptoGSTIN: Code[20];
        RecState: Record State;
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Customer: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        SalesShipmentBuffer: Record "Sales Shipment Buffer";
        SalesInvCountPrinted: codeunit "Sales Inv.-Printed";
        FormatAddr: codeunit "Format Address";
        SegManagement: codeunit SegManagement;
        TCSAmt: Decimal;
        GSTCompAmount: array[20] of Decimal;
        GSTComponentCode: array[10] of Code[10];
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopy: Integer;
        NoOfLoops: Integer;
        No: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        Continue: Boolean;
        LogIntaction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        DocCaption: Text;
        CalculatedExchRate: Decimal;
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        ChargesAmount: Decimal;
        OtherTaxesAmount: Decimal;
        SupplementaryText: Text[30];
        TotalTCSAmount: Decimal;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        ServiceTaxRegistrationNo: Code[20];
        DisplayAddFeeNote: Boolean;
        IsGSTApplicable: Boolean;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CessAmt: Decimal;
        TotalGSTAmount: Decimal;
        GSTBaseAmount: Decimal;
        VAtAmtSpecLbl: Label 'Label';
        LocaCurrLbl: Label 'Label';
        ExchangRateLbl: Label 'Label';
        SalesPrepInvLbl: Label 'Label';
        TotalIncTaxLbl: Label 'Label';
        TotalExclTaxLbl: Label 'Label';
        SalesPerLbl: Label 'Label';
        TotalLbl: Label 'Label';
        CopyLbl: Label 'Label';
        SalesInvLbl: Label 'Label';
        PageCaptionCapLbl: Label 'Label';
        PhoneNoCaptionLbl: Label 'Label';
        HomePageCaptionCapLbl: Label 'Label';
        VATRegNoCaptionLbl: Label 'Label';
        GiroNoCaptionLbl: Label 'Label';
        BankNameCaptionLbl: Label 'Label';
        BankAccNoCaptionLbl: Label 'Label';
        DueDateCaptionLbl: Label 'Label';
        InvoiceNoCaptionLbl: Label 'Label';
        PostingDateCaptionLbl: Label 'Label';
        PLAEntryNoCaptionLbl: Label 'Label';
        RG23AEntryNoCaptionLbl: Label 'Label';
        RG23CEntryNoCaptionLbl: Label 'Label';
        HeaderDimensionsCaptionLbl: Label 'Label';
        UnitPriceCaptionLbl: Label 'Label';
        DiscountCaptionLbl: Label 'Label';
        AmountCaptionLbl: Label 'Label';
        LineDiscountCaptionLbl: Label 'Label';
        PostedShipmentDateCaptionLbl: Label 'Label';
        SubtotalCaptionLbl: Label 'Label';
        ChargesAmountCaptionLbl: Label 'Label';
        OtherTaxesAmountCaptionLbl: Label 'Label';
        TCSAmountCaptionLbl: Label 'Label';
        PaymentDiscVATCaptionLbl: Label 'Label';
        ShipmentCaptionLbl: Label 'Label';
        LineDimensionsCaptionLbl: Label 'Label';
        VATAmountSpecificationCaptionLbl: Label 'Label';
        InvDiscBaseAmtCaptionLbl: Label 'Label';
        LineAmountCaptionLbl: Label 'Label';
        ShipToAddressCaptionLbl: Label 'Label';
        CGSTLbl: Label 'Label';
        SGSTLbl: Label 'Label';
        IGSTLbl: Label 'Label';
        CessLbl: Label 'Label';
        ServiceTaxRegistrationNoLbl: Label 'Label';
        InvDiscountAmountCaptionLbl: Label 'Label';
        VATPercentageCaptionLbl: Label 'Label';
        VATAmountCaptionLbl: Label 'Label';
        VATIdentifierCaptionLbl: Label 'Label';
        TotalCaptionLbl: Label 'Label';
        VATBaseCaptionLbl: Label 'Label';
        PaymentTermsCaptionLbl: Label 'Label';
        ShipmentMethodCaptionLbl: Label 'Label';
        EMailCaptionLbl: Label 'Label';
        DocumentDateCaptionLbl: Label 'Label';
        CompanyRegistrationLbl: Label 'Label';
        CustomerRegistrationLbl: Label 'Label';
        Cheque: report Check;
        AmountToText: array[2] of Text[80];
        PostedVoucher: report "Check Report";
        DescriptionPrint: Option "Description 1","Description 2";
        LineDescription: Text[100];
        QRCode: Text;
}