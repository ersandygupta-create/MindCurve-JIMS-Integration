page 50171 "E3 Approved HIS Indent List"
{
    PageType = List;
    SourceTable = "E3 Indent Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Indent List';
    CardPageId = "E3 HIS Indent Card";
    SourceTableView = sorting("Document No.") order(descending) WHERE(Status = FILTER(Approved), "Source Type" = filter(HIS), "HIS Approved Indent Closed" = const(false));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Voucher Type Code"; Rec."Voucher Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type associated with the indent.';
                }
                field("Voucher Type Name"; Rec."Voucher Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type Name associated with the indent.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department for which the indent is created.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department for which the indent is created.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source type of the indent.';
                }
                field("Indent No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique indent number.';
                }
                field("Indenter Name"; Rec."Indenter Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the indentor.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the indent was requested.';
                }
                field("Prepared Date"; Rec."Prepared Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the indent was prepared.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who prepared the indent.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the indent.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who approved the indent.';
                }
            }
        }
    }
}