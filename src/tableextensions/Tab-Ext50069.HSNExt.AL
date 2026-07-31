tableextension 50069 HSNExt extends 18009
{
    fields
    {
        field(50000; GLEN; Enum "E3 GLEN Type")
        {
            Caption = 'GLEN';
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeInsert()
    begin
        CheckPermission();
    end;

    trigger OnBeforeModify()
    begin
        CheckPermission();
    end;

    trigger OnBeforeDelete()
    begin
        CheckPermission();
    end;

    trigger OnBeforeRename()
    begin
        CheckPermission();
    end;

    var
        UserSetup: Record "User Setup";

    local procedure CheckPermission()
    begin
        UserSetup.Get(UserId());
        if Not UserSetup."HSN Master" then
            Error('You donot have permission Perform operation on HSN.');
    end;
}