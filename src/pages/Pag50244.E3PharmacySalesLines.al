
page 50244 "E3 Pharmacy Sales Lines"
{
    Caption = 'Pharmacy Sales Line';
    //AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "E3 Pharmacy Sale Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the internal line entry number.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the related pharmacy sales entry number.';
                }
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document Number"; Rec."Document Number")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the document number.';
                }
                field("D365 Department Code"; Rec."D365 Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D365 department code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location name.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit.';
                }
                field("Consultant Name"; Rec."Consultant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the consultant name.';
                }
                field(Speciality; Rec.Speciality)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the speciality.';
                }
                field("Patient UHID"; Rec."Patient UHID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient UHID.';
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
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch number.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item quantity.';
                }
                field("D365 Unit Code"; Rec."D365 Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D365 unit code.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit name.';
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill number.';
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill date.';
                }
                field("Bill Time"; Rec."Bill Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill time.';
                }
                field("OH Amt Gross"; Rec."OH Amt Gross")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("OH Amt Discount"; Rec."OH Amt Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount.';
                }
                field("OH Amt Taxable"; Rec."OH Amt Taxable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the taxable amount.';
                }
                field("OH Amt CGST"; Rec."OH Amt CGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST amount.';
                }
                field("OH Amt SGST"; Rec."OH Amt SGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST amount.';
                }
                field("OH Amt UGST"; Rec."OH Amt UGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the UGST amount.';
                }
                field("OH Amt IGST"; Rec."OH Amt IGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST amount.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who prepared the line.';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate("Entry Type", Rec.GetRangeMin("Entry Type"));
        Rec.Validate("Document Type", Rec.GetRangeMin("Document Type"));
        Rec.Validate("Entry Number", Rec.GetRangeMin("Entry Number"));
    end;
}