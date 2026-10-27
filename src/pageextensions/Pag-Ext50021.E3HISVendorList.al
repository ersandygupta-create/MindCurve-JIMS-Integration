pageextension 50021 "E3 HIS Vendor List" extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field("P.A.N. No."; Rec."P.A.N. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the P.A.N. No. field.';
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GST Registration No. field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the record is open, waiting to be approved, or released to the next stage of processing.';
            }
        }
    }
}
