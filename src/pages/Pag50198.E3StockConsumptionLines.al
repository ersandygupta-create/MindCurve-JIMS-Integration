page 50198 "E3 Stock Consumption Line"
{
    Caption = 'Stock Consumption Lines';
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "E3 Stock Consumption Line";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("D365 Item Code"; Rec."D365 Item Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the D365 item code.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item name.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("D365 From Department Code"; Rec."D365 From Department Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source department code.';
                }
                field("D365 From Department Name"; Rec."D365 From Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source department name.';
                }
                field("D365 To Department Code"; Rec."D365 To Department Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination department code.';
                }
                field("D365 To Department Name"; Rec."D365 To Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination department name.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item type.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the consumed quantity.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Unit Cost.';
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch number.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Expiry Date.';
                }
                field("D365 Unit Code"; Rec."D365 Unit Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the D365 unit code.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit name.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies a value Gen. Bus. Posting Group';
                }
            }
        }
    }
}