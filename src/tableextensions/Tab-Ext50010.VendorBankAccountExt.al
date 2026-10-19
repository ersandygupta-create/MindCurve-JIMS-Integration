tableextension 50010 "E3 HIS Vendor Bank Account" extends "Vendor Bank Account"
{
    fields
    {
        field(50000; "E3 IFSC Code"; Code[20])
        {
            Caption = 'IFSC Code';
            DataClassification = CustomerContent;
        }
        field(50001; "Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeInsert()
    var
        UserSetupRec: Record "User Setup";
    begin
        if not UserSetupRec.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetupRec."Vendor Bank Insert" then
            Error('You are not allowed to insert Vendor Bank records.');
    end;

    trigger OnBeforeModify()
    var
        UserSetupRec: Record "User Setup";
    begin
        if not UserSetupRec.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetupRec."Vendor Bank Modify" then
            Error('You are not allowed to modify Vendor Bank records.');
    end;

    trigger OnBeforeDelete()
    var
        UserSetupRec: Record "User Setup";
    begin
        if not UserSetupRec.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetupRec."Vendor Bank Delete" then
            Error('You are not allowed to delete Vendor Bank records.');
    end;

}
