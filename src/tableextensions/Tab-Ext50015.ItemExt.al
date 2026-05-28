tableextension 50015 "E3 HIS Item" extends Item
{
    fields
    {
        field(50000; "E3 HIS Type"; Enum "E3 HIS Type")
        {
            Caption = 'HIS Type';
            DataClassification = CustomerContent;
        }
        field(50001; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50002; Category; Code[20])
        {
            Caption = 'Category';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Category Master".Code;
        }
        field(50003; "Material Category"; Code[20])
        {
            Caption = 'Material Category';
            DataClassification = CustomerContent;
            TableRelation = "E3 Material Category Master".Code;
        }
        field(50004; Model; Code[20])
        {
            Caption = 'Model';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Model Master".Code;
        }
        field(50005; Strength; Code[20])
        {
            Caption = 'Strength';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Strength Master".Code;
        }
        field(50006; "Medicine Group"; Text[50])
        {
            Caption = 'Medicine Group';
            DataClassification = CustomerContent;
        }
        field(50007; "Rate Margin Fix"; Text[50])
        {
            Caption = 'Rate Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50008; "Medicine Manufacturer"; Text[50])
        {
            Caption = 'Medicine Manufacturer';
            DataClassification = CustomerContent;
        }
        field(50009; "Medicine Company"; Text[50])
        {
            Caption = 'Medicine Company';
            DataClassification = CustomerContent;
        }
    }
}
