
pageextension 50113 "E3 Order Address list Ext" extends "Order Address List"
{
    trigger OnOpenPage()
    begin
        CheckOrderAddressPermission();
    end;

    local procedure CheckOrderAddressPermission()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId());

        if UserSetup.FindFirst() then begin
            if not UserSetup."Order Address Insert" then
                Error('You do not have permission to access the Order Address List page.');
        end else
            Error('User Setup not found for User ID %1.', UserId());
    end;
}
