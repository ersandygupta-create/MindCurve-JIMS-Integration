tableextension 50069 "E3 HSN SAC Ext" extends "HSN/SAC"
{
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

    local procedure CheckPermission()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."HSN Master" then
                exit;

        Error('You do not have permission to create, modify, or delete HSN records.');
    end;
}