page 50160 "E3 Quotation List"
{
    CardPageID = "E3 Quotation Card";
    Editable = false;
    PageType = List;
    SourceTableView = sorting("Document No.") order(Descending) WHERE(Status = FILTER(Approved), "Release Indent" = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Order Creation Lists';
    SourceTable = "E3 Indent Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Indent No.';
                    ToolTip = 'Specifies the indent number of the Indent No.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested by of the Prepared By.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the request date of the Request Date.';
                }
                field("Voucher Type Code"; Rec."Voucher Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'Voucher Type';
                    ToolTip = 'Specifies the voucher type code of the Voucher Type Code.';
                }
                field("Voucher Type Name"; Rec."Voucher Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type name of the Voucher Type Name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the Status.';
                }

                field("Prepared Date"; Rec."Prepared Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected receive date of the Prepared Date.';
                }

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approved by of the Approved By.';
                }
            }
        }
    }
}