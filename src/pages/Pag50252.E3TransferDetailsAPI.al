page 50252 "E3 Transfer Header API"
{
    PageType = API;
    Caption = 'Transfer Header API';
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    EntityName = 'transferHeader';
    EntitySetName = 'transferHeaders';
    SourceTable = "E3 Transfer Header";
    ODataKeyFields = "Entry Number";
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
                field(vDate; Rec.v_Date)
                {
                }
                field(documentType; Rec."Document Type")
                {
                }
                field(documentNumber; Rec."Document Number")
                {
                }
                field(businessUnitCode; Rec."Business Unit Code")
                {
                }
                field(legalEntity; Rec."Legal Entity")
                {
                }
                field(numberOfLines; Rec."Number of Lines")
                {
                }
                field(isCreated; Rec."Is Created")
                {
                }
                field(isPosted; Rec."Is Posted")
                {
                }
                part(TransferLine; "E3 Transfer Line API")
                {
                    Caption = 'Lines';
                    EntityName = 'transferLine';
                    EntitySetName = 'transferLines';
                    SubPageLink = "Entry Type" = field("Entry Type"), "Document Type" = field("Document Type"), "Entry Number" = field("Entry Number");
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        TransferHeader: Record "E3 Transfer Header";
    begin
        if Rec."Entry Number" = '' then
            Error('Entry Number must not be blank.');

        TransferHeader.Reset();
        TransferHeader.SetRange("Entry Number", Rec."Entry Number");

        if TransferHeader.FindFirst() then
            Error('Transfer Header with Entry Number %1 already exists.', Rec."Entry Number");

        exit(true);
    end;
}