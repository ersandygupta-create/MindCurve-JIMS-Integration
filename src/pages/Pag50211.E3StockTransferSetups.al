page 50211 "E3 Stock Transfer List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Stock Transfer Setup";
    Caption = 'Stock Transfer Setup';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Nature Type"; Rec."Nature Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Nature Type';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry type.';
                }
                field("From Company"; Rec."From Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company from which the stock transfer is made.';
                }
                field("To Company"; Rec."To Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company to which the stock transfer is made.';
                }
                field("From BU"; Rec."From BU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source business unit.';
                }
                field("From Dept"; Rec."From Dept")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source department.';
                }
                field("From Dept Name"; Rec."From Dept Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the department from which the stock transfer is made.';
                }
                field("From Location"; Rec."From Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source location.';
                }
                field("To BU"; Rec."To BU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination business unit.';
                }
                field("To Dept"; Rec."To Dept")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination department.';
                }
                field("To Dept Name"; Rec."To Dept Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the department to which the stock transfer is made.';
                }
                field("To Location"; Rec."To Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination location.';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer code.';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();

        // From Department Name
        Rec."From Dept Name" := '';

        if Rec."From Dept" <> '' then begin
            DimensionValue.Reset();
            DimensionValue.SetRange(
                "Dimension Code",
                GeneralLedgerSetup."Global Dimension 2 Code");
            DimensionValue.SetRange(Code, Rec."From Dept");

            if DimensionValue.FindFirst() then
                Rec."From Dept Name" := DimensionValue.Name;
        end;

        // To Department Name
        Rec."To Dept Name" := '';

        if Rec."To Dept" <> '' then begin
            DimensionValue.Reset();
            DimensionValue.SetRange(
                "Dimension Code",
                GeneralLedgerSetup."Global Dimension 2 Code");
            DimensionValue.SetRange(Code, Rec."To Dept");

            if DimensionValue.FindFirst() then
                Rec."To Dept Name" := DimensionValue.Name;
        end;
    end;
}