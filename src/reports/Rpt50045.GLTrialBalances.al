report 50045 "MIS Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rpt50045.GLTrailBalance.rdl';
    Caption = 'MIS Mapping Trial Balance';
    //UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;



    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Net Change", "Balance at Date";
            DataItemTableView = SORTING("No.") where("Account Type" = filter(Posting));
            // RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            RequestFilterFields = "No.", "Account Type";
            column(FORMAT_TODAY_0_4; FORMAT(TODAY, 0, 4))
            {
            }
            column(CompanyName; CompanyName)
            {

            }
            column(STRSUBSTNO_Text000_PeriodText; STRSUBSTNO(Text000, PeriodText))
            {
            }

            column(FromDate; FromDate)
            {

            }
            column(ToDate; ToDate)
            {

            }
            column(USERID; USERID)
            {
            }
            column(GLAccNo; "No.")
            {
            }
            column(GLAccName; "Name")
            {
            }
            column(GLIncome_Balance; "Income/Balance")
            {
            }
            column(GLAccType; "Account Type")
            {
            }
            column(GLAccCategory; "Account Category")
            {
            }
            column(Account_Subcategory_Descript_; "Account Subcategory Descript.")
            {
            }
            // column(MIS_Mapping_Code; "MIS Mapping Code")
            // {
            // }
            // column(MIS_Mapping_Name; "MIS Mapping Name")
            // {
            // }
            column(CreditAmount; CreditAmount)
            {

            }
            column(DebitAmount; DebitAmount)
            {

            }
            column(OpeningBalance; OpeningBalance)
            {

            }
            column(UnitCode; UnitCode)
            {

            }
            column(ClosingDebit; ClosingDebit)
            {
            }

            column(ClosingCredit; ClosingCredit)
            {
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Reset();
                CompanyInfo.get();
                CompanyName := CompanyInfo.Name;
            end;

            trigger OnAfterGetRecord()

            begin
                DebitAmount := 0;
                CreditAmount := 0;
                OpeningBalance := 0;

                if (UnitCode = '') then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    GLEntry.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
                    IF GLEntry.Find('-') then
                        repeat
                            if (GLEntry.Amount < 0) then
                                DebitAmount += GLEntry.amount
                            else
                                CreditAmount += GLEntry.Amount;
                        until GLEntry.Next = 0;

                    GLEntryOpening.Reset();
                    GLEntryOpening.SetRange("G/L Account No.", "No.");
                    GLEntryOpening.SetFilter("Posting Date", '<%1', FromDate);
                    if GLEntryOpening.Find('-') then
                        repeat
                            OpeningBalance += GLEntryOpening.Amount;
                        until GLEntryOpening.next = 0;

                end else begin
                    GLEntry.Reset();
                    GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    GLEntry.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
                    GLEntry.SetRange("Global Dimension 1 Code", UnitCode);
                    IF GLEntry.Find('-') then
                        repeat
                            if (GLEntry.Amount < 0) then
                                DebitAmount += GLEntry.amount
                            else
                                CreditAmount += GLEntry.Amount;
                        until GLEntry.Next = 0;

                    GLEntryOpening.Reset();
                    GLEntryOpening.SetRange("G/L Account No.", "No.");
                    GLEntryOpening.SetFilter("Posting Date", '<%1', FromDate);
                    GLEntryOpening.SetRange("Global Dimension 1 Code", UnitCode);
                    if GLEntryOpening.Find('-') then
                        repeat
                            OpeningBalance += GLEntryOpening.Amount;
                        until GLEntryOpening.next = 0;

                end;
                // Closing Balance
                "G/L Account".SetRange("Date Filter");
                "G/L Account".SetRange("Global Dimension 1 Filter");

                "G/L Account".SetRange("Date Filter", 0D, ToDate);

                if UnitCode <> '' then
                    "G/L Account".SetRange("Global Dimension 1 Filter", UnitCode);

                "G/L Account".CalcFields("Balance at Date");

                ClosingDebit := 0;
                ClosingCredit := 0;

                if "G/L Account"."Balance at Date" >= 0 then begin
                    ClosingDebit := "G/L Account"."Balance at Date";
                    ClosingCredit := 0;
                end else begin
                    ClosingDebit := 0;
                    ClosingCredit := Abs("G/L Account"."Balance at Date");
                end;


            end;

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
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                        ApplicationArea = All;
                        ToolTip = 'Specifies whether the report should be exported to Microsoft Excel.';
                    }

                    field(FromDate; FromDate)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the starting date for the report.';
                    }

                    field(ToDate; ToDate)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the ending date for the report.';
                    }

                    field(UnitCode; UnitCode)
                    {
                        Caption = 'Unit Code';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the unit code to filter the report data.';
                        TableRelation = "Dimension Value" where("Global Dimension No." = const(1));
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'Period: %1';
        CompanyInfo: Record "Company Information";
        CompanyName: Text;
        GLEntryOpening: Record "G/L Entry";
        GLEntry: Record "G/L Entry";
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        OpeningBalance: Decimal;

        FromDate: Date;
        ToDate: Date;
        UnitCode: text;
        ExcelBuf: Record 370 temporary;
        GLFilter: Text;
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: Label 'Trial Balance';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        TotalDebitNetChange: Decimal;
        TotalCreditNetChange: Decimal;
        TotalDebitBalanceAtDate: Decimal;
        TotalCreditBalanceAtDate: Decimal;
        NewTotalDebitNetChange: Decimal;
        NewTotalCreditNetChange: Decimal;
        NewTotalDebitBalanceAtDate: Decimal;
        NewTotalCreditBalanceAtDate: Decimal;
        GroupNum: Integer;
        LastNewPage: Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        BlankLineNo: Integer;
        ClosingDebit: Decimal;
        ClosingCredit: Decimal;

}
