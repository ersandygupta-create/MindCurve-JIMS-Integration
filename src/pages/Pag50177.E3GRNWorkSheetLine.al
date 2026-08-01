page 50177 "E3 GRN Work Sheet Line"
{
    PageType = ListPart;
    SourceTable = "E3 GRN Work Sheet Line";
    Caption = 'GRN Work Sheet Lines';
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document ID.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                }
                field("Indent Document ID"; Rec."Indent Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent document ID.';
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent line number.';
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item code.';
                }
                field("DM Item Code"; Rec."DM Item Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM item code.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item name.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("DM Department Code"; Rec."DM Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM department code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit code.';
                }
                field("DM Unit Code"; Rec."DM Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM unit code.';
                }
                field("HSN Code"; Rec."HSN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN code.';
                }
                field("DM HSN Code"; Rec."DM HSN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM HSN code.';
                }
                field("Indent SKU Qty"; Rec."Indent SKU Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent SKU quantity.';
                }
                field("Received SKU Qty"; Rec."Received SKU Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the received SKU quantity.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate.';
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount percentage.';
                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the taxable amount.';
                }
                field("CGST %"; Rec."CGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST percentage.';
                }
                field("CGST Amount"; Rec."CGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CGST amount.';
                }
                field("SGST %"; Rec."SGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST percentage.';
                }
                field("SGST Amount"; Rec."SGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SGST amount.';
                }
                field("IGST %"; Rec."IGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST percentage.';
                }
                field("IGST Amount"; Rec."IGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IGST amount.';
                }
                field("UGST %"; Rec."UGST %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the UGST percentage.';
                }
                field("UGST Amount"; Rec."UGST Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the UGST amount.';
                }
                field("Final Discount %"; Rec."Final Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount percentage.';
                }
                field("Final Discount Amount"; Rec."Final Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the final discount amount.';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount.';
                }
                field("Landed SKU Value"; Rec."Landed SKU Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the landed SKU value.';
                }
                field("Landed SKU Rate"; Rec."Landed SKU Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the landed SKU rate.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remark.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the MRP.';
                }
                field("SKU MRP"; Rec."SKU MRP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SKU MRP.';
                }
                field("Sale Rate"; Rec."Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sale rate.';
                }
                field("SKU Sale Rate"; Rec."SKU Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SKU sale rate.';
                }
                field("Staff Sale Rate"; Rec."Staff Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the staff sale rate.';
                }
                field("SKU Staff Sale Rate"; Rec."SKU Staff Sale Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SKU staff sale rate.';
                }
                field(Barcode; Rec.Barcode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the barcode.';
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch number.';
                }
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturing date.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item make code.';
                }
                field("GST Type Code"; Rec."GST Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST type code.';
                }
                field("Item GST Nature"; Rec."Item GST Nature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item GST nature.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
                field("DM TimeStamp"; Rec."DM TimeStamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM timestamp.';
                }
                field("DM Document ID"; Rec."DM Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DM document ID.';
                }
            }
        }
    }
}