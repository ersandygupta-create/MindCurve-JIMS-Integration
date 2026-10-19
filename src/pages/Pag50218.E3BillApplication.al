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
                    SelectedCustomerCode: Code[20];
                    receiptNo: Code[50];
                    EntryNo: Integer;
                    AllocationReceipt: Record "E3 Allocation Receipt";

                begin
                    receiptNo := Rec.GetRangeMin("Receipt No.");
                    EntryNo := Rec.GetRangeMin("Allocation Receipt Entry No.");
                    // Call the public function on Subpage 1 (AllocationReceipt) to get the highlighted customer code
                    AllocationReceipt.Reset();
                    AllocationReceipt.SetRange("Entry No.", EntryNo);
                    AllocationReceipt.SetRange("Receipt No.", receiptNo);
                    if AllocationReceipt.Find('-') then;
                    SelectedCustomerCode := AllocationReceipt."Customer Code";
                    if SelectedCustomerCode = '' then
                        Error('Please select a customer row in the Allocation Receipt subpage first.');

                    // Pass the customer code into the report
                    BillAppImportReport.SetCustomerFilter(SelectedCustomerCode);
                    BillAppImportReport.RunModal();
                    // Report.RunModal(
                    //     Report::"E3 Bill Application Import",
                    //     true,
                    //     false);
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
}