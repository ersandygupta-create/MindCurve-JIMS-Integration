page 50126 "E3 Posted Salary List"
{
    PageType = List;
    ApplicationArea = All;
    Editable = false;
    CardPageId = "E3 Salary Card";
    Caption = 'Salary List';
    SourceTable = "E3 Salary Header";
    UsageCategory = Lists;
    SourceTableView = sorting("Entry No.") where(IsProcessed = filter(true));

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
                    Tooltip = 'Specifies the entry number for the salary entry.';
                }
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
        }
    }
}