page 50128 "E3 Employee Details API"
{
    APIGroup = 'apiPayroll';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Employee Details API';
    DelayedInsert = true;
    EntityName = 'employeeDetails';
    EntitySetName = 'employeeDetailsSet';
    PageType = API;
    SourceTable = "E3 Employee Details";
    ODataKeyFields = "Entry No.";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(employeeCode; Rec."Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field(employeeName; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(employeeStatus; Rec."Employee Status")
                {
                    Caption = 'Employee Status';
                }
                field(dateOfJoining; Rec."Date of Joining")
                {
                    Caption = 'Date of Joining';
                }
                field(dateOfLeaving; Rec."Date of Leaving")
                {
                    Caption = 'Date of Leaving';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(designation; Rec.Designation)
                {
                    Caption = 'Designation';
                }
                field(salaryHead; Rec."Salary Head")
                {
                    Caption = 'Salary Head';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field(grade; Rec.Grade)
                {
                    Caption = 'Grade';
                }
                field(costCenterCode; Rec."Cost Center Code")
                {
                    Caption = 'Cost Center Code';
                }
                field(costCenterName; Rec."Cost Center Name")
                {
                    Caption = 'Cost Center Name';
                }
                field(gender; Rec.Gender)
                {
                    Caption = 'Gender';
                }
                field(pan; Rec.PAN)
                {
                    Caption = 'PAN';
                }
                field(paymode; Rec.Paymode)
                {
                    Caption = 'Paymode';
                }
                field(bankAccountName; Rec."Bank Account Name")
                {
                    Caption = 'Bank Account Name';
                }
                field(bankAccountNo; Rec."Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                }
                field(ifscCode; Rec."IFSC Code")
                {
                    Caption = 'IFSC Code';
                }
                field(salaryHold; Rec."Salary Hold")
                {
                    Caption = 'Salary Hold';
                }
                field(pfNo; Rec."PF No.")
                {
                    Caption = 'PF No.';
                }
                field(uanNo; Rec."UAN No.")
                {
                    Caption = 'UAN No.';
                }
                field(esiNo; Rec."ESI No.")
                {
                    Caption = 'ESIC No.';
                }
                field(ptLocation; Rec."PT Location")
                {
                    Caption = 'PT Location';
                }
                field(arrearDays; Rec."Arrear Days")
                {
                    Caption = 'Arrear Days';
                }
                field(stddays; Rec.Stddays)
                {
                    Caption = 'Stddays';
                }
                field(wrkDAYS; Rec.WRKDAYS)
                {
                    Caption = 'WRKDAYS';
                }
                field(lopDays; Rec."LOP DAYS")
                {
                    Caption = 'LOP DAYS';
                }
                field(arrearDAY; Rec.ARREARDAYS)
                {
                    Caption = 'ARREARDAYS';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;
}