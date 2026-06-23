page 50025 "E3 State Master Log"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "E3 State Master Log";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the state codes as per the Income Tax Act 1961';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of state codes';
                }
                field("State Code (GST Reg. No.)"; Rec."State Code (GST Reg. No.)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the state code for GST Registration of the state as per authorized body.';
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ToolTip = 'Specifies the value of the Sync Status field.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Specifies the value of the Error Message field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Syn to DB")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Syn to DB';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Send the data in the  page to an DB';

                trigger OnAction()
                var
                    StateMaster: Record "E3 State Master Log";
                    StateMastMgmt: Codeunit "E3 State Master Mgmt.";
                begin
                    if StateMaster.Get(Rec.Code) then
                        StateMastMgmt.SendStateMasterDetails(StateMaster)
                end;
            }
        }
    }
}
