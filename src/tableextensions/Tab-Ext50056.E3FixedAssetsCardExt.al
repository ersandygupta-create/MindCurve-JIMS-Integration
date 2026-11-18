tableextension 50056 "E3 HIS Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Model No."; Text[50])
        {
            Caption = 'Model No.';
            DataClassification = CustomerContent;
        }
        field(50001; "QR Code"; Media)
        {
            Caption = 'QR Code';
        }
        field(50002; "Building Code"; Code[20])
        {
            Caption = 'Building Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Building Type".Code;
            trigger OnValidate()
            var
                BuildingType: Record "E3 Building Type";
            begin
                Rec."Building Name" := '';

                if Rec."Building Code" <> '' then
                    if BuildingType.Get(Rec."Building Code") then
                        Rec."Building Name" := BuildingType.Description;
            end;
        }
        field(50003; "Room/Ward No."; Code[20])
        {
            Caption = 'Room/Ward No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Room/Ward Type".Code;
            trigger OnValidate()
            var
                RoomWardType: Record "E3 Room/Ward Type";
            begin
                Rec."Room/Ward Name" := '';

                if Rec."Room/Ward No." <> '' then
                    if RoomWardType.Get(Rec."Room/Ward No.") then
                        Rec."Room/Ward Name" := RoomWardType.Description;
            end;
        }
        field(50004; "Custodian ID"; Code[20])
        {
            Caption = 'Custodian ID';
            DataClassification = CustomerContent;
            TableRelation = "E3 Custodian Type".Code;

            trigger OnValidate()
            var
                CustodianType: Record "E3 Custodian Type";
            begin
                "Custodian Name" := '';

                if "Custodian ID" <> '' then
                    if CustodianType.Get("Custodian ID") then
                        "Custodian Name" := CustodianType."Name (Head of Department)";
                "Name (Head of Department)" := CustodianType."Name (Head of Department)";
            end;
        }
        field(50005; "Custodian Name"; Text[100])
        {
            Caption = 'Custodian Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50006; "Name (Head of Department)"; Text[100])
        {
            Caption = 'Name (Head of Department)';
            DataClassification = CustomerContent;
        }
        field(50007; "Building Name"; Text[100])
        {
            Caption = 'Building Name';
            DataClassification = CustomerContent;
        }
        field(50008; "Room/Ward Name"; Text[100])
        {
            Caption = 'Room/Ward Name';
            DataClassification = CustomerContent;
        }
        field(50009; "Sub Location"; Text[100])
        {
            Caption = 'Sub Location';
            DataClassification = CustomerContent;
        }
        field(50010; "Assets Name"; Text[200])
        {
            Caption = 'Assets Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Asset Item Group"; Code[20])
        {
            Caption = 'Asset Item Group';
            DataClassification = CustomerContent;
            TableRelation = "E3 Asset Item Group".Code;
        }
        field(50012; "Asset Item Category"; Code[20])
        {
            Caption = 'Asset Item Category';
            DataClassification = CustomerContent;

            TableRelation = "E3 Asset Item Category".Code
                where("Asset Item Group" = field("Asset Item Group"));
        }
        field(50013; "Asset Item Name Group"; Code[20])
        {
            Caption = 'Asset Item Name Group';
            DataClassification = CustomerContent;

            TableRelation = "E3 Asset Item Name Group".Code
                where(
                    "Asset Item Category" = field("Asset Item Category"));
        }
        field(50014; "Asset Item Sub Group"; Code[20])
        {
            Caption = 'Asset Item Sub Group';
            DataClassification = CustomerContent;

            TableRelation = "E3 Asset Item Sub Group".Code
                where(
                    "Asset Item Name Group" = field("Asset Item Name Group"));
        }
    }
    trigger OnBeforeRename()
    begin
        if (Rec."No." <> xRec."No.") and (xRec."No." <> '') then
            Error('You cannot modify the FA No.');
    end;
}
