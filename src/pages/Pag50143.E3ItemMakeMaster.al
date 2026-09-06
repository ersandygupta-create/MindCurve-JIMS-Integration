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
                    SentCount: Integer;
                    SkippedCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(ItemMakeMast);

                    if ItemMakeMast.FindSet() then begin
                        repeat
                            if ItemMakeMast.IsSent then begin
                                SkippedCount += 1;
                                continue;
                            end;

                            if ItemMakeMastMgmt.SendItemMakeMastDetails(ItemMakeMast) then begin
                                ItemMakeMast."First Sent" := true;
                                ItemMakeMast.Modify();

                                SentCount += 1;
                            end else begin
                                Error(
                                    'Failed to send Item Make Master %1.',
                                    ItemMakeMast.Code);
                            end;

                        until ItemMakeMast.Next() = 0;

                        Message(
                            '%1 record(s) sent successfully. %2 record(s) skipped because they were already sent.',
                            SentCount,
                            SkippedCount);
                    end else
                        Message('Please select at least one record.');
                end;
            }
        }
    }
}
