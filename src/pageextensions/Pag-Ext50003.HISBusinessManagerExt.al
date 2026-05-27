pageextension 50003 "E3 HIS Business Manager RC" extends "Business Manager Role Center"
{
    actions
    {
        addbefore(Action39)
        {
            group("E3 HIS Interface")
            {
                Caption = 'HIS Interface';

                group("E3 HIS Setup")
                {
                    Caption = 'Integration Setup';
                    action("E3 Setups")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Integration Setup';
                        Image = Setup;
                        RunObject = Page "E3 Integration Setup";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Integration Setup action.';
                    }
                    group("E3 Masters Setups")
                    {
                        Caption = 'Setups';
                        action("E3 MOP Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'MOP Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS MOP Revenue Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the MOP Setup action.';
                        }
                        action("E3 Payroll Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Payroll Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Payroll Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Payroll Setup action.';
                        }
                        action("E3 Pharmacy Setup")
                        {
                            Visible = false;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Pharmacy Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Pharmacy Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Pharmacy Setup action.';
                        }
                        action("E3 Revenue Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Revenue Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Revenue Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Revenue Setup action.';
                        }
                        action("E3 Collection Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Collection Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Collection Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Collection Setup action.';
                        }
                        action("E3 Consumption Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Consumption Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Consumption Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Consumption Setup action.';
                        }
                        action("E3 HIS Doctor Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Doctor Payout Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Doctor Payout Setup";
                            RunPageMode = Create;
                            ToolTip = 'Create a new Doctor Payout for HIS Interface.';
                        }
                        action("E3 Settlement Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Settlement Setup';
                            Image = Setup;
                            RunObject = Page "E3 HIS Settlement Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Settlement Setup action.';
                        }
                        action("E3 Payment Advice E-Mail Setups")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Payment Advice E-Mail Setups';
                            Image = Setup;
                            RunObject = Page "E3 HIS E-Mail Setup";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Payment Advice E-Mail Setups action.';
                        }
                    }
                    group("E3 HIS Mapping")
                    {
                        Caption = 'Mapping';

                        // action("E3 HIS Item Mapping")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Item Mapping';
                        //     Image = Setup;
                        //     RunObject = Page "E3 HIS Item Mapping";
                        //     RunPageMode = Create;
                        //     ToolTip = 'Executes the Item Mapping action.';
                        // }
                        action("E3 HIS UOM Mapping")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'UOM Mapping';
                            Image = Setup;
                            RunObject = Page "E3 HIS UOM Mapping";
                            RunPageMode = Create;
                            ToolTip = 'Create a new UOM Mapping for HIS Interface.';
                        }
                        action("E3 Profit Center")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Dimension Mapping';
                            Image = Setup;
                            RunObject = Page "E3 HIS Dimension Setup";
                            RunPageMode = Create;
                            ToolTip = 'Create a new Dimension mapping for HIS Interface.';
                        }
                        action("E3 HIS Customer Mapping")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'HIS Customer Mapping';
                            Image = Setup;
                            RunObject = Page "E3 HIS Customer Mapping";
                            RunPageMode = Create;
                            ToolTip = 'Executes the HIS Customer Mapping Setups action.';
                        }
                    }
                    group("Allow Date")
                    {
                        Caption = 'Allow HIS Data Posting Date';
                        action("Allow Posting Date")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Allow HIS Data Posting Date';
                            Image = Setup;
                            RunObject = Page "Allow Posting Date";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Allow Posting Date action.';
                        }
                    }
                }
                group("E3 HIS Masters")
                {
                    Caption = 'Master';

                    group("E3 Masters Create")
                    {
                        Caption = 'Master Create';

                        action("E3 HIS Vendor List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Vendors List';
                            Image = NewOrder;
                            RunObject = Page "E3 HIS Vendor Staging List";
                            RunPageMode = Create;
                            ToolTip = 'Create a new HIS Vendors for items or services.';
                        }
                        action("E3 HIS Doctor List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Doctor List';
                            Image = NewOrder;
                            RunObject = Page "E3 HIS Doctor Staging List";
                            RunPageMode = Create;
                            ToolTip = 'Create a new HIS Doctor for items or services.';
                        }
                        action("E3 HIS Customer List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customers List';
                            Image = NewOrder;
                            RunObject = Page "E3 HIS Customer Staging List";
                            RunPageMode = Create;
                            ToolTip = 'Create a new Customers for items or services.';
                        }
                        action("E3 HIS Emplooyee List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Employees List';
                            Image = NewOrder;
                            RunObject = Page "E3 HIS Employee Staging List";
                            RunPageMode = Create;
                            ToolTip = 'Check a new Employees for Payroll Entries.';
                        }
                        // action("E3 HIS items List")
                        // {
                        //     AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Items List';
                        //     Image = NewOrder;
                        //     RunObject = Page "E3 HIS Item List";
                        //     RunPageMode = Create;
                        //     ToolTip = 'Create a new Item for Purchase or Sales.';
                        // }
                        // action("HIS Pending items List")
                        // {
                        //     AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Item Approval Level1';
                        //     Image = NewOrder;
                        //     RunObject = Page "E3 HIS Item Pending List";
                        //     RunPageMode = Create;
                        //     ToolTip = 'Create a Pending Item for Purchase or Sales.';
                        // }
                        // action("HIS Approved items List")
                        // {
                        //     AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Item Approval Level2';
                        //     Image = NewOrder;
                        //     RunObject = Page "E3 HIS Item Approved List";
                        //     RunPageMode = Create;
                        //     ToolTip = 'Create a Approved Item for Purchase or Sales.';
                        // }

                    }
                    group("E3 Master Created Successfully")
                    {
                        Caption = 'Master Created Successfully';

                        action("E3 Created HIS Vendor List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Created Vendors List';
                            Image = Archive;
                            RunObject = Page "E3 Posted HIS Vend. Stg. List";
                            RunPageMode = Create;
                            ToolTip = 'Check a new Vendors for items or services.';
                        }
                        action("E3 Created HIS Doctor List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Created Doctor List';
                            Image = Archive;
                            RunObject = Page "E3 Posted HIS Doct. Stg. List";
                            RunPageMode = Create;
                            ToolTip = 'Check a new Doctor for items or services.';
                        }
                        action("E3 Created HIS Customer List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Created Customers List';
                            Image = Archive;
                            RunObject = Page "E3 Posted HIS Customer List";
                            RunPageMode = Create;
                            ToolTip = 'Check a new Customers for items or services.';
                        }
                        action("E3 Created HIS Employee List")
                        {
                            AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Created Employees List';
                            Image = Archive;
                            RunObject = Page "E3 Posted HIS Employee List";
                            RunPageMode = Create;
                            ToolTip = 'Check a new Employees for Payroll Entries.';
                        }
                        // action("E3 Created HIS items List")
                        // {
                        //     AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Created Items List';
                        //     Image = Archive;
                        //     RunObject = Page "E3 Posted HIS Item List";
                        //     RunPageMode = Create;
                        //     ToolTip = 'Check a new Items for Purchase or Sales.';
                        // }
                        // action("Pending items List")
                        // {
                        //     AccessByPermission = TableData "E3 HIS Master Staging" = IMD;
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'All Pending Items List';
                        //     Image = Archive;
                        //     RunObject = Page "E3 ALL HIS Item List";
                        //     RunPageMode = Create;
                        //     ToolTip = 'Check a Pending Items for Purchase or Sales.';
                        // }

                    }

                }
                group("API Integration Setup")
                {
                    Caption = 'API Integration Setup';

                    action("E3 Integration API Setup")
                    {
                        AccessByPermission = TableData "E3 Integration API Setup" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'API Setup';
                        Image = Setup;
                        RunObject = Page "E3 Integration API Setup";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Integration API Setup action.';
                    }
                }
                group("Item Component")
                {
                    Caption = 'Item Component';
                    action("Item Type")
                    {
                        AccessByPermission = TableData "E3 Item Type" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Type';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Type";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Master List.';
                    }
                    action("Item Model")
                    {
                        AccessByPermission = TableData "E3 Item Model Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Model';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Model Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Model List.';
                    }
                    action("Item Strength")
                    {
                        AccessByPermission = TableData "E3 Item Strength Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Strength';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Strength Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Strength List.';
                    }
                    action("Item Property")
                    {
                        AccessByPermission = TableData "E3 Item Property Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Property';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Property";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Property List.';
                    }
                    action("Item MedicineSubcategory")
                    {
                        AccessByPermission = TableData "E3 Medicine Sub-Category Mast" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Medicine Subcategory';
                        Image = NewOrder;
                        RunObject = Page "E3 Medicine SubCategory";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Medicine Subcategory List.';
                    }
                    action("Sub Group Nature")
                    {
                        AccessByPermission = TableData "E3 Sub-Group Nature" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Sub-Group Nature';
                        Image = NewOrder;
                        RunObject = Page "E3 Sub Group Nature";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Sub-Group Nature List.';
                    }
                    action("Item Category Master")
                    {
                        AccessByPermission = TableData "E3 Item Category Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Category';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Category Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Category List.';
                    }
                    action("Item Make Master")
                    {
                        AccessByPermission = TableData "E3 Item Make Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Make';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Make Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Make List.';
                    }
                    action("Medicine Component Master")
                    {
                        AccessByPermission = TableData "E3 Medicine Component Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Medicine Component';
                        Image = NewOrder;
                        RunObject = Page "E3 Medicine Component Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Medicine Component List.';
                    }
                    action("Item Specialty Master")
                    {
                        AccessByPermission = TableData "E3 Item Speciality Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Specialty';
                        Image = NewOrder;
                        RunObject = Page "E3 Item Speciality Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Item Specialty List.';
                    }
                    action("Material Category Master")
                    {
                        AccessByPermission = TableData "E3 Material Category Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Material Category';
                        Image = NewOrder;
                        RunObject = Page "E3 Material Category Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Material Category List.';
                    }
                    action("Material Type Master")
                    {
                        AccessByPermission = TableData "E3 Material Type Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Material Type';
                        Image = NewOrder;
                        RunObject = Page "E3 Material Type Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Material Type List.';
                    }
                    action("Restricted Group Master")
                    {
                        AccessByPermission = TableData "E3 Restricted Group Master" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Restricted Group';
                        Image = NewOrder;
                        RunObject = Page "E3 Restricted Group Master";
                        RunPageMode = Create;
                        ToolTip = 'Check Restricted Group List.';
                    }
                    action("Medicine Composition Master")
                    {
                        AccessByPermission = TableData "E3 Medicine Composition" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Medicine Composition';
                        Image = NewOrder;
                        RunObject = Page "E3 Medicine Composition";
                        RunPageMode = Create;
                        ToolTip = 'Check Medicine Composition List.';
                    }
                    action("Sub Group Site List")
                    {
                        AccessByPermission = TableData "E3 Sub Group Site List" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sub Group Site List';
                        Image = NewOrder;
                        RunObject = Page "E3 Sub Group Site List";
                        RunPageMode = Create;
                        ToolTip = 'Check Sub Group Site List.';
                    }
                }
                group("E3 HIS Collection Staging")
                {
                    Caption = 'Collection Entries';

                    action("E3 Create HIS Collection Entries")
                    {
                        AccessByPermission = TableData "E3 HIS Revenue Staging Table" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Collection Entries';
                        Image = Archive;
                        RunObject = Page "E3 HIS Revenue Stagging";
                        RunPageMode = Create;
                        ToolTip = 'Create a new Collection Entries for Companies.';
                    }
                    action("E3 Created HIS Collection Entries")
                    {
                        AccessByPermission = TableData "E3 HIS Revenue Staging Table" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Created Collection Entries';
                        Image = Archive;
                        RunObject = Page "E3 Posted HIS Rev. Stagging";
                        RunPageMode = Create;
                        ToolTip = 'Check a new Collection Entries for Companies.';
                    }

                }
                group("E3 HIS Pharmacy Staging")
                {
                    Caption = 'Pharmacy Entries';
                    Visible = false;

                    action("E3 Create HIS Pharmacy Entries")
                    {
                        AccessByPermission = TableData "E3 HIS Pharmacy Entries" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Pharmacy Entries';
                        Image = Archive;
                        RunObject = Page "E3 HIS Pharmacy Entries";
                        RunPageMode = Create;
                        ToolTip = 'Create a new Pharmacy Entries for Companies.';
                    }


                    action("E3 Created HIS Phamacy Entries")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Created Phamacy Entries';
                        Image = Archive;
                        RunObject = Page "E3 Posted HIS Pharm. Entries";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Created Phamacy Entries action.';
                    }

                }
                group("E3 HIS Consumption Staging")
                {
                    Caption = 'Consumption Entries';

                    action("E3 Create HIS Consumption Entries")
                    {
                        AccessByPermission = TableData "E3 HIS Consumption Entries" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Consumption Entries';
                        Image = Archive;
                        RunObject = Page "E3 HIS Consumption Entries";
                        RunPageMode = Create;
                        ToolTip = 'Create a new Consumption Entries for Companies.';
                    }


                    action("E3 Created HIS Consumption Ent.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Created Consumption Entries';
                        Image = Archive;
                        RunObject = Page "E3 Posted HIS Cons. Entries";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Created Consumption Entries action.';
                    }

                }
                group("E3 HIS Revenue Invoice Entries")
                {
                    Caption = 'Revenue Invoice Entries';
                    action("E3 HIS Revenue Invoice")
                    {
                        AccessByPermission = TableData "E3 HIS Revenue Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Revenue Invoice';
                        Image = Archive;
                        RunObject = Page "E3 HIS Revenue List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Create Revenue Invoice action.';
                    }
                    action("E3 Created HIS Revenue Invoice")
                    {
                        AccessByPermission = TableData "E3 HIS Revenue Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Image = Archive;
                        RunObject = Page "E3 Posted HIS Revenue List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Created Revenue Invoice action.';
                        Caption = 'Created Revenue Invoice';
                    }
                }
                group("E3 HIS Revenue Cancel Entries")
                {
                    Caption = 'Revenue Cancel Entries';
                    action("E3 HIS Revenue Cancel")
                    {
                        AccessByPermission = TableData "E3 HIS Revenue Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Image = Archive;
                        RunObject = Page "E3 HIS Revenue Cancel List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Revenue Cancel action.';
                        Caption = 'Create Revenue Cancel';
                    }
                    action("E3 Created HIS Revenue Cancel")
                    {
                        AccessByPermission = TableData "E3 HIS Revenue Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Image = Archive;
                        RunObject = Page "E3 HIS Posted Rev Cancel List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Created Revenue Cancel action.';
                        Caption = 'Created Revenue Cancel';
                    }
                }

                group("E3 Gate Entry")
                {
                    Caption = 'Gate Entry';

                    action("E3 Gate Entry Inward")
                    {
                        AccessByPermission = TableData "E3 Gate Entry Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Gate Entry Inward';
                        Image = Archive;
                        RunObject = Page "E3 Gate Entry Inward List";
                        RunPageMode = Create;
                        ToolTip = 'Create a new Gate Entry Inward for Vendor.';
                    }
                    action("E3 Posted Gate Entry Inward")
                    {
                        AccessByPermission = TableData "E3 Posted Gate Entry Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Gate Entry Inward';
                        Image = Archive;
                        RunObject = Page "E3 Posted Gate Ent Inward List";
                        RunPageMode = Create;
                        ToolTip = 'Create a new Gate Entry Inward for Vendor.';
                    }
                    action("E3 Gate Entry Outward")
                    {
                        AccessByPermission = TableData "E3 Gate Entry Header" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Gate Entry Outward';
                        Image = Archive;
                        RunObject = Page "E3 Gate Entry Outward List";
                        RunPageMode = Create;
                        ToolTip = 'Created a Gate Entry Outward for Vendor.';
                    }
                }
            }
        }

        addlast("India Taxation")
        {
            group("Excel Report")
            {
                group("Balance Report")
                {
                    Caption = 'Balance Report';

                    action("Vendor Balance")
                    {
                        Caption = 'Vendor Balance';
                        ApplicationArea = All;
                        RunObject = Page "Vendor Balance";
                        ToolTip = 'Executes the Vendor Balance action.';
                    }
                    action("Customer Balance")
                    {
                        Caption = 'Customer Balance';
                        ApplicationArea = All;
                        RunObject = Page "Customer Balance";
                        ToolTip = 'Executes the Customer Balance action.';
                    }
                    action("Bank Balance")
                    {
                        Caption = 'Bank Balance';
                        ApplicationArea = All;
                        RunObject = Page "Bank Balance";
                        ToolTip = 'Executes the Bank Balance action.';
                    }
                    action("Employee Balance")
                    {
                        Caption = 'Employee Balance';
                        ApplicationArea = All;
                        RunObject = Page "Employee Balance";
                        ToolTip = 'Executes the Employee Balance action.';
                    }
                    action("Update UTR No./RTGS")
                    {
                        Caption = 'Update UTR No./RTGS';
                        ApplicationArea = All;
                        RunObject = Page "Update UTR No./RTGS";
                        ToolTip = 'Executes the Update UTR No./RTGS action.';
                    }
                }
            }
        }
        addbefore(Action39)
        {
            group("3E Bank Pay Letter")
            {
                Caption = 'Bank Pay Letter';
                group("Payment Process")
                {
                    Caption = 'Payment Process';

                    action("VLE Payment Entry Selection")
                    {
                        AccessByPermission = TableData "Vendor Ledger Entry" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Payment Entry Selection';
                        Image = NewOrder;
                        RunObject = Page "E3 Vendor Ledger Entries";
                        RunPageMode = Create;
                        ToolTip = 'Specify the Payment Entry Selection';
                    }
                    action("VLE Ready for Payment")
                    {
                        AccessByPermission = TableData "Vendor Ledger Entry" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ready for Payment Process';
                        Image = NewOrder;
                        RunObject = Page "E3 VLE Ready for Payment";
                        RunPageMode = Create;
                        ToolTip = 'Specify the VLE Ready for Payment';
                    }
                    action("Bank Process Data")
                    {
                        AccessByPermission = TableData "E3 Bank Integration" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Process Data';
                        Image = NewOrder;
                        RunObject = Page "E3 Exported BLE File";
                        RunPageMode = Create;
                        ToolTip = 'Specify the Exported BLE File';
                    }
                }
            }
        }

        addbefore(Action39)
        {
            group("E3 Bank Integration")
            {
                Caption = 'Payroll Integration';
                group("E3 Payroll Integration")
                {
                    Caption = 'Payroll Integration';
                    action("E3 Payroll Entries")
                    {
                        AccessByPermission = TableData "E3 Salary Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create Payroll Entries';
                        Image = Archive;
                        RunObject = Page "E3 Salary List Page";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Create Payroll Entries action.';
                    }
                    action("E3 Created Payroll Entries")
                    {
                        AccessByPermission = TableData "E3 Salary Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Image = Archive;
                        RunObject = Page "E3 Posted Salary List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Created Payroll Entries action.';
                        Caption = 'Created Payroll Entries';
                    }
                }
            }
        }
    }
}


