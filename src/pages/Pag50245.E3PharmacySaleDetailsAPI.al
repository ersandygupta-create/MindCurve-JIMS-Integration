
page 50245 "E3 Pharmacy Sales API"
{
    PageType = API;
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    Caption = 'Pharmacy Sale Details API';
    EntityName = 'pharmacySaleDetail';
    EntitySetName = 'pharmacySaleDetails';
    SourceTable = "E3 Pharmacy Sale Header";
    DelayedInsert = true;
    ApplicationArea = All;
    ODataKeyFields = "Validation Key";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; }
                field(validationKey; Rec."Validation Key")
                {
                    Caption = 'Validation Key';
                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(entryNo; Rec."Entry No.") { Caption = 'Entry No.'; }
                field(entryType; Rec."Entry Type") { Caption = 'Entry Type'; }
                field(entryNumber; Rec."Entry Number") { Caption = 'Entry Number'; }
                field(documentType; Rec."Document Type") { Caption = 'Document Type'; }
                field(documentNumber; Rec."Document Number") { Caption = 'Document Number'; }
                field(d365DepartmentCode; Rec."D365 Department Code") { Caption = 'D365 Department Code'; }
                field(departmentName; Rec."Department Name") { Caption = 'Department Name'; }
                field(locationCode; Rec."Location Code") { Caption = 'Location Code'; }
                field(locationName; Rec."Location Name") { Caption = 'Location Name'; }
                field(businessUnit; Rec."Business Unit") { Caption = 'Business Unit'; }
                field(legalEntity; Rec."Legal Entity") { Caption = 'Legal Entity'; }
                field(consultantName; Rec."Consultant Name") { Caption = 'Consultant Name'; }
                field(speciality; Rec.Speciality) { Caption = 'Speciality'; }
                field(patientUHID; Rec."Patient UHID") { Caption = 'Patient UHID'; }
                field(patientName; Rec."Patient Name") { Caption = 'Patient Name'; }
                field(patientMobile; Rec."Patient Mobile") { Caption = 'Patient Mobile'; }
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
                field(ohAmtRoundOff; Rec."OH Amt RoundOff") { Caption = 'OH Amt RoundOff'; }
                field(ohAmtNet; Rec."OH Amt Net") { Caption = 'OH Amt Net'; }
                field(preparedBy; Rec."Prepared By") { Caption = 'Prepared By'; }
                field(noOfLines; Rec."No of Lines") { Caption = 'No of Lines'; }
                field(isCreated; Rec."Is Created") { Caption = 'Is Created'; }
                field(isPosted; Rec."Is Posted") { Caption = 'Is Posted'; }
            }

            part(PharmacySaleLine; "E3 Pharmacy Sales Lines API")
            {
                Caption = 'Lines';
                EntityName = 'pharmacySaleLine';
                EntitySetName = 'pharmacySaleLines';
                SubPageLink = "Entry Type" = field("Entry Type"), "Document Type" = field("Document Type"), "Entry Number" = field("Entry Number");
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
        PharmacySaleHdr: Record "E3 Pharmacy Sale Header";
    begin
        PharmacySaleHdr.SetRange("Entry Type", Rec."Entry Type");
        PharmacySaleHdr.SetRange("Document Type", Rec."Document Type");
        PharmacySaleHdr.SetRange("Entry Number", Rec."Entry Number");
        if not PharmacySaleHdr.IsEmpty then
            error('Duplicate Entry');
    end;
}