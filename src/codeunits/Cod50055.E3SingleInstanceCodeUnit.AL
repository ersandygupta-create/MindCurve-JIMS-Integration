
codeunit 50055 "E3 PO Creation Context"
{
    SingleInstance = true;

    var
        BypassRespCenterCheck: Boolean;

    procedure SetBypass(Enable: Boolean)
    begin
        BypassRespCenterCheck := Enable;
    end;

    procedure IsBypassActive(): Boolean
    begin
        exit(BypassRespCenterCheck);
    end;
}