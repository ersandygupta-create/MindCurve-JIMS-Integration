page 50150 "E3 Sub Group Site List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Sub Group Site List";
    Editable = true;
    Caption = 'Sub Group Site List';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sub Code"; Rec."Sub Code")
                {
                    ToolTip = 'Specifies the value of the Sub Code field';
                    ApplicationArea = All;
                }
                field("Site Code"; Rec."Site Code")
                {
                    ToolTip = 'Specifies the value of the Site Code field';
                    ApplicationArea = All;
                }
                field("Is Opd Consultant"; Rec."Is Opd Consultant")
                {
                    ToolTip = 'Specifies the value of the Is Opd Consultant field';
                    ApplicationArea = All;
                }
                field("Allow For Site"; Rec."Allow For Site")
                {
                    ToolTip = 'Specifies the value of the Allow For Site field';
                    ApplicationArea = All;
                }
                field("Is Ipd Consultant"; Rec."Is Ipd Consultant")
                {
                    ToolTip = 'Specifies the value of the Is Ipd Consultant field';
                    ApplicationArea = All;
                }
                field("Drug License No."; Rec."Drug License No.")
                {
                    ToolTip = 'Specifies the value of the Drug License No. field';
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

                begin
                end;
            }
        }
    }
}