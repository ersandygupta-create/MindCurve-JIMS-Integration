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
                UpdateAllocationStatus();
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
        if "Receipt No." = '' then
            exit;

        if not OrganizationReceipt.Get("Receipt No.") then
            Error(
                'Organization Receipt %1 does not exist.',
                "Receipt No.");

        // Calculate the total allocated amount for this receipt.
        AllocationReceipt.Reset();
        AllocationReceipt.SetRange("Receipt No.", "Document No.");
        //AllocationReceipt.CalcSums("Allocated Amount");

        TotalAllocatedAmount :=
            AllocationReceipt."Allocated Amount" + "Allocated Amount";

        // Do not allow allocation above the received amount.
        if TotalAllocatedAmount > OrganizationReceipt."Received Amount" then
            Error(
                'Allocated Amount %1 exceeds the Received Amount %2 for Receipt No. %3.',
                TotalAllocatedAmount,
                OrganizationReceipt."Received Amount",
                "Receipt No.");

        // Update status in Organization Receipt.
        if TotalAllocatedAmount = OrganizationReceipt."Received Amount" then
            OrganizationReceipt."Allocation Status" :=
                OrganizationReceipt."Allocation Status"::"Fully Allocate"
        else
            OrganizationReceipt."Allocation Status" :=
                OrganizationReceipt."Allocation Status"::"Partial Allocate";

        OrganizationReceipt.Modify(true);
    end;
}