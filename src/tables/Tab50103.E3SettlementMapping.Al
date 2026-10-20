table 50103 "E3 Settlement Mapping Setup"
{
    Caption = 'Settlement Mapping Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }

        // 1. Disallowed Reg. Wise G/L Account Mapping
        field(2; "Disallowed Reg. Wise Account"; Code[20])
        {
            Caption = 'Disallowed Reg. Wise Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }

        // 2. Disallowed Billable G/L Account Mapping
        field(3; "Disallowed Billable Account"; Code[20])
        {
            Caption = 'Disallowed Billable Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }

        // 3. Disallowed Security G/L Account Mapping
        field(4; "Disallowed Security Account"; Code[20])
        {
            Caption = 'Disallowed Security Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }

        // 4. TDS Amount G/L Account Mapping
        field(5; "TDS Account No."; Code[20])
        {
            Caption = 'TDS Account No.';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }

        // 5. Default Customer Code (CU00008) Mapping
        field(6; "TPA Account"; Code[20])
        {
            Caption = 'TPA Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }

        // 6. Excess Billable Account Mapping
        field(7; "Excess Billable Account"; Code[20])
        {
            Caption = 'Excess Billable Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Ensures a single instance of the setup record exists (Singleton pattern).
    /// </summary>
    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            "Primary Key" := '';
            Insert(true);
        end;
    end;
}