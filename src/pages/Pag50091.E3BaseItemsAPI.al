page 50091 "E3 Item API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'ItemAPI';
    DelayedInsert = true;
    EntityName = 'itemAPI';
    EntitySetName = 'itemsAPIs';
    PageType = API;
    SourceTable = Item;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(unitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit Of Measure';
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field(genProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    Caption = 'Gen. Prod. Posting Group';
                }
                field(inventoryPostingGroup; Rec."Inventory Posting Group")
                {
                    Caption = 'Inventory Posting Group';
                }
                field(gstGroupCode; Rec."GST Group Code")
                {
                    Caption = 'GST Group Code';
                }
                field(hsnSACCode; Rec."HSN/SAC Code")
                {
                    Caption = 'HSN/SAC Code';
                }
                field(gstCredit; Rec."GST Credit")
                {
                    Caption = 'GST Credit';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    local procedure DuplicateCheck()
    var
        Vendor: Record Vendor;
    begin
        Vendor.SetRange("No.", Rec."No.");
        if not Vendor.IsEmpty then
            error('Duplicate Entry');
    end;
}
