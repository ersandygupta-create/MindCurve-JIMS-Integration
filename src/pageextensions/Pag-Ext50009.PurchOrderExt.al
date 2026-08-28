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
            }
            field("Store Name"; Rec."Store Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Store Name field';
            }
            field("Advance PO"; Rec."Advance PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance PO field';
            }
            field("W/S DL No."; Rec."W/S DL No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Wholesale Drug License Number for the vendor.';
            }

            field("Retail DL No."; Rec."Retail DL No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Retail Drug License Number for the vendor.';
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
        addafter("No.")
        {
            field("TransactionType"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                Caption = 'Transaction Type';
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
                PromotedCategory = Process;
                ToolTip = 'Manage the Terms & Conditions for this Purchase Order.';

                trigger OnAction()
                var
                    POTerms: Record "E3 Order Terms & Conditions";
                begin
                    Page.Run(Page::"E3 Order Terms & Conditions", POTerms);
                end;
            }
        }
    }

    var
        recPurchHdr: Record "Purchase Header";

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());

        if not UserSetup."Purchase Order" then
            Error('You do not have permission to open Purchase Order.');
    end;

}
