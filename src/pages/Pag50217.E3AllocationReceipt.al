page 50217 "E3 Allocation Receipt List"
{
    Caption = 'Allocation Receipt List';
    PageType = ListPart;
    SourceTable = "E3 Allocation Receipt";
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt number.';
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt date.';
                }
                field("Receipt Amount"; Rec."Receipt Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt amount.';
                }
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HIS document type.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code.';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer code.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Allocated Amount"; Rec."Allocated Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the allocated amount.';
                    trigger OnValidate()
                    begin
                        CalculateBalanceAmount();
                    end;
                }
                field("Balance Amount"; BalanceAmt)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Balance Amount';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetData)
            {
                ApplicationArea = All;
                Caption = 'Get Data';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select an organization receipt and populate the allocation receipt line.';

                trigger OnAction()
                var
                    receiptNo: Code[50];
                begin
                    receiptNo := Rec.GetRangeMin("Receipt No.");
                    GetOrganizationReceipt(receiptNo);
                    CurrPage.Update(true);
                end;
            }
            action(SelectAllocation)
            {
                ApplicationArea = All;
                Caption = 'Select Allocation';
                Image = Checkmark;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Receipt No." = '' then
                        exit;

                    CurrPage.Update(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateBalanceAmount();
    end;

    trigger OnAfterGetCurrRecord()
    var
        OrgReceipt: Record "E3 Organization Receipt";
    begin
        CalculateBalanceAmount();

        if Rec."Receipt No." = '' then
            exit;

        OrgReceipt.Reset();
        OrgReceipt.SetRange("Document No.", Rec."Receipt No.");
        if OrgReceipt.Find('-') then begin
            if (OrgReceipt."Selected Allocation Entry No." <> Rec."Entry No.") or
               (OrgReceipt."Selected Customer Codecode" <> Rec."Customer Code") then begin
                OrgReceipt."Selected Allocation Entry No." := Rec."Entry No.";
                OrgReceipt."Selected Customer Codecode" := Rec."Customer Code";
                OrgReceipt.Modify(false);
            end;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CalculateBalanceAmount();
        CurrPage.Update(false);
    end;

    var
        BalanceAmt: Decimal;

    local procedure CalculateBalanceAmount()
    var
        BillApp: Record "E3 Bill Application";
        TotalReceived: Decimal;
    begin
        TotalReceived := 0;

        if (Rec."Receipt No." <> '') and (Rec."Customer Code" <> '') then begin
            BillApp.Reset();
            BillApp.SetRange("Receipt No.", Rec."Receipt No.");
            BillApp.SetRange("Customer Code", Rec."Customer Code");
            if BillApp.FindSet() then
                repeat
                    TotalReceived += BillApp."Payment Received";
                until BillApp.Next() = 0;
        end;

        BalanceAmt := Rec."Allocated Amount" - TotalReceived;
    end;

    local procedure GetOrganizationReceipt(ReceiptNo: Code[50])
    var
        OrgReceipt: Record "E3 Organization Receipt";
        GetOrgReceiptPage: Page "E3 Get Orgnization Receipt";
        AllocationReceipt: Record "E3 Allocation Receipt";
    begin
        OrgReceipt.Reset();
        OrgReceipt.SetRange("Document No.", ReceiptNo);
        OrgReceipt.SetFilter(Balance, '<>%1', 0);

        if OrgReceipt.IsEmpty() then
            Error('No organization receipts are available.');

        GetOrgReceiptPage.SetTableView(OrgReceipt);
        GetOrgReceiptPage.LookupMode(true);

        if GetOrgReceiptPage.RunModal() = Action::LookupOK then begin
            GetOrgReceiptPage.SetSelectionFilter(OrgReceipt);

            if OrgReceipt.FindFirst() then begin
                AllocationReceipt.Init();
                AllocationReceipt.Validate("Receipt No.", OrgReceipt."Document No.");
                AllocationReceipt.Validate("Receipt Date", OrgReceipt."Document Date");
                AllocationReceipt.Validate("Receipt Amount", OrgReceipt."Received Amount");
                AllocationReceipt.Validate("HIS Document Type", format(OrgReceipt."HIS Document Type"));
                AllocationReceipt.Validate("Shortcut Dimension 1 Code", OrgReceipt."Shortcut Dimension 1 Code");
                AllocationReceipt.Insert(true);
            end;
        end;
    end;

    procedure GetSelectedCustomerCode(): Code[20]
    begin
        exit(Rec."Customer Code");
    end;

    procedure RefreshData()
    begin
        CalculateBalanceAmount();
        CurrPage.Update(false);
    end;
}