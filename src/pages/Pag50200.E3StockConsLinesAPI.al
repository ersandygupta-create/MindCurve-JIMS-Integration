page 50200 "E3 Stock Consumption Line API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Stock Cons Line API';
    DelayedInsert = true;
    AutoSplitKey = true;
    EntityName = 'stockConsLine';
    EntitySetName = 'stockConsLines';
    PageType = API;
    SourceTable = "E3 Stock Consumption Line";
    Extensible = false;

    layout
    {
        area(content)
        {
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
            field(documentNo; Rec."Document No.")
            {
                Caption = 'Document Number';
            }
            field(businessUnit; Rec."Business Unit")
            {
                Caption = 'Business Unit';
            }
            field(legalEntity; Rec."Legal Entity")
            {
                Caption = 'Legal Entity';
            }
            field(lineNo; Rec."Line No.")
            {
                Caption = 'Line Number';
            }
            field(d365FromDepartmentCode; Rec."D365 From Department Code")
            {
                Caption = 'D365 From Department Code';
            }
            field(d365FromDepartmentName; Rec."D365 From Department Name")
            {
                Caption = 'D365 From Department Name';
            }
            field(d365ToDepartmentCode; Rec."D365 To Department Code")
            {
                Caption = 'D365 To Department Code';
            }
            field(d365ToDepartmentName; Rec."D365 To Department Name")
            {
                Caption = 'D365 To Department Name';
            }
            field(d365ItemCode; Rec."D365 Item Code")
            {
                Caption = 'D365 Item Code';
            }
            field(itemName; Rec."Item Name")
            {
                Caption = 'Item Name';
            }
            field(itemType; Rec."Item Type")
            {
                Caption = 'Item Type';
            }
            field(batchNo; Rec."Batch No.")
            {
                Caption = 'Batch Number';
            }
            field(quantity; Rec.Quantity)
            {
                Caption = 'Quantity';
            }
            field(d365UnitCode; Rec."D365 Unit Code")
            {
                Caption = 'D365 Unit Code';
            }
            field(unitName; Rec."Unit Name")
            {
                Caption = 'Unit Name';
            }
        }
    }
}