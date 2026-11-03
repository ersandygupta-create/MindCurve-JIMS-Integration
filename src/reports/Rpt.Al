report 50103 "Delete Custom Data Report"
{
    Caption = 'Delete Custom Data Report';
    // ApplicationArea = All;

    UsageCategory = Administration;
    ProcessingOnly = true; // Specifies that this is a data processing report without a UI layout

    dataset
    {
        dataitem("MyCustomTable"; 50062)
        {
            // You can set initial table views or filters here if needed
            // TableView = sorting("Entry No.") where("IsProcessed" = const(true));

            trigger OnAfterGetRecord()
            begin
                // Perform the deletion for each record matching the criteria
                MyCustomTable.Delete(true); // Set to true to trigger OnDelete triggers and validations
                DeletedCounter += 1;
            end;

            trigger OnPreDataItem()
            begin
                // Optional: Confirm with the user before proceeding with deletion
                if not Confirm('Are you sure you want to delete the selected records from MyCustomTable?', false) then
                    Error('Deletion process cancelled by user.');

                DeletedCounter := 0;
            end;

            trigger OnPostDataItem()
            begin
                Message('Process completed successfully. Total records deleted: %1', DeletedCounter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    // You can add request page fields here if you need user input parameters
                }
            }
        }

        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        DeletedCounter: Integer;
}