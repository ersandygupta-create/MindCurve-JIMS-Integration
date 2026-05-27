page 50125 "E3 Salary Component"
{
    Caption = 'Salary Component';
    PageType = ListPart;
    SourceTable = "E3 Salary Component";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the document number for the salary component.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the entry number for the salary component.';
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the employee code for the salary component.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the employee name for the salary component.';
                }
                field("Salary Head"; Rec."Salary Head")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the salary head for the salary component.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the amount for the salary component.';

                }
            }
        }
    }
}