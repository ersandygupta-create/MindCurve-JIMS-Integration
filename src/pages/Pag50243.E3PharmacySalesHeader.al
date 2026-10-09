
page 50243 "E3 Pharmacy Sales Card"
{
    PageType = Card;
    Caption = 'Pharmacy Sales Card';
    SourceTable = "E3 Pharmacy Sale Header";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the internal entry number.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pharmacy sales entry reference.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document Number"; Rec."Document Number")
                {
                    ApplicationArea = All;
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
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
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
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient name.';
                }
                field("Patient Mobile"; Rec."Patient Mobile")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient mobile number.';
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
            }

            part(SalesLines; "E3 Pharmacy Sales Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Entry Type" = field("Entry Type"), "Document Type" = field("Document Type"), "Entry Number" = field("Entry Number");
                UpdatePropagation = Both;
            }

            group(Amounts)
            {
                Caption = 'Amounts';

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
                field("OH Amt RoundOff"; Rec."OH Amt RoundOff")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the round-off amount.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount.';
                }
            }

            group(Processing)
            {
                Caption = 'Processing';

                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who prepared the record.';
                }
                field("No of Lines"; Rec."No of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of sales lines.';
                }
                field("Is Created"; Rec."Is Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record has been created.';
                }
                field("Is Posted"; Rec."Is Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record has been posted.';
                }
            }
        }
    }
}