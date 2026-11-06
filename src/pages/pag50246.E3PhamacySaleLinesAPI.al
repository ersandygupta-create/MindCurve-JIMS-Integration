
page 50246 "E3 Pharmacy Sales Lines API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Pharmacy Sale Line API';
    DelayedInsert = true;
    AutoSplitKey = true;
    EntityName = 'pharmacySaleLine';
    EntitySetName = 'pharmacySaleLines';
    PageType = API;
    SourceTable = "E3 Pharmacy Sale Lines";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; }
                field(entryType; Rec."Entry Type") { Caption = 'Entry Type'; }
                field(entryNumber; Rec."Entry Number") { Caption = 'Entry Number'; }
                field(lineNumber; Rec."Line Number") { Caption = 'Line Number'; }
                field(documentType; Rec."Document Type") { Caption = 'Document Type'; }
                field(documentNumber; Rec."Document Number") { Caption = 'Document Number'; }
                field(d365DepartmentCode; Rec."D365 Department Code") { Caption = 'D365 Department Code'; }
                field(departmentName; Rec."Department Name") { Caption = 'Department Name'; }
                field(locationCode; Rec."Location Code") { Caption = 'Location Code'; }
                field(locationName; Rec."Location Name") { Caption = 'Location Name'; }
                field(businessUnit; Rec."Business Unit") { Caption = 'Business Unit'; }
                field(consultantName; Rec."Consultant Name") { Caption = 'Consultant Name'; }
                field(speciality; Rec.Speciality) { Caption = 'Speciality'; }
                field(patientUHID; Rec."Patient UHID") { Caption = 'Patient UHID'; }
                field(d365ItemCode; Rec."D365 Item Code") { Caption = 'D365 Item Code'; }
                field(itemName; Rec."Item Name") { Caption = 'Item Name'; }
                field(batchNo; Rec."Batch No.") { Caption = 'Batch No.'; }
                field(quantity; Rec.Quantity) { Caption = 'Quantity'; }
                field(d365UnitCode; Rec."D365 Unit Code") { Caption = 'D365 Unit Code'; }
                field(unitName; Rec."Unit Name") { Caption = 'Unit Name'; }
                field(billNo; Rec."Bill No.") { Caption = 'Bill No.'; }
                field(billDate; Rec."Bill Date") { Caption = 'Bill Date'; }
                field(billTime; Rec."Bill Time") { Caption = 'Bill Time'; }
                field(ohAmtGross; Rec."OH Amt Gross") { Caption = 'OH Amt Gross'; }
                field(ohAmtDiscount; Rec."OH Amt Discount") { Caption = 'OH Amt Discount'; }
                field(ohAmtTaxable; Rec."OH Amt Taxable") { Caption = 'OH Amt Taxable'; }
                field(ohAmtCGST; Rec."OH Amt CGST") { Caption = 'OH Amt CGST'; }
                field(ohAmtSGST; Rec."OH Amt SGST") { Caption = 'OH Amt SGST'; }
                field(ohAmtUGST; Rec."OH Amt UGST") { Caption = 'OH Amt UGST'; }
                field(ohAmtIGST; Rec."OH Amt IGST") { Caption = 'OH Amt IGST'; }
                field(ohAmtNet; Rec."OH Amt Net") { Caption = 'OH Amt Net'; }
                field(preparedBy; Rec."Prepared By") { Caption = 'Prepared By'; }
            }
        }
    }
}