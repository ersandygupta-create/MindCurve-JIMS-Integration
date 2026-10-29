pageextension 50092 "E3 Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        modify(Amount)
        {
            Editable = IsEditable;
            trigger OnBeforeValidate()
            var
                AdvancePo: Record "Vendor Adv. Pay. Ag. PO";
            begin
                if (Rec."Document No" <> '') then begin
                    AdvancePo.Reset();
                    AdvancePo.SetRange("Document No", rec."Document No");
                    if AdvancePo.Find('-') then begin
                        if rec.Amount > AdvancePo."Remaining Amount" then
                            Error('Amount can not be greater then Remaining amount of Advance document no.');
                    end;
                end;

            end;
        }
        modify("Amount (LCY)")
        {
            Editable = IsEditable;
        }

        addafter("Cheque No.")
        {
            field("E3 Narration"; Rec."E3 Narration")
            {
                ApplicationArea = All;
                Editable = IsEditable;
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
                Editable = IsEditable;
                ToolTip = 'Purchase Order No.';
                Caption = 'Purchase Order No.';
            }

            field("Document No"; Rec."Document No")
            {
                ToolTip = 'Advance Document No.';
                ApplicationArea = All;
                Editable = IsEditable;
                Caption = 'Advance Document No.';
            }
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ToolTip = 'Beneficiary Name';
                ApplicationArea = All;
                Editable = IsEditable;
                //Editable = blnEdit;
            }
        }

        modify("Bal. Account No.")
        {
            Editable = IsEditable;
            trigger OnAfterValidate()
            begin
                UpdateCardPaymentAction();
                CurrPage.Update(false);
            end;
        }
        modify("Account Type")
        {
            Editable = IsEditable;
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
        modify("Posting Date")
        {
            Editable = IsEditable;
        }
        modify("Document Type")
        {
            Editable = IsEditable;
        }
        modify("Document No.")
        {
            Editable = IsEditable;
        }
        modify("External Document No.")
        {
            Editable = IsEditable;
        }
        modify("Payment Reference")
        {
            Editable = IsEditable;
        }
        modify("Account No.")
        {
            Editable = IsEditable;
            trigger OnAfterValidate()
            begin
                if rec."Account Type" = rec."Account Type"::Vendor then begin
                    Vendor.get(rec."Account No.");
                    rec."Beneficiary Name" := Vendor."Beneficiary Name";
                end;
            end;
        }
        modify(Description)
        {
            Editable = IsEditable;
        }
        modify("Location Code")
        {
            Editable = IsEditable;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = IsEditable;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = IsEditable;
        }
        modify("TDS Section Code")
        {
            Editable = IsEditable;
        }
        modify("Posting Group")
        {
            Editable = IsEditable;
        }
        modify("Bank Payment Type")
        {
            Editable = IsEditable;
        }
        modify("Message to Recipient")
        {
            Editable = IsEditable;
        }
        modify("Debit Amount")
        {
            Editable = IsEditable;
        }
        modify("Credit Amount")
        {
            Editable = IsEditable;
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
                    ChequeJnlLine: Record "Gen. Journal Line";
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        Error('You can print the Card Payment Report only when Status is Approved.');

                    if CardPaymentReportID = 0 then
                        Error('Card Payment Report is not configured for Bank Account %1.',
                            Rec."Bal. Account No.");

                    // Validate all journal lines having the same cheque number.
                    ChequeJnlLine.Reset();
                    ChequeJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ChequeJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    ChequeJnlLine.SetRange("Cheque No.", Rec."Cheque No.");
                    if ChequeJnlLine.FindSet() then
                        repeat
                            if ChequeJnlLine.Status <> ChequeJnlLine.Status::Approved then
                                Error(
                                    'Cheque No. %1 cannot be printed. Journal line Document No. %2 has Status %3. All lines with the same cheque number must be Approved.',
                                    Rec."Cheque No.",
                                    ChequeJnlLine."Document No.",
                                    ChequeJnlLine.Status);
                        until ChequeJnlLine.Next() = 0;

                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");

                    Report.RunModal(CardPaymentReportID, true, true, GenJnlLine);
                    Rec."Check Printed" := true;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        blnEdit := false;
        isEdit := true;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateCardPaymentAction();
        AmountEdit();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateCardPaymentAction();
        AmountEdit();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Allow the user to enter a new payment journal line.
        IsEditable := true;
        isEdit := true;
    end;

    local procedure AmountEdit()
    var
        vendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        isEdit :=
        (Rec.Status <> Rec.Status::"Pending Approval") and
        (Rec.Status <> Rec.Status::Approved);

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
