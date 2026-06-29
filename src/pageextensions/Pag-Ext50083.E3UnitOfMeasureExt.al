pageextension 50083 "E3 Unit Of Measure Ext" extends "Units of Measure"
{
    actions
    {
        addlast(Processing)
        {
            action("UOM Send To Log")
            {
                ApplicationArea = All;
                Caption = 'Syn UOM To Log';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UOMLog: Record "E3 Unit Of Measure Update Log";
                    UOMMgmt: Codeunit "E3 Unit Of Measure Mgmt.";
                begin
                    UOMMgmt.SendtoUOMLog(UOMLog);
                    Message('UOM data sent to log table successfully.');
                end;
            }
        }
    }
}