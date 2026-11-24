using Microsoft.Sales.History;

pageextension 50114 "Posted Invoice IsSent Update" extends "Posted Sales Inv. - Update"
{
    layout
    {
        addlast(Content)
        {
            group(JIMSIntegration)
            {
                Caption = 'JIMS Integration';

                field(JIMSIsSent; Rec.IsSent)
                {
                    ApplicationArea = All;
                    Caption = 'Is Sent';
                    Editable = true;
                }
            }
        }
    }
}