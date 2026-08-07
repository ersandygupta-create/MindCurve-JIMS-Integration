page 50179 "E3 Margin Type"
{
    PageType = List;
    SourceTable = "E3 Margin Type";
    Caption = 'Margin Type';
    ApplicationArea = All;
    UsageCategory = Lists;
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
                    ToolTip = 'Specifies the unique margin type code.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the margin type.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Open Item Margin")
            {
                ApplicationArea = All;
                Caption = 'Open Item Margin';
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                //RunObject = Page "E3 Item Margin List";
                ToolTip = 'Opens the Item Margin page.';
                trigger OnAction()
                var
                    ItemMargin: Record "E3 Item Margin";
                    ItemMarginPage: Page "E3 Item Margin List";
                begin
                    ItemMargin.Reset();
                    ItemMargin.SetRange("Margin Code", Rec.Code);
                    ItemMarginPage.SetTableView(ItemMargin);
                    ItemMarginPage.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}