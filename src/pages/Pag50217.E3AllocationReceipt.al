page 50217 "E3 Allocation Receipt List"
{
    Caption = 'Allocation Receipt List';
    PageType = ListPart;
    SourceTable = "E3 Allocation Receipt";
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;

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
                begin
                    GetOrganizationReceipt();
                end;
            }
        }
    }
    local procedure GetOrganizationReceipt()
    var
        OrgReceipt: Record "E3 Organization Receipt";
        GetOrgReceiptPage: Page "E3 Get Orgnization Receipt";
    begin
        OrgReceipt.Reset();

        if OrgReceipt.IsEmpty() then
            Error('No organization receipts are available.');

        GetOrgReceiptPage.SetTableView(OrgReceipt);
        GetOrgReceiptPage.LookupMode(true);

        if GetOrgReceiptPage.RunModal() = Action::LookupOK then begin
            GetOrgReceiptPage.SetSelectionFilter(OrgReceipt);

            if OrgReceipt.FindFirst() then begin
                // Create Allocation Receipt record if it does not exist
                if Rec."Entry No." = 0 then begin
                    Rec.Init();
                    Rec.Insert(true);
                end;

                // Update Allocation Receipt table
                Rec.Validate("Receipt No.", OrgReceipt."Document No.");
                Rec.Validate("Receipt Date", OrgReceipt."Document Date");
                Rec.Validate("Receipt Amount", OrgReceipt."Received Amount");
                Rec.Validate("HIS Document Type", OrgReceipt."HIS Document Type");
                Rec.Modify(true);

                // Update Organization Receipt status
                if OrgReceipt."Allocation Amount" = 0 then
                    OrgReceipt.Validate("Allocation Status", OrgReceipt."Allocation Status"::" ")
                else
                    if OrgReceipt."Allocation Amount" >= OrgReceipt."Received Amount" then
                        OrgReceipt.Validate(
                            "Allocation Status",
                            OrgReceipt."Allocation Status"::"Fully Allocate")
                    else
                        OrgReceipt.Validate(
                            "Allocation Status",
                            OrgReceipt."Allocation Status"::"Partial Allocate");

                OrgReceipt.Modify(true);

                CurrPage.Update(false);
            end;
        end;
    end;
}