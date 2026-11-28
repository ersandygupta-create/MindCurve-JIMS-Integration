page 50275 "E3 Med PRD Refund"
{
    ApplicationArea = All;
    Caption = 'Med PRD Refund';
    PageType = List;
    SourceTable = "E3 Med PRD Refund";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the external document number.';
                }
                field("UHID"; Rec."UHID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unique Health Identification (UHID) of the patient.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the patient.';
                }
                field("Total"; Rec."Total")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference amount between invoice and settlement entries.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of account.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account number.';
                }
                field("Balance Account Type"; Rec."Balance Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balancing account type.';
                }
                field("Balance Account No."; Rec."Balance Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balancing account number.';
                }
                field("Pt. Account No."; Rec."Pt. Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient bank account number.';
                }
                field("IFSC Code"; Rec."IFSC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IFSC code for the patient bank account.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FillRefundEntries)
            {
                ApplicationArea = All;
                Caption = 'Fill Refund Entries';
                Image = GetEntries;
                ToolTip = 'Populates refund entries from G/L invoice and settlement entries for the configured G/L account.';

                trigger OnAction()
                begin
                    FillRefundEntriesFromGLEntry();
                end;
            }
        }
    }

    local procedure FillRefundEntriesFromGLEntry()
    var
        GLEntryInvoice: Record "G/L Entry";
        GLEntrySettlement: Record "G/L Entry";
        RefundEntry: Record "E3 Med PRD Refund";
        HardcodedGLAccNo: Code[20];
        SettlementTotal: Decimal;
        DiffAmount: Decimal;
        InsertedCount: Integer;
    begin
        // Hardcoded single G/L Account No. to check
        HardcodedGLAccNo := '1121204008';
        InsertedCount := 0;

        GLEntryInvoice.Reset();
        GLEntryInvoice.SetCurrentKey("G/L Account No.", "External Document No.");
        GLEntryInvoice.SetRange("G/L Account No.", HardcodedGLAccNo);
        GLEntryInvoice.SetRange("Med Refund created", false);
        GLEntryInvoice.SetFilter("External Document No.", '<>%1', '');
        GLEntryInvoice.SetFilter("E3 HIS Document Type", '%1', 'Invoice');
        // If your G/L Entry has a HIS Document Type field, uncomment and adjust the next line:
        // GLEntryInvoice.SetRange("HIS Document Type", GLEntryInvoice."HIS Document Type"::Invoice);

        if GLEntryInvoice.FindSet() then
            repeat
                SettlementTotal := 0;
                GLEntrySettlement.Reset();
                GLEntrySettlement.SetRange("G/L Account No.", HardcodedGLAccNo);
                GLEntrySettlement.SetRange("External Document No.", GLEntryInvoice."External Document No.");
                GLEntrySettlement.SetRange("E3 UHID", GLEntryInvoice."E3 UHID");
                GLEntryInvoice.SetFilter("E3 HIS Document Type", '%1', 'Settlement');
                // Example if you have a HIS Document Type enum/option field:
                // GLEntrySettlement.SetRange("HIS Document Type", GLEntrySettlement."HIS Document Type"::Settlement);

                if GLEntrySettlement.FindSet() then
                    repeat
                        if GLEntrySettlement."Entry No." <> GLEntryInvoice."Entry No." then
                            SettlementTotal += GLEntrySettlement.Amount;
                    until GLEntrySettlement.Next() = 0;

                DiffAmount := GLEntryInvoice.Amount - SettlementTotal;

                if DiffAmount <> 0 then begin
                    if not RefundEntry.Get(GLEntryInvoice."External Document No.", '') then begin
                        RefundEntry.Init();
                        RefundEntry."External Document No." := GLEntryInvoice."External Document No.";
                        RefundEntry."UHID" := ''; // Set to GLEntryInvoice."UHID" if present on G/L Entry
                        // RefundEntry."Patient Name" := GLEntryInvoice."Patient Name";
                        RefundEntry."Total" := DiffAmount;
                        RefundEntry."Account Type" := RefundEntry."Account Type"::"G/L Account";
                        RefundEntry."Account No." := HardcodedGLAccNo;
                        RefundEntry."Balance Account Type" := RefundEntry."Balance Account Type"::"Bank Account";
                        // RefundEntry."Pt. Account No." := GLEntryInvoice."Pt. Account No.";
                        // RefundEntry."IFSC Code" := GLEntryInvoice."IFSC Code";
                        RefundEntry.Insert(true);

                        GLEntryInvoice."Med Refund created" := true;
                        GLEntryInvoice.Modify();

                        InsertedCount += 1;
                    end;
                end;
            until GLEntryInvoice.Next() = 0;

        CurrPage.Update(false);
        Message('%1 refund entry line(s) inserted.', InsertedCount);
    end;
}