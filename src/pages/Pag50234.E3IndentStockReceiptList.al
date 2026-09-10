page 50234 "E3 Indent Stock Receipt List"
{
    Caption = 'Stock Receipt';
    PageType = List;
    SourceTable = "E3 Indent Sale/Purchase Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Indent Stock Receipt Card";
    SourceTableView = sorting("Entry No.") order(descending) where("Entry Type" = filter(Purchase));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
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
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
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
                field("From Location Code"; Rec."From Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("From Shortcut Dimension 1 Code"; Rec."From Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit code.';
                }
                field("From Shortcut Dimension 2 Code"; Rec."From Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("Create PO"; Rec."Create PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a purchase order should be created.';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error description.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remarks for the document.';
                }
            }
        }
    }
}