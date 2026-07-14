tableextension 50068 "E3 Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        field(50000; "Item Model Nos."; Code[20])
        {
            Caption = 'Item Model Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50001; "Item Strength Nos."; Code[20])
        {
            Caption = 'Item Strength Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50002; "Medicine SubCategory Nos."; Code[20])
        {
            Caption = 'Medicine SubCategory Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50003; "Item Category Nos."; Code[20])
        {
            Caption = 'Item Category Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50004; "Item Make Nos."; Code[20])
        {
            Caption = 'Item Make Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50005; "Medicine Company Nos."; Code[20])
        {
            Caption = 'Medicine Company Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50006; "Medicine Component Nos."; Code[20])
        {
            Caption = 'Medicine Component Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50007; "Item Speciality Nos."; Code[20])
        {
            Caption = 'Item Speciality Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50008; "Material Category Nos."; Code[20])
        {
            Caption = 'Material Category Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50009; "Material Type Nos."; Code[20])
        {
            Caption = 'Material Type Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

        field(50010; "Restricted Group Nos."; Code[20])
        {
            Caption = 'Restricted Group Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
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