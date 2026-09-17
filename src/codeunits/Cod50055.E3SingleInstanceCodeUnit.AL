
codeunit 50055 "E3 PO Creation Context"
{
    SingleInstance = true;

    var
        BypassRespCenterCheck: Boolean;
        ByPassSalesLine: Boolean;

    procedure SetBypass(Enable: Boolean)
    begin
        BypassRespCenterCheck := Enable;
    end;

    procedure IsBypassActive(): Boolean
    begin
        exit(BypassRespCenterCheck);
    end;

    procedure SetByPassSalesLineCheck(enable: Boolean)
    begin
        ByPassSalesLine := enable;
    end;

    procedure IsSalesLineBypassActive(): Boolean
    begin
        exit(ByPassSalesLine);
    end;

}