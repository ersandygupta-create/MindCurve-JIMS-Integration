report 50018 "Vendor Payment Report"
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/reports/Rpt50018.VendorPaymentReport.rdl';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("Bal. Account Type" = FILTER(Vendor),
                                      "Cheque No." = FILTER(<> ''), Reversed = filter(false));
            RequestFilterFields = "Bank Account No.", "Cheque No.";

            column(txtCompanyName; txtCompanyName)
            {
            }
            column(CompAddress; CompAddress) { }
            column(BankAccountName; BankAccountName) { }
            column(ComBankAccNo; ComBankAccNo) { }
            column(CompPhoneNo; CompPhoneNo) { }
            column(CompEmail; CompEmail) { }
            column(VendorName; VendorName) { }
            column(VenBankAccNo; VenBankAccNo) { }
            column(VenBankName; VenBankName) { }
            column(VenBranch; VenBranch) { }
            column(VenIFSCCode; VenIFSCCode) { }
            column(Amount; Amount) { }
            column(AmountInWords; AmountText)
            {
            }
            column(TotalVendorAmount; TotalVendorAmount)
            {
            }
            column(VendorAmount; VendorAmount) { }
            column(ChequeNo; "Bank Account Ledger Entry"."Cheque No.")
            {
            }
            // column(StartDate; StartDate)
            // {
            // }
            // column(EndDate; EndDate)
            // {
            // }
            trigger OnAfterGetRecord()
            begin

                ChequeNo := "Bank Account Ledger Entry"."Cheque No.";

                VendorAmount := Abs("Bank Account Ledger Entry"."Amount (LCY)");

                TotalVendorAmount += VendorAmount;

                VenBankName := '';
                VenBankAccNo := '';
                VenIFSCCode := '';
                VenBankAdd := '';
                VenBankCity := '';
                VendMobile := '';
                VendorName := '';
                VendorBankAccount.RESET();
                VendorBankAccount.SETRANGE("Vendor No.", "Bank Account Ledger Entry"."Bal. Account No.");
                IF VendorBankAccount.FINDLAST() THEN BEGIN
                    VenBankName := VendorBankAccount.Name;
                    VenBankAccNo := VendorBankAccount."Bank Account No.";
                    VenIFSCCode := VendorBankAccount."E3 IFSC Code";
                    VenBankAdd := VendorBankAccount.Address + ' ' + VendorBankAccount."Address 2";
                    VenBankCity := VendorBankAccount.City;
                    VendorName1 := VendorBankAccount.Name;
                    VendMobile := VendorBankAccount."Phone No.";
                    VenBranch := VendorBankAccount."Branch Name";
                END;


                VendEmail := '';
                VendorName2 := '';
                Vendor.RESET;
                Vendor.SETRANGE("No.", "Bank Account Ledger Entry"."Bal. Account No.");
                IF Vendor.FINDFIRST THEN BEGIN
                    VendEmail := Vendor."E-Mail"; //Vendor."E-Mail";
                    VendorName := Vendor.Name;
                    VendorName2 := Vendor."Name 2";
                END;
            end;


            trigger OnPreDataItem()
            var
                BankLedgerEntry2: Record "Bank Account Ledger Entry";
            begin
                CompanyInformation.Get();

                Clear(TotalVendorAmount);
                Clear(AmountText);
                Clear(AmountInWords);

                // Copy the same filters applied to the report dataitem
                BankLedgerEntry2.CopyFilters("Bank Account Ledger Entry");

                if BankLedgerEntry2.FindSet() then
                    repeat
                        TotalVendorAmount += Abs(BankLedgerEntry2."Amount (LCY)");
                    until BankLedgerEntry2.Next() = 0;

                // Convert filtered total amount into words
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(AmountInWords, TotalVendorAmount, '');

                AmountText := AmountInWords[1];

                if AmountInWords[2] <> '' then
                    AmountText += ' ' + AmountInWords[2];
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                // field("Start Date"; StartDate)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Start Date field.';
                //     Caption = 'Start Date';
                // }
                // field("End Date"; EndDate)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the End Date field.';
                //     Caption = 'End Date';
                // }
                // field("Bank Account Code"; BankAccountCode)
                // {
                //     TableRelation = "Bank Account"."No.";
                //     ToolTip = 'Specifies the value of the Bank Account Code field.';
                //     Caption = 'Bank Account Code';
                //     ApplicationArea = All;

                // trigger OnLookup(var Text: Text): Boolean
                // var
                //     BankAccountList: Page 371;
                // begin
                //     BankAccount.RESET;
                //     BankAccount.SETFILTER(BankAccount."No.", BankAccountCode);
                //     IF BankAccount.FINDFIRST THEN BEGIN
                //         BankAccountList.LOOKUPMODE(TRUE);
                //         BankAccountList.SETTABLEVIEW(BankAccount);
                //         IF BankAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                //             BankAccountList.GETRECORD(BankAccount);
                //             BankAccountCode := BankAccount."No.";
                //             ComBankAccNo := BankAccount."Bank Account No.";
                //             BankAccountName := BankAccount.Name;
                //         END;
                //     END;
                // end;
                // }
                // field("Bank Account No."; ComBankAccNo)
                // {
                //     ToolTip = 'Specifies the value of the Bank Account No. field.';
                //     Caption = 'Bank Account No.';
                //     ApplicationArea = All;
                // }
                // field("Bank Account Name"; BankAccountName)
                // {
                //     ToolTip = 'Specifies the value of the Bank Account Name field.';
                //     Caption = 'Bank Account Name';
                //     ApplicationArea = All;
                // }
                field("Company Name"; txtCompanyName)
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    Caption = 'Company Name';
                    ApplicationArea = All;
                }
                field(ChequeNo; ChequeNo)
                {
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                    Caption = 'Cheque No';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CompanyInformation.GET;
            txtCompanyName := CompanyInformation.Name;
            CompAddress := CompanyInformation.Address + ' ' + CompanyInformation."Address 2";
            CompPhoneNo := CompanyInformation."Phone No.";
            CompEmail := CompanyInformation."E-Mail";
        end;
    }

    labels
    {
    }

    var
        CompanyInformation: Record 79;
        BankAccount: Record 270;
        BankAccountCode: Code[20];
        txtCompanyName: Text;
        // StartDate: Date;
        // EndDate: Date;
        BankAccountName: Text;
        VendorBankAccount: Record 288;
        VenBankName: Text[150];
        VenBankAccNo: Code[150];
        Vendor: Record 23;
        VenBankAdd: Text[150];
        VenIFSCCode: Code[150];
        VendMobile: Code[150];
        VendEmail: Text[150];
        VenBankCity: Text;
        ComBankAccNo: Text;
        VendorName: Text;
        VendorName1: Text;
        VendorName2: Text;
        VendorAmount: Decimal;
        BankDocNo: Code[20];
        ChequeNo: Text[20];
        VenBranch: Text[100];
        CompPhoneNo: Code[20];
        CompEmail: Text[100];
        TotalVendorAmount: Decimal;
        CheckReport: Report "Check Report";
        AmountInWords: array[2] of Text[250];
        AmountText: Text[250];
        CompAddress: Text[150];

}

