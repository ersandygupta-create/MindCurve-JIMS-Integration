pageextension 50109 "E3 Purchase Invoice" extends 9308
{
    layout
    {
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Vourcher type';
            }
        }
        addbefore("Assigned User ID")
        {
            field("Submit to Finance"; Rec."Submit to Finance")
            {
                ToolTip = 'Submit to finance';
                ApplicationArea = All;
            }
            field("Submit Doc No."; Rec."Submit Doc No.")
            {
                ToolTip = 'Finance Document No.';
                ApplicationArea = all;
            }
            field("Receive Finance"; Rec."Receive Finance")
            {
                ApplicationArea = all;
                ToolTip = 'Received by Finance';
            }
        }
    }

    actions
    {
        addafter(Action7)
        {
            action("Submit")
            {
                ApplicationArea = all;
                Caption = 'Submit to Finance';
                ToolTip = 'Submit to Finance';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                Visible = ShowSubmitButton;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    NoSeriesMgt: Codeunit "No. Series";
                    VoucherType: Record "E3 Voucher Type";
                    NewDocNo: Code[20];
                    SelectedCount: Integer;
                    FirstVoucherType: Code[20];
                    FirstBUCode: Code[20];
                begin
                    // 1. Get selected records from the page
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    if not PurchaseHeader.FindSet() then
                        Error('No records selected.');

                    // 2. Store first selected invoice values
                    FirstVoucherType := PurchaseHeader."Voucher Type";
                    FirstBUCode := PurchaseHeader."Shortcut Dimension 1 Code";

                    repeat
                        if PurchaseHeader."Submit to Finance" then
                            Error(
                                'Purchase Invoice %1 has already been submitted to Finance. You cannot submit it again.',
                                PurchaseHeader."No.");

                        if PurchaseHeader."Voucher Type" <> FirstVoucherType then
                            Error(
                                'Selected Purchase Invoices have different Voucher Types. Please select invoices with the same Voucher Type.');

                        // Business Unit validation
                        if PurchaseHeader."Shortcut Dimension 1 Code" <> FirstBUCode then
                            Error(
                                'Selected Purchase Invoices belong to different Business Units. Please select invoices with the same Business Unit.');

                    until PurchaseHeader.Next() = 0;

                    // ADDED: Get selected records again after validation
                    Clear(PurchaseHeader);
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    // 2. Fetch the No. Series code from your setup table
                    if FirstVoucherType = '' then
                        Error('Specify a Voucher Type on the selected Purchase Invoices.');

                    VoucherType.Reset();
                    VoucherType.SetRange(Code, FirstVoucherType);
                    if not VoucherType.FindFirst() then
                        Error('Voucher Type %1 is missing from E3 Voucher Type setup.', FirstVoucherType);

                    VoucherType.TestField("Finance Doc. No.");
                    NewDocNo := NoSeriesMgt.GetNextNo(VoucherType."Finance Doc. No.", WorkDate());

                    // 4. Update all selected records with the same generated Document No.
                    if PurchaseHeader.FindSet(true) then
                        repeat
                            PurchaseHeader."Submit Doc No." := NewDocNo;
                            PurchaseHeader."Submit to Finance" := true;
                            PurchaseHeader.Modify(true);

                            // Insert Bill Handling record
                            InsertBillHandling(PurchaseHeader, 'Submit to Finance');
                            PurchaseHeader."Posting Date" := WorkDate();
                            PurchaseHeader.Modify(true);

                            SelectedCount += 1;
                        until PurchaseHeader.Next() = 0;

                    CurrPage.Update(false);

                    Message(
                        'Document No. %1 submitted to finance to %2 selected record(s).',
                        NewDocNo,
                        SelectedCount);
                end;
            }

            action("Accept")
            {
                ApplicationArea = All;
                Caption = 'Accept to Finance';
                ToolTip = 'Mark selected records as Received if Submitted Document No. is not blank.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Approve;
                Visible = ShowAcceptButton;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    // 1. Get all user-selected rows from the page
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    // 2. Filter ONLY records where Submitted Document No. is NOT blank
                    PurchaseHeader.SetFilter("Submit Doc No.", '<>%1', '');

                    if PurchaseHeader.IsEmpty() then
                        Error('None of the selected records have a Submitted Document No.');

                    // Insert Bill Handling records for matching selected records
                    if PurchaseHeader.FindSet() then
                        repeat
                            InsertBillHandling(PurchaseHeader, 'Accept to Finance');
                            PurchaseHeader."Posting Date" := WorkDate();
                            PurchaseHeader.Modify(true);
                        until PurchaseHeader.Next() = 0;

                    // 3. Update matching records
                    PurchaseHeader.ModifyAll("Receive Finance", true);

                    Message('%1 record(s) marked as Received.', PurchaseHeader.Count());
                end;
            }

            action("Reject")
            {
                ApplicationArea = All;
                Caption = 'Submit to Store';
                ToolTip = 'Reject selected records if Submitted Document No. is not blank.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAcceptButton;
                Image = Reject;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    CancelIndentDialog: Page "E3 Cancel Indent Dialog";
                    CancelReason: Text[250];
                    SelectedCount: Integer;
                begin
                    // 1. Get selected records from the page
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    // 2. Filter ONLY records where Submitted Document No. is NOT blank
                    PurchaseHeader.SetFilter("Submit Doc No.", '<>%1', '');

                    if PurchaseHeader.IsEmpty() then
                        Error('None of the selected records have a Submitted Document No.');

                    // 3. Open cancellation reason dialog
                    if CancelIndentDialog.RunModal() <> Action::OK then
                        exit;

                    // 4. Get entered reason
                    CancelReason := CancelIndentDialog.GetCancelReason();

                    // 5. Validate reason
                    if DelChr(CancelReason, '=', ' ') = '' then
                        Error('Please enter the cancellation reason.');

                    // 6. Insert Bill Handling with entered remarks
                    if PurchaseHeader.FindSet() then
                        repeat
                            InsertBillHandlingWithRemarks(
                                PurchaseHeader,
                                'Submit to Store',
                                CancelReason);

                            SelectedCount += 1;
                        until PurchaseHeader.Next() = 0;

                    // 7. Update Purchase Invoice fields
                    PurchaseHeader.ModifyAll("Receive Finance", false);
                    PurchaseHeader.ModifyAll("Submit to Finance", false);

                    CurrPage.Update(false);

                    // 8. Confirmation
                    Message(
                        '%1 selected record(s) submitted to Store successfully.',
                        SelectedCount);
                end;
            }

            action("Bill Handling")
            {
                ApplicationArea = All;
                Caption = 'Bill Handling';
                ToolTip = 'Open the Bill Handling List page.';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"E3 Bill Handling List");
                end;
            }
        }
    }

    local procedure InsertBillHandling(PurchaseHeader: Record "Purchase Header"; EventName: Text[100])
    var
        BillHandling: Record "E3 Bill Handling";
    begin
        BillHandling.Init();

        BillHandling."No." := PurchaseHeader."No.";
        BillHandling."Voucher Type Code" := PurchaseHeader."Voucher Type";
        BillHandling."Voucher Type Name" := PurchaseHeader."GRN Voucher Type Name";
        BillHandling."Vendor Code" := PurchaseHeader."Buy-from Vendor No.";
        BillHandling."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
        BillHandling."Challan No." := PurchaseHeader."Vendor Invoice No.";
        BillHandling."Challan Date" := PurchaseHeader."Document Date";
        BillHandling."GRN No." := PurchaseHeader."Receipt No.";
        BillHandling."GRN Date" := PurchaseHeader."Receipt Date";
        BillHandling."Bill Handling No." := PurchaseHeader."Submit Doc No.";
        BillHandling."Due Date" := PurchaseHeader."Due Date";
        BillHandling.Remarks := PurchaseHeader."Posting Description";
        BillHandling."Event Name" := EventName;
        BillHandling."Posting Date" := PurchaseHeader."Posting Date";
        BillHandling."Location Code" := PurchaseHeader."Location Code";
        BillHandling."Net Amount" := PurchaseHeader."Net Amount";
        BillHandling."Created By" := UserId();
        BillHandling.Insert(true);
    end;

    local procedure InsertBillHandlingWithRemarks(
    PurchaseHeader: Record "Purchase Header";
    EventName: Text[100];
    RemarksText: Text[250])
    var
        BillHandling: Record "E3 Bill Handling";
    begin
        BillHandling.Init();

        BillHandling."No." := PurchaseHeader."No.";
        BillHandling."Voucher Type Code" := PurchaseHeader."Voucher Type";
        BillHandling."Voucher Type Name" := PurchaseHeader."GRN Voucher Type Name";
        BillHandling."Vendor Code" := PurchaseHeader."Buy-from Vendor No.";
        BillHandling."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
        BillHandling."Challan No." := PurchaseHeader."Vendor Invoice No.";
        BillHandling."Challan Date" := PurchaseHeader."Document Date";
        BillHandling."GRN No." := PurchaseHeader."Receipt No.";
        BillHandling."GRN Date" := PurchaseHeader."Receipt Date";
        BillHandling."Bill Handling No." := PurchaseHeader."Submit Doc No.";
        BillHandling."Due Date" := PurchaseHeader."Due Date";

        // User-entered rejection reason
        BillHandling.Remarks := RemarksText;

        BillHandling."Event Name" := EventName;
        BillHandling."Posting Date" := PurchaseHeader."Posting Date";
        BillHandling."Location Code" := PurchaseHeader."Location Code";
        BillHandling."Net Amount" := PurchaseHeader."Net Amount";
        BillHandling."Created By" := UserId();

        BillHandling.Insert(true);
    end;

    trigger OnOpenPage()
    begin
        UpdateButtonVisibility();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalculateGSTAmount();
    end;

    local procedure UpdateButtonVisibility()
    begin
        Clear(ShowSubmitButton);
        Clear(ShowAcceptButton);

        if UserSetup.Get(UserId()) then begin
            ShowSubmitButton := UserSetup."Receive Finance";
            ShowAcceptButton := UserSetup."Submit to Finance";
        end;
    end;

    var
        UserSetup: Record "User Setup";
        ShowSubmitButton: Boolean;
        ShowAcceptButton: Boolean;
}