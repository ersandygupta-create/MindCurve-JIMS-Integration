
page 50259 "E3 Cancel Indent Dialog"
{
    PageType = StandardDialog;
    Caption = 'Cancel Indent';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Cancellation Details';

                field(CancelReason; CancelReason)
                {
                    ApplicationArea = All;
                    Caption = 'Cancellation Reason';
                    ToolTip = 'Enter the reason for cancelling the selected indent lines.';
                    MultiLine = true;
                    ShowMandatory = true;
                }
            }
        }
    }

    var
        CancelReason: Text[250];

    procedure GetCancelReason(): Text[250]
    begin
        exit(CancelReason);
    end;
}
