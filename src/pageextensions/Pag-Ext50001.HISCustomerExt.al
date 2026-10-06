pageextension 50001 "E3 HIS Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("E3 HIS Code"; Rec."E3 HIS Code")
            {
                ApplicationArea = All;
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("DL No."; Rec."DL No.")
            {
                ApplicationArea = All;
                toolTip = 'Specifies the value of the DL No. field';
            }
        }
    }

    actions
    {
        addafter("Sent Emails")
        {
            action("Customer Ledger Report")
            {
                ApplicationArea = All;
                Caption = 'Customer Ledger Report';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Report;
                trigger OnAction()
                begin
                    recCustomer.Reset();
                    recCustomer.SetRange("No.", Rec."No.");
                    //REPORT.RUNMODAL(Report::"Customer Ledger Report", TRUE, TRUE, recCustomer);

                end;
            }
        }


    }
    var
        recCustomer: Record Customer;

}