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
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the name of the selected item.';
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
}