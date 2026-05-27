page 50123 "E3 Salary Card"
{
    PageType = Document;
    RefreshOnActivate = true;
    DelayedInsert = false;
    Caption = 'Salary Card';
    SourceTable = "E3 Salary Header";
    SourceTableView = sorting("Entry No.");

    layout
    {
        area(Content)
        {
            group(Salary)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the document number for the salary entry.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the document date for the salary entry.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the amount for the salary entry.';
                }
                field("Group Name"; Rec."Group Name")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the group name for the salary entry.';
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the narration for the salary entry.';
                }
                field("Employee Dimension Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the employee dimension code for the salary entry.';
                    Caption = 'Employee Dimension Code';
                }
                field("Salary Dimension Code"; Rec."Salary Dimension Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the salary dimension code for the salary entry.';
                }
                field(IsProcessed; Rec.IsProcessed)
                {
                    ApplicationArea = All;
                    Tooltip = 'Indicates whether the salary entry has been processed.';
                }
            }
            part(EmployeeDetails; "E3 Employees Details")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("Document No.");
            }
            part(SalaryComponent; "E3 Salary Component")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }


}