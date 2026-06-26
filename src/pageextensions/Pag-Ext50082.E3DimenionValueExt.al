pageextension 50082 "E3 Dimension Value Ext" extends "Dimension Values"
{
    actions
    {
        addlast(Processing)
        {
            action("DEPT Send To Log")
            {
                ApplicationArea = All;
                Caption = 'Syn Dept To Log';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DEPTLog: Record "E3 Dimension Value Log";
                    DEPTMgmt: Codeunit "E3 Dimension Value Mgmt.";
                begin
                    DEPTMgmt.SendToDimensionLog(DEPTLog);
                    Message('DEPT data sent to log table successfully.');
                end;
            }
        }
    }
}