page 50277 "E3 Asset Item Group List"
{
    PageType = List;
    SourceTable = "E3 Asset Item Group";
    Caption = 'Asset Item Groups';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Asset Item Group";

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