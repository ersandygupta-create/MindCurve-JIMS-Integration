page 50198 "E3 Stock Consumption Line"
{
    Caption = 'Stock Consumption Lines';
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "E3 Stock Consumption Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                }
                field("D365 From Department Code"; Rec."D365 From Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source department code.';
                }
                field("D365 From Department Name"; Rec."D365 From Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source department name.';
                }
                field("D365 To Department Code"; Rec."D365 To Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination department code.';
                }
                field("D365 To Department Name"; Rec."D365 To Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination department name.';
                }
                field("D365 Item Code"; Rec."D365 Item Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D365 item code.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item name.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item type.';
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch number.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the consumed quantity.';
                }
                field("D365 Unit Code"; Rec."D365 Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D365 unit code.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit name.';
                }
            }
        }
    }
}