
pageextension 50009 "E3 HIS Purchase Order" extends "Purchase Order"
{
    layout

    {
        addlast(General)
        {

            field("E3 Item Type"; Rec."E3 Item Type")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                Visible = false;
                ToolTip = 'Specifies the value of the Item Type field.';
            }
            field("E3 Delivery Terms"; Rec."E3 Delivery Terms")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
                Editable = false;
                ToolTip = 'Specifies the value of the Delivery Terms field.';
                Visible = false;
            }
            field("Store Name"; Rec."Store Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Store Name field';
                Visible = false;
            }
            field("Advance PO"; Rec."Advance PO")
            {
                ApplicationArea = All;
                //Editable = CanEditCustomFields;
                ToolTip = 'Specifies the value of the Advance PO field';
            }
            field("Advance PO Count"; Rec."Advance PO Count")
            {
                ApplicationArea = All;
                ToolTip = 'Count of Advance Document created against this PO.';
            }
            field("W/S DL No."; Rec."W/S DL No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the Wholesale Drug License Number for the vendor.';
            }

            field("Retail DL No."; Rec."Retail DL No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Retail Drug License Number for the vendor.';
                Visible = false;
            }
            field("Exp. CN Value"; Rec."Exp. CN Value")
            {
                ApplicationArea = All;
                //Editable = CanEditCustomFields;
                ToolTip = 'Exp. CN Value';
            }
            field("Item Make Code"; Rec."Item Make Code")
            {
                ApplicationArea = All;
                Caption = 'Item Make Code';
                ToolTip = 'Specifies the unique code of the item make.';
                ShowMandatory = true;
                Editable = CanEditCustomFields;
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }

        }
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                Caption = 'Voucher Type';
                Editable = Rec."Voucher Type" = '';
                ToolTip = 'Voucher Type';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
        addafter("Reason Code")
        {
            field("Short Close Reason"; Rec."Short Close Reason")
            {
                ApplicationArea = all;
                ShowMandatory = true;
                ToolTip = 'Short Close Reason';
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("Terms & Conditions")
            {
                ApplicationArea = All;
                Caption = 'Order Terms & Conditions';
                Image = ViewDetails;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                ToolTip = 'Manage the Terms & Conditions for this Purchase Order.';

                trigger OnAction()
                var
                    POTerms: Record "E3 Order Terms & Conditions";
                begin
                    Page.Run(Page::"E3 Order Terms & Conditions", POTerms);
                end;
            }
            action("Cancel PO")
            {
                ApplicationArea = All;
                Caption = 'Cancel PO';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Cancel Purchase Order from Indent.';

                trigger OnAction()
                var
                    purchaseline: record "Purchase Line";
                    ReleasePurchDoc: Codeunit "Release Purchase Document";
                    FullyReceivedLineExists: Boolean;
                    HasQuantityLine: Boolean;
                    AllQuantityLinesReceived: Boolean;
                begin
                    FullyReceivedLineExists := false;
                    HasQuantityLine := false;
                    AllQuantityLinesReceived := true;
                    purchaseline.SetRange("Document Type", Rec."Document Type");
                    purchaseline.SetRange("Document No.", Rec."No.");
                    if purchaseline.FindSet() then
                        repeat
                            if purchaseline.Quantity <> 0 then begin
                                HasQuantityLine := true;
                                if purchaseline.Quantity = purchaseline."Quantity Received" then
                                    FullyReceivedLineExists := true
                                else
                                    AllQuantityLinesReceived := false;
                            end;
                        until purchaseline.Next() = 0;

                    // Check before Reopen to avoid status and archive changes.
                    if HasQuantityLine and AllQuantityLinesReceived then begin
                        Message('The purchase order is fully received and cannot be cancelled.');
                        exit;
                    end;

                    if Rec.Status = Rec.Status::Released then
                        ReleasePurchDoc.PerformManualReopen(Rec);

                    CheckPoStatus();
                    Rec.TestField("Reason Code");
                    purchaseline.reset();
                    purchaseline.SetRange("Document Type", rec."Document Type");
                    purchaseline.SetRange("Document No.", Rec."No.");
                    purchaseline.SetRange("Cancelled Line", false);
                    if purchaseline.FindSet() then
                        repeat
                            // Preserve the quantity before cancellation.
                            PurchaseLine."PO Qty" := PurchaseLine.Quantity;
                            cancleIndentLine(purchaseline);
                        until purchaseline.Next() = 0;
                    rec.Cancelled := not FullyReceivedLineExists;
                    rec.Modify(false);
                    CurrPage.Update(false);
                    if Rec.Cancelled then
                        Message('Purchase Order has been canceled from indent;')
                    else
                        Message('Eligible lines have been cancelled. The purchase order is not marked cancelled because it contains a fully received line.');
                end;

            }
            action(RecreateLinesFromReceipt)
            {
                ApplicationArea = All;
                Caption = 'Recreate Lines from Receipt';
                Image = GetReceiptLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Recreate missing purchase lines from posted purchase receipt lines.';

                trigger OnAction()
                var
                    RecreatePurchLines: Codeunit "Recreate Purch Lines From Rcpt";
                begin
                    if not Confirm('Recreate missing purchase lines from posted receipt lines for order %1?', false, Rec."No.") then
                        exit;

                    RecreatePurchLines.RecreateLinesFromReceipt(Rec."No.");
                    CurrPage.Update(false);
                end;
            }
            action("Short Close PO")
            {
                ApplicationArea = All;
                Caption = 'Short Close PO';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Short close Purchase Order.';

                trigger OnAction()
                var
                    purchaseline: record "Purchase Line";
                begin
                    CheckPoStatus();
                    rec.TestField("Short Close Reason");
                    purchaseline.reset();
                    purchaseline.SetRange("Document Type", rec."Document Type");
                    purchaseline.SetRange("Document No.", Rec."No.");
                    purchaseline.SetFilter("Short Close Qty", '<>%1', 0);
                    purchaseline.SetFilter("Outstanding Quantity", '<>%1', 0);
                    if purchaseline.FindSet() then
                        repeat
                            ShortCloseQty(purchaseline);
                        until purchaseline.Next() = 0;
                    rec."Short Closed" := true;
                    rec.Modify(false);
                    Message('Purchase Order has been Short closed.');
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());

        if not UserSetup."Purchase Order" then
            Error('You do not have permission to open Purchase Order.');

        if Rec.Cancelled then
            Error('Purchase Order %1 is cancelled and cannot be opened.', Rec."No.");
    end;

    local procedure ShortCloseQty(var purchLine: Record "Purchase Line")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine := purchLine;

        PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine."Outstanding Qty. (Base)" - purchLine."Short Close Qty";
        PurchaseLine.Validate("Outstanding Qty. (Base)");
        PurchaseLine."Outstanding Quantity" := PurchaseLine."Outstanding Quantity" - purchLine."Short Close Qty";
        PurchaseLine.Validate("Outstanding Quantity");
        PurchaseLine."Qty. to Receive" := PurchaseLine."Outstanding Quantity";
        PurchaseLine."Qty. to Receive (Base)" := PurchaseLine."Outstanding Quantity";
        PurchaseLine.Modify(true);
    end;

    local procedure cancleIndentLine(var purchLine: Record "Purchase Line")
    var
        IndentLine: Record "E3 Indent Line";
        CancelPoLines: Record "E3 Cancel PO Lines";
    begin
        if ((purchLine."Qty. Invoiced (Base)" = 0) AND (purchLine."Qty. Received (Base)" = 0)) then begin
            IndentLine.Reset();
            //  IndentLine.SetRange("Order Line No.", purchLine."Line No.");
            IndentLine.SetRange("Purchase Order No.", purchLine."Document No.");
            IndentLine.SetRange("No.", purchLine."No.");
            if IndentLine.FindSet() then
                repeat
                    IndentLine."Order Line No." := 0;
                    IndentLine."Purchase Order No." := '';
                    IndentLine."PO Created" := false;
                    indentline."Closed Indent Grouped Line" := false;
                    IndentLine."Released Stock Issue" := false;
                    IndentLine.Modify();
                // purchLine."Indent Line No." := 0;
                // purchLine."Indent No." := '';
                // purchLine."Indent Line Remarks" := '';
                // purchLine.Quantity := 0;


                //Sandeep
                until IndentLine.Next() = 0;
            purchLine."PO Qty" := purchLine.Quantity;
            CancelPoLines.TransferFields(purchLine);
            CancelPoLines.Insert();
            //purchLine.Delete(false);
            purchLine."Cancelled Line" := true;
            purchLine.Modify(true);
        end else
            Message('Purchase line %1 is partially receive so it line can not be canceled.', purchLine."Line No.");
    end;

    var
        CanEditCustomFields: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        SetFieldEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetFieldEditable();
    end;

    local procedure SetFieldEditable()
    begin
        CanEditCustomFields := not (Rec.Status in [Rec.Status::"Pending Approval", Rec.Status::Released]);
    end;

    local procedure CheckPoStatus()

    begin

        if Rec.Status <> Rec.Status::Open then
            Error('Purchase order should be open');
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PurchaseLine: Record "Purchase Line";
        PendingShortCloseErr: Label
        'Line %1 has a Short Close Qty of %2. Choose Short Close PO Line or set the quantity to 0 before closing.';
    begin
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetRange("Short Closed", false);
        PurchaseLine.SetFilter("Short Close Qty", '<>%1', 0);

        if PurchaseLine.FindFirst() then
            Error(PendingShortCloseErr, PurchaseLine."Line No.",
                PurchaseLine."Short Close Qty");

        exit(true);
    end;

}
