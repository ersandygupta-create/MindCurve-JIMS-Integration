table 50053 "E3 State Master Log"
{
    Caption = 'State';
    DataClassification = EndUserIdentifiableInformation;
    DrillDownPageId = "E3 State Master Log";
    LookupPageId = "E3 State Master Log";
    Access = Public;
    Extensible = true;

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; Description; Text[50])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; "Sync Status"; Option)
        {
            Caption = 'Sync Status';
            OptionMembers = " ",Synced,Error;
            OptionCaption = ' ,Synced,Error';
        }
        field(4; "Error Message"; Text[100])
        {
            Caption = 'Error Message';
        }
        field(5; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
            DataClassification = CustomerContent;
        }
        field(6; "Processed Date Time"; DateTime)
        {
            Caption = 'Processed Date Time';
            DataClassification = CustomerContent;
        }
        field(18000; "State Code (GST Reg. No.)"; code[10])
        {
            Caption = 'State Code (GST Reg. No.)';
            DataClassification = CustomerContent;
            Numeric = true;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
