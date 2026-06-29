page 50066 "E3 Unit Of Measure Update Log"
{
    PageType = List;
    SourceTable = "E3 Unit Of Measure Update Log";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Unit Of Measure Update Log';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension value code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description name.';
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
                    UomRec: Record "E3 Unit Of Measure Update Log";
                    E3UOMMgmt: Codeunit "E3 Unit Of Measure Mgmt.";
                begin
                    if Rec."Sync Status" = Rec."Sync Status"::Synced then
                        Error('This UOM record is already synced.');

                    E3UOMMgmt.SendUOMDetails(Rec);
                    Message('UOM sent successfully');
                end;
            }
        }
    }
}