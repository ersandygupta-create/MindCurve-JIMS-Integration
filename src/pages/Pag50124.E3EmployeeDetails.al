page 50124 "E3 Employees Details"
{
    Caption = 'Employee Details';
    //AutoSplitKey = true;
    // DelayedInsert = true;
    // LinksAllowed = false;
    // MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "E3 Employee Details";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the employee number.';
                }
                field("Employee Name"; Rec."Employee Name")

                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the employee name.';
                }
                field("Employee Status"; Rec."Employee Status")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the employee status.';
                }
                field("Date of Joining"; Rec."Date of Joining")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the date of joining for the employee.';
                }
                field("Date of Leaving"; Rec."Date of Leaving")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the date of leaving for the employee.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the first shortcut dimension code for the employee.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the designation of the employee.';
                }
                field("Salary Head"; Rec."Salary Head")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the salary head for the employee.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the department of the employee.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the grade of the employee.';
                }
                field("Cost Center Code"; Rec."Cost Center Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the cost center code for the employee.';
                }
                field("Cost Center Name"; Rec."Cost Center Name")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the cost center name for the employee.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the gender of the employee.';
                }
                field(PAN; Rec.PAN)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the PAN number of the employee.';

                }
                field(Paymode; Rec.Paymode)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the pay mode for the employee.';
                }
                field("Bank Account Name"; Rec."Bank Account Name")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the bank account name of the employee.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the bank account number of the employee.';
                }
                field("IFSC Code"; Rec."IFSC Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the IFSC code of the employee.';
                }
                field("Salary Hold"; Rec."Salary Hold")
                {
                    ApplicationArea = All;
                    Tooltip = 'Indicates whether the salary for the employee is on hold.';
                }
                field("PF No."; Rec."PF No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the PF number of the employee.';
                }
                field("UAN No."; Rec."UAN No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the UAN number of the employee.';
                }
                field("ESI No."; Rec."ESI No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the ESI number of the employee.';
                }
                field("PT Location"; Rec."PT Location")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the professional tax location of the employee.';
                }
                field("Arrear Days"; Rec."Arrear Days")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of arrear days for the employee.';
                }
                field(Stddays; Rec.Stddays)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of standard days for the employee.';
                }
                field(WRKDAYS; Rec.WRKDAYS)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of worked days for the employee.';
                }
                field("LOP DAYS"; Rec."LOP DAYS")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of loss of pay days for the employee.';
                }
                field(ARREARDAYS; Rec.ARREARDAYS)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the number of arrear days for the employee.';
                }
            }
        }
    }
}