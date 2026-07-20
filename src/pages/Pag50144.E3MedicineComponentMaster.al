page 50144 "E3 Medicine Component Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Medicine Component Master";
    Editable = true;
    Caption = 'Medicine Component Master';
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
                field("Restrict Group Code"; Rec."Restrict Group Code")
                {
                    ToolTip = 'Specifies the value of the Restrict Group Code field';
                    ApplicationArea = All;
                }
                field(IsActive; Rec.IsActive)
                {
                    ToolTip = 'Specifies the value of the Is Active field';
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
                    MedicineCompMastMgmt: Codeunit "E3 Medicine Comp Master Mgmt.";
                    MedicineCompMast: Record "E3 Medicine Component Master";
                begin
                    MedicineCompMast.Get(Rec.Code);
                    if MedicineCompMast.IsSent then
                        Error('This record has already been sent.');

                    if MedicineCompMastMgmt.SendMedicineCompMastDetails(MedicineCompMast) then begin
                        MedicineCompMast.Get(Rec.Code);
                        MedicineCompMast."First Sent" := true;
                        MedicineCompMast.Modify(false);
                        Message('Data sent successfully.')
                    end else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
