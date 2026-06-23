pageextension 50079 "E3 State Ext" extends States
{
    actions
    {
        addlast(Processing)
        {
            action("Send To Log")
            {
                ApplicationArea = All;
                Caption = 'Syn To Log';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    StateLog: Record "E3 State Master Log";
                    StateMgmt: Codeunit "E3 State Master Mgmt.";
                begin
                    StateMgmt.SendtoStateMasterLog(StateLog);
                    Message('State data sent to log table successfully.');
                end;
            }
        }
    }
}