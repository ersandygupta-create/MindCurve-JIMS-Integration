page 50213 "E3 Indent Sale/Purchase Card"
{
    Caption = 'Indent Sale/Purchase Card';
    PageType = Card;
    SourceTable = "E3 Indent Sale/Purchase Header";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Nature Type"; Rec."Nature Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the nature type.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent number.';
                }
                field("Indent Date"; Rec."Indent Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent date.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the transaction is for a vendor or customer.';
                }
                field("Vendor/Customer No."; Rec."Vendor/Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor or customer number.';
                }
                field("Vendor/Customer Name"; Rec."Vendor/Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor or customer name.';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoice number.';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoice date.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
            }
            group(AmountDetails)
            {
                Caption = 'Amount Details';

                field("No. of Lines"; Rec."No. of Lines")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of lines.';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit code.';
                }
                field("Dept Code"; Rec."Dept Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("Create PO"; Rec."Create PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a purchase order should be created.';
                }
            }
            group(ErrorDetails)
            {
                Caption = 'Error Details';

                field("Error 1"; Rec."Error 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether error 1 exists.';
                }
                field("Error 2"; Rec."Error 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether error 2 exists.';
                }
                field("Error 3"; Rec."Error 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether error 3 exists.';
                }
                field("Error 4"; Rec."Error 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether error 4 exists.';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the error description.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies remarks for the document.';
                }
            }
            part(Lines; "E3 Indent Sale/Purchase Lines")
            {
                ApplicationArea = All;
                SubPageLink =
                    "Entry No." = FIELD("Entry No."),
                    "Nature Type" = FIELD("Nature Type"),
                    "Entry Type" = FIELD("Entry Type"),
                    "Document No." = FIELD("Document No.");
            }
        }
    }
}