page 50127 "E3 Salary Header API"
{
    APIGroup = 'apiPayroll';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Salary Header API';
    DelayedInsert = true;
    EntityName = 'salaryHeader';
    EntitySetName = 'salaryHeaders';
    PageType = API;
    SourceTable = "E3 Salary Header";
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
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(documentDate; Rec."Document Date")
                {
                    Caption = 'Document Date';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(groupName; Rec."Group Name")
                {
                    Caption = 'Group Name';
                }
                field(narration; Rec.Narration)
                {
                    Caption = 'Narration';
                    Tooltip = 'Specifies the narration for the salary entry.';
                }
                field(employeeDimensionCode; Rec."Employee Code")
                {
                    Caption = 'Employee Dimension Code';
                }
                field(salaryDimensionCode; Rec."Salary Dimension Code")
                {
                    Caption = 'Salary Dimension Code';
                }
                field(isProcessed; Rec.IsProcessed)
                {
                    Caption = 'Is Processed';
                }
            }
            part(EmployeeDetails; "E3 Employee Details API")
            {
                Caption = 'Line';
                EntityName = 'employeeDetails';
                EntitySetName = 'employeeDetailsSet';
                SubPageLink = "Document No." = field("Document No.");
            }
            part(SalaryComponent; "E3 Salary Component API")
            {
                Caption = 'Line';
                EntityName = 'salaryComponent';
                EntitySetName = 'salaryComponents';
                SubPageLink = "Document No." = field("Document No.");
            }

        }
    }
    local procedure DuplicateCheck()
    var
        PayrollHDR: Record "E3 Salary Header";
    begin
        PayrollHDR.SetRange("Document No.", Rec."Document No.");
        if not PayrollHDR.IsEmpty then
            error('Duplicate Entry');
    end;

}