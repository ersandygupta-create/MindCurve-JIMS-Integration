page 50026 "E3 HSN/SAC Update Log"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "E3 HSN/SAC Log";
    Caption = 'HSN/SAC Log';
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(GLEN; Rec.GLEN)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ApplicationArea = All;
                    Editable = CanEditResponse;
                    ToolTip = 'Specifies the synchronization status of the record with the external system.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    Editable = CanEditResponse;
                    ToolTip = 'Specifies the response or error message received from the external system during synchronization.';
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
                    HSNSAC: Record "E3 HSN/SAC Log";
                    SyncCount: Integer;
                begin
                    // Get only selected records
                    CurrPage.SetSelectionFilter(HSNSAC);

                    if not HSNSAC.FindSet() then begin
                        Message('Please select at least one HSN/SAC record.');
                        exit;
                    end;

                    repeat
                        if HSNSAC."Sync Status" = HSNSAC."Sync Status"::Synced then
                            Error(
                                'HSN/SAC Code %1 is already synced.',
                                HSNSAC.Code);

                        if HSNSACMgmt.SendHSNSACDetails(HSNSAC) then begin
                            SyncCount += 1;
                        end else begin
                            Error(
                                'Failed to sync HSN/SAC Code %1. %2',
                                HSNSAC.Code,
                                HSNSAC."Error Message");
                        end;

                    until HSNSAC.Next() = 0;

                    CurrPage.Update(false);

                    Message(
                        '%1 selected HSN/SAC record(s) synced successfully.',
                        SyncCount);
                end;
            }
        }
    }
    var
        CanEditResponse: Boolean;
        UserSetup: Record "User Setup";

    trigger OnAfterGetRecord()
    begin
        UserSetup.Get(UserId());
        if Not UserSetup."HSN Master" then
            Error('You donot have permission Perform operation on HSN.');
        CanEditResponse := true;
    end;
}