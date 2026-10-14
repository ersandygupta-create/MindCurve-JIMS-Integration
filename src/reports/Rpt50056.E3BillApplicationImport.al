report 50056 "E3 Bill Application Import"
{
    Caption = 'Import Bill Application';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnPreDataItem()
            begin
                InsertBillApplication();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(CustomerCode; CustomerCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer Code';
                        ToolTip = 'Select the customer whose allocation receipts should be imported.';
                        TableRelation = "E3 Allocation Receipt"."Customer Code";
                    }
                }
            }
        }
    }

    var
        CustomerCode: Code[20];
        AllocationReceipt: Record "E3 Allocation Receipt";
        BillApplication: Record "E3 Bill Application";
        InsertedCount: Integer;

    local procedure InsertBillApplication()
    begin
        if CustomerCode = '' then
            Error('Please select a Customer Code.');

        AllocationReceipt.Reset();
        AllocationReceipt.SetRange("Customer Code", CustomerCode);

        if not AllocationReceipt.FindSet() then
            Error(
                'No allocation receipt records found for Customer Code %1.',
                CustomerCode);

        repeat
            // Prevent duplicate receipt entries for this customer.
            BillApplication.Reset();
            BillApplication.SetRange(
                "Receipt No.", AllocationReceipt."Receipt No.");
            BillApplication.SetRange(
                "Customer Code", AllocationReceipt."Customer Code");

            if not BillApplication.FindFirst() then begin
                BillApplication.Init();

                // Entry No. is AutoIncrement; do not assign it manually.
                BillApplication."Receipt No." := AllocationReceipt."Receipt No.";
                BillApplication."Customer Code" := AllocationReceipt."Customer Code";
                BillApplication."Customer Name" := AllocationReceipt."Customer Name";
                BillApplication."Bill Date" := AllocationReceipt."Receipt Date";
                BillApplication."Bill Amount" := AllocationReceipt."Allocated Amount";

                BillApplication.Insert(true);
                InsertedCount += 1;
            end;
        until AllocationReceipt.Next() = 0;

        Message(
            '%1 Bill Application record(s) inserted for Customer %2.',
            InsertedCount, CustomerCode);
    end;
}