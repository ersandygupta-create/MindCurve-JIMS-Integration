page 50208 "E3 UnBilled Batch API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'UnBilledBatchAPI';
    DelayedInsert = true;
    EntityName = 'unBilledsBatch';
    EntitySetName = 'unBilledsBatch';
    SourceTable = "E3 UnBilled Service Revenue";
    SourceTableTemporary = true;
    PageType = API;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(batchNo; BatchNo)
                {
                    Caption = 'Batch No.';

                    trigger OnValidate()
                    begin
                        Rec.Init();
                        Rec.Insert();
                    end;
                }
            }
            part(RevenueLine; "E3 UnBilled Revenue API")
            {
                Caption = 'UnbilledRevenue';
                EntityName = 'unBilledRevenue';
                EntitySetName = 'unBilledRevenue';
            }
        }
    }

    var
        BatchNo: Text[100];
}
