table 50034 "E3 Sub-Group Nature"
{
    DataPerCompany = false;
    DrillDownPageId = "E3 Sub Group Nature";
    LookupPageId = "E3 Sub Group Nature";

    fields
    {
        field(1; Code; Integer)
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (xRec.Code <> 0) and (Rec.Code <> xRec.Code) then
                    Error('Code cannot be modified once it has been assigned.');
            end;
        }
        field(2; Name; Text[60])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Manual Code"; Text[60])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(4; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(5; Response; Text[60])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(6; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }
        field(7; "First Sent"; Boolean)
        {
            Caption = 'First Sent';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        UserSetup: Record "User Setup";
    begin
        TestField(Name);
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Item Sub Table Insert" then
            Error(
                'You do not have permission to create a new Sub-Group Nature record. ' +
                'Please contact your administrator.');

    end;

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Item Sub Table Modify" then
            Error(
                'You do not have permission to modify an Sub-Group Nature record. ' +
                'Please contact your administrator.');
    end;


}

