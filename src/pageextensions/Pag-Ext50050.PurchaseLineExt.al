pageextension 50050 "E3 HIS Purch. Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addafter("TDS Section Code")
        {
            field("Item Make Code"; Rec."Item Make Code")
            {
                ApplicationArea = All;
                Caption = 'Item Make Code';
                ToolTip = 'Specifies the unique code of the item make.';
            }

            field("Item Make Name"; Rec."Item Make Name")
            {
                ApplicationArea = All;
                Caption = 'Item Make Name';
                ToolTip = 'Specifies the name of the item make.';
            }

            field(Critical; Rec.Critical)
            {
                ApplicationArea = All;
                Caption = 'Critical Item';
                ToolTip = 'Specifies whether the item make is marked as critical.';
            }
            field(MRP; Rec.MRP)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies The Value MRP';
            }
            field(Scheme; Rec.Scheme)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a value Scheme';
            }
            field("Incl Free Qty in Sale Rate"; Rec."Incl Free Qty in Sale Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies The Value Incl Free Qty in Sale Rate';
            }
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Indent Number from which the item or requirement is being referenced.';
            }

            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the line number associated with the selected Indent Number.';
            }
            field("SNo."; Rec."SNo.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specify a value SNo.';
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("GRNWorkSheet")
            {
                ApplicationArea = All;
                Caption = 'GRN Work Sheet';
                Image = Create;
                Ellipsis = true;
                ToolTip = 'GRN Work Sheet';

                trigger OnAction()
                var
                    GRNWorkSheet: Record "E3 GRN Work Sheet";
                    PurchHdr: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                begin
                    if not PurchHdr.Get(Rec."Document Type", Rec."Document No.") then
                        Error(
                            'Purchase Order %1 not found.',
                            Rec."Document No.");
                    if PurchHdr."Vendor Invoice No." = '' then
                        Error(
                            'Vendor Invoice No. cannot be blank. Please enter the Vendor Invoice No. before creating the GRN Worksheet.');
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."Document No.");

                    // Only lines having Qty. to Receive
                    PurchLine.SetFilter("Qty. to Receive", '>0');

                    if PurchLine.IsEmpty() then
                        Error(
                            'No Purchase Order lines have Qty. to Receive greater than zero.');
                    // Create worksheet for all PO lines
                    GRNWorkSheet.InitFromPurchaseLine(Rec."Document No.");

                    // Open worksheet
                    GRNWorkSheet.Reset();
                    GRNWorkSheet.SetRange("PO No.", Rec."Document No.");

                    Page.Run(Page::"E3 GRN Work Sheet", GRNWorkSheet);
                end;
            }
            action(GetIndentLines)
            {
                ApplicationArea = All;
                Caption = 'Get Indent Lines';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select released indent lines and add them to the purchase order.';

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    IndentHeader: Record "E3 Indent Header";
                    IndentLine: Record "E3 Indent Line";
                    GetIndentLinesPage: Page "E3 Get Indent Lines";
                begin
                    IndentHeader.Reset();
                    IndentHeader.SetRange(Status, IndentHeader.Status::Approved);
                    // Open filtered page
                    GetIndentLinesPage.SetTableView(IndentLine);
                    GetIndentLinesPage.LookupMode(true);

                    if GetIndentLinesPage.RunModal() = Action::LookupOK then begin
                        GetIndentLinesPage.SetSelectionFilter(IndentLine);

                        if IndentLine.FindSet() then
                            repeat
                                CreatePurchaseLineFromIndent(IndentLine);
                            until IndentLine.Next() = 0;
                    end;

                    CurrPage.Update(false);
                end;
            }
            action("Validate Purch Price")
            {
                ApplicationArea = All;
                Caption = 'Validate Purch Price';
                Image = Price;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ValidatePurchasePrice();
                    CurrPage.Update(false);
                end;
            }
            action("Validate Purch Discount")
            {
                ApplicationArea = All;
                Caption = 'Validate Purch Discount';
                Image = Discount;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Update the purchase line discount percentage from the applicable RC Discount based on Item Make Code.';

                trigger OnAction()
                begin
                    ValidatePurchaseDiscount();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure GetIndentLines()
    var
        IndentLine: Record "E3 Indent Line";
        GetIndentLinesPage: Page "E3 Get Indent Lines";
    begin
        IndentLine.Reset();
        IndentLine.SetRange(Type, IndentLine.Type::Item);
        IndentLine.SetRange("Released", false);
        IndentLine.SetRange("PO Created", false);
        if IndentLine.IsEmpty() then
            Error('No released indent lines are available for purchase order creation.');
        GetIndentLinesPage.SetTableView(IndentLine);
        GetIndentLinesPage.LookupMode(true);
        if GetIndentLinesPage.RunModal() = Action::LookupOK then begin
            GetIndentLinesPage.SetSelectionFilter(IndentLine);
            if IndentLine.FindSet() then
                repeat
                    CreatePurchaseLineFromIndent(IndentLine);
                until IndentLine.Next() = 0;
        end;
        CurrPage.Update(false);
    end;

    local procedure CreatePurchaseLineFromIndent(
        IndentLine: Record "E3 Indent Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        if PurchaseLineAlreadyExists(IndentLine) then
            exit;
        PurchLine.Init();

        PurchLine."Document Type" := Rec."Document Type";
        PurchLine."Document No." := Rec."Document No.";

        PurchLine."Line No." := GetNextPurchaseLineNo();
        PurchLine.Validate(Type, PurchLine.Type::Item);
        PurchLine.Validate("No.", IndentLine."No.");
        PurchLine.Description := IndentLine.Description;
        PurchLine.Validate(Quantity, IndentLine."Approved Qty");
        PurchLine.Validate("Direct Unit Cost", IndentLine."Quotation Price");
        if IndentLine."Location Code" <> '' then
            PurchLine.Validate("Location Code", IndentLine."Location Code");
        if IndentLine."Purch. Unit of Measure" <> '' then
            PurchLine.Validate("Unit of Measure Code", IndentLine."Purch. Unit of Measure");
        PurchLine."Indent No." := IndentLine."Document No.";

        PurchLine."Indent Line No." := IndentLine."Line No.";
        PurchLine."Item Make Code" := IndentLine."Item Make Code";
        PurchLine."Item Make Name" := IndentLine."Item Make Name";
        PurchLine.Critical := IndentLine."Critical Item";
        //PurchLine.MRP := IndentLine.MRP;
        //PurchLine.Scheme := IndentLine.Scheme;
        PurchLine."SNo." := IndentLine."SNo.";
        PurchLine.Insert(true);
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
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange("Indent No.", IndentLine."Document No.");
        PurchLine.SetRange("Indent Line No.", IndentLine."Line No.");

        exit(PurchLine.FindFirst());
    end;

    local procedure GetNextPurchaseLineNo(): Integer
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");

        if PurchLine.FindLast() then
            exit(PurchLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure ValidatePurchasePrice()
    var
        PurchLine: Record "Purchase Line";
        PRC: Record "E3 Rate Contract Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);

        if PurchLine.FindSet() then
            repeat
                if PurchLine."No." <> '' then begin
                    PRC.Reset();
                    PRC.SetRange("Product No.", PurchLine."No.");
                    PRC.SetRange("Make Code", PurchLine."Item Make Code");

                    if PRC.FindFirst() then begin
                        PurchLine.Validate("Direct Unit Cost", PRC.Price);
                        PurchLine.Validate(MRP, PRC.MRP);
                        PurchLine.Validate(Scheme, PRC.Scheme);
                        PurchLine."Incl Free Qty in Sale Rate" := PRC."Incl Free Qty in Sale Rate";
                        PurchLine.Modify(true);
                    end;
                end;
            until PurchLine.Next() = 0;
    end;

    local procedure ValidatePurchaseDiscount()
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        RCDiscountLine: Record "E3 RC Discount Line";
    begin
        PurchHeader.Get(Rec."Document Type", Rec."Document No.");

        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");

        if PurchLine.FindSet(true) then
            repeat
                if PurchLine."No." = '' then
                    continue;

                if PurchLine."Item Make Code" = '' then
                    continue;

                RCDiscountLine.Reset();

                // Vendor-wise filter
                RCDiscountLine.SetRange("Vendor Code", PurchHeader."Buy-from Vendor No.");

                // Make-wise filter
                RCDiscountLine.SetRange("Make Code", PurchLine."Item Make Code");

                if RCDiscountLine.FindFirst() then begin
                    PurchLine.Validate("Line Discount %", RCDiscountLine."Line Discount %");

                    PurchLine.Modify(true);
                end;

            until PurchLine.Next() = 0;
    end;
}