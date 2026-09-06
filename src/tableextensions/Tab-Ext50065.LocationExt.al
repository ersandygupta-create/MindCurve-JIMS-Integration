tableextension 50065 "E3 Location" extends Location
{
    fields
    {
        field(50000; "Invoice Bank"; Code[20])
        {
            Caption = 'Invoice Bank';
            TableRelation = "Bank Account";
            DataClassification = CustomerContent;
        }
        field(50001; "W/S DL No."; Text[60])
        {
            Caption = 'W/S DL No.';
            DataClassification = CustomerContent;
        }

        field(50002; "Retail DL No."; Text[60])
        {
            Caption = 'Retail DL No.';
            DataClassification = CustomerContent;
        }
        field(50003; "E3 Indent PO Series"; Code[20])
        {
            Caption = 'Indent PO Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50004; "GST Credit"; enum "GST Credit")
        {
            Caption = 'GST Credit';
            DataClassification = CustomerContent;
        }
        field(50005; "InterCompany Nos."; Code[20])
        {
            Caption = 'InterCompany Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50006; "InterUnit Nos."; Code[20])
        {
            Caption = 'InterUnit Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50007; "Name 3"; Text[100])
        {
            Caption = 'Name 3';
            DataClassification = CustomerContent;
        }
        field(50008; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
            TableRelation = "Gen. Business Posting Group";
        }
    }
}