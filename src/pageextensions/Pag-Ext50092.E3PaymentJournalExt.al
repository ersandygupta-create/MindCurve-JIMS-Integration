pageextension 50092 "E3 Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        modify(Amount)
        {
            Editable = isEdit;
        }
        modify("Amount (LCY)")
        {
            Editable = isEdit;
        }
        modify(Control1)
        {
            Editable = IsEditable;
        }
        addafter("Cheque No.")
        {
            field("E3 Narration"; Rec."E3 Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Narration';
            }
            field("CheckPrinted"; Rec."Check Printed")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
                //Visible = false;
                ToolTip = 'Specifies a value status field.';
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
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        Error('You can print the Card Payment Report only when Status is Approved.');

                    if CardPaymentReportID = 0 then
                        Error(
                            'Card Payment Report is not configured for Bank Account %1.',
                            Rec."Bal. Account No.");

                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");

                    Report.RunModal(CardPaymentReportID, true, true, GenJnlLine);

                    //Report.Run(CardPaymentReportID);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateCardPaymentAction();
        SetPageEditable();

    end;

    trigger OnAfterGetCurrRecord()
    begin
        AmountEdit();
    end;

    trigger OnOpenPage()
    begin
        blnEdit := false;
        isEdit := true;
        SetPageEditable();
    end;

    local procedure AmountEdit()
    var
        vendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if (rec."VLE Doc No." <> '') then begin
            vendLedgerEntry.Reset();
            vendLedgerEntry.SetRange("Document No.", rec."VLE Doc No.");
            if vendLedgerEntry.Find('-') then
                isEdit := false;
        end
        else
            isEdit := true;

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

    local procedure SetPageEditable()
    begin
        IsEditable :=
         (Rec.Status <> Rec.Status::"Pending Approval") and
         (Rec.Status <> Rec.Status::Approved);
    end;

    var
        Vendor: Record Vendor;
        ShowCardPayment: Boolean;
        CardPaymentReportID: Integer;
        blnEdit: Boolean;
        isEdit: Boolean;
        IsEditable: Boolean;
}
