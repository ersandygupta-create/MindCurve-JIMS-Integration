page 50185 "E3 App. Rate Contract List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Rate Contract Header";
    SourceTableView = sorting("Document No.") order(descending) where(Status = filter(Active));
    Caption = 'Approved Purch. Price List';
    CardPageId = "E3 App. Rate Contract Card";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate contract document number.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the rate contract.';
                }
                field("RC Type"; Rec."RC Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of rate contract.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the rate contract.';
                }
                field("Make / Supplier"; Rec."Make / Supplier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the rate contract is for a make or supplier.';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor name.';
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the make code.';
                }
                field("Make Name"; Rec."Make Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the make name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the rate contract.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency code.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the rate contract.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the rate contract.';
                }
                field("Approve Date"; Rec."Approve Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the rate contract was approved.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who approved the rate contract.';
                }
            }
        }
    }
}