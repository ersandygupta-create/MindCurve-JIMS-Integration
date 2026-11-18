codeunit 50067 "E3 Stock Consumption Document"
{
    Access = Internal;
    TableNo = "E3 Stock Consumption Header";

    trigger OnRun()
    var
        PostStockConsumption: Codeunit "E3 Post Stock Consumption";
    begin
        PostStockConsumption.ProcessStockConsumptionDocument(Rec, AutoPost);
    end;

    var
        AutoPost: Boolean;

    procedure SetAutoPost(NewAutoPost: Boolean)
    begin
        AutoPost := NewAutoPost;
    end;
}
