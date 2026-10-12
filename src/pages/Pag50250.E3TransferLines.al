page 50250 "E3 Transfer Lines"
{
    PageType = ListPart;
    SourceTable = "E3 Transfer Line";
    Caption = 'Transfer Lines';
    ApplicationArea = All;
    DelayedInsert = true;

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
                    Editable = false;
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer validation key.';
                    Editable = false;
                }
                field("Entry Date"; Rec."Entry Date")
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
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer line number.';
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
                    ToolTip = 'Specifies the transfer quantity.';
                }
                field("D365 Unit Code"; Rec."D365 Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit code.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit name.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        TransferLine: Record "E3 Transfer Line";
    begin
        if Rec.GetFilter("Entry Type") <> '' then
            Rec.Validate("Entry Type", Rec.GetRangeMin("Entry Type"));

        if Rec.GetFilter("Entry Number") <> '' then
            Rec.Validate("Entry Number", Rec.GetRangeMin("Entry Number"));

        TransferLine.Reset();
        TransferLine.SetRange("Entry Type", Rec."Entry Type");
        TransferLine.SetRange("Entry Number", Rec."Entry Number");
        TransferLine.SetCurrentKey("Entry Type", "Entry Number", "Line Number");

        if TransferLine.FindLast() then
            Rec."Line Number" := TransferLine."Line Number" + 10000
        else
            Rec."Line Number" := 10000;
    end;
}