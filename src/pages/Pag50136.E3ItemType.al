page 50136 "E3 Item Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Item Type";
    Editable = true;
    Caption = 'Item Type';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Manual Code"; Rec."Manual Code")
                {
                    ToolTip = 'Specifies the value of the Manual Code field';
                    ApplicationArea = All;
                }
                field(IsSent; Rec.IsSent)
                {
                    ToolTip = 'Specifies the value of the Is Sent field';
                    ApplicationArea = All;
                    Editable = false;
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
                    E3APIIntegrationMgmt: Codeunit "E3 Item Type Mgmt.";
                    E3ItemType: Record "E3 Item Type";
                begin
                    E3ItemType.Get(Rec.Code, Rec.Name);
                    if E3APIIntegrationMgmt.SendItemTypeDetails(E3ItemType) then
                        Message('Data sent successfully.')
                    else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
