page 50264 "E3 Settlement Mapping Setup"
{
    Caption = 'Settlement Mapping Setup';
    PageType = Card;
    SourceTable = "E3 Settlement Mapping Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("G/L Mappings")
            {
                Caption = 'Account Mappings';

                field("Disallowed Reg. Wise Account"; Rec."Disallowed Reg. Wise Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account for Disallowed Reg. Wise.';
                }
                field("Disallowed Billable Account"; Rec."Disallowed Billable Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account for Disallowed Billable.';
                }
                field("Disallowed Security Account"; Rec."Disallowed Security Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account for Disallowed Security.';
                }
                field("TDS Account No."; Rec."TDS Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account for TDS Amount.';
                }
                field("Excess Billable Account"; Rec."Excess Billable Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account for Excess Billable.';
                }
                field("TPA Account"; Rec."TPA Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account for TPA Account.';
                }
            }

        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}