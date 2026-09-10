pageextension 50096 "E3 No. Series Lines Ext" extends "No. Series Lines"
{
    layout
    {
        modify("Series Code")
        {
            Editable = IsLineEditable;
        }
        modify("Starting Date")
        {
            Editable = IsLineEditable;
        }
        modify("Starting No.")
        {
            Editable = IsLineEditable;
        }
        modify("Ending No.")
        {
            Editable = IsLineEditable;
        }
        modify("Last Date Used")
        {
            Editable = IsLineEditable;
        }
        modify("Last No. Used")
        {
            Editable = IsLineEditable;
        }
        modify("Warning No.")
        {
            Editable = IsLineEditable;
        }
        modify("Increment-by No.")
        {
            Editable = IsLineEditable;
        }
    }
    var
        IsLineEditable: Boolean;
        UserSetup: Record "User Setup";

    trigger OnAfterGetCurrRecord()
    begin
        IsLineEditable := false;

        if UserSetup.Get(UserId) then
            IsLineEditable := UserSetup."No. Series Line Edit";
    end;

}