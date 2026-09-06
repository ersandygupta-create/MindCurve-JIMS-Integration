codeunit 50051 "E3 Item JIMS Job Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        E3Item: Record Item;
        ProcessedItems: Integer;
    begin
        E3Item.Reset();
        E3Item.SetRange("Item Sync Status", false);

        if E3Item.FindSet() then
            repeat
                ItemIntegrationMgmt.MultipleSendToJIMS(E3Item);
                E3Item."Item Sync Status" := true;
                E3Item.Modify(true);
                ProcessedItems += 1;
                if ProcessedItems >= 500 then
                    break;

            until E3Item.Next() = 0;
    end;

    var
        ItemIntegrationMgmt: Codeunit "E3 Item Integration Mgmt.";
}