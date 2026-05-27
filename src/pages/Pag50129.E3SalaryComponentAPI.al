page 50129 "E3 Salary Component API"
{
    APIGroup = 'apiPayroll';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Salary Component API';
    DelayedInsert = true;
    EntityName = 'salaryComponent';
    EntitySetName = 'salaryComponents';
    PageType = API;
    SourceTable = "E3 Salary Component";
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
                field(salaryHead; Rec."Salary Head")
                {
                    Caption = 'Salary Head';
                }
                field(amount; Rec."Amount")
                {
                    Caption = 'Amount';
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










