page 50169 "E3 GRN Work Sheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 GRN Work Sheet";
    Caption = 'GRN Work Sheet';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("PO No."; Rec."PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order number.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number.';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item name.';
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the purchase order quantity.';
                }
                field("Free Qty"; Rec."Free Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase Free quantity.';
                }
                field("Outstanding Qty"; Rec."Outstanding Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the outstanding quantity.';
                }
                field("Invoice Qty"; Rec."Invoice Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the invoice quantity.';
                }
                field("Receipt Qty"; Rec."Receipt Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt quantity.';
                }
                field("Rejected Qty"; Rec."Rejected Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rejected quantity.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the lot number.';
                    trigger OnAssistEdit()
                    var
                        PurchSetup: Record "Purchases & Payables Setup";
                        NoSeries: Codeunit "No. Series";
                    begin
                        PurchSetup.Get();
                        PurchSetup.TestField("Lot Nos.");

                        if Rec."Lot No." = '' then begin
                            Rec."No. Series" := PurchSetup."Lot Nos.";
                            Rec."Lot No." := NoSeries.GetNextNo(Rec."No. Series", WorkDate(), true);
                            CurrPage.Update();
                        end;
                    end;
                }
                field("Mfg Date"; Rec."Manufacturing Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturing date.';
                }
                field("Exp. Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                    Editable = false;
                }
                field("Indent Doc ID"; Rec."Indent Doc ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent number.';
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent line number.';
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
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SKU unit of measure (UOM).';
                }
                field("HSN Code"; Rec."HSN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN code.';
                }
                field("Indent SKU Qty"; Rec."Indent SKU Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested quantity from the indent.';
                }
                field("Item GST Nature"; Rec."Item GST Nature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST nature of the item.';
                }
                field("Supplier Batch No."; Rec."Supplier Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier batch number.';
                }
                field("Line Gross"; Rec."Line Gross")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the gross amount for the line.';
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum retail price.';
                }
                field(skuMrp; Rec."SKU MRP")
                {
                    ApplicationArea = All;
                    Caption = 'SKU MRP';
                    ToolTip = 'Specifies the SKU MRP.';
                }
                field(saleRate; Rec."Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Sale Rate';
                    ToolTip = 'Specifies the sale rate.';
                }
                field(skuSaleRate; Rec."SKU Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'SKU Sale Rate';
                    ToolTip = 'Specifies the SKU sale rate.';
                }
                field(staffSaleRate; Rec."Staff Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Staff Sale Rate';
                    ToolTip = 'Specifies the staff sale rate.';
                }
                field(skuStaffSaleRate; Rec."SKU Staff Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'SKU Staff Sale Rate';
                    ToolTip = 'Specifies the SKU staff sale rate.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line net amount.';
                }
                field("Landed SKU Value"; Rec."Landed SKU Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line landed SKU value.';
                }
                field("Landed SKU Rate"; Rec."Landed SKU Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line landed SKU rate.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line remark.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase rate.';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the item make.';
                }
                field(itemMakeCode; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Caption = 'Item Make Code';
                    Editable = false;
                    ToolTip = 'Specifies the item make code.';
                }
                field(gstTypeCode; Rec."GST Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'GST Type Code';
                    ToolTip = 'Specifies the GST type code.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount amount.';
                    Editable = false;
                }
                field("Line Discount Percentage"; Rec."Line Discount Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the line discount percentage.';
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
                field("Rec SKU QTY"; Rec."Rec SKU QTY")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the received SKU quantity.';
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
                field("GRN Date"; Rec."GRN Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GRN date.';
                }
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the challan number.';
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the challan date.';
                }
                field("Challan Qty"; Rec."Challan Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the challan quantity.';
                }
                field("Accepted Qty"; Rec."Accepted Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the accepted quantity.';
                }
                field("Supplier State"; Rec."Supplier State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier state.';
                }
                field("V Prefix"; Rec."V Prefix")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher prefix.';
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type.';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Receive")
            {
                ApplicationArea = All;
                Caption = 'Receive';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GRNWorksheet: Record "E3 GRN Work Sheet";
                    PurchHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                begin
                    CurrPage.SetSelectionFilter(GRNWorksheet);

                    if GRNWorksheet.FindSet() then
                        repeat
                            PurchHeader.Get(PurchHeader."Document Type"::Order, GRNWorksheet."PO No.");

                            PurchLine.Get(PurchHeader."Document Type", PurchHeader."No.", GRNWorksheet."Line No.");

                            PurchLine.Validate("Qty. to Receive", GRNWorksheet."Receipt Qty");
                            PurchLine.Modify(true);

                        until GRNWorksheet.Next() = 0;

                    // Post Receipt
                    PurchHeader.Receive := true;
                    PurchHeader.Invoice := false;

                    Codeunit.Run(Codeunit::"Purch.-Post", PurchHeader);

                    Message('Purchase Receipt posted successfully.');
                end;
            }
        }
    }
}