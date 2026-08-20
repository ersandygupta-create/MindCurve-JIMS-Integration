page 50216 "E3 Organization Receipt"
{
    Caption = 'Organization Receipt';
    PageType = Card;
    SourceTable = "E3 Organization Receipt";
    ApplicationArea = All;
    UsageCategory = Documents;

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
                    ToolTip = 'Specifies the entry number.';
                }
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HIS document type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the received amount.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account type.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balance account type.';
                }
                field("Bal. Account No"; Rec."Bal. Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the balance account.';
                }
                field("Instrument No."; Rec."Instrument No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instrument number.';
                }
                field("Instrument Date"; Rec."Instrument Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instrument date.';
                }
            }
            part(AllocationReceipt; "E3 Allocation Receipt List")
            {
                ApplicationArea = All;

                SubPageLink =
                        "Receipt No." = FIELD("Document No.");
            }

            part(BillApplication; "E3 Bill Application List")
            {
                ApplicationArea = All;

                SubPageLink =
                        "Customer Code" = FIELD("Account No.");
            }
        }
    }
}