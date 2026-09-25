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
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ToolTip = 'Beneficiary Name';
                ApplicationArea = All;
                //Editable = blnEdit;
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
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                if rec."Account Type" = rec."Account Type"::Vendor then
                    blnEdit := false;
                if rec."Account Type" = rec."Account Type"::"G/L Account" then begin
                    blnEdit := true;
                    rec."Beneficiary Name" := '';
                    rec.Modify();
                end;

                CurrPage.Update(false);

            end;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                if rec."Account Type" = rec."Account Type"::Vendor then begin
                    Vendor.get(rec."Account No.");
                    rec."Beneficiary Name" := Vendor."Beneficiary Name";
                end;
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

    trigger OnOpenPage()
    begin
        blnEdit := false;
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
        Vendor: Record Vendor;
        ShowCardPayment: Boolean;
        CardPaymentReportID: Integer;
        blnEdit: Boolean;
}