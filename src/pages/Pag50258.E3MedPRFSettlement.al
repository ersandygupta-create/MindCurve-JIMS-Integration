page 50258 "E3 Med PRF List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Med PRF";
    Caption = 'Med PRF List';
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
                    ToolTip = 'Specifies the Med PRF code.';
                    Caption = 'Code';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the Med PRF.';
                    Caption = 'Description';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditList)
            {
                ApplicationArea = All;
                Caption = 'Edit List';
                Image = Edit;
                ToolTip = 'Edit the Med PRF records.';

                trigger OnAction()
                begin
                    CurrPage.Editable := true;
                end;
            }
        }
    }
}