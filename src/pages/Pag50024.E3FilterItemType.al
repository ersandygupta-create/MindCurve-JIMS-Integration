page 50024 "E3 Filter Item Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Filter Item Type";
    Editable = true;
    Caption = 'Filter Item Type';

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
                }
                field(Response; Rec.Response)
                {
                    ToolTip = 'Specifies the value of the Response field';
                    ApplicationArea = All;
                }
                field("Last Sent"; Rec."Last Sent")
                {
                    ToolTip = 'Specifies the value of the Last Sent field';
                    ApplicationArea = All;
                }
                field(Segment1; Rec.Segment1)
                {
                    ToolTip = 'Specifies the value of the Segmant1 field';
                    ApplicationArea = All;
                }
                field(Segment2; Rec.Segment2)
                {
                    ToolTip = 'Specifies the value of the Segment2 field';
                    ApplicationArea = All;
                }
                field(Segment3; Rec.Segment3)
                {
                    ToolTip = 'Specifies the value of the Segment3 field';
                    ApplicationArea = All;
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
                    E3APIIntegrationMgmt: Codeunit "E3 API Integration Mgmt.";
                    E3ItemType: Record "E3 Item Type";
                begin
                    if E3ItemType.Get(Rec.Code) then
                        E3APIIntegrationMgmt.SendItemTypeDetails(E3ItemType);
                end;
            }
        }
    }
}
