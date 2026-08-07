page 50173 "E3 Item Margin List"
{
    PageType = List;
    SourceTable = "E3 Item Margin";
    Caption = 'Item Margin';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Margin Code"; Rec."Margin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique margin code.';
                }
                field("Margin Name"; Rec."Margin Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name of the selected margin.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit code.';
                }
                field("Business Unit Name"; Rec."Business Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name of the selected business unit.';
                }
                field("Margin Type"; Rec."Margin Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the margin type.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the margin value.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Copy Line")
            {
                ApplicationArea = All;
                Caption = 'Copy Line';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Creates a copy of the selected Item Margin line with the next available Line No.';

                trigger OnAction()
                var
                    ItemMargin: Record "E3 Item Margin";
                    NewItemMargin: Record "E3 Item Margin";
                    NextLineNo: Integer;
                begin
                    CurrPage.SetSelectionFilter(ItemMargin);

                    if not ItemMargin.FindFirst() then
                        Error('Please select a line to copy.');

                    // Get next Line No. for the same Margin Code
                    ItemMargin.Reset();
                    ItemMargin.SetRange("Margin Code", Rec."Margin Code");

                    if ItemMargin.FindLast() then
                        NextLineNo := ItemMargin."Line No." + 10000
                    else
                        NextLineNo := 10000;

                    // Copy the selected record
                    NewItemMargin := Rec;
                    NewItemMargin."Line No." := NextLineNo;

                    NewItemMargin.Insert(true);

                    CurrPage.Update(false);
                    Message('Line copied successfully. New Line No. = %1.', NextLineNo);
                end;
            }
        }
    }
}