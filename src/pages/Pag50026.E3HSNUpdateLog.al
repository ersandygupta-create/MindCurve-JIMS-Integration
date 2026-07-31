page 50026 "E3 HSN/SAC Update Log"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "E3 HSN/SAC Log";
    Caption = 'HSN/SAC Log';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies GST group code.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies HSN/SAC codes for various groups.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies details of HSN/SAC code.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether GST group is for HSN/SAC.';
                }
                field(GLEN; Rec.GLEN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether GLEN';
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error Message"; Rec."Error Message")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Syn to DB")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Syn to DB';
                Image = Send;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Send the data in the  page to an DB';

                trigger OnAction()
                var
                    HSNSACMgmt: Codeunit "E3 HSN/SAC Mgmt.";
                begin
                    if Rec."Sync Status" = Rec."Sync Status"::Synced then
                        Error('This HSN/SAC record is already synced.');

                    if HSNSACMgmt.SendHSNSACDetails(Rec) then begin
                        CurrPage.Update(false);
                        Message('HSN/SAC Code sent successfully');
                    end else begin
                        CurrPage.Update(false);
                        Error(Rec."Error Message");
                    end;
                end;
            }
        }
    }
}