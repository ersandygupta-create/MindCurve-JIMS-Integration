page 50196 "E3 Stock Consumption List"
{
    Caption = 'Stock Consumption List';
    PageType = List;
    SourceTable = "E3 Stock Consumption Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Stock Consumption Card";
    SourceTableView = sorting("Entry No.") where("Is Created" = filter(false));
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type of the stock consumption.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number.';
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the stock consumption entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Business Unit"; Rec."Business Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the legal entity.';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error description.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DeleteSelected)
            {
                ApplicationArea = All;
                Caption = 'Delete Selected';
                Image = DeleteRow;
                ToolTip = 'Deletes all selected pharmacy sales documents and their related lines.';
                Visible = ShowDeleteStockConsumption;

                trigger OnAction()
                var
                    StockCOgsHdrHeader: Record "E3 Stock Consumption Header";
                begin
                    CurrPage.SetSelectionFilter(StockHdrHdr);

                    if StockHdrHdr.FindSet() then
                        repeat
                            StockCOgsHdrHeader := StockHdrHdr;
                            StockCOgsHdrHeader.Delete(true);
                        until StockHdrHdr.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdateButtonVisibility();
    end;

    local procedure UpdateButtonVisibility()
    begin
        Clear(ShowDeleteStockConsumption);

        if UserSetup.Get(UserId()) then
            ShowDeleteStockConsumption := UserSetup."Delete Stock Consumption";
    end;

    var
        StockHdrHdr: Record "E3 Stock Consumption Header";
        UserSetup: Record "User Setup";
        ShowDeleteStockConsumption: Boolean;

}