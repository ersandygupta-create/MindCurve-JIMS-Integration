pageextension 50020 "E3 Bank Acc. Ledger Entrie" extends "Bank Account Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("E3 Narration"; Rec."E3 Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Narration field.', Comment = '%';
            }
            field("E3 Line Narration"; Rec."E3 Line Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Narration field.', Comment = '%';
            }
            field("E3 Voucher Narration"; Rec."E3 Voucher Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Voucher Narration field.', Comment = '%';
            }
            field("E3 UTR No."; Rec."E3 UTR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the UTR No. field.';
            }
            field("Closed at Date"; Rec."Closed at Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Closed at Date field.';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.';
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedBy field.';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.';
            }
            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedBy field.';
            }
            field("Recipient Bank Name"; Rec."Recipient Bank Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Recipient Bank Name field.';
            }
            field("Recipient Bank Account"; Rec."Recipient Bank Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Recipient Bank Account field.';
            }
            field("Recipient Bank IFSC Code"; Rec."Recipient Bank IFSC Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Recipient Bank IFSC Code field.';
            }
            field("Recipient Branch Name"; Rec."Recipient Branch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Recipient Branch Name field.';
            }
            field("Bank Transaction Status"; Rec."Bank Transaction Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bank Transaction Status field.';
            }
            field("Value Date"; Rec."Value Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Value Date field.';
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            action("Export Payment")
            {
                ApplicationArea = All;
                Caption = 'Export Payment';
                Image = ExportToBank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    IntegrationMgmt: Codeunit "E3 Bank Integration"; // replace 50005 with actual name if different
                    TempBankAccountLedgerEntry: Record "Bank Account Ledger Entry" temporary;
                    BankAccount: Record "Bank Account";
                    Vendor: Record Vendor;
                    i: Integer;
                    Ch: Char;
                begin
                    //   Clear(SCIntegrationMgmt);
                    CurrPage.SetSelectionFilter(BankAccountLedgerEntry);
                    TempBankAccountLedgerEntry.DeleteAll();

                    if BankAccountLedgerEntry.FindSet() then
                        repeat

                            if BankAccountLedgerEntry."Recipient Bank Account" = '' then
                                Error(
                                    'Recipient Bank Account is missing for Entry No. %1. Please update before exporting.',
                                    BankAccountLedgerEntry."Entry No.");

                            if BankAccountLedgerEntry."Recipient Bank IFSC Code" = '' then
                                Error(
                                    'Recipient Bank IFSC Code is missing for Entry No. %1. Please update before exporting.',
                                    BankAccountLedgerEntry."Entry No.");

                            if BankAccountLedgerEntry."Recipient Branch Name" = '' then
                                Error(
                                    'Recipient Branch Name is missing for Entry No. %1. Please update before exporting.',
                                    BankAccountLedgerEntry."Entry No.");

                            if BankAccountLedgerEntry."Recipient Bank Name" = '' then
                                Error(
                                    'Recipient Bank Name is missing for Entry No. %1. Please update before exporting.',
                                    BankAccountLedgerEntry."Entry No.");


                            if Vendor.Get(BankAccountLedgerEntry."Bal. Account No.") then begin
                                if Vendor.Name = '' then
                                    Error('Vendor Name is blank for Vendor No. %1 (Entry No. %2). Please update before exporting.',
                                          Vendor."No.", BankAccountLedgerEntry."Entry No.");

                                if Vendor."E-Mail" = '' then
                                    Error('Vendor Email is blank for Vendor No. %1 (Entry No. %2). Please update before exporting.',
                                          Vendor."No.", BankAccountLedgerEntry."Entry No.");


                                // Check if already exported
                                if BankAccountLedgerEntry."Bank Transaction Status" =
                                   BankAccountLedgerEntry."Bank Transaction Status"::"File exported" then
                                    Error(
                                        'Transaction %1 is already exported. File cannot be generated again.',
                                        BankAccountLedgerEntry."Entry No.");

                                // Process for export
                                if BankAccount.Get(BankAccountLedgerEntry."Bank Account No.") then begin
                                    // if BankAccount."SC Bank Integration" then begin
                                    TempBankAccountLedgerEntry.Init();
                                    TempBankAccountLedgerEntry := BankAccountLedgerEntry;
                                    TempBankAccountLedgerEntry.Insert();
                                end;
                            end;
                        until BankAccountLedgerEntry.Next() = 0;

                    // Export after collecting all
                    IntegrationMgmt.SCExportTransactionRequestFile(TempBankAccountLedgerEntry);
                end;
            }
        }
        addafter("Export Payment")
        {
            action("Vendor Excel Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Pay Letter';
                Image = Report;

                trigger OnAction()
                var
                    BankAccountLed: Record "Bank Account Ledger Entry";
                    FirstBankAccountNo: Code[20];
                    FirstChequeNo: Code[20];
                begin
                    CurrPage.SetSelectionFilter(BankAccountLed);

                    if BankAccountLed.IsEmpty() then
                        Error('Please select at least one bank ledger entry.');

                    // First selected record
                    BankAccountLed.FindFirst();

                    FirstBankAccountNo := BankAccountLed."Bank Account No.";
                    FirstChequeNo := BankAccountLed."Cheque No.";

                    if FirstChequeNo = '' then
                        Error('Cheque No. is blank for the selected record.');

                    // Check all selected records
                    if BankAccountLed.FindSet() then
                        repeat
                            if BankAccountLed."Bank Account No." <> FirstBankAccountNo then
                                Error(
                                    'Selected entries must have the same Bank Account No. %1.',
                                    FirstBankAccountNo);

                            if BankAccountLed."Cheque No." = '' then
                                Error(
                                    'Cheque No. is blank for Document No. %1.',
                                    BankAccountLed."Document No.");

                            if BankAccountLed."Cheque No." <> FirstChequeNo then
                                Error(
                                    'You cannot select different Cheque Nos. Selected Cheque No. %1, but Document No. %2 has Cheque No. %3.',
                                    FirstChequeNo,
                                    BankAccountLed."Document No.",
                                    BankAccountLed."Cheque No.");

                        until BankAccountLed.Next() = 0;

                    // Apply filters for report
                    BankAccountLed.Reset();
                    BankAccountLed.SetRange("Bank Account No.", FirstBankAccountNo);
                    BankAccountLed.SetRange("Cheque No.", FirstChequeNo);

                    Report.RunModal(
                        Report::"Vendor Payment Report",
                        true,
                        false,
                        BankAccountLed);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());

        if not UserSetup."Bank Ledger View" then
            Error('You do not have permission to view Bank Account Ledger Entries.');
    end;
}

