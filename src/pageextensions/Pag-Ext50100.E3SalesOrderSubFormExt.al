pageextension 50100 "E3 Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        addbefore("Qty. to Ship")
        {
            field(MRP; Rec.MRP)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the MRP for the item.';
            }
            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the batch number for the item.';
            }
            field("Manufacturing Date"; Rec."Manufacturing Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the manufacturing date of the item.';
            }
            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the expiry date of the item.';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(GetIndentLines)
            {
                ApplicationArea = All;
                Caption = 'Get Indent Lines';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select approved indent lines and add them to the sales order.';

                trigger OnAction()
                var
                    IndentLine: Record "E3 Indent Line";
                    GetIndentLinesPage: Page "E3 Get Sale Indent Lines";
                begin
                    GetIndentLinesPage.SetTableView(IndentLine);
                    GetIndentLinesPage.LookupMode(true);

                    if GetIndentLinesPage.RunModal() = Action::LookupOK then begin

                        GetIndentLinesPage.SetSelectionFilter(IndentLine);

                        if not IndentLine.FindSet() then
                            exit;

                        repeat
                            if not SalesLineAlreadyExists(IndentLine) then
                                CreateSalesLineFromIndent(IndentLine);
                        until IndentLine.Next() = 0;
                    end;

                    CurrPage.Update(false);
                end;
            }
            action(SplitSalesLine)
            {
                Caption = 'Split Line';
                ApplicationArea = All;
                Image = Splitlines;

                trigger OnAction()
                var
                    SplitQtyPage: Page "E3 Split Qty";
                    SplitQty: Decimal;
                begin
                    // Only allow positive quantity
                    if Rec.Quantity <= 0 then
                        Error('Quantity must be greater than zero.');

                    // Open popup
                    if SplitQtyPage.RunModal() = Action::OK then begin
                        SplitQty := SplitQtyPage.GetSplitQty();

                        // Validate Split Qty
                        if SplitQty <= 0 then
                            Error('Split Qty must be greater than zero.');

                        if SplitQty >= Rec.Quantity then
                            Error(
                                'Split Qty must be less than the original Quantity (%1).',
                                Rec.Quantity);

                        // Create new sales line and reduce current line
                        CreateSplitLine(Rec, SplitQty);

                        // Refresh page
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
    local procedure CreateSalesLineFromIndent(IndentLine: Record "E3 Indent Line")
    var
        SalesLine: Record "Sales Line";
        Location: Record Location;
    begin
        if SalesLineAlreadyExists(IndentLine) then
            exit;
        SalesLine.Init();

        SalesLine."Document Type" := Rec."Document Type";
        SalesLine."Document No." := Rec."Document No.";

        SalesLine."Line No." := GetNextSalesLineNo();
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", IndentLine."No.");
        SalesLine.Description := IndentLine.Description;
        SalesLine.Validate(Quantity, IndentLine."Approved Qty");
        if IndentLine.Remarks = 'Free Qty' then
            SalesLine.Validate("Unit Cost", 0)
        else
            SalesLine.Validate("Unit Price", IndentLine."Unit Cost");
        if Location.Get(IndentLine."Location Code") then
            SalesLine.Validate("GST Credit", Location."GST Credit");
        if IndentLine."Purch. Unit of Measure" <> '' then
            SalesLine.Validate("Unit of Measure Code", IndentLine."Purch. Unit of Measure");

        SalesLine.MRP := IndentLine.MRP;
        if IndentLine.Remarks = 'Free Qty' then
            SalesLine.FOC := true;
        SalesLine."E3 Indent Line" := true;
        SalesLine.Insert(true);
        UpdateIndentLine(IndentLine);
    end;


    local procedure SalesLineAlreadyExists(
        IndentLine: Record "E3 Indent Line"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        // SalesLine.SetRange("Indent No.", IndentLine."Document No.");
        // SalesLine.SetRange("Indent Line No.", IndentLine."Line No.");

        exit(SalesLine.FindFirst());
    end;

    local procedure GetNextSalesLineNo(): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");

        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure UpdateIndentLine(
        var IndentLine: Record "E3 Indent Line")
    begin
        IndentLine."Sales Order No." := Rec."No.";
        IndentLine."SO Created" := true;

        IndentLine.Modify(true);
    end;

    local procedure CreateSplitLine(
    var SalesLine: Record "Sales Line";
    SplitQty: Decimal)
    var
        NewSalesLine: Record "Sales Line";
        NewLineNo: Integer;
        OriginalQty: Decimal;
    begin
        OriginalQty := SalesLine.Quantity;
        NewLineNo := GetNextSalesLineNo();

        NewSalesLine.Init();
        NewSalesLine."Document Type" := SalesLine."Document Type";
        NewSalesLine."Document No." := SalesLine."Document No.";
        NewSalesLine."Line No." := NewLineNo;
        NewSalesLine.Validate(Type, SalesLine.Type);
        if SalesLine."No." <> '' then
            NewSalesLine.Validate("No.", SalesLine."No.");
        NewSalesLine.Description := SalesLine.Description;
        NewSalesLine."Description 2" := SalesLine."Description 2";
        if SalesLine."Location Code" <> '' then
            NewSalesLine.Validate("Location Code", SalesLine."Location Code");
        if SalesLine."Unit of Measure Code" <> '' then
            NewSalesLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
        NewSalesLine.Validate("Unit Price", SalesLine."Unit Price");
        NewSalesLine.Validate("Line Discount %", SalesLine."Line Discount %");
        NewSalesLine.Validate(Quantity, SplitQty);
        NewSalesLine.Insert(true);
        SalesLine.Validate(Quantity, OriginalQty - SplitQty);
        SalesLine.Modify(true);
    end;


    var
        SalesHeader: Record "Sales Header";
}