tableextension 50067 "E3 Purchase & Payable Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Bank File Series"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank File Series';
            TableRelation = "No. Series";
        }
        field(50001; "Gate Entry Nos."; Code[20])
        {
            Caption = 'Gate Entry Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50002; "E3 Order Address Number"; code[10])
        {
            Caption = 'Order Address No Series';
            TableRelation = "No. Series".Code;
        }


    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}