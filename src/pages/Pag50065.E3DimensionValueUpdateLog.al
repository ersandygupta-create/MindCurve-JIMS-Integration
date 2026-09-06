page 50065 "E3 Dimension Value List"
{
    PageType = List;
    SourceTable = "E3 Dimension Value Log";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Dimension Values Log';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension value code.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension value name.';
                }
                field(Nature; Rec.Nature)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension value Nature.';
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ToolTip = 'Specifies the Sync Status.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    Caption = 'Response';
                    ToolTip = 'Specifies the error Message.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Sync)
            {
                Caption = 'Sync';
                ApplicationArea = All;
                Image = Link;
                ToolTip = 'Executes the Sync action.';
                trigger OnAction()
                var
                    DimensionValueLog: Record "E3 Dimension Value Log";
                    E3DimensionMgmt: Codeunit "E3 Dimension Value Mgmt.";
                    SyncCount: Integer;
                begin
                    // Get only selected records from the list
                    CurrPage.SetSelectionFilter(DimensionValueLog);

                    if not DimensionValueLog.FindSet() then begin
                        Message('Please select at least one Department record.');
                        exit;
                    end;

                    repeat
                        if DimensionValueLog."Sync Status" =
                           DimensionValueLog."Sync Status"::Synced then
                            Error(
                                'Department %1 is already synced.',
                                DimensionValueLog.Code);

                        if E3DimensionMgmt.SendDimensionValueDetails(DimensionValueLog) then begin
                            DimensionValueLog."First Sent" := true;
                            DimensionValueLog.Modify();

                            SyncCount += 1;
                        end else
                            Error(
                                'Failed to send Department %1.',
                                DimensionValueLog.Code);

                    until DimensionValueLog.Next() = 0;

                    CurrPage.Update(false);

                    Message(
                        '%1 selected Department record(s) sent successfully.',
                        SyncCount);
                end;
            }
        }
    }
}