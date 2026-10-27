page 50270 "E3 Custodian Type List"
{
    Caption = 'Custodian Type List';
    PageType = List;
    SourceTable = "E3 Custodian Type";
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
                    ToolTip = 'Specifies the custodian code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the custodian description.';
                }
                field("Name (Head of Department)"; Rec."Name (Head of Department)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the head of department.';
                }
            }
        }
    }
}