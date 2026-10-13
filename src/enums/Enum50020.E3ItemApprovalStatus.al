enum 50020 "E3 Approval Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "Created") { Caption = 'Created'; }
    value(1; "Open") { Caption = 'Open'; }
    value(2; "Canceled") { Caption = 'Canceled'; }
    value(3; "Rejected") { Caption = 'Rejected'; }
    value(4; "Approved") { Caption = 'Approved'; }
    value(5; " ") { Caption = ' '; }
    value(6; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
}