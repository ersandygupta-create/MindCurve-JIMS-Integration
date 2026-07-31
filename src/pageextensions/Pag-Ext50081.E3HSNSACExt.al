pageextension 50081 "E3 HSN/SAC Ext" extends "HSN/SAC"
{
    layout
    {
        addafter(Type)
        {
            field(GLEN; Rec.GLEN)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the GLEN classification for the HSN/SAC code.';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("HSN Send To Log")
            {
                ApplicationArea = All;
                Caption = 'Syn HSN To Log';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    HSNLog: Record "E3 HSN/SAC Log";
                    HSNMgmt: Codeunit "E3 HSN/SAC Mgmt.";
                begin
                    HSNMgmt.SendtoHSNLog(HSNLog);
                    Message('HSN/SAC data sent to log table successfully.');
                end;
            }
        }
    }
}