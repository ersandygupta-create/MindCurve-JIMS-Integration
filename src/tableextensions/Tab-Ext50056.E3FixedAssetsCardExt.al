tableextension 50056 "E3 HIS Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateAssetsName();
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateAssetsName();
            end;
        }
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
            trigger OnValidate()
            begin
                UpdateAssetsName();
            end;
        }
        field(50010; "Assets Name"; Text[200])
        {
            Caption = 'Assets Name';
            DataClassification = CustomerContent;
        }
        field(50011; "Asset Item Group"; Code[20])
        {
            Caption = 'Asset Item Group';
            TableRelation = "E3 Asset Item Group".Code;
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeRename()
    begin
        if (Rec."No." <> xRec."No.") and (xRec."No." <> '') then
            Error('You cannot modify the FA No.');
    end;

    local procedure UpdateAssetsName()
    var
        AssetsName: Text[200];
    begin
        AssetsName :=
            Rec."Global Dimension 1 Code" + '/' +
            Rec."Sub Location" + '/' +
            //Rec."Assets Category Code" + '/' +
            Rec."No." + '/' +
            GetFinancialYear();

        Rec."Assets Name" :=
            CopyStr(AssetsName, 1, MaxStrLen(Rec."Assets Name"));
    end;

    local procedure GetFinancialYear(): Text[10]
    var
        StartYear: Integer;
        EndYear: Integer;
        CurrentDate: Date;
    begin
        CurrentDate := WorkDate();

        if Date2DMY(CurrentDate, 2) >= 4 then
            StartYear := Date2DMY(CurrentDate, 3)
        else
            StartYear := Date2DMY(CurrentDate, 3) - 1;

        EndYear := StartYear + 1;

        exit(
            CopyStr(
                Format(StartYear) + '-' + CopyStr(Format(EndYear), 3, 2),
                1, 10));
    end;

}
