page 50242 "E3 Pharmacy Sales List"
{
    PageType = List;
    Caption = 'Pharmacy Sales List';
    SourceTable = "E3 Pharmacy Sale Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Pharmacy Sales Card";
    Editable = false;
    SourceTableView = where("Is Created" = filter(false));
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the internal entry number.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pharmacy sales entry number.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pharmacy sales entry type.';
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
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pharmacy bill number.';
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill date.';
                }
                field("No of Lines"; Rec."No of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No of Lines.';
                }
                field("D365 Department Code"; Rec."D365 Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit.';
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
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error description.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net bill amount.';
                }
                field("OH Amt Gross"; Rec."OH Amt Gross")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross bill amount.';
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
                field("Is Created"; Rec."Is Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record has been created.';
                }
                field("Is Posted"; Rec."Is Posted")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies whether the record has been posted.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DeleteSelected)
            {
                ApplicationArea = All;
                Caption = 'Delete Selected';
                Image = DeleteRow;
                ToolTip = 'Deletes all selected pharmacy sales documents and their related lines.';

                trigger OnAction()
                var
                    PharmacyHdr: Record "E3 Pharmacy Sale Header";
                    PharmacySaleHeader: Record "E3 Pharmacy Sale Header";
                begin
                    CurrPage.SetSelectionFilter(PharmacyHdr);

                    if PharmacyHdr.FindSet() then
                        repeat
                            PharmacySaleHeader := PharmacyHdr;
                            PharmacySaleHeader.Delete(true);
                        until PharmacyHdr.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
        PharmacyHdr: Record "E3 Pharmacy Sale Header";
}