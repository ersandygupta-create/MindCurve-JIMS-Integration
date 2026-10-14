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
                        ToolTip = 'Select the customer whose allocation receipts and customer ledger entries should be imported.';
                        TableRelation = "E3 Allocation Receipt"."Customer Code";
                    }
                }
            }
        }
    }

    var
        CustomerCode: Code[20];
        AllocationReceipt: Record "E3 Allocation Receipt";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        BillApplication: Record "E3 Bill Application";
        LastBillApplication: Record "E3 Bill Application";
        NextEntryNo: Integer;
        InsertedCount: Integer;

    local procedure InsertBillApplication()
    begin
        if CustomerCode = '' then
            Error('Please select a Customer Code.');

        InsertedCount := 0;

        AllocationReceipt.Reset();
        AllocationReceipt.SetRange("Customer Code", CustomerCode);

        if not AllocationReceipt.FindSet() then
            Error(
                'No allocation receipt records found for Customer Code %1.',
                CustomerCode);

        repeat
            CustomerLedgerEntry.Reset();
            CustomerLedgerEntry.SetRange("Customer No.", CustomerCode);
            CustomerLedgerEntry.SetFilter("Remaining Amount", '<>%1', 0);

            if CustomerLedgerEntry.FindSet() then
                repeat
                    BillApplication.Reset();
                    BillApplication.SetRange(
                        "Receipt No.", AllocationReceipt."Receipt No.");
                    BillApplication.SetRange(
                        "Customer Code", CustomerCode);
                    BillApplication.SetRange(
                        "Bill No", CustomerLedgerEntry."Document No.");

                    if not BillApplication.FindFirst() then begin
                        // Get the next Entry No.
                        LastBillApplication.Reset();
                        LastBillApplication.LockTable();

                        if LastBillApplication.FindLast() then
                            NextEntryNo :=
                                LastBillApplication."Entry No." + 1
                        else
                            NextEntryNo := 1;

                        // Initialize and insert the record.
                        BillApplication.Init();
                        BillApplication."Entry No." := NextEntryNo;
                        BillApplication."Receipt No." := AllocationReceipt."Receipt No.";
                        BillApplication."Customer Code" := CustomerLedgerEntry."Customer No.";
                        BillApplication."Customer Name" := AllocationReceipt."Customer Name";
                        BillApplication."Bill No" := CustomerLedgerEntry."Document No.";
                        BillApplication."Bill Date" := CustomerLedgerEntry."Document Date";
                        BillApplication."UHIDNo" := CustomerLedgerEntry."E3 UHID";
                        CustomerLedgerEntry.CalcFields("Remaining Amount");
                        BillApplication."Bill Amount" := CustomerLedgerEntry."Remaining Amount";

                        BillApplication.Insert(true);
                        InsertedCount += 1;
                    end;
                until CustomerLedgerEntry.Next() = 0;

        until AllocationReceipt.Next() = 0;

        Message(
            '%1 Bill Application record(s) inserted for Customer %2.',
            InsertedCount,
            CustomerCode);
    end;
}