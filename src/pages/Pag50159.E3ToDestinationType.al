page 50159 "E3 To Destination Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'To Destination Type';
    SourceTable = "E3 To Destination Type";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}