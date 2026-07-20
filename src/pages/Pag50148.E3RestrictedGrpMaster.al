page 50148 "E3 Restricted Group Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Restricted Group Master";
    Editable = true;
    Caption = 'Restricted Group Master';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field(IsSent; Rec.IsSent)
                {
                    ToolTip = 'Specifies the value of the Is Sent field';
                    ApplicationArea = All;
                    Editable = true;
                }
                field(Response; Rec.Response)
                {
                    ToolTip = 'Specifies the value of the Response field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Sent"; Rec."Last Sent")
                {
                    ToolTip = 'Specifies the value of the Last Sent field';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SENDTOSTAGING)
            {
                ApplicationArea = all;
                Caption = 'Send Data to Staging';
                ToolTip = 'Sends the data to staging tables for processing';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = SendTo;
                trigger OnAction()
                var
                    RestrictedGrpMgmt: Codeunit "E3 Restricted Group Mgmt.";
                    RestrictedGrpMast: Record "E3 Restricted Group Master";
                begin
                    RestrictedGrpMast.Get(Rec.Code);
                    if RestrictedGrpMast.IsSent then
                        Error('This record has already been sent.');
                    if RestrictedGrpMgmt.SendRestrictedGroupDetails(RestrictedGrpMast) then begin
                        RestrictedGrpMast.Get(Rec.Code);
                        RestrictedGrpMast."First Sent" := true;
                        RestrictedGrpMast.Modify();
                        Message('Data sent successfully.')
                    end else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
