table 50085 "E3 Bill Application"
{
    Caption = 'Bill Application';
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
        field(2; "Bill No"; Code[50])
        {
            Caption = 'Bill No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateMedPRF();
            end;
        }
        field(3; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            DataClassification = CustomerContent;
        }
        field(4; "Patient Name"; Text[100])
        {
            Caption = 'Patient Name';
            DataClassification = CustomerContent;
        }
        field(5; "UHIDNo"; Code[50])
        {
            Caption = 'UHID No.';
            DataClassification = CustomerContent;
        }
        field(6; "Bill Amount"; Decimal)
        {
            Caption = 'Bill Amount';
            DataClassification = CustomerContent;
        }
        field(7; "Payment Received"; Decimal)
        {
            Caption = 'Payment Received';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidatePaymentReceived();
                CalculateTPAAmounts();
            end;
        }
        field(8; "Disallowed Reg. Wise"; Decimal)
        {
            Caption = 'Disallowed Reg. Wise';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateTPAAmounts();
            end;
        }
        field(9; "Disallowed Billable"; Decimal)
        {
            Caption = 'Disallowed Billable';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateTPAAmounts();
            end;
        }
        field(10; "Disallowed Security"; Decimal)
        {
            Caption = 'Disallowed Security';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateTPAAmounts();
            end;
        }
        field(11; "TDS Amount"; Decimal)
        {
            Caption = 'TDS Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateTPAAmounts();
            end;
        }
        field(12; "Total Received From TPA"; Decimal)
        {
            Caption = 'Total Received From TPA';
            DataClassification = CustomerContent;
        }
        field(13; "Excess Billable"; Decimal)
        {
            Caption = 'Excess Billable';
            DataClassification = CustomerContent;
        }
        field(14; "Med PRF"; Decimal)
        {
            Caption = 'Med PRF';
            DataClassification = CustomerContent;
        }
        field(15; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(16; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Organization Receipt";
        }
        field(17; "Receipt No."; Code[50])
        {
            Caption = 'Receipt No.';
            DataClassification = CustomerContent;
        }
        field(18; "Customer Name"; Text[100])
        {
            Caption = 'Customer';
            DataClassification = CustomerContent;
        }
        field(19; "InterCompany"; Text[100])
        {
            Caption = 'InterCompany';
            DataClassification = CustomerContent;
        }
        field(20; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(21; "Allocation Receipt Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(22; "JV Created"; Boolean)
        {
            Caption = 'JV Created';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")

        {
            Clustered = true;
        }
    }
    local procedure ValidatePaymentReceived()
    var
        AllocationReceipt: Record "E3 Allocation Receipt";
        BillApplication: Record "E3 Bill Application";
        TotalPaymentReceived: Decimal;
        AvailableAmount: Decimal;
    begin
        if "Payment Received" < 0 then
            Error('Payment Received cannot be negative.');

        if "Payment Received" = 0 then
            exit;

        if "Receipt No." = '' then
            Error('Please enter Receipt No. before entering Payment Received.');

        if "Customer Code" = '' then
            Error('Please enter Customer Code before entering Payment Received.');

        // Find the matching allocation receipt.
        AllocationReceipt.Reset();
        AllocationReceipt.SetRange("Receipt No.", "Receipt No.");
        AllocationReceipt.SetRange("Customer Code", "Customer Code");
        //AllocationReceipt.SetRange("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");

        if not AllocationReceipt.FindFirst() then
            Error(
                'Receipt Amount not found for Receipt No. %1, Customer Code %2',
                "Receipt No.", "Customer Code");//,
                                                //"Shortcut Dimension 1 Code");

        // Calculate payments already allocated to other bills.
        BillApplication.Reset();
        BillApplication.SetRange("Receipt No.", "Receipt No.");
        BillApplication.SetRange("Customer Code", "Customer Code");
        //BillApplication.SetRange("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
        //BillApplication.SetFilter("Entry No.", '<>%1', "Entry No.");

        if BillApplication.FindSet() then
            repeat
                TotalPaymentReceived += BillApplication."Payment Received";
            until BillApplication.Next() = 0;

        AvailableAmount :=
            AllocationReceipt."Receipt Amount" - TotalPaymentReceived;

        if "Payment Received" > AvailableAmount then
            Error(
                'Payment Received %1 exceeds the available receipt amount %2 for Receipt No. %3. Already allocated: %4.',
                "Payment Received",
                AvailableAmount,
                "Receipt No.",
                TotalPaymentReceived);
    end;

    local procedure CalculateTPAAmounts()
    begin
        "Total Received From TPA" :=
            "Payment Received" +
            "Disallowed Reg. Wise" +
            "Disallowed Billable" +
            "Disallowed Security" +
            "TDS Amount";

        if "Total Received From TPA" > "Bill Amount" then
            "Excess Billable" :=
                "Total Received From TPA" - "Bill Amount"
        else
            "Excess Billable" := 0;
    end;

    local procedure CalculateMedPRF()
    var
        RevenueLine: Record "E3 HIS Revenue Line";
        MedPRFCode: Record "E3 MED PRF";
    begin
        "Med PRF" := 0;

        RevenueLine.Reset();
        RevenueLine.SetRange("Document No.", "Bill No");

        if RevenueLine.FindSet() then
            repeat
                MedPRFCode.Reset();
                MedPRFCode.SetRange(Code, RevenueLine."Service Item Code");

                if MedPRFCode.FindFirst() then
                    "Med PRF" += RevenueLine.Amount;
            until RevenueLine.Next() = 0;
    end;
}