page 50149 "E3 Medicine Composition"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Medicine Composition";
    Editable = true;
    Caption = 'Medicine Composition';

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
                field(SNo; Rec.SNo)
                {
                    ToolTip = 'Specifies the value of the SNo field';
                    ApplicationArea = All;
                }
                field("Composition Code"; Rec."Composition Code")
                {
                    ToolTip = 'Specifies the value of the Composition Code field';
                    ApplicationArea = All;
                }
                field(IsBase; Rec.IsBase)
                {
                    ToolTip = 'Specifies the value of the Is Base field';
                    ApplicationArea = All;
                }
                field(Power; Rec.Power)
                {
                    ToolTip = 'Specifies the value of the Power field';
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
