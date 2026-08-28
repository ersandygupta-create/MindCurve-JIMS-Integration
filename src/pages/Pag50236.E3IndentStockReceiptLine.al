page 50236 "E3 Indent Stock Receipt Lines"
{
    Caption = 'Stock Receipt Lines';
    PageType = ListPart;
    SourceTable = "E3 Indent Sale/Purchase Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item type.';
                }
                field("Item ID"; Rec."Item ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item name.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.';
                }
                field("Shipped Qty"; Rec."Shipped Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shipped quantity.';
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("GST Per"; Rec."GST Per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GST percentage.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HSN/SAC code.';
                }
                field(Discount; Rec.Discount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the discount amount.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line amount.';
                }
                field(BatchNo; Rec.BatchNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch number.';
                }
                field(ExpiryDate; Rec.ExpiryDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiry date.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item category code.';
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product group code.';
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent number.';
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the indent line number.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetSaleIndentLines)
            {
                ApplicationArea = All;
                Caption = 'Get Indent Lines';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select released indent lines and add them to the Sale & Purchase order.';

                trigger OnAction()
                var
                    PurchHeader: Record "E3 Indent Sale/Purchase Header";
                    IndentHeader: Record "E3 Indent Header";
                    IndentLine: Record "E3 Indent Line";
                    GetIndentLinesPage: Page "E3 Get Indent Lines";
                    SelectedMakeCode: Code[20];
                begin
                    IndentHeader.Reset();
                    IndentHeader.SetRange(Status, IndentHeader.Status::Approved);
                    IndentHeader.SetRange(Released, false);
                    // Open filtered page
                    GetIndentLinesPage.SetTableView(IndentLine);
                    GetIndentLinesPage.LookupMode(true);

                    if GetIndentLinesPage.RunModal() = Action::LookupOK then begin
                        GetIndentLinesPage.SetSelectionFilter(IndentLine);
                        if not IndentLine.FindSet() then
                            exit;
                        SelectedMakeCode := IndentLine."Item Make Code";

                        repeat
                            if IndentLine."Item Make Code" <> SelectedMakeCode then begin
                                Message(
                                    'You cannot select different Item Make Codes.\' +
                                    'First Item Make Code: %1\' +
                                    'Selected Item Make Code: %2\' +
                                    'Item No.: %3',
                                    SelectedMakeCode,
                                    IndentLine."Item Make Code",
                                    IndentLine."No.");

                                exit;
                            end;
                        until IndentLine.Next() = 0;

                        // Get selected lines again
                        GetIndentLinesPage.SetSelectionFilter(IndentLine);


                        if IndentLine.FindSet() then
                            repeat
                                CreateSalePurchaseLineFromIndent(IndentLine);
                            until IndentLine.Next() = 0;
                    end;

                    CurrPage.Update(false);
                end;
            }
        }
    }
    local procedure CreateSalePurchaseLineFromIndent(IndentLine: Record "E3 Indent Line")
    var
        SalePurchLine: Record "E3 Indent Sale/Purchase Line";
    begin
        if PurchaseLineAlreadyExists(IndentLine) then
            exit;
        SaleSalePurchLine.Init();

        SalePurchLine."Nature Type" := Rec."Nature Type";
        SalePurchLine."Entry Type" := Rec."Entry Type";
        SalePurchLine."Document No." := Rec."Document No.";

        SalePurchLine."Line No." := GetNextPurchaseLineNo();
        SalePurchLine.Validate("Item Type", 'Item');
        SalePurchLine.Validate("Item ID", IndentLine."No.");
        SalePurchLine."Item Name" := IndentLine.Description;
        SalePurchLine.Validate("Shipped Qty", IndentLine."Approved Qty");
        SalePurchLine.Validate("Unit Cost", IndentLine."Unit Cost");
        // if IndentLine."Location Code" <> '' then
        //     SalePurchLine.Validate("Location Code", IndentLine."Location Code");       
        SalePurchLine."Indent No." := IndentLine."Document No.";
        SalePurchLine.Insert(true);
        UpdateIndentLine(
            IndentLine);
    end;

    local procedure UpdateIndentLine(
        var IndentLine: Record "E3 Indent Line")
    begin
        IndentLine."Purchase Order No." := Rec."Document No.";

        IndentLine."PO Created" := true;

        IndentLine.Modify(true);
    end;

    local procedure PurchaseLineAlreadyExists(
        IndentLine: Record "E3 Indent Line"): Boolean
    var
        SalePurchLine: Record "E3 Indent Sale/Purchase Line";
    begin
        SalePurchLine.Reset();
        SalePurchLine.SetRange("Nature Type", Rec."Nature Type");
        SalePurchLine.SetRange("Entry Type", Rec."Entry Type");
        SalePurchLine.SetRange("Document No.", Rec."Document No.");
        SalePurchLine.SetRange("Indent No.", IndentLine."Document No.");
        SalePurchLine.SetRange("Indent Line No.", IndentLine."Line No.");

        exit(SalePurchLine.FindFirst());
    end;

    local procedure GetNextPurchaseLineNo(): Integer
    var
        SalesLine: Record "E3 Indent Sale/Purchase Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Nature Type", Rec."Nature Type");
        SalesLine.SetRange("Entry Type", Rec."Entry Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");

        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);

        exit(10000);
    end;

    var
        SaleSalePurchLine: Record "E3 Indent Sale/Purchase Line";

}