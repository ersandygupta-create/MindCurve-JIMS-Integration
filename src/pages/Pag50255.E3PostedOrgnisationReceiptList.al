page 50255 "E3 Posted Org. Receipt List"
{
    Caption = 'Posted Organization Receipt List';
    PageType = List;
    SourceTable = "E3 Organization Receipt";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Posted Organization Receipt";
    SourceTableView = where(IsCreated = const(true));
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'Orgnization Receipt';
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
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

                field("Allocation Amount"; Rec."Allocation Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount allocated.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remaining balance amount.';
                }
                field("Allocation Status"; Rec."Allocation Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the receipt is fully or partially allocated.';
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
        }
    }
}