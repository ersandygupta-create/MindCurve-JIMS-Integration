page 50203 "E3 UnBilled Revenue API"
{
    PageType = API;
    SourceTable = "E3 UnBilled Service Revenue";
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    Caption = 'UnBilled Revenue API';
    EntityName = 'unBilledRevenue';
    EntitySetName = 'unBilledRevenue';
    DelayedInsert = true;
    ApplicationArea = All;
    ODataKeyFields = "Entry No.";
    Extensible = false;
    layout
    {
        area(content)
        {
            field(entryNo; Rec."Entry No.")
            {
                Caption = 'Entry No.';
            }
            field(serviceType; Rec."Service Type")
            {
                Caption = 'Service Type';
            }
            field(glAccountName; Rec."GL Account Name")
            {
                Caption = 'GL Account Name';
            }
            field(department; Rec.Department)
            {
                Caption = 'Department';
            }
            field(departmentCode; Rec."Department Code")
            {
                Caption = 'Department Code';
            }
            field(serviceCategory; Rec."Service Category")
            {
                Caption = 'Service Category';
            }
            field(serviceItemId; Rec."Service Item ID")
            {
                Caption = 'Service Item ID';
            }
            field(serviceItemName; Rec."Service Item Name")
            {
                Caption = 'Service Item Name';
            }
            field(serviceItemCode; Rec."Service Item Code")
            {
                Caption = 'Service Item Code';
            }
            field(quantity; Rec.Quantity)
            {
                Caption = 'Quantity';
            }
            field(rate; Rec.Rate)
            {
                Caption = 'Rate';
            }
            field(grossAmount; Rec."Gross Amount")
            {
                Caption = 'Gross Amount';
            }
            field(mouDiscount; Rec."MOU Discount")
            {
                Caption = 'MOU Discount';
            }
            field(addOnDiscount; Rec."AddOn Discount")
            {
                Caption = 'AddOn Discount';
            }
            field(netAmount; Rec."Net Amount")
            {
                Caption = 'Net Amount';
            }
            field(locationCode; Rec."Location Code")
            {
                Caption = 'Location Code';
            }
            field(locationName; Rec."Location Name")
            {
                Caption = 'Location Name';
            }
            field(createdBy; Rec."Created By")
            {
                Caption = 'Created By';
            }
            field(createdDateTime; Rec."Created Date Time")
            {
                Caption = 'Created Date Time';
            }
            field(payorCode; Rec."Payor Code")
            {
                Caption = 'Payor Code';
            }
            field(payorCategory; Rec."Payor Category")
            {
                Caption = 'Payor Category';
            }
            field(payorName; Rec."Payor Name")
            {
                Caption = 'Payor Name';
            }
            field(serviceLineNo; Rec."Service Line No.")
            {
                Caption = 'Service Line No.';
            }
            field(departmentId; Rec."Department ID")
            {
                Caption = 'Department ID';
            }
            field(facilityId; Rec."Facility ID")
            {
                Caption = 'Facility ID';
            }
            field(headerId; Rec."Header ID")
            {
                Caption = 'Header ID';
            }
            field(netPayableAmount; Rec."Net Payable Amount")
            {
                Caption = 'Net Payable Amount';
            }
            field(validationHisKey; Rec."Validation HIS Key")
            {
                Caption = 'Validation HIS Key';
            }
            field(regNo; Rec."Reg. No.")
            {
                Caption = 'Reg. No.';
            }
            field(uhid; Rec.UHID)
            {
                Caption = 'UHID';
            }
            field(patientName; Rec."Patient Name")
            {
                Caption = 'Patient Name';
            }
        }
    }
}