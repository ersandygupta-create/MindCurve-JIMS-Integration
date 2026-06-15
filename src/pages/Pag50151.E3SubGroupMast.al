page 50151 "E3 Sub Group Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Sub Group Master";
    Editable = true;
    Caption = 'Sub Group';

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
                field("Manual Code"; Rec."Manual Code")
                {
                    ToolTip = 'Specifies the value of the Manual Code field';
                    ApplicationArea = All;
                }
                field(Initial; Rec.Initial)
                {
                    ToolTip = 'Specifies the value of the Initial field';
                    ApplicationArea = All;
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

                begin
                end;
            }
        }
    }
}