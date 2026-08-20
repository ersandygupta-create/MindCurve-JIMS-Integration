page 50195 "E3 HIS G/L Account Mapping"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Revenue HIS Doc. Type Setup";
    Caption = 'HIS G/L Account Mapping';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the G/L account mapping.';
                }
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HIS document type for the G/L account mapping.';
                }
                field("Cash/Patient Payable"; Rec."Cash/Patient Payable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account used for cash or patient payable transactions.';
                }
                field("Cash/Patient Payable Name"; Rec."Cash/Patient Payable Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the selected cash or patient payable G/L account.';
                }
            }
        }
    }
}