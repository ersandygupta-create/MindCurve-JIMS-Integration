pageextension 50060 "E3 Chart of Accounts List" extends "Chart of Accounts"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Caption = 'Name 2';
                ToolTip = 'Specifies the value of the Name 2 field.';
            }
            field("DebitAmount"; Rec."Debit Amount")
            {
                ApplicationArea = All;
                Caption = 'Debit Amount';
                ToolTip = 'Specifies the value of the Debit Amount field.';
            }
            field("CreditAmount"; Rec."Credit Amount")
            {
                ApplicationArea = All;
                Caption = 'Credit Amount';
                ToolTip = 'Specifies the value of the Credit Amount field.';
            }
            // field("NetChange"; Rec."Net Change")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Net Change';
            //     ToolTip = 'Specifies the value of the Net Change field.';
            // }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if not UserSetup."GL View" then
                Error(
                  'Permission of COA is not added in your access. If required, please contact the IT Administrator.');
    end;

    var
        CheckBln: Code[30];
        UserSetup: Record "User Setup";
}


