page 50220 "E3 Settlement Process Setup"
{
    Caption = 'Settlement Process Setup';
    PageType = List;
    SourceTable = "E3 Settlement Process Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the entry number of the settlement process setup.';
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the settlement type.';
                }
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HIS document type.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account type used for the settlement process.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account number used for the settlement process.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balancing account type used for the settlement process.';
                }
                field("Bal. Account No"; Rec."Bal. Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balancing account number used for the settlement process.';
                }
            }
        }
    }
}