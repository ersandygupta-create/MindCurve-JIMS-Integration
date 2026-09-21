pageextension 50092 "E3 Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addafter("Cheque No.")
        {
            field("E3 Narration"; Rec."E3 Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Narration';
            }
        }

        addafter("Bal. Account No.")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Purchase Order No.';
                Caption = 'Purchase Order No.';
            }

            field("Document No"; Rec."Document No")
            {
                ToolTip = 'Advance Document No.';
                ApplicationArea = All;
                Caption = 'Advance Document No.';
            }
        }

        modify("Bal. Account No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateCardPaymentAction();
                CurrPage.Update(false);
            end;
        }
    }

    actions
    {
        addafter("Post and &Print")
        {
            action(CardPayment)
            {
                Caption = 'Check Print';
                ApplicationArea = All;
                Image = Payment;
                Visible = ShowCardPayment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if CardPaymentReportID = 0 then
                        Error(
                            'Card Payment Report is not configured for Bank Account %1.',
                            Rec."Bal. Account No.");

                    Report.Run(CardPaymentReportID);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateCardPaymentAction();
    end;

    local procedure UpdateCardPaymentAction()
    var
        BankAccount: Record "Bank Account";
    begin
        ShowCardPayment := false;
        CardPaymentReportID := 0;

        if Rec."Bal. Account Type" <> Rec."Bal. Account Type"::"Bank Account" then
            exit;

        if Rec."Bal. Account No." = '' then
            exit;

        if not BankAccount.Get(Rec."Bal. Account No.") then
            exit;

        CardPaymentReportID := BankAccount."Payment Report ID";
        ShowCardPayment := CardPaymentReportID <> 0;
    end;

    var
        ShowCardPayment: Boolean;
        CardPaymentReportID: Integer;
}