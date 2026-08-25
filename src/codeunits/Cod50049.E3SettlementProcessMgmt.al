codeunit 50049 "E3 Settlement Process Mgmt."
{
    trigger OnRun()
    begin

    end;

    procedure InitGenJnlLineSettlementProcess()
    var
        GenJournalLine: Record "Gen. Journal Line";
        HISGLAccountMapping: Record "E3 Settlement Process Setup";
        intLineNo: Integer;
        MOPLbl: Label 'MOP Setup not found for Mode of payment %1.';
        DocumentTypeLbl: Label 'Setup not found for Document Type %1.';
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Settlement Process Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");
        IntegrationSetup.TESTFIELD("Custom Gen. Bus. Posting Group");

        IntegrationSetupLine.Reset();
        IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Settlement);
        IntegrationSetupLine.FindFirst();
        IntegrationSetupLine.TestField("General Journal Template Code");
        IntegrationSetupLine.TestField("General Journal Batch Code");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Settlement Process Enabled") THEN
            EXIT;

        OrgnizationReceipt.RESET();
        OrgnizationReceipt.SETFILTER(OrgnizationReceipt.IsCreated, '%1', FALSE);
        OrgnizationReceipt.SETFILTER(OrgnizationReceipt."Received Amount", '<>%1', 0);
        IF OrgnizationReceipt.FINDSET() THEN
            REPEAT
                GenJournalLine.RESET();
                GenJournalLine.SETRANGE("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                GenJournalLine.SETRANGE("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                IF GenJournalLine.FINDLAST() THEN
                    intLineNo := GenJournalLine."Line No."
                ELSE
                    intLineNo := 10000;

                GenJournalLine.INIT();
                GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                intLineNo += 10000;
                GenJournalLine."Line No." := intLineNo;
                //GenJournalLine.VALIDATE("Document Type", OrgnizationReceipt."Document Type");
                GenJournalLine.VALIDATE("Document No.", OrgnizationReceipt."Document No.");
                GenJournalLine.VALIDATE("Posting Date", OrgnizationReceipt."Document Date");

                HISGLAccountMapping.Reset();
                HISGLAccountMapping.SetRange("Settlement Type", HISGLAccountMapping."Settlement Type"::Orgnization);
                HISGLAccountMapping.SetRange("HIS Document Type", OrgnizationReceipt."HIS Document Type");
                if HISGLAccountMapping.FindFirst() then begin

                    GenJournalLine.VALIDATE("Account Type", HISGLAccountMapping."Account Type");
                    GenJournalLine.VALIDATE("Account No.", HISGLAccountMapping."Account No.");
                end ELSE
                    Error(MOPLbl, OrgnizationReceipt."HIS Document Type");//ak

                GenJournalLine.VALIDATE(Amount, OrgnizationReceipt."Received Amount");
                GenJournalLine.VALIDATE("Cheque Date", OrgnizationReceipt."Instrument Date");
                GenJournalLine.VALIDATE("Cheque No.", COPYSTR(OrgnizationReceipt."Instrument No.", 1, 10));
                GenJournalLine.validate("Bal. Account Type", OrgnizationReceipt."Bal. Account Type");
                GenJournalLine.validate("Bal. Account No.", OrgnizationReceipt."Bal. Account No");
                if OrgnizationReceipt."Shortcut Dimension 1 Code" <> '' then begin
                    GenJournalLine.VALIDATE("Location Code", OrgnizationReceipt."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", OrgnizationReceipt."Shortcut Dimension 1 Code");
                end;

                if OrgnizationReceipt."Shortcut Dimension 2 Code" <> '' then
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", (OrgnizationReceipt."Shortcut Dimension 2 Code"));

                GenJournalLine.VALIDATE("E3 HIS Document Type", OrgnizationReceipt."HIS Document Type");

                GenJournalLine.INSERT();

                OrgnizationReceipt."Created By" := USERID;
                OrgnizationReceipt."Created Date Time" := CURRENTDATETIME;
                OrgnizationReceipt.IsCreated := TRUE;
                OrgnizationReceipt.MODIFY();
            UNTIL OrgnizationReceipt.NEXT() = 0;

    end;

    procedure PostGenJnlLineEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        GenJournalLine1: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);


        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Revenue Creation Enabled") THEN
            EXIT;

        GenJnlLine.RESET();
        GenJnlLine.SETFILTER(GenJnlLine."Account No.", '%1', '');
        GenJnlLine.SETFILTER(GenJnlLine.Amount, '%1', 0);
        IF GenJnlLine.FINDFIRST() THEN BEGIN
            GenJnlLine.DELETEALL;
        END;

        HISIntegrationSetupLine.Reset();
        HISIntegrationSetupLine.SetFilter(Type, '<>%1', IntegrationSetupLine.Type::Consumption);
        IF HISIntegrationSetupLine.FindSet() then
            repeat
                GenJnlLine.RESET();
                GenJnlLine.SETRANGE("Journal Template Name", HISIntegrationSetupLine."General Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", HISIntegrationSetupLine."General Journal Batch Code");
                IF GenJnlLine.FindSet() THEN
                    REPEAT
                        GenJournalLine1.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJournalLine1.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJournalLine1.SETRANGE("Document No.", GenJnlLine."Document No.");
                        GenJournalLine1.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                        IF GenJournalLine1.FINDFIRST() THEN
                            REPEAT
                                GenJnlPostBatch.RUN(GenJournalLine1);
                            UNTIL GenJournalLine1.NEXT() = 0;
                    UNTIL GenJnlLine.NEXT() = 0
                else
                    Error('There is no Entries Pending for the Posting');
            until HISIntegrationSetupLine.Next() = 0;

    end;



    var
        IntegrationSetup: Record "E3 HIS Integartion Setup";
        IntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        OrgnizationReceipt: Record "E3 Organization Receipt";
}