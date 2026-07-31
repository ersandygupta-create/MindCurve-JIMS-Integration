table 50054 "E3 HSN/SAC Log"
{
    Caption = 'HSN/SAC Log';
    DataCaptionFields = "GST Group Code", Code;
    LookupPageId = "HSN/SAC";
    DrillDownPageId = "HSN/SAC";

    fields
    {
        field(1; "GST Group Code"; Code[10])
        {
            Caption = 'GST Group Code';
            NotBlank = true;
            DataClassification = CustomerContent;
            TableRelation = "GST Group";
        }
        field(2; "Code"; code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(3; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "Type"; enum "GST Goods And Services Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(5; "Sync Status"; Option)
        {
            Caption = 'Sync Status';
            OptionMembers = " ",Synced,Error;
            OptionCaption = ' ,Synced,Error';
        }
        field(6; "Error Message"; Text[100])
        {
            Caption = 'Error Message';
        }
        field(50000; GLEN; Enum "E3 GLEN Type")
        {
            Caption = 'GLEN';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "GST Group Code", Code)
        {
            Clustered = true;
        }
    }
}