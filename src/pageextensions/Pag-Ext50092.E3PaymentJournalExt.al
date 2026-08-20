pageextension 50092 "E3 Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addafter("P&osting")
        {
            action("Check Print H")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Check Print H';
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
            action("Axis Print Check")
            {
                ApplicationArea = All;
                Caption = 'Multiple Vendor Check Print A';
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Axis Bank Check_M", true, true, Rec);
                end;
            }

        }
    }
}
