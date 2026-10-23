page 50218 "E3 Bill Application List"
{
    Caption = 'Bill Application List';
    PageType = ListPart;
    SourceTable = "E3 Bill Application";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Receipt No.';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the customer code.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Customer Name.';
                }
                field("Bill No"; Rec."Bill No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the bill number.';
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the bill date.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the patient name.';
                }
                field(UHIDNo; Rec.UHIDNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the UHID number.';
                }
                field("Bill Amount"; Rec."Bill Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the bill amount.';
                }
                field("Payment Received"; Rec."Payment Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment received.';
                }
                field("Disallowed Reg. Wise"; Rec."Disallowed Reg. Wise")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the registration-wise disallowed amount.';
                }
                field("Disallowed Billable"; Rec."Disallowed Billable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the billable disallowed amount.';
                }
                field("Med PRF"; Rec."Med PRF")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Med PRF.';
                }
                field("Disallowed Security"; Rec."Disallowed Security")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the security disallowed amount.';
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the TDS amount.';
                }
                field("Total Received From TPA"; Rec."Total Received From TPA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount received from TPA.';
                }
                field("Excess Billable"; Rec."Excess Billable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the excess billable amount.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(BillApplicationData)
            {
                ApplicationArea = All;
                Caption = 'Get Data';
                Image = GetLines;
                ToolTip = 'Retrieve receipt data for the selected customer and insert it into Bill Application.';

                trigger OnAction()
                var
                    BillAppImportReport: Report "E3 Bill Application Import";
                    OrgReceipt: Record "E3 Organization Receipt";
                    DocNo: Code[50];
                begin
                    DocNo := Rec.GetFilter("Receipt No.");
                    if DocNo = '' then
                        DocNo := Rec."Receipt No.";

                    // Correctly fetch the header record using SetRange instead of .Get()
                    OrgReceipt.Reset();
                    OrgReceipt.SetRange("Document No.", DocNo);
                    if not OrgReceipt.FindFirst() then
                        exit;

                    if OrgReceipt."Selected Allocation Entry No." = 0 then
                        error('Please select a line in Subpage Allocation Receipt.');

                    // Pass the customer code into the report
                    BillAppImportReport.SetCustomerFilter(OrgReceipt."Selected Customer CodeCode");
                    BillAppImportReport.SetEntryNo(OrgReceipt."Selected Allocation Entry No.");
                    BillAppImportReport.SetReceiptNo(OrgReceipt."Document No.");
                    BillAppImportReport.RunModal();
                end;
            }
            action(CreateJV)
            {
                ApplicationArea = All;
                Caption = 'Create JV';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Journal Voucher entries for the selected bill application records.';

                trigger OnAction()
                var
                    BillApp: Record "E3 Bill Application";
                    GenJnlLine: Record "Gen. Journal Line";
                    MappingSetup: Record "E3 Settlement Mapping Setup";
                    OrgReceipt: Record "E3 Organization Receipt";
                    GenJnlBatch: Record "Gen. Journal Batch";
                    LineNo: Integer;
                    TemplateName: Code[10];
                    BatchName: Code[10];
                    TotalDebit: Decimal;
                begin
                    // 1. Get selected records
                    CurrPage.SetSelectionFilter(BillApp);
                    if not BillApp.FindSet() then
                        error('Please select at least one record.');

                    // 2. Fetch Setup Mappings
                    MappingSetup.Get();

                    // Define your General Journal Template and Batch name here (adjust as needed)
                    TemplateName := 'JV-BU11';
                    BatchName := 'DEFAULT';

                    GenJnlBatch.Get(TemplateName, BatchName);

                    // Find last line no to append properly
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", TemplateName);
                    GenJnlLine.SetRange("Journal Batch Name", BatchName);
                    if GenJnlLine.FindLast() then
                        LineNo := GenJnlLine."Line No." + 10000
                    else
                        LineNo := 10000;

                    // 3. Loop through each selected bill application record
                    repeat
                        // if BillApp."JV Created" then
                        //     continue;
                        // Optional: Get parent organization receipt for the Balance Account / Document details
                        OrgReceipt.Reset();
                        OrgReceipt.SetRange("Document No.", BillApp."Receipt No.");
                        if not OrgReceipt.FindFirst() then
                            Clear(OrgReceipt);

                        // --- LINE 1: Balance A/c No (Dr) ---
                        if BillApp."Payment Received" <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::"G/L Account", OrgReceipt."Account No.",
                                BillApp."Payment Received", 0, BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");


                        // --- LINE 2: Disallowed Reg. Wise (Dr) ---
                        if BillApp."Disallowed Reg. Wise" <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::"G/L Account", MappingSetup."Disallowed Reg. Wise Account",
                                BillApp."Disallowed Reg. Wise", 0, BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");


                        // --- LINE 3: Disallowed Billable (Dr) ---
                        if BillApp."Disallowed Billable" <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::"G/L Account", MappingSetup."Disallowed Billable Account",
                                BillApp."Disallowed Billable", 0, BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");


                        // --- LINE 4: Disallowed Security (Dr) ---
                        if BillApp."Disallowed Security" <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::"G/L Account", MappingSetup."Disallowed Security Account",
                                BillApp."Disallowed Security", 0, BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");


                        // --- LINE 5: TDS Amount (Dr) ---
                        if BillApp."TDS Amount" <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::"G/L Account", MappingSetup."TDS Account No.",
                                BillApp."TDS Amount", 0, BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");

                        if BillApp."Excess Billable" <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::"G/L Account", MappingSetup."Excess Billable Account",
                                0, BillApp."Excess Billable", BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");


                        // --- LINE 6: Customer CU00008 (Cr) ---
                        // Total Credit amount equals the sum of all debits



                        TotalDebit := BillApp."Payment Received" + BillApp."Disallowed Reg. Wise" +
                                      BillApp."Disallowed Billable" + BillApp."Disallowed Security" + BillApp."TDS Amount" - BillApp."Excess Billable";

                        if TotalDebit <> 0 then
                            CreateGenJnlLine(TemplateName, BatchName, LineNo, GenJnlLine."Document Type"::Payment,
                                BillApp."Document No.", GenJnlLine."Account Type"::Customer, BillApp."Customer Code",
                                0, TotalDebit, BillApp."Customer Code", BillApp."Bill No", OrgReceipt."Shortcut Dimension 1 Code"
                                , BillApp."Patient Name", BillApp.UHIDNo, OrgReceipt."Instrument No.", OrgReceipt."Document No.");

                        BillApp."JV Created" := true;
                        BillApp.Modify(false);
                    until BillApp.Next() = 0;


                    Message('Journal Voucher lines have been successfully created.');
                end;
            }

        }

    }

    trigger OnAfterGetRecord()
    begin
        UpdateMedPRF();
    end;

    local procedure UpdateMedPRF()
    var
        RevenueLine: Record "E3 HIS Revenue Line";
        MedPRFCode: Record "E3 Med PRF";
        TotalMedPRF: Decimal;
    begin
        TotalMedPRF := 0;

        RevenueLine.Reset();
        RevenueLine.SetRange("Document No.", Rec."Bill No");

        if RevenueLine.FindSet() then
            repeat
                if MedPRFCode.Get(RevenueLine."Service Item Code") then
                    TotalMedPRF += RevenueLine.Amount;
            until RevenueLine.Next() = 0;

        Rec."Med PRF" := TotalMedPRF;
    end;

    procedure SetCustomerFilter(DocNo: Code[20]; AllocationEntryNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Document No.", DocNo);
        Rec.SetRange("Allocation Receipt Entry No.", AllocationEntryNo);
        CurrPage.Update(false);
    end;

    procedure SetAllocationFilter(DocNo: Code[20]; AllocationEntryNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Receipt No.", DocNo);
        Rec.SetRange("Allocation Receipt Entry No.", AllocationEntryNo);
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateAllocationFilter();
    end;

    procedure UpdateAllocationFilter()
    var
        RecordA: Record "E3 Organization Receipt";
        DocNo: Code[20];
    begin
        DocNo := Rec.GetFilter("Document No.");
        if DocNo = '' then
            DocNo := Rec."Receipt No.";
        if DocNo = '' then
            DocNo := Rec."Document No.";

        if DocNo <> '' then begin
            RecordA.Reset();
            RecordA.SetRange("Document No.", DocNo);
            if RecordA.FindFirst() then begin
                // Filter Table C correctly using SetRange instead of .Get()
                Rec.SetRange("Receipt No.", DocNo);
                Rec.SetRange("Allocation Receipt Entry No.", RecordA."Selected Allocation Entry No.");
            end;
        end;
    end;
    // Helper procedure to insert Gen. Journal Lines cleanly
    local procedure CreateGenJnlLine(TemplateName: Code[10]; BatchName: Code[10]; var LineNo: Integer;
        DocType: Enum "Gen. Journal Document Type"; DocNo: Code[50]; AccType: Enum "Gen. Journal Account Type";
        AccNo: Code[20]; Amt: Decimal; AmtLCY: Decimal; CustNo: Code[20]; DescriptionText: Text[100]; BU: Code[20];
        PatientName: text[100]; UHID: Code[50]; UTNo: Code[50]; ReceiptNo: Code[50])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := TemplateName;
        GenJnlLine."Journal Batch Name" := BatchName;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Document Type" := DocType;
        GenJnlLine."Document No." := ReceiptNo;
        GenJnlLine."Posting Date" := WorkDate();
        GenJnlLine.Validate("Shortcut Dimension 1 Code", BU);
        GenJnlLine.Validate("Location Code", BU);
        GenJnlLine."Account Type" := AccType;
        GenJnlLine."Account No." := AccNo;
        GenJnlLine."E3 Patient Name" := PatientName;
        GenJnlLine."E3 UTR No." := UTNo;
        GenJnlLine."E3 UHID" := UHID;
        GenJnlLine."External Document No." := DescriptionText;
        GenJnlLine.Description := CopyStr(DescriptionText, 1, MaxStrLen(GenJnlLine.Description));

        if Amt > 0 then
            GenJnlLine.Amount := Amt
        else
            GenJnlLine.Amount := -1 * AmtLCY;

        // If account type is Customer, map balancing/customer details appropriately
        // if AccType = AccType::Customer then
        //     GenJnlLine."Bal. Account No." := CustNo;
        GenJnlLine.Validate(Amount);

        GenJnlLine.Insert(true);
        LineNo += 10000;
    end;
}