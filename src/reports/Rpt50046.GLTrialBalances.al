report 50046 "MIS Trial Balance Excel"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'MIS Trial Balance Excel';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type" = const(Posting));
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                CreateExcelHeader();
            end;

            trigger OnAfterGetRecord()
            var
                GLBal: Decimal;
            begin
                Clear(DebitAmount);
                Clear(CreditAmount);
                Clear(OpeningDebit);
                Clear(OpeningCredit);
                Clear(ClosingDebit);
                Clear(ClosingCredit);

                //==========================
                // Opening Balance
                //==========================
                GLBal := 0;
                OpeningDebit := 0;
                OpeningCredit := 0;

                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", GLAccount."No.");
                GLEntry.SetRange("Posting Date", 0D, CalcDate('<-1D>', FromDate));

                if UnitCode <> '' then
                    GLEntry.SetRange("Global Dimension 1 Code", UnitCode);

                if GLEntry.FindSet() then
                    repeat
                        GLBal += GLEntry.Amount;
                    until GLEntry.Next() = 0;

                // Convert balance into Debit/Credit
                if GLBal >= 0 then
                    OpeningDebit := GLBal
                else
                    OpeningCredit := Abs(GLBal);

                // Period Debit / Credit
                //==========================
                Clear(GLBal);

                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", GLAccount."No.");
                GLEntry.SetRange("Posting Date", FromDate, ToDate);

                if UnitCode <> '' then
                    GLEntry.SetRange("Global Dimension 1 Code", UnitCode);

                if GLEntry.FindSet() then
                    repeat
                        if GLEntry.Amount < 0 then
                            DebitAmount += Abs(GLEntry.Amount)
                        else
                            CreditAmount += GLEntry.Amount;
                    until GLEntry.Next() = 0;

                //==========================
                // Closing Balance
                //==========================
                Clear(GLBal);

                GLEntry.Reset();
                GLEntry.SetRange("G/L Account No.", GLAccount."No.");
                GLEntry.SetRange("Posting Date", 0D, ToDate);

                if UnitCode <> '' then
                    GLEntry.SetRange("Global Dimension 1 Code", UnitCode);

                if GLEntry.FindSet() then
                    repeat
                        GLBal += GLEntry.Amount;
                    until GLEntry.Next() = 0;

                if GLBal >= 0 then
                    ClosingDebit := GLBal
                else
                    ClosingCredit := Abs(GLBal);

                AddExcelLine();
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
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                    }

                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                    }

                    field(UnitCode; UnitCode)
                    {
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        CompanyInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";

        FromDate: Date;
        ToDate: Date;
        UnitCode: Code[20];

        OpeningDebit: Decimal;
        OpeningCredit: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        ClosingDebit: Decimal;
        ClosingCredit: Decimal;

    local procedure CreateExcelHeader()
    begin
        CompanyInfo.Get();

        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompanyInfo.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('MIS Trial Balance', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(StrSubstNo('Period : %1 to %2', FromDate, ToDate), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();

        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn('G/L Account No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Name', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Income/Balance Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account Category', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account Sub Category', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Opening Debit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Opening Credit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Debit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Credit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Closing Debit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('Closing Credit', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure AddExcelLine()
    begin
        ExcelBuffer.NewRow();

        ExcelBuffer.AddColumn(GLAccount."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(GLAccount.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Format(GLAccount."Income/Balance"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Format(GLAccount."Account Type"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Format(GLAccount."Account Category"), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        GLAccount.CalcFields("Account Subcategory Descript.");
        ExcelBuffer.AddColumn(GLAccount."Account Subcategory Descript.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(OpeningDebit, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(OpeningCredit, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CreditAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(DebitAmount, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ClosingDebit, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ClosingCredit, false, '', false, false, false, '#,##0.00', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelBook()
    begin
        ExcelBuffer.CreateNewBook('MIS Trial Balance');
        ExcelBuffer.WriteSheet('MIS Trial Balance', CompanyName, UserId);
        ExcelBuffer.CloseBook();

        ExcelBuffer.SetFriendlyFilename('MIS Trial Balance');
        ExcelBuffer.OpenExcel();
    end;
}