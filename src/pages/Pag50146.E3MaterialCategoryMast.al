page 50146 "E3 material Category Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Material Category Master";
    Editable = true;
    Caption = 'Material Category Master';

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
                field("Filter Item Type"; Rec."Filter Item Type")
                {
                    ToolTip = 'Specifies the value of the Filter Item Type field';
                    ApplicationArea = All;
                }
                field(IsCommon; Rec.IsCommon)
                {
                    ToolTip = 'Specifies the value of the Is Common field';
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
                    MaterialCatMgmt: Codeunit "E3 Material Category Mgmt.";
                    MaterialCatMast: Record "E3 Material Category Master";
                begin
                    MaterialCatMast.Get(Rec.Code, Rec.Name);
                    if MaterialCatMgmt.SendMaterialCategoryDetails(MaterialCatMast) then
                        Message('Data sent successfully.')
                    else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
