page 50217 "E3 Allocation Receipt List"
{
    Caption = 'Allocation Receipt List';
    PageType = ListPart;
    SourceTable = "E3 Allocation Receipt";
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = true;

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
                    ToolTip = 'Specifies the entry number.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt number.';
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt date.';
                }
                field("Receipt Amount"; Rec."Receipt Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt amount.';
                }
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HIS document type.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code.';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer code.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Allocated Amount"; Rec."Allocated Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the allocated amount.';
                    trigger OnValidate()
                    begin

                    end;

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(GetData)
            {
                ApplicationArea = All;
                Caption = 'Get Data';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select an organization receipt and populate the allocation receipt line.';

                trigger OnAction()
                var
                    receiptNo: Code[50];
                begin
                    receiptNo := Rec.GetRangeMin("Receipt No.");
                    GetOrganizationReceipt(receiptNo);
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Update(false);
        // updateAllocatedAmount(Rec."Receipt No.");
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    /* trigger OnNewRecord(BelowxRec: Boolean)
     begin
         updateAllocatedAmount(Rec."Receipt No.");
     end;

     trigger OnNextRecord(Steps: Integer): Integer
     begin
         updateAllocatedAmount(Rec."Receipt No.");
     end;
 */
    /* local procedure updateAllocatedAmount(receiptNo: code[50])
     var
         AllocationReceipt: Record "E3 Allocation Receipt";
         OrgReceipt: Record "E3 Organization Receipt";
         AllocatedAmt: Decimal;
     begin
         AllocatedAmt := 0;
         AllocationReceipt.Reset();
         AllocationReceipt.SetRange("Receipt No.", receiptNo);
         if AllocationReceipt.FindSet() then
             repeat
                 AllocatedAmt += AllocationReceipt."Allocated Amount";
             until AllocationReceipt.Next() = 0;

         OrgReceipt.Reset();
         OrgReceipt.SetRange("Document No.", receiptNo);
         if OrgReceipt.Find('-') then begin
             OrgReceipt."Allocation Amount" := AllocatedAmt;
             OrgReceipt.Balance := OrgReceipt."Received Amount" - AllocatedAmt;
             if (OrgReceipt.Balance = 0) then
                 OrgReceipt."Allocation Status" := "E3 Allocation Status"::"Fully Allocate"
             else
                 OrgReceipt."Allocation Status" := "E3 Allocation Status"::"Partial Allocate";
             OrgReceipt.Modify(true);
             CurrPage.Update(false);
         end;
     end;
 */
    local procedure GetOrganizationReceipt(ReceiptNo: Code[50])
    var
        OrgReceipt: Record "E3 Organization Receipt";
        GetOrgReceiptPage: Page "E3 Get Orgnization Receipt";
        AllocationReceipt: Record "E3 Allocation Receipt";
    begin
        OrgReceipt.Reset();
        OrgReceipt.SetRange("Document No.", ReceiptNo);
        OrgReceipt.SetFilter(Balance, '<>%1', 0);

        if OrgReceipt.IsEmpty() then
            Error('No organization receipts are available.');

        GetOrgReceiptPage.SetTableView(OrgReceipt);
        GetOrgReceiptPage.LookupMode(true);

        if GetOrgReceiptPage.RunModal() = Action::LookupOK then begin
            GetOrgReceiptPage.SetSelectionFilter(OrgReceipt);

            if OrgReceipt.FindFirst() then begin
                // Create Allocation Receipt record if it does not exist
                //if Rec."Entry No." = 0 then begin
                AllocationReceipt.Init();
                AllocationReceipt.Validate("Receipt No.", OrgReceipt."Document No.");
                AllocationReceipt.Validate("Receipt Date", OrgReceipt."Document Date");
                AllocationReceipt.Validate("Receipt Amount", OrgReceipt."Received Amount");
                AllocationReceipt.Validate("HIS Document Type", OrgReceipt."HIS Document Type");
                AllocationReceipt.Validate("Shortcut Dimension 1 Code", OrgReceipt."Shortcut Dimension 1 Code");
                AllocationReceipt.Insert(true);
                //end;

                // Update Allocation Receipt table

                //Rec.Modify(true);

                // Update Organization Receipt status
                /*if OrgReceipt."Allocation Amount" = 0 then
                    OrgReceipt.Validate("Allocation Status", OrgReceipt."Allocation Status"::" ")
                else
                    if OrgReceipt."Allocation Amount" >= OrgReceipt."Received Amount" then
                        OrgReceipt.Validate(
                            "Allocation Status",
                            OrgReceipt."Allocation Status"::"Fully Allocate")
                    else
                        OrgReceipt.Validate(
                            "Allocation Status",
                            OrgReceipt."Allocation Status"::"Partial Allocate");

                OrgReceipt.Modify(true);
*/
                CurrPage.Update(false);
            end;
        end;
    end;
}