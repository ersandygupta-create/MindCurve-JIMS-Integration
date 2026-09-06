page 50145 "E3 Item Speciality Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Item Speciality Master";
    Editable = true;
    Caption = 'Item Speciality Master';
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
                    ItemSpecialityMgmt: Codeunit "E3 Item Speciality Mgmt.";
                    ItemSpecialityMast: Record "E3 Item Speciality Master";
                    SentCount: Integer;
                begin
                    // Get only selected records from the list
                    CurrPage.SetSelectionFilter(ItemSpecialityMast);

                    if not ItemSpecialityMast.FindSet() then begin
                        Message('Please select at least one record.');
                        exit;
                    end;

                    repeat
                        if ItemSpecialityMast.IsSent then
                            Error(
                                'Item Speciality %1 has already been sent.',
                                ItemSpecialityMast.Code);

                        if ItemSpecialityMgmt.SendItemSpecialityDetails(ItemSpecialityMast) then begin
                            ItemSpecialityMast."First Sent" := true;
                            ItemSpecialityMast.Modify();

                            SentCount += 1;
                        end else
                            Error(
                                'Failed to send Item Speciality %1.',
                                ItemSpecialityMast.Code);

                    until ItemSpecialityMast.Next() = 0;

                    Message(
                        '%1 selected record(s) sent successfully.',
                        SentCount);
                end;
            }
        }
    }
}
