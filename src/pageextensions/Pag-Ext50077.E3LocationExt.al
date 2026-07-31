pageextension 50077 "E3 Location Extension" extends "Location Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Caption = 'Name 2';
            }
            field("W/S DL No."; Rec."W/S DL No.")
            {
                ApplicationArea = All;
            }

            field("Retail DL No."; Rec."Retail DL No.")
            {
                ApplicationArea = All;
            }
        }
        addlast(content)
        {
            group(NoSeries)
            {
                field("E3 Indent PO Series"; Rec."E3 Indent PO Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E3 Indent PO Series field.';
                }
                field("GST Credit"; Rec."GST Credit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GST Credit field.';
                }
            }
        }
    }
}