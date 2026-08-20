page 50204 "E3 Scheme Type"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "E3 Scheme Type";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Scheme; Rec.Scheme)
                {
                    ApplicationArea = All;
                }
                field("Free Qty"; Rec."Free Qty")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}