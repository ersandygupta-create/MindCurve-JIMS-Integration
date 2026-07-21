tableextension 50071 "E3 Unit of Measure Ext" extends "Unit of Measure"
{
    trigger OnBeforeInsert()
    begin
        UserSetup.Get(UserId());
        if not UserSetup."UOM Editable" then
            Error('You do not have permission to create a Unit of Measure.');
    end;

    trigger OnBeforeModify()
    begin
        UserSetup.Get(UserId());
        if not UserSetup."UOM Editable" then
            Error('You do not have permission to modify a Unit of Measure.');
    end;

    trigger OnBeforeDelete()
    begin
        UserSetup.Get(UserId());
        if not UserSetup."UOM Editable" then
            Error('You do not have permission to delete a Unit of Measure.');
    end;

    trigger OnBeforeRename()
    begin
        UserSetup.Get(UserId());
        if not UserSetup."UOM Editable" then
            Error('You do not have permission to rename a Unit of Measure.');
    end;

    var
        UserSetup: Record "User Setup";
}