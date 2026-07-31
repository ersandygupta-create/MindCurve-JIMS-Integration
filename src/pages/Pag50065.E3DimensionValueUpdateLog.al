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
                    E3DimenionMgmt: Codeunit "E3 Dimension Value Mgmt.";
                begin
                    DimensionValueLog.Get(Rec."Dimension Code", Rec.Code);
                    if Rec."Sync Status" = Rec."Sync Status"::Synced then
                        Error('This Department record is already synced.');

                    if E3DimenionMgmt.SendDimensionValueDetails(Rec) then begin
                        DimensionValueLog.Get(Rec."Dimension Code", Rec.Code);
                        DimensionValueLog."First Sent" := true;
                        DimensionValueLog.Modify();
                        Message('Department data sent successfully.');
                    end else
                        Message('Failed to send department data.');
                end;
            }
        }
    }
}