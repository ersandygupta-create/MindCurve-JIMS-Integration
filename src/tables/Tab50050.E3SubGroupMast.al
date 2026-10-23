table 50050 "E3 Sub Group Master"
{
    DataPerCompany = false;
    LookupPageId = "E3 Sub Group Master";
    DrillDownPageId = "E3 Sub Group Master";

    fields
    {
        field(1; "Sub Code"; Code[20])
        {
            Caption = 'Sub Code';
            DataClassification = CustomerContent;
        }
        field(2; "Manual Code"; Text[10])
        {
            Caption = 'Manual Code';
            DataClassification = CustomerContent;
        }
        field(3; Initial; Text[20])
        {
            Caption = 'Initial';
            DataClassification = CustomerContent;
        }
        field(4; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(5; IsSent; Boolean)
        {
            Caption = 'IsSent';
            DataClassification = CustomerContent;
        }
        field(6; Response; Text[30])
        {
            Caption = 'Response';
            DataClassification = CustomerContent;
        }
        field(7; "Last Sent"; DateTime)
        {
            Caption = 'Last Sent';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Manual Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup is not configured for user %1.', UserId());

        if not UserSetup."Item Sub Table Insert" then
            Error(
                'You do not have permission to create a new Sub Group record. ' +
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
                'You do not have permission to modify an Sub Group record. ' +
                'Please contact your administrator.');
    end;
}

