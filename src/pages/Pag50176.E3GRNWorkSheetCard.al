page 50176 "E3 GRN Work Sheet Header"
{
    PageType = Card;
    SourceTable = "E3 GRN Work Sheet Header";
    Caption = 'GRN Work Sheet Card';
    ApplicationArea = All;
    UsageCategory = Documents;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document ID.';
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type.';
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher prefix.';
                }
                field("Voucher Date"; Rec."Voucher Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher date.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier code.';
                }
                field("Place of Supply"; Rec."Place of Supply")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the place of supply.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remark.';
                }
                field("Purchase Challan No."; Rec."Purchase Challan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase challan number.';
                }
                field("Purchase Challan Date"; Rec."Purchase Challan Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase challan date.';
                }
            }

            group(Amounts)
            {
                Caption = 'Amounts';

                field("OH Amount Gross"; Rec."OH Amount Gross")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("OH Amount Discount"; Rec."OH Amount Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount.';
                }
                field("OH Amount Taxable"; Rec."OH Amount Taxable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the taxable amount.';
                }
                field("OH Amount CGST"; Rec."OH Amount CGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST amount.';
                }
                field("OH Amount SGST"; Rec."OH Amount SGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST amount.';
                }
                field("OH Amount IGST"; Rec."OH Amount IGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST amount.';
                }
                field("OH Amount UGST"; Rec."OH Amount UGST")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the UGST amount.';
                }
                field("OH Amount Total"; Rec."OH Amount Total")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount.';
                }
                field("OH Final Discount %"; Rec."OH Final Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount percentage.';
                }
                field("OH Final Discount Amount"; Rec."OH Final Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount amount.';
                }
                field("OH Round Off"; Rec."OH Round Off")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the round off amount.';
                }
                field("OH Net Amount"; Rec."OH Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount.';
                }
                field("OH Landed Value"; Rec."OH Landed Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the landed value.';
                }
            }

            group(Approval)
            {
                Caption = 'Approval';

                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who prepared the document.';
                }
                field("Prepared Date"; Rec."Prepared Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the prepared date.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approver.';
                }
                field("Approval Date Time"; Rec."Approval Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval date and time.';
                }
            }

            group(Additional)
            {
                Caption = 'Additional Information';

                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit code.';
                }
                field("Business Unit Name"; Rec."Business Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit name.';
                }
                field("RCM Applicable"; Rec."RCM Applicable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether RCM is applicable.';
                }
                field("Party Type"; Rec."Party Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the party type.';
                }
                field(GSTIN; Rec.GSTIN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GSTIN.';
                }
                field("E-Way Bill No."; Rec."E-Way Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the E-Way Bill number.';
                }
                field("E-Way Bill Date"; Rec."E-Way Bill Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the E-Way Bill date.';
                }
                field("LR No."; Rec."LR No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the LR number.';
                }
                field("LR Date"; Rec."LR Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the LR date.';
                }
                field("GST Location"; Rec."GST Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST location.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
                field("DM Doc ID"; Rec."DM Doc ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM document ID.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
                }
            }
            part(Lines; "E3 GRN Work Sheet Line")
            {
                ApplicationArea = All;
                SubPageLink = "Document ID" = FIELD("Document ID");
            }
        }
    }
}