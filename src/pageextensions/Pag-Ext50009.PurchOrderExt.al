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
                ToolTip = 'Exp. CN Value';
            }
            field("Item Make Code"; Rec."Item Make Code")
            {
                ApplicationArea = All;
                Caption = 'Item Make Code';
                ToolTip = 'Specifies the unique code of the item make.';
            }
        }
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                Caption = 'Voucher Type';
                Editable = Rec."Voucher Type" = '';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
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
            action("Cancle PO")
            {
                ApplicationArea = All;
                Caption = 'Cancle PO';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Cancel Purchase Order from Indent.';

                trigger OnAction()
                var
                    IndentLine: Record "E3 Indent Line";
                    purchaseline: record "Purchase Line";
                begin
                    purchaseline.reset();
                    purchaseline.SetRange("Document Type", rec."Document Type");
                    purchaseline.SetRange("Document No.", Rec."No.");
                    if purchaseline.FindSet() then
                        repeat
                            cancleIndentLine(purchaseline);
                        until purchaseline.Next() = 0;

                    Message('Purchase Order has been canceled from indent;');
                end;
            }
        }
    }

    var
        recPurchHdr: Record "Purchase Header";
        VoucherTypeEditable: Boolean;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());

        if not UserSetup."Purchase Order" then
            Error('You do not have permission to open Purchase Order.');
    end;

    local procedure cancleIndentLine(var purchLine: Record "Purchase Line")
    var
        IndentLine: Record "E3 Indent Line";
    begin
        if purchLine."Qty. Invoiced (Base)" = 0 then begin
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
                    IndentLine.Modify();
                    purchLine."Indent Line No." := 0;
                    purchLine."Indent No." := '';
                    purchLine."Indent Line Remarks" := '';
                    purchLine.Quantity := 0;
                    purchLine.Modify();
                until IndentLine.Next() = 0;
        end else
            Message('Purchase line %1 is partially receive so it line can not be canceled.', purchLine."Line No.");
    end;



}
