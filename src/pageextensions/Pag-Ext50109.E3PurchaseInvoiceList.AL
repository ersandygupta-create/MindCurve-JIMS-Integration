pageextension 50109 "E3 Purchase Invoice" extends 9308
{
    layout
    {
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
        addafter("&Invoice")
        {
            action("Submit")
            {
                ApplicationArea = all;
                Caption = 'Submit to Finance';
                ToolTip = 'Submit to Finance';
                Promoted = true;
                Image = Post;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    NoSeriesMgt: Codeunit "No. Series";
                    VoucherType: Record "E3 Voucher Type";
                    NewDocNo: Code[20];
                begin
                    // 1. Get selected records from the page
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    if not PurchaseHeader.FindSet() then
                        Error('No records selected.');

                    // 2. Fetch the No. Series code from your setup table
                    VoucherType.Reset();
                    VoucherType.SetFilter("Finance Doc. No.", '<>%1', '');
                    if not VoucherType.FindFirst() then
                        Error('Specify Finance doc no series in voucehr setup table.');

                    // 3. Generate ONE new document number from the No. Series
                    NewDocNo := NoSeriesMgt.GetNextNo(VoucherType."Finance Doc. No.", WorkDate(), true);

                    // 4. Update all selected records with the same generated Document No.
                    repeat
                        PurchaseHeader."Submit Doc No." := NewDocNo; // Replace "Document No." with your field name
                        PurchaseHeader.Modify(true);
                    until PurchaseHeader.Next() = 0;

                    Message('Document No. %1 submitted to finance to %2 selected record(s).', NewDocNo, PurchaseHeader.Count());
                end;
            }
            action("Accept")
            {
                ApplicationArea = All;
                Caption = 'Accept';
                ToolTip = 'Mark selected records as Received if Submitted Document No. is not blank.';
                Promoted = true;
                PromotedCategory = Process;
                Image = Approve;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    // 1. Get all user-selected rows from the page
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    // 2. Filter ONLY records where Submitted Document No. is NOT blank
                    PurchaseHeader.SetFilter("Submit Doc No.", '<>%1', ''); // Replace "Submit to Finance No." with your exact field name

                    if PurchaseHeader.IsEmpty() then
                        Error('None of the selected records have a Submitted Document No.');

                    // 3. Update matching records
                    PurchaseHeader.ModifyAll("Receive Finance", true);

                    Message('%1 record(s) marked as Received.', PurchaseHeader.Count());
                end;
            }

            action("Reject")
            {
                ApplicationArea = All;
                Caption = 'Reject';
                ToolTip = 'Reject selected records if Submitted Document No. is not blank.';
                Promoted = true;
                PromotedCategory = Process;
                Image = Reject;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    // 1. Get selected records from the page
                    CurrPage.SetSelectionFilter(PurchaseHeader);

                    // 2. Filter ONLY records where Submitted Document No. is NOT blank
                    PurchaseHeader.SetFilter("Submit Doc No.", '<>%1', ''); // Replace "Submit to Finance No." with your exact field name

                    if PurchaseHeader.IsEmpty() then
                        Error('None of the selected records have a Submitted Document No.');

                    // 3. Clear fields across qualifying records
                    PurchaseHeader.ModifyAll("Receive Finance", false);
                    PurchaseHeader.ModifyAll("Submit to Finance", false);

                    Message('%1 selected record(s) rejected.', PurchaseHeader.Count());
                end;
            }
        }
    }
}