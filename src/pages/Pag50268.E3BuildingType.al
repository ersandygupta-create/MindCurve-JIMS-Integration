page 50268 "E3 Building Type List"
{
    Caption = 'Building Type List';
    PageType = List;
    SourceTable = "E3 Building Type";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the building code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the building description.';
                }
            }
        }
    }
}