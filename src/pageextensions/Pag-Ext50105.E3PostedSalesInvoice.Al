pageextension 50105 "E3 Posted Sales Invoice" extends 143
{
    actions
    {
        addafter(ActivityLog)
        {
            action(CreatePurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Order';
                Image = CreatePO;
                ToolTip = 'Create a Purchase Order based on this Sales Invoice.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateMgmt: Codeunit "E3 Create PO Management";
                begin
                    // 1. Validate that Voucher Type is populated
                    Rec.TestField("Voucher Type");
                    if (rec."Purchase Order Created" = false) then
                        // 2. Execute Purchase Order Creation Logic
                        CreateMgmt.CreatePurchaseOrderFromSalesInvoice(Rec)
                    else
                        Message('Purchase Order already created.');
                end;
            }
            action(SendToHIS)
            {
                ApplicationArea = All;
                Caption = 'Send to HIS';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Sends the selected posted sales Invoice data to HIS.';

                trigger OnAction()
                var
                    HISIntegrationMgt: Codeunit "E3 Sale Invoice Cons. Mgmt.";
                begin
                    Rec.TestField("No.");

                    if not Confirm(
                         StrSubstNo('Do you want to send Invoice %1 to the DB?', Rec."No."))
                    then
                        exit;

                    if HISIntegrationMgt.SendSaleInvoiceDetails(Rec."No.") then begin
                        Message('Sale %1 has been sent successfully.', Rec."No.");
                        CurrPage.Update(true);
                    end else
                        Error('Failed to send Sale %1. Please check the Response field.', Rec."No.");
                end;
            }
        }
    }

}