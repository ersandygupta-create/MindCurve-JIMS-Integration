tableextension 50069 HSNExt extends 18009
{
    trigger OnBeforeInsert()
    begin
        UserSetup.Get(UserId());
        if Not UserSetup."HSN Master" then
            Error('You donot have permission to create a new HSN.');
    end;

    trigger OnBeforeModify()
    begin
        UserSetup.Get(UserId());
        if Not UserSetup."HSN Master" then
            Error('You donot have permission to Modify a HSN.');
    end;

    trigger OnBeforeDelete()
    begin
        UserSetup.Get(UserId());
        if Not UserSetup."HSN Master" then
            Error('You donot have permission to Delete a HSN.');
    end;

    trigger OnBeforeRename()
    begin
        UserSetup.Get(UserId());
        if Not UserSetup."HSN Master" then
            Error('You donot have permission to Rename a HSN.');
    end;

    var
        UserSetup: Record "User Setup";
}