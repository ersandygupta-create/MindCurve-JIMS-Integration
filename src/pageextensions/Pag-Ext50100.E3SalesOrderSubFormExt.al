pageextension 50100 "E3 Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
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
                    IndentLine.Reset();
                    IndentLine.SetRange(Status, IndentLine.Status::Approved);
                    IndentLine.SetRange(Released, false);

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
        }
    }
    local procedure CreateSalesLineFromIndent(
    IndentLine: Record "E3 Indent Line")
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesLineAlreadyExists(IndentLine) then
            exit;

        SalesLine.Init();

        SalesLine."Document Type" := Rec."Document Type";
        SalesLine."Document No." := Rec."No.";
        SalesLine."Line No." := GetNextSalesLineNo();

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", IndentLine."No.");
        SalesLine.Description := IndentLine.Description;
        SalesLine.Validate(Quantity, IndentLine."Approved Qty");
        SalesLine.Validate("Unit Price", IndentLine."Unit Cost");
        if IndentLine."Location Code" <> '' then
            SalesLine.Validate("Location Code", IndentLine."Location Code");
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
        SalesLine.SetRange("Document No.", Rec."No.");
        exit(SalesLine.FindFirst());
    end;

    local procedure GetNextSalesLineNo(): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
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




    var
        myInt: Integer;
}