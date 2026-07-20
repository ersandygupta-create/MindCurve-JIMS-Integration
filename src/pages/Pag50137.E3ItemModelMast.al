page 50137 "E3 Item Model Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    SourceTable = "E3 Item Model Master";
    Editable = true;
    Caption = 'Item Model';

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
                    ShowMandatory = true;
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
                    E3ItemModelMgmt: Codeunit "E3 Item Model Mgmt.";
                    ItemModelMst: Record "E3 Item Model Master";
                begin
                    ItemModelMst.Get(Rec.Code);
                    if ItemModelMst.IsSent then
                        Error('This record has already been sent.');

                    if E3ItemModelMgmt.SendItemModelDetails(ItemModelMst) then begin
                        ItemModelMst.Get(Rec.Code);
                        ItemModelMst."First Sent" := true;
                        ItemModelMst.Modify();
                        Message('Data sent successfully.');
                    end else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
