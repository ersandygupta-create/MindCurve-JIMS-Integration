page 50209 "E3 Posted Stock Cons. List"
{
    Caption = 'Posted Stock Consumption List';
    PageType = List;
    SourceTable = "E3 Stock Consumption Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Stock Consumption Card";
    Editable = false;
    SourceTableView = sorting("Entry No.") where(Posted = filter(true));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type of the stock consumption.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number.';
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the stock consumption entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
                }
            }
        }
    }
}