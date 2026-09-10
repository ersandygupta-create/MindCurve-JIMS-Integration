page 50180 "E3 Indent Role Center"
{
    PageType = RoleCenter;
    Caption = 'Indent Module';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(RoleCenter)
        {
            part(IndentCue; "E3 Indent Cue Card")
            {
                ApplicationArea = All;
            }
            part(EmailActivities; "Email Activities")
            {
                ApplicationArea = All;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }

        }
    }

    actions
    {
        area(Creation)
        {
            group("E3 Indent Module")
            {
                Caption = 'Indent Module';
                group(CreateIndent)
                {
                    Caption = 'Create Indent';
                    action("E3 Indent Entries")
                    {
                        AccessByPermission = TableData "E3 Indent Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'System Indent Entries';
                        Image = Archive;
                        RunObject = Page "E3 Indent List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Create Indent Entries action.';
                    }
                    action("E3 HIS Indent Entries")
                    {
                        AccessByPermission = TableData "E3 Indent Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'HIS Indent Entries';
                        Image = Archive;
                        RunObject = Page "E3 HIS Indent List";
                        RunPageMode = Create;
                        ToolTip = 'Executes the Create Indent Entries action.';
                    }
                }
                group(ApprovedIndent)
                {
                    Caption = 'Approved Indent';
                    Image = Approved;
                    action(ApprovedIndents)
                    {
                        Caption = 'System Approved Indent List';
                        ApplicationArea = All;
                        Visible = false;
                        RunObject = Page "E3 Approved Indent List";
                        ToolTip = 'Specify a value System Approved Indent List field.';
                    }
                    action(HISApprovedIndents)
                    {
                        Caption = 'Approved Indent List';
                        ApplicationArea = All;
                        RunObject = Page "E3 Approved HIS Indent List";
                        ToolTip = 'Executes the Vendor Quotation action.';
                    }
                    action(ShortClose)
                    {
                        Caption = 'Short Closed List';
                        ApplicationArea = All;
                        RunObject = page "E3 Short Closed Indent List";
                        ToolTip = 'Specify a value Short Closed Indent';
                    }
                }
                group("StoreSalesIndents")
                {
                    Caption = 'Store Indents';
                    action("Released Purchase")
                    {
                        AccessByPermission = TableData "E3 Indent Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Open Store Indents';
                        Image = Archive;
                        //Visible = false;
                        RunObject = Page "E3 HIS Release Indent List";
                        RunPageMode = View;
                        ToolTip = 'Specifies a view Release Indent List';
                    }
                    action("Released Store Indents Stock Issue")
                    {
                        AccessByPermission = TableData "E3 Indent Sale/Purchase Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Released Indents for Stock Issue';
                        Image = Archive;
                        RunObject = Page "HIS Released Sales Indent List";
                        RunPageMode = Create;
                        ToolTip = 'Create a Indents Store List';
                    }
                    action("Stock Issue")
                    {
                        AccessByPermission = TableData "E3 Indent Sale/Purchase Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stock Issue';
                        Image = Archive;
                        RunObject = Page "E3 Indent Sale/Purchase List";
                        RunPageMode = Create;
                        ToolTip = 'Closed a Closed Indents Store List';
                    }
                }
                group(ReleasedPurchaseIndent)
                {
                    Caption = 'Purchase Indents';
                    action("ReleasedPurchaseIssue")
                    {
                        AccessByPermission = TableData "E3 Indent Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Indents';
                        Image = Archive;
                        RunObject = Page "E3 HIS Issue Indent List";
                        RunPageMode = View;
                        ToolTip = 'Specifies a view Issue Indent List';
                    }
                    action("Released Purchase Indent")
                    {
                        AccessByPermission = TableData "E3 Indent Sale/Purchase Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Indents (In Process)';
                        Image = Archive;
                        RunObject = Page "HIS Released Purch Indent List";
                        RunPageMode = Create;
                        ToolTip = 'Create a Purchase Indents List';
                    }
                    action("Stock Receipt")
                    {
                        AccessByPermission = TableData "E3 Indent Sale/Purchase Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stock Receipt';
                        //Visible = false;
                        Image = Archive;
                        RunObject = Page "E3 Indent Stock Receipt List";
                        RunPageMode = Create;
                        ToolTip = 'Closed a Purchase Indents List';
                    }
                    action("Closed Purchase Indents")
                    {
                        AccessByPermission = TableData "E3 Indent Sale/Purchase Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Closed Purchase Indents';
                        //Visible = false;
                        Image = Archive;
                        RunObject = Page "E3 Closed Indent List";
                        RunPageMode = Create;
                        ToolTip = 'Closed a Purchase Indents List';
                    }
                }
                group(StockConsumption)
                {
                    Caption = 'Stock Consumption';
                    action("Stock Consumption")
                    {
                        AccessByPermission = TableData "E3 Stock Consumption Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stock Consumption Creation';
                        Image = Archive;
                        RunObject = Page "E3 Stock Consumption List";
                        RunPageMode = Create;
                        ToolTip = 'Create a new Stock Consumption.';
                    }
                    action("Posted Stock Consumption")
                    {
                        AccessByPermission = TableData "E3 Stock Consumption Header" = IMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Stock Consumption';
                        Image = Archive;
                        RunObject = Page "E3 Posted Stock Cons. List";
                        RunPageMode = View;
                        ToolTip = 'Specifies a view Stock Consumption.';
                    }
                }
                // group(Quotation)
                // {
                //     Caption = 'Purchase Indent';
                //     Image = Quote;
                //     action(VendorQuotation)
                //     {
                //         Caption = 'Purchase Indent Creation';
                //         ApplicationArea = All;
                //         RunObject = Page "E3 Quotation List";
                //         ToolTip = 'Executes the Vendor Quotation action.';
                //     }
                //     action(PurchaseReleased)
                //     {
                //         Caption = 'Purchase Released';
                //         ApplicationArea = All;
                //         RunObject = Page "E3 Indent Purchase Processing";
                //         ToolTip = 'Executes the Released Quotation List action.';
                //     }
                // }
                // action("E3 Indenter Master")
                // {
                //     AccessByPermission = TableData "E3 Indenter Master" = IMD;
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Indenter Master';
                //     Image = Archive;
                //     RunObject = Page "E3 Indenter Master List";
                //     RunPageMode = Create;
                //     ToolTip = 'Executes the Create Indenter Entries action.';
                // }
                action("E3 GRN Work Sheet")
                {
                    AccessByPermission = TableData "E3 GRN Work Sheet Header" = IMD;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted GRN Work Sheet';
                    Image = Archive;
                    RunObject = Page "E3 GRN Work Sheet List";
                    RunPageMode = Create;
                    ToolTip = 'Executes the Posted GRN Work Sheet Entries';
                }
                group(RCDetails)
                {
                    Caption = 'Purchase Agreement';
                    Image = Ratecontract;
                    group(PurchaseAgreement)
                    {
                        Caption = 'Purchase Agreement Creation';
                        action("E3 RC Details")
                        {
                            AccessByPermission = TableData "E3 Rate Contract Header" = RIMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Purchase Price Agreement';
                            Image = List;
                            RunObject = Page "E3 Rate Contract List";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Create Rate Contract Entries action.';
                        }
                        action("E3 RC Discount Details")
                        {
                            AccessByPermission = TableData "E3 RC Discount Header" = RIMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Purchase Discount Agreement';
                            Image = List;
                            RunObject = Page "E3 RC Discount List";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Create RC Discount Entries action.';
                        }
                    }
                    group(ApprovedList)
                    {
                        Caption = 'Approved Price List';
                        action("E3 Approved RC Details")
                        {
                            AccessByPermission = TableData "E3 Rate Contract Header" = RIMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Approved Purch. Price Aggreement';
                            Image = List;
                            RunObject = Page "E3 App. Rate Contract List";
                            RunPageMode = Create;
                            ToolTip = 'Executes the Approved Rate Contract Entries action.';
                        }
                        action("E3 Approved RC Dis. Details")
                        {
                            AccessByPermission = TableData "E3 RC Discount Header" = RIMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'Approved Disc. Price Aggreement';
                            Image = List;
                            RunObject = Page "E3 App. RC Discount List";
                            RunPageMode = View;
                            ToolTip = 'Executes the App. RC Discount List.';
                        }
                    }
                    group(RCLineList)
                    {
                        action("E3 Approved RC Price Details")
                        {
                            AccessByPermission = TableData "E3 Rate Contract Line" = RIMD;
                            ApplicationArea = Basic, Suite;
                            Caption = 'All Price Aggreement List';
                            Image = List;
                            RunObject = Page "E3 Rate Contract Line Lists";
                            RunPageMode = View;
                            ToolTip = 'Executes the RC All List.';
                        }
                    }
                }
                group(StockTransferSetup)
                {
                    Caption = 'Stock Transfer Setups';
                    action("Stock Transfer")
                    {
                        AccessByPermission = TableData "E3 Stock Transfer Setup" = RIMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Stock Transfer Setups';
                        Image = List;
                        RunObject = Page "E3 Stock Transfer List";
                        RunPageMode = View;
                        ToolTip = 'Executes the Stock Transfer Setup.';
                    }
                }
                group(Scheme)
                {
                    Caption = 'Scheme Type';
                    action("E3 Scheme Type")
                    {
                        AccessByPermission = TableData "E3 Scheme Type" = RIMD;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Scheme Type';
                        Image = List;
                        RunObject = Page "E3 Scheme Type";
                        RunPageMode = View;
                        ToolTip = 'Executes the Scheme Type List.';

                    }
                }
            }
        }
    }
}