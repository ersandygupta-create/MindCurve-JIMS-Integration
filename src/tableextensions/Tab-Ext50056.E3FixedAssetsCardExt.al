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
        }
        field(50003; "Room/Ward No."; Code[20])
        {
            Caption = 'Room/Ward No.';
            DataClassification = CustomerContent;
            TableRelation = "E3 Room/Ward Type".Code;
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
    }
    trigger OnBeforeRename()
    begin
        if (Rec."No." <> xRec."No.") and (xRec."No." <> '') then
            Error('You cannot modify the FA No.');
    end;

}
