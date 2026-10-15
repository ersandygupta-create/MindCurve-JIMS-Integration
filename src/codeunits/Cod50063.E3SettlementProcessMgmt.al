
codeunit 50063 "E3 Bill Application JV"
{
    procedure InitGenJnlLineBillApplication(
        var BillApplication: Record "E3 Bill Application";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10])
    var
        SelectedBillApplication: Record "E3 Bill Application";
        GenJournalLine: Record "Gen. Journal Line";
        SettlementProcessSetup: Record "E3 Settlement Process Setup";
        LineNo: Integer;
        DocumentNo: Code[20];
        TotalDebitAmount: Decimal;
        CustomerCreditAmount: Decimal;
        ExcessAmount: Decimal;
        TotalReceived: Decimal;
        MappingLbl: Label 'Settlement Process Setup not found for %1.';
        ExpectedCreditAmount: Decimal;
        OrganizationReceipt: Record "E3 Organization Receipt";
    begin
        SelectedBillApplication.CopyFilters(BillApplication);

        if SelectedBillApplication.IsEmpty() then
            Error('No Bill Application records found.');

        if SelectedBillApplication.FindSet() then
            repeat
                SelectedBillApplication.TestField("Customer Code");
                SelectedBillApplication.TestField("Bill No");
                SelectedBillApplication.TestField("Bill Date");

                DocumentNo := CopyStr(
                    SelectedBillApplication."Bill No",
                    1,
                    MaxStrLen(DocumentNo));

                TotalReceived :=
                    SelectedBillApplication."Total Received From TPA";

                // Calculate excess billable.
                ExcessAmount :=
                    TotalReceived -
                    SelectedBillApplication."Bill Amount";

                // The debit lines must equal Total Received From TPA.
                TotalDebitAmount := 0;

                // Get next line number.
                GenJournalLine.Reset();
                GenJournalLine.SetRange(
                    "Journal Template Name",
                    JournalTemplateName);
                GenJournalLine.SetRange(
                    "Journal Batch Name",
                    JournalBatchName);

                if GenJournalLine.FindLast() then
                    LineNo := GenJournalLine."Line No."
                else
                    LineNo := 0;

                // 1. Debit TPA Unsettled.
                if SelectedBillApplication."Payment Received" <> 0 then begin
                    LineNo += 10000;

                    AddMappedJournalLine(
                        GenJournalLine,
                        JournalTemplateName,
                        JournalBatchName,
                        LineNo,
                        SelectedBillApplication,
                        DocumentNo,
                        'TPA Unsettled',
                        SelectedBillApplication."Payment Received");

                    TotalDebitAmount +=
                        SelectedBillApplication."Payment Received";
                end;

                // 2. Debit Disallowed Registration Wise.
                if SelectedBillApplication."Disallowed Reg. Wise" <> 0 then begin
                    LineNo += 10000;

                    AddMappedJournalLine(
                        GenJournalLine,
                        JournalTemplateName,
                        JournalBatchName,
                        LineNo,
                        SelectedBillApplication,
                        DocumentNo,
                        'Disallowed Reg. Wise',
                        SelectedBillApplication."Disallowed Reg. Wise");

                    TotalDebitAmount +=
                        SelectedBillApplication."Disallowed Reg. Wise";
                end;

                // 3. Debit Disallowed Billable.
                if SelectedBillApplication."Disallowed Billable" <> 0 then begin
                    LineNo += 10000;

                    AddMappedJournalLine(
                        GenJournalLine,
                        JournalTemplateName,
                        JournalBatchName,
                        LineNo,
                        SelectedBillApplication,
                        DocumentNo,
                        'Disallowed Billable',
                        SelectedBillApplication."Disallowed Billable");

                    TotalDebitAmount +=
                        SelectedBillApplication."Disallowed Billable";
                end;

                // 4. Debit Disallowed Security.
                if SelectedBillApplication."Disallowed Security" <> 0 then begin
                    LineNo += 10000;

                    AddMappedJournalLine(
                        GenJournalLine,
                        JournalTemplateName,
                        JournalBatchName,
                        LineNo,
                        SelectedBillApplication,
                        DocumentNo,
                        'Disallowed Security',
                        SelectedBillApplication."Disallowed Security");

                    TotalDebitAmount +=
                        SelectedBillApplication."Disallowed Security";
                end;

                // 5. Debit TDS Amount.
                if SelectedBillApplication."TDS Amount" <> 0 then begin
                    LineNo += 10000;

                    AddMappedJournalLine(
                        GenJournalLine,
                        JournalTemplateName,
                        JournalBatchName,
                        LineNo,
                        SelectedBillApplication,
                        DocumentNo,
                        'TDS Amount',
                        SelectedBillApplication."TDS Amount");

                    TotalDebitAmount +=
                        SelectedBillApplication."TDS Amount";
                end;

                if ExcessAmount > 0 then begin
                    CustomerCreditAmount :=
                        SelectedBillApplication."Bill Amount";

                    LineNo += 10000;

                    AddMappedJournalLine(GenJournalLine, JournalTemplateName, JournalBatchName,
                        LineNo, SelectedBillApplication, DocumentNo, 'Excess Billable',
                        -ExcessAmount);
                end else
                    CustomerCreditAmount := TotalReceived;

                // 6. Credit Customer.
                if CustomerCreditAmount <> 0 then begin
                    LineNo += 10000;

                    AddCustomerJournalLine(GenJournalLine, JournalTemplateName, JournalBatchName,
                        LineNo,
                        SelectedBillApplication,
                        DocumentNo,
                        -CustomerCreditAmount);
                end;

                // Validate the voucher before continuing.
                ExpectedCreditAmount := CustomerCreditAmount;
                if ExcessAmount > 0 then
                    ExpectedCreditAmount += ExcessAmount;

                if Round(TotalDebitAmount, 0.01) <>
                   Round(ExpectedCreditAmount, 0.01)
                then
                    Error(
                        'JV is not balanced for Bill %1. Debit Amount: %2, Credit Amount: %3.',
                        SelectedBillApplication."Bill No",
                        TotalDebitAmount,
                        ExpectedCreditAmount);
            until SelectedBillApplication.Next() = 0;
    end;

    local procedure AddMappedJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        LineNo: Integer;
        BillApplication: Record "E3 Bill Application";
        DocumentNo: Code[20];
        HISTransactionType: Text[50];
        Amount: Decimal)
    var
        SettlementProcessSetup: Record "E3 Settlement Process Setup";
        LineDescription: Text[100];
    begin
        SettlementProcessSetup.Reset();
        SettlementProcessSetup.SetRange("Settlement Type", SettlementProcessSetup."Settlement Type"::Application);
        SettlementProcessSetup.SetRange("HIS Document Type", HISTransactionType);

        if not SettlementProcessSetup.FindFirst() then
            Error(
                'Settlement Process Setup not found for %1.',
                HISTransactionType);

        SettlementProcessSetup.TestField("Account No.");

        GenJournalLine.Init();
        GenJournalLine.Validate("Journal Template Name", JournalTemplateName);
        GenJournalLine.Validate("Journal Batch Name", JournalBatchName);
        GenJournalLine."Line No." := LineNo;
        GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::" ");
        GenJournalLine.Validate("Document No.", DocumentNo);
        GenJournalLine.Validate("Posting Date", BillApplication."Bill Date");

        GenJournalLine.Validate("Account Type", SettlementProcessSetup."Account Type");
        GenJournalLine.Validate("Account No.", SettlementProcessSetup."Account No.");
        GenJournalLine.Validate(Amount, Amount);

        LineDescription := CopyStr(
            StrSubstNo(
                '%1 - Bill %2',
                HISTransactionType,
                BillApplication."Bill No"),
            1,
            MaxStrLen(GenJournalLine.Description));

        GenJournalLine.Validate(Description, LineDescription);

        GenJournalLine."E3 Receipt No." := CopyStr(
            BillApplication."Receipt No.",
            1,
            MaxStrLen(GenJournalLine."E3 Receipt No."));
        GenJournalLine."E3 UHID" := BillApplication."UHIDNo";
        GenJournalLine."E3 Patient Name" :=
            BillApplication."Patient Name";
        GenJournalLine."E3 HIS Document Type" :=
            CopyStr(
                HISTransactionType,
                1,
                MaxStrLen(GenJournalLine."E3 HIS Document Type"));

        if BillApplication."Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.Validate(
                "Shortcut Dimension 1 Code",
                BillApplication."Shortcut Dimension 1 Code");

        GenJournalLine.Insert(true);
    end;

    local procedure AddCustomerJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        LineNo: Integer;
        BillApplication: Record "E3 Bill Application";
        DocumentNo: Code[20];
        Amount: Decimal)
    begin
        GenJournalLine.Init();
        GenJournalLine.Validate("Journal Template Name", JournalTemplateName);
        GenJournalLine.Validate("Journal Batch Name", JournalBatchName);
        GenJournalLine."Line No." := LineNo;
        GenJournalLine.Validate("Document No.", DocumentNo);
        GenJournalLine.Validate("Posting Date", BillApplication."Bill Date");
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
        GenJournalLine.Validate("Account No.", BillApplication."Customer Code");
        GenJournalLine.Validate(Amount, Amount);
        GenJournalLine.Validate(Description,
            CopyStr(
                StrSubstNo(
                    'Bill Application - %1',
                    BillApplication."Bill No"),
                1,
                MaxStrLen(GenJournalLine.Description)));

        GenJournalLine."E3 Receipt No." := CopyStr(
            BillApplication."Receipt No.",
            1,
            MaxStrLen(GenJournalLine."E3 Receipt No."));
        GenJournalLine."E3 UHID" := BillApplication."UHIDNo";
        GenJournalLine."E3 Patient Name" := BillApplication."Patient Name";

        if BillApplication."Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.Validate("Shortcut Dimension 1 Code", BillApplication."Shortcut Dimension 1 Code");
        GenJournalLine.Insert(true);
    end;
}
