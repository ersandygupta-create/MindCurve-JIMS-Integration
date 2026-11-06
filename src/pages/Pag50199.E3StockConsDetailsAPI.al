page 50199 "E3 Stock Consumption API"
{
    PageType = API;
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    Caption = 'Stock Cons Details API';
    EntityName = 'stockConsDetail';
    EntitySetName = 'stockConsDetails';
    SourceTable = "E3 Stock Consumption Header";
    DelayedInsert = true;
    ApplicationArea = All;
    ODataKeyFields = "Document No.";
    Extensible = false;

    layout
    {
        area(content)
        {
            field(documentNo; Rec."Document No.")
            {
                Caption = 'Document Number';
                trigger OnValidate()
                begin
                    DuplicateCheck();
                end;
            }
            field(entryType; Rec."Entry Type")
            {
                Caption = 'Entry Type';
            }
            field(entryNumber; Rec."Entry Number")
            {
                Caption = 'Entry Number';
            }
            field(entryDate; Rec."Entry Date")
            {
                Caption = 'Entry Date';
            }
            field(documentType; Rec."Document Type")
            {
                Caption = 'Document Type';
            }
            field(businessUnit; Rec."Business Unit")
            {
                Caption = 'Business Unit';
            }
            field(legalEntity; Rec."Legal Entity")
            {
                Caption = 'Legal Entity';
            }
            part(lines; "E3 Stock Consumption Line API")
            {
                EntityName = 'stockConsLine';
                EntitySetName = 'stockConsLines';
                SubPageLink = "Document No." = field("Document No."), "Entry Type" = field("Entry Type");
            }
        }
    }
    local procedure DuplicateCheck()
    var
        StockHeader: Record "E3 Stock Consumption Header";
    begin
        StockHeader.SetRange("Document No.", Rec."Document No.");
        StockHeader.SetRange("Entry Type", Rec."Entry Type");
        if StockHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}