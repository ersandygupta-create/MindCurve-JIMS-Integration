page 50253 "E3 Transfer Line API"
{
    PageType = API;
    Caption = 'Transfer Line API';
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    EntityName = 'transferLine';
    EntitySetName = 'transferLines';
    SourceTable = "E3 Transfer Line";
    ODataKeyFields = "Entry No.";
    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(entryType; Rec."Entry Type")
                {
                }
                field(entryNumber; Rec."Entry Number")
                {
                }
                field(entryDate; Rec."Entry Date")
                {
                }
                field(documentType; Rec."Document Type")
                {
                }
                field(documentNumber; Rec."Document Number")
                {
                }
                field(businessUnit; Rec."Business Unit")
                {
                }
                field(legalEntity; Rec."Legal Entity")
                {
                }
                field(lineNumber; Rec."Line Number")
                {
                }
                field(d365FromDepartmentCode; Rec."D365 From Department Code")
                {
                }
                field(d365FromDepartmentName; Rec."D365 From Department Name")
                {
                }
                field(d365ToDepartmentCode; Rec."D365 To Department Code")
                {
                }
                field(d365ToDepartmentName; Rec."D365 To Department Name")
                {
                }
                field(d365ItemCode; Rec."D365 Item Code")
                {
                }
                field(itemName; Rec."Item Name")
                {
                }
                field(itemType; Rec."Item Type")
                {
                }
                field(batchNo; Rec."Batch No.")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(d365UnitCode; Rec."D365 Unit Code")
                {
                }
                field(unitName; Rec."Unit Name")
                {
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        TransferHeader: Record "E3 Transfer Header";
        TransferLine: Record "E3 Transfer Line";
    begin
        if Rec."Entry Number" = '' then
            Error('Entry Number must not be blank.');

        if Rec."Line Number" = 0 then
            Error('Line Number must not be zero.');

        TransferHeader.Reset();
        TransferHeader.SetRange("Entry Number", Rec."Entry Number");

        if not TransferHeader.FindFirst() then
            Error('Transfer Header with Entry Number %1 does not exist.', Rec."Entry Number");

        TransferLine.Reset();
        TransferLine.SetRange("Entry Type", Rec."Entry Type");
        TransferLine.SetRange("Entry Number", Rec."Entry Number");
        TransferLine.SetRange("Line Number", Rec."Line Number");

        if TransferLine.FindFirst() then
            Error(
                'Transfer Line %1 already exists for Entry Number %2.',
                Rec."Line Number",
                Rec."Entry Number");

        exit(true);
    end;
}