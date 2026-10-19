tableextension 50022 "E3 Order Adress" extends "Order Address"
{
    fields
    {
        field(50010; "E3 NPU"; Boolean)
        {
            Caption = 'NPU';
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeInsert()
    var
        UserSetupRec: Record "User Setup";
    begin
        if not UserSetupRec.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetupRec."Order Address Insert" then
            Error('You are not allowed to insert Order Address records.');
    end;

    trigger OnBeforeModify()
    var
        UserSetupRec: Record "User Setup";
    begin
        if not UserSetupRec.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetupRec."Order Address Modify" then
            Error('You are not allowed to modify Order Address records.');
    end;

    trigger OnBeforeDelete()
    var
        UserSetupRec: Record "User Setup";
    begin
        if not UserSetupRec.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetupRec."Order Address Delete" then
            Error('You are not allowed to delete Order Address records.');
    end;

}
