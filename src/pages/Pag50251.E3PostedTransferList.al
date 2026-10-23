page 50251 "E3 Posted Transfer List"
{
    PageType = List;
    SourceTable = "E3 Transfer Header";
    Caption = 'Transfer List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Transfer Card";
    SourceTableView = where("Is Created" = filter(true));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer entry type.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer validation key.';
                }
                field(v_Date; Rec.v_Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer date.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document Number"; Rec."Document Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer document number.';
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit code.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
                }
                field("Number of Lines"; Rec."Number of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of transfer lines.';
                }
                field("Is Created"; Rec."Is Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the transfer has been created.';
                }
                field("Is Posted"; Rec."Is Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the transfer has been posted.';
                }
            }
        }
    }
}