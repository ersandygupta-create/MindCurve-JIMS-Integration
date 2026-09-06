page 50197 "E3 Stock Consumption Card"
{
    Caption = 'Stock Consumption Card';
    SourceTable = "E3 Stock Consumption Header";
    ApplicationArea = All;
    PageType = Document;
    DelayedInsert = true;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type of the stock consumption.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number.';
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the stock consumption entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
                }
            }
            part(Lines; "E3 Stock Consumption Line")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = field("Document No."), "Entry Type" = field("Entry Type");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateItemJournal)
            {
                Caption = 'Create Item Journal';
                ApplicationArea = All;
                Image = CreateLines;
                ToolTip = 'Creates Item Journal Lines from the Stock Consumption Lines.';

                trigger OnAction()
                var
                    E3PostStockConsumption: Codeunit "E3 Post Stock Consumption";
                begin
                    E3PostStockConsumption.CreateItemJournal(Rec);
                    Rec.Posted := true;
                    Rec.Modify(true);
                    Message(
                        'Item Journal has been created for Stock Consumption Document %1.',
                        Rec."Document No.");
                end;
            }
            action(PostItemJournal)
            {
                Caption = 'Post Item Journal';
                ApplicationArea = All;
                Image = Post;

                ToolTip = 'Posts the Item Journal created for the Stock Consumption Document.';

                trigger OnAction()
                var
                    E3PostStockConsumption: Codeunit "E3 Post Stock Consumption";
                begin
                    //E3PostStockConsumption.PostItemJournal(Rec);

                    Message(
                        'Item Journal has been posted for Stock Consumption Document %1.',
                        Rec."Document No.");
                end;
            }
        }
    }
}