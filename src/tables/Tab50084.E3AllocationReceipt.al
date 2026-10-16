table 50084 "E3 Allocation Receipt"
{
    Caption = 'Allocation Receipt';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(2; "HIS Document Type"; Text[50])
        {
            Caption = 'HIS Document Type';
            DataClassification = CustomerContent;
        }
        field(3; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            trigger OnValidate()
            var
                CustomerRec: Record Customer;
            begin
                if "Customer Code" <> '' then begin
                    if CustomerRec.Get("Customer Code") then
                        "Customer Name" := CustomerRec.Name;
                end else
                    Clear("Customer Name");
            end;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer';
            DataClassification = CustomerContent;
        }
        field(5; "Receipt No."; Code[50])
        {
            Caption = 'Receipt No.';
            DataClassification = CustomerContent;
        }
        field(6; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
            DataClassification = CustomerContent;
        }
        field(7; "Receipt Amount"; Decimal)
        {
            Caption = 'Receipt Amount';
            DataClassification = CustomerContent;
        }
        field(8; "Allocated Amount"; Decimal)
        {
            Caption = 'Allocated Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //  UpdateAllocationStatus();
                checkAllocationLimit();
                updateAllocatedAmount(Rec."Receipt No.");
            end;
        }
        field(9; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Organization Receipt";
        }
        field(10; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.", "Customer Code")
        {
            Clustered = true;
        }
    }

    local procedure UpdateAllocationStatus()
    var
        OrganizationReceipt: Record "E3 Organization Receipt";
        AllocationReceipt: Record "E3 Allocation Receipt";
        TotalAllocatedAmount: Decimal;
    begin
        if "Document No." = '' then
            exit;

        // Find Organization Receipt by Document No.
        OrganizationReceipt.Reset();
        OrganizationReceipt.SetRange("Document No.", "Document No.");

        if not OrganizationReceipt.FindFirst() then
            Error(
                'Organization Receipt with Document No. %1 does not exist.',
                "Document No.");

        // Sum allocations for this organization receipt.
        AllocationReceipt.Reset();
        AllocationReceipt.SetRange("Document No.", "Document No.");
        AllocationReceipt.SetFilter("Entry No.", '<>%1', "Entry No.");
        AllocationReceipt.CalcSums("Allocated Amount");

        TotalAllocatedAmount :=
            AllocationReceipt."Allocated Amount" + "Allocated Amount";

        // Do not allow allocation above the received amount.
        if TotalAllocatedAmount > OrganizationReceipt."Received Amount" then
            Error(
                'Total Allocated Amount %1 exceeds Received Amount %2 for Document No. %3.',
                TotalAllocatedAmount,
                OrganizationReceipt."Received Amount",
                "Document No.");

        // Update allocation status.
        if TotalAllocatedAmount = OrganizationReceipt."Received Amount" then
            OrganizationReceipt."Allocation Status" :=
                OrganizationReceipt."Allocation Status"::"Fully Allocate"
        else
            OrganizationReceipt."Allocation Status" :=
                OrganizationReceipt."Allocation Status"::"Partial Allocate";

        OrganizationReceipt.Modify(true);
    end;

    local procedure updateAllocatedAmount(receiptNo: code[50])
    var
        AllocationReceipt: Record "E3 Allocation Receipt";
        OrgReceipt: Record "E3 Organization Receipt";
        AllocatedAmt: Decimal;
    begin
        AllocatedAmt := 0;
        AllocationReceipt.Reset();
        AllocationReceipt.SetRange("Receipt No.", receiptNo);
        if AllocationReceipt.FindSet() then
            repeat
                if AllocationReceipt."Entry No." = Rec."Entry No." then
                    AllocatedAmt += Rec."Allocated Amount"
                else
                    AllocatedAmt += AllocationReceipt."Allocated Amount";
            until AllocationReceipt.Next() = 0;

        OrgReceipt.Reset();
        OrgReceipt.SetRange("Document No.", receiptNo);
        if OrgReceipt.Find('-') then begin
            OrgReceipt."Allocation Amount" := AllocatedAmt;
            OrgReceipt.Balance := OrgReceipt."Received Amount" - OrgReceipt."Allocation Amount";
            if (OrgReceipt.Balance = 0) then
                OrgReceipt."Allocation Status" := "E3 Allocation Status"::"Fully Allocate"
            else
                OrgReceipt."Allocation Status" := "E3 Allocation Status"::"Partial Allocate";
            OrgReceipt.Modify(false);
            //CurrPage.Update(false);
        end;
    end;

    local procedure checkAllocationLimit()
    var
        OrgReceipt: Record "E3 Organization Receipt";
    begin
        OrgReceipt.Reset();
        ;
        OrgReceipt.SetRange("Document No.", rec."Receipt No.");
        if OrgReceipt.FindFirst() then
            if (OrgReceipt.Balance < rec."Allocated Amount") then
                Error('Amount can not be greater than %1 .', OrgReceipt.Balance);

    end;

}