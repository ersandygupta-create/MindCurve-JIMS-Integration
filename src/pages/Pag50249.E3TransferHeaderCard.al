page 50249 "E3 Transfer Card"
{
    PageType = Card;
    SourceTable = "E3 Transfer Header";
    Caption = 'Transfer Card';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer entry type.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer validation key.';
                }
                field(v_Date; Rec.v_Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer date.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document Number"; Rec."Document Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer document number.';
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit code.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
                }
                field("Number of Lines"; Rec."Number of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of transfer lines.';
                }
                field("Is Created"; Rec."Is Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the transfer has been created.';
                }
                field("Is Posted"; Rec."Is Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the transfer has been posted.';
                }
            }
            part(TransferLines; "E3 Transfer Lines")
            {
                ApplicationArea = All;
                SubPageLink =
                    "Entry Type" = field("Entry Type"),
                    "Entry Number" = field("Entry Number");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PostTransfer)
            {
                ApplicationArea = All;
                Caption = 'Post Transfer';
                ToolTip = 'Posts the Item Reclassification Journal for this transfer.';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                Enabled = Rec."Is Created" and not Rec."Is Posted";

                trigger OnAction()
                var
                    TransferJournalMgmt: Codeunit "E3 Transfer Journal Mgmt.";
                begin
                    Rec.TestField("Entry Number");

                    if Rec."Is Posted" then
                        Error('Transfer %1 has already been posted.', Rec."Entry Number");

                    if not Rec."Is Created" then
                        Error('Create the Item Reclassification Journal before posting the transfer.');

                    if not Confirm(
                        'Do you want to post the Item Reclassification Journal for Transfer %1?',
                        false,
                        Rec."Entry Number")
                    then
                        exit;

                    TransferJournalMgmt.CreateItemReclassificationJournal(Rec."Entry Number");

                    CurrPage.Update(false);
                end;
            }
        }
    }
}