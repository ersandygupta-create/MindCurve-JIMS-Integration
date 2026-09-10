pageextension 50095 "E3 No. Series Ext" extends "No. Series"
{
    layout
    {
        modify(Code)
        {
            Editable = IsLineEditable;
        }
        modify(Description)
        {
            Editable = IsLineEditable;
        }
        modify("Default Nos.")
        {
            Editable = IsLineEditable;
        }
        modify("Manual Nos.")
        {
            Editable = IsLineEditable;
        }
        modify("Date Order")
        {
            Editable = IsLineEditable;
        }
        modify(Implementation)
        {
            Editable = IsLineEditable;
        }
    }

    actions
    {
        // Add changes to page actions here
    }


    var
        IsLineEditable: Boolean;
        UserSetup: Record "User Setup";

    trigger OnAfterGetCurrRecord()
    begin
        IsLineEditable := false;

        if UserSetup.Get(UserId) then
            IsLineEditable := UserSetup."No. Series Edit";
    end;

}