page 50257 "E3 Get Orgnization Receipt"
{
    Caption = 'Get Organization Receipt';
    PageType = List;
    SourceTable = "E3 Organization Receipt";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = where(IsCreated = const(true));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field("HIS Document Type"; Rec."HIS Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HIS document type.';
                }
                field("Allocation Amount"; Rec."Allocation Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount allocated.';
                }
            }
        }
    }
}