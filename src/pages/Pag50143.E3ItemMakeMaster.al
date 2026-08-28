page 50143 "E3 Item Make Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Item Make Master";
    Editable = true;
    Caption = 'Item Make Master';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Make Type"; Rec."Make Type")
                {
                    ToolTip = 'Specifies the value of the Make Type field';
                    ApplicationArea = All;
                    AssistEdit = true;


                }
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field';
                    ApplicationArea = All;
                }
                field("Filter Item Type"; Rec."Filter Item Type")
                {
                    ToolTip = 'Specifies the value of the Filter Item Type field';
                    ApplicationArea = All;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ToolTip = 'Specifies the value of the Short Name field';
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
                field(LocalEmail; Rec.LocalEmail)
                {
                    ApplicationArea = All;
                    Caption = 'localEmail';
                    ToolTip = 'Specifies the local email address.';
                }
                field(RegEmail; Rec.RegEmail)
                {
                    ApplicationArea = All;
                    Caption = 'regEmail';
                    ToolTip = 'Specifies the regional email address.';
                }
                field(NatEmail; Rec.NatEmail)
                {
                    ApplicationArea = All;
                    Caption = 'natEmail';
                    ToolTip = 'Specifies the national email address.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Specifies the email address.';
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
                    ItemMakeMastMgmt: Codeunit "E3 Item Make Master Mgmt.";
                    ItemMakeMast: Record "E3 Item Make Master";
                begin
                    ItemMakeMast.Get(Rec.Code, Rec."Company Name");
                    if ItemMakeMast.IsSent then
                        Error('This record has already been sent.');

                    if ItemMakeMastMgmt.SendItemMakeMastDetails(ItemMakeMast) then begin
                        ItemMakeMast.Get(Rec.Code, Rec."Company Name");
                        ItemMakeMast."First Sent" := true;
                        ItemMakeMast.Modify();
                        Message('Data sent successfully.')
                    end else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
