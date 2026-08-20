pageextension 50024 "E3 Purch. Comment Line Ext" extends "Purch. Comment Sheet"
{
    DeleteAllowed = false;
    layout
    {
        modify(Date)
        {
            Editable = false;
        }
        addafter(Date)
        {
            field("Order Terms"; Rec."Order Terms")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Order Terms field.';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("Get Default Terms")
            {
                Caption = 'Get Default Terms';
                Image = GetLines;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copies all active Order Terms & Conditions into the Purchase Comment Sheet.';

                trigger OnAction()
                var
                    OrderTerms: Record "E3 Order Terms & Conditions";
                    PurchCommentLine: Record "Purch. Comment Line";
                    NextLineNo: Integer;
                begin
                    Rec.TestField("Document Type");
                    Rec.TestField("No.");

                    PurchCommentLine.Reset();
                    PurchCommentLine.SetRange("Document Type", Rec."Document Type");
                    PurchCommentLine.SetRange("No.", Rec."No.");

                    if PurchCommentLine.FindLast() then
                        NextLineNo := PurchCommentLine."Line No." + 10000
                    else
                        NextLineNo := 10000;

                    OrderTerms.Reset();
                    OrderTerms.SetRange(Active, true);

                    if not OrderTerms.FindSet() then
                        Error('No active Order Terms & Conditions are available.');

                    repeat
                        PurchCommentLine.Init();
                        PurchCommentLine.Validate("Document Type", Rec."Document Type");
                        PurchCommentLine.Validate("No.", Rec."No.");
                        PurchCommentLine."Document Line No." := 0;
                        PurchCommentLine."Line No." := NextLineNo;
                        PurchCommentLine.Validate(Date, Today);

                        PurchCommentLine."Order Terms" := OrderTerms.Description;
                        PurchCommentLine.Comment := OrderTerms."Default Value";

                        PurchCommentLine.Insert(true);

                        NextLineNo += 10000;
                    until OrderTerms.Next() = 0;

                    CurrPage.Update(true);
                    Message('Default Order Terms & Conditions inserted successfully.');
                end;
            }
        }
    }
}