pageextension 50102 E3PaymentJournal extends 256
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Purchase Order No.';
                Caption = 'Purchase Order No.';
            }
            field("Document No"; Rec."Document No")
            {
                ToolTip = 'Advance Document No.';
                ApplicationArea = all;
                Caption = 'Advance Document No.';

            }
        }
    }
}