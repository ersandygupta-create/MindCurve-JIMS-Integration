page 50153 "E3 Indent Card"
{
    PageType = Card;
    SourceTable = "E3 Indent Header";
    ApplicationArea = All;
    Caption = 'Indent Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "E3 Indent Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("Document No.");
                UpdatePropagation = Both;
            }
        }
    }
}