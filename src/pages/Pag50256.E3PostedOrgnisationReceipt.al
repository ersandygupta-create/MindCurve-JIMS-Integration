page 50256 "E3 Posted Organization Receipt"
{
    Caption = 'Posted Organization Receipt';
    PageType = Card;
    SourceTable = "E3 Organization Receipt";
    ApplicationArea = All;
    UsageCategory = Documents;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the entry number.';
                }
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the HIS document type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the document number.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the document date.';
                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the received amount.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the account type.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the account.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the balance account type.';
                }
                field("Bal. Account No"; Rec."Bal. Account No")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the balance account.';
                }
                field("Instrument No."; Rec."Instrument No.")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the instrument number.';
                }
                field("Instrument Date"; Rec."Instrument Date")
                {
                    ApplicationArea = All;
                    Editable = not Rec.IsCreated;
                    ToolTip = 'Specifies the instrument date.';
                }
                field("Allocation Amount"; Rec."Allocation Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount allocated.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the remaining balance amount.';
                }
                field("Allocation Status"; Rec."Allocation Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the receipt is fully or partially allocated.';
                }
            }
            part(AllocationReceipt; "E3 Allocation Receipt List")
            {
                ApplicationArea = All;

                SubPageLink =
                        "Receipt No." = FIELD("Document No.");
                UpdatePropagation = Both;
            }

            part(BillApplication; "E3 Bill Application List")
            {
                ApplicationArea = All;

                SubPageLink =
                       "Receipt No." = field("Document No."),
                "Allocation Receipt Entry No." = field("Selected Allocation Entry No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Orgnization Entries")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Orgnization Entries action.';
                Caption = 'Create Orgnization Entries';
                trigger OnAction();
                var
                    OrgnizationReceiptMgmt: Codeunit "E3 Settlement Process Mgmt.";
                begin
                    OrgnizationReceiptMgmt.InitGenJnlLineSettlementProcess(Rec);

                end;
            }
            action("Post Revenue Entries")
            {
                ApplicationArea = All;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post OrgnizationReceiptMgmt Entries action.';
                Caption = 'Post OrgnizationReceiptMgmt Entries';
                trigger OnAction();
                var
                    OrgnizationReceiptMgmt: Codeunit "E3 Settlement Process Mgmt.";
                begin

                    OrgnizationReceiptMgmt.PostGenJnlLineEntries();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        FilterSubpageC(Rec."Selected Allocation Entry No.");
    end;

    procedure FilterSubpageC(EntryNo: Integer)
    begin
        CurrPage.BillApplication.Page.SetAllocationFilter(Rec."Document No.", EntryNo);
    end;
    // trigger OnAfterGetCurrRecord()
    // begin
    //     FilterSubpageC(Rec."Selected Allocation Entry No.");
    // end;




    // procedure FilterSubpageC(EntryNo: Integer)
    // begin
    //     CurrPage.BillApplication.Page.SetAllocationFilter(Rec."Document No.", EntryNo);
    // end;

    procedure SetCustomerFilter(DocNo: Code[20]; AllocationEntryNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Document No.", DocNo);
        Rec.SetRange("Selected Allocation Entry No.", AllocationEntryNo);
        CurrPage.Update(false);
    end;

    procedure SetAllocationFilter(DocNo: Code[20]; AllocationEntryNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Document No.", DocNo);
        Rec.SetRange("Selected Allocation Entry No.", AllocationEntryNo);
        CurrPage.Update(false);
    end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     // Every time Subpage C refreshes, update its filter directly from Table A
    //    // UpdateAllocationFilter();
    // end;

    procedure UpdateAllocationFilter()
    var
        RecordA: Record "E3 Organization Receipt";
        DocNo: Code[20];
    begin
        DocNo := Rec.GetFilter("Document No.");
        if DocNo = '' then
            DocNo := Rec."Document No.";

        if DocNo <> '' then begin
            // if RecordA.Get(DocNo) then begin
            // Directly filter Table C based on Table A's active tracking field
            Rec.SetRange("Document No.", DocNo);
            Rec.SetRange("Selected Allocation Entry No.", RecordA."Selected Allocation Entry No.");
            //end;
        end;
    end;
}