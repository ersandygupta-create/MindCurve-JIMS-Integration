page 50146 "E3 material Category Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Material Category Master";
    Editable = true;
    Caption = 'Material Category Master';
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
                    MaterialCatMgmt: Codeunit "E3 Material Category Mgmt.";
                    MaterialCatMast: Record "E3 Material Category Master";
                    SentCount: Integer;
                begin
                    // Get only selected records from the list
                    CurrPage.SetSelectionFilter(MaterialCatMast);

                    if not MaterialCatMast.FindSet() then begin
                        Message('Please select at least one record.');
                        exit;
                    end;

                    repeat
                        if MaterialCatMast.IsSent then
                            Error(
                                'Material Category %1 has already been sent.',
                                MaterialCatMast.Code);

                        if MaterialCatMgmt.SendMeterialCateDetails(MaterialCatMast) then begin
                            MaterialCatMast."First Sent" := true;
                            MaterialCatMast.Modify();

                            SentCount += 1;
                        end else
                            Error(
                                'Failed to send Material Category %1.',
                                MaterialCatMast.Code);

                    until MaterialCatMast.Next() = 0;

                    Message(
                        '%1 selected record(s) sent successfully.',
                        SentCount);
                end;
            }
        }
    }
}
