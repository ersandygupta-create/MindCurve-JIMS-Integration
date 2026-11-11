
page 50244 "E3 Pharmacy Sales Lines"
{
    Caption = 'Pharmacy Sales Line';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "E3 Pharmacy Sale Lines";
    ApplicationArea = All;
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
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the internal line entry number.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the related pharmacy sales entry number.';
                }
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                    Visible = true;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document Number"; Rec."Document Number")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                }

                // 1. Item Details
                field("D365 Item Code"; Rec."D365 Item Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the D365 item code.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Editable = false;
                    ToolTip = 'Specifies the item quantity.';
                }

                // 2. Unit Details
                field("D365 Unit Code"; Rec."D365 Unit Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the D365 unit code.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit name.';
                }

                // 3. Department Details
                field("D365 Department Code"; Rec."D365 Department Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the D365 department code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the department name.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the business unit.';
                }

                // 4. Amount Details
                field("OH Amt Gross"; Rec."OH Amt Gross")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("OH Amt Discount"; Rec."OH Amt Discount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the discount amount.';
                }
                field("OH Amt Taxable"; Rec."OH Amt Taxable")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the taxable amount.';
                }
                field("OH Amt CGST"; Rec."OH Amt CGST")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the CGST amount.';
                }
                field("OH Amt SGST"; Rec."OH Amt SGST")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the SGST amount.';
                }
                field("OH Amt UGST"; Rec."OH Amt UGST")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the UGST amount.';
                }
                field("OH Amt IGST"; Rec."OH Amt IGST")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the IGST amount.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the net amount.';
                }

                // 5. Location Details
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the location code.';
                }
                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the location name.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Entry Type" := Rec."Entry Type";
        Rec."Document Type" := Rec."Document Type";
    end;
}
