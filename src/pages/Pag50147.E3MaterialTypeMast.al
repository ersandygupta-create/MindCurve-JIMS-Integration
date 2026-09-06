page 50147 "E3 material Type Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Material Type Master";
    Editable = true;
    Caption = 'Material Type Master';
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
                    MaterialTypeMgmt: Codeunit "E3 Material Type Mgmt.";
                    MaterialTypeMast: Record "E3 Material Type Master";
                    SentCount: Integer;
                begin
                    // Get only selected records from the list
                    CurrPage.SetSelectionFilter(MaterialTypeMast);

                    if not MaterialTypeMast.FindSet() then begin
                        Message('Please select at least one record.');
                        exit;
                    end;

                    repeat
                        if MaterialTypeMast.IsSent then
                            Error(
                                'Material Type %1 has already been sent.',
                                MaterialTypeMast.Code);

                        if MaterialTypeMgmt.SendMaterialTypeDetails(MaterialTypeMast) then begin
                            MaterialTypeMast."First Sent" := true;
                            MaterialTypeMast.Modify();

                            SentCount += 1;
                        end else
                            Error(
                                'Failed to send Material Type %1.',
                                MaterialTypeMast.Code);

                    until MaterialTypeMast.Next() = 0;

                    Message(
                        '%1 selected record(s) sent successfully.',
                        SentCount);
                end;
            }
        }
    }
}
