page 50154 "E3 Indent Subform"
{
    PageType = ListPart;
    SourceTable = "E3 Indent Line";
    ApplicationArea = All;
    Caption = 'Indent Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }

                field("Allocated Qty"; Rec."Allocated Qty")
                {
                    ApplicationArea = All;
                }

                field("Remaining Qty For Quote"; Rec."Remaining Qty For Quote")
                {
                    ApplicationArea = All;
                }

                field("First Vendor No."; Rec."First Vendor No.")
                {
                    ApplicationArea = All;
                }

                field("First Price"; Rec."First Price")
                {
                    ApplicationArea = All;
                }

                field("First Amount"; Rec."First Amount")
                {
                    ApplicationArea = All;
                }

                field("Second Vendor No."; Rec."Second Vendor No.")
                {
                    ApplicationArea = All;
                }

                field("Second Price"; Rec."Second Price")
                {
                    ApplicationArea = All;
                }

                field("Second Amount"; Rec."Second Amount")
                {
                    ApplicationArea = All;
                }

                field("Third Vendor No."; Rec."Third Vendor No.")
                {
                    ApplicationArea = All;
                }

                field("Third Price"; Rec."Third Price")
                {
                    ApplicationArea = All;
                }

                field("Third Amount"; Rec."Third Amount")
                {
                    ApplicationArea = All;
                }

                field("Quotation No."; Rec."Quotation No.")
                {
                    ApplicationArea = All;
                }

                field("Price Quoted"; Rec."Price Quoted")
                {
                    ApplicationArea = All;
                }

                field(Finalized; Rec.Finalized)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}