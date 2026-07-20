page 50141 "E3 Sub Group Nature"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Sub-Group Nature";
    Editable = true;
    Caption = 'Sub Group Nature';
    DeleteAllowed = false;

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
                    ItemSubGroupNatureMgmt: Codeunit "E3 Sub Group Nature Mgmt.";
                    ItemSubGroupNature: Record "E3 Sub-Group Nature";
                begin
                    ItemSubGroupNature.Get(Rec.Code);
                    if ItemSubGroupNature.IsSent then
                        Error('This record has already been sent.');

                    if ItemSubGroupNatureMgmt.SendSubGroupNatureDetails(ItemSubGroupNature) then begin
                        ItemSubGroupNature.Get(Rec.Code);
                        ItemSubGroupNature."First Sent" := true;
                        ItemSubGroupNature.Modify();
                        Message('Data sent successfully.')
                    end else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
