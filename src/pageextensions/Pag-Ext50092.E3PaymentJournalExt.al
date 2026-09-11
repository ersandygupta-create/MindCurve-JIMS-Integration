pageextension 50092 "E3 Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addafter("P&osting")
        {
            action("HDFC Check Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'HDFC Check Print';
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SaveRecord();

                    GenJournalLine.Reset();
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    //GenJournalLine.SetRange("Line No.", Rec."Line No.");

                    Report.RunModal(Report::"Bank Check H", true, true, GenJournalLine);
                end;
            }
            action("SBI Check Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'SBI Check Print';
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SaveRecord();

                    GenJournalLine.Reset();
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    //GenJournalLine.SetRange("Line No.", Rec."Line No.");

                    Report.RunModal(Report::"SBI Bank Check Print", true, true, GenJournalLine);
                end;
            }
            action("Induslnd Check Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Induslnd Check Print';
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SaveRecord();

                    GenJournalLine.Reset();
                    GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    //GenJournalLine.SetRange("Line No.", Rec."Line No.");

                    Report.RunModal(Report::"Induslnd Bank Check Print", true, true, GenJournalLine);
                end;
            }
            action("Axis Print Check")
            {
                ApplicationArea = All;
                Caption = 'Axis Check Print';
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Axis Bank Check Print", true, true, Rec);
                end;
            }

        }
    }
}
