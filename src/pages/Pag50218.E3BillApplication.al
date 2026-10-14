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
                field("Receipt From Patient Against Bill"; Rec."Receipt From Patient Against Bill")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt received from the patient against the bill.';
                }
                field("Disallowed Service Wise"; Rec."Disallowed Service Wise")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service-wise disallowed amount.';
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
                field("Balance TPA Due"; Rec."Balance TPA Due")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balance TPA due.';
                }
                field("Admission Date"; Rec."Admission Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the admission date.';
                }
                field("Discharged Date"; Rec."Discharged Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discharged date.';
                }
                field("Patient Type"; Rec."Patient Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient type.';
                }
                field("Reg No."; Rec."Reg No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the registration number.';
                }
                field("Insurance Co."; Rec."Insurance Co.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the insurance company.';
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
                begin
                    Report.RunModal(
                        Report::"E3 Bill Application Import",
                        true,
                        false);
                end;
            }
        }
    }
}