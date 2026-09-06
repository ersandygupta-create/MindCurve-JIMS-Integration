pageextension 50050 "E3 HIS Purch. Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                if Rec."FOC" then
                    Rec."Direct Unit Cost" := 0;
            end;
        }
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
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
                Editable = false;
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
            field("Margin Fix"; Rec."Margin Fix")
            {
                ApplicationArea = All;
                Caption = 'Type of RC';
                ToolTip = 'Specifies the margin fixing method for the item.';
            }
            field("Line Remarks"; Rec."Line Remarks")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Remarks for the item.';
            }
            field("Indent Line Remarks"; Rec."Indent Line Remarks")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Indent Line Remarks for the item.';
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

                    // GRNWorkSheet.Reset();
                    // GRNWorkSheet.SetRange("Vendor Invoice No.", PurchHdr."Vendor Invoice No.");
                    // GRNWorkSheet.SetRange("Vendor Code", PurchHdr."Buy-from Vendor No.");
                    // if GRNWorkSheet.FindFirst() then
                    //     Error(
                    //         'Vendor Invoice No. %1 already exists in GRN Work Sheet %2 for Vendor %3.',
                    //         PurchHdr."Vendor Invoice No.",
                    //         GRNWorkSheet."Vendor Code",
                    //         PurchHdr."Buy-from Vendor No.");

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
                Visible = false;
                PromotedCategory = Process;
                ToolTip = 'Select released indent lines and add them to the purchase order.';

                trigger OnAction()
                var
                    IndentHeader: Record "E3 Indent Header";
                    IndentLine: Record "E3 Indent Line";
                    GetIndentLinesPage: Page "E3 Get Indent Lines";
                    SelectedMakeCode: Code[20];
                    DocumentNo: Code[20];
                    LineNo: Integer;
                    SelectedLines: Record "E3 Indent Line";
                    PurchHeader: Record "Purchase Header";
                begin
                    IndentHeader.Reset();
                    IndentHeader.SetRange(Status, IndentHeader.Status::Approved);
                    IndentHeader.SetRange(Released, true);

                    // if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    //     if PurchHeader."Location Code" <> '' then
                    //         IndentLine.SetRange("Location Code", PurchHeader."Location Code");
                    // end;

                    GetIndentLinesPage.SetTableView(IndentLine);
                    GetIndentLinesPage.LookupMode(true);
                    if GetIndentLinesPage.RunModal() <> Action::LookupOK then
                        exit;
                    GetIndentLinesPage.SetSelectionFilter(IndentLine);
                    if not IndentLine.FindSet() then
                        exit;
                    SelectedMakeCode := IndentLine."Item Make Code";
                    repeat
                        if IndentLine."Item Make Code" <> SelectedMakeCode then begin
                            Message(
                                'You have selected a different Make Code.\' +
                                'First Selected Make Code: %1\' +
                                'Selected Make Code: %2\' +
                                'Item No.: %3',
                                SelectedMakeCode,
                                IndentLine."Item Make Code",
                                IndentLine."No.");

                            exit;
                        end;

                    until IndentLine.Next() = 0;
                    GetIndentLinesPage.SetSelectionFilter(SelectedLines);
                    if not SelectedLines.FindSet() then
                        exit;
                    repeat
                        DocumentNo := SelectedLines."Document No.";
                        LineNo := SelectedLines."Line No.";
                        CreatePurchaseLineFromIndent(SelectedLines);
                        if IndentLine.Get(DocumentNo, LineNo) then begin
                            IndentLine."Closed Indent" := true;
                            IndentLine.Modify(true);
                        end;
                    until SelectedLines.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
            action("Group Indent Lines")
            {
                ApplicationArea = All;
                Caption = 'Group Indent Lines';
                Image = Group;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Select multiple indent lines and create one grouped purchase order line for the same item.';

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    IndentHeader: Record "E3 Indent Header";
                    IndentLine: Record "E3 Indent Line";
                begin
                    IndentHeader.Reset();
                    IndentHeader.SetRange(Status, IndentHeader.Status::Approved);
                    IndentHeader.SetRange(Released, true);

                    // if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    //     if PurchHeader."Location Code" <> '' then
                    //         IndentLine.SetRange("Location Code", PurchHeader."Location Code");
                    // end;
                    GroupIndentLines();
                end;
            }
            action("Validate Purch Price")
            {
                ApplicationArea = All;
                Caption = 'Validate Purch Price & Discount';
                Image = Price;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                    PurchHeader: Record "Purchase Header";
                begin
                    ValidatePurchasePrice();
                    ValidatePurchaseDiscount();
                    if not PurchHeader.Get(Rec."Document Type", Rec."Document No.") then
                        Error(
                            'Purchase Order %1 not found.',
                            Rec."Document No.");

                    // Mark Price Check as completed
                    PurchHeader."Price Check" := true;
                    PurchHeader.Modify(true);

                    CurrPage.Update(false);

                    Message(
                        'Purchase Price & Discount validated successfully.');
                end;
            }
            action("Validate Purch Discount")
            {
                ApplicationArea = All;
                Caption = 'Validate Purch Discount';
                Image = Discount;
                Promoted = true;
                visible = false;
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

    local procedure CreatePurchaseLineFromIndent(IndentLine: Record "E3 Indent Line")
    var
        PurchLine: Record "Purchase Line";
        Location: Record Location;
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
        if IndentLine.Remarks = 'Free Qty' then
            PurchLine.Validate("Direct Unit Cost", 0)
        else
            PurchLine.Validate(
                "Direct Unit Cost",
                IndentLine."Unit Cost");
        PurchLine.Validate("Direct Unit Cost", IndentLine."Unit Cost");
        PurchLine."Entry No." := IndentLine."Entry No.";
        // if IndentLine."Location Code" <> '' then
        //     PurchLine.Validate("Location Code", IndentLine."Location Code");
        if Location.Get(IndentLine."Location Code") then
            PurchLine.Validate("GST Credit", Location."GST Credit");
        if IndentLine."Purch. Unit of Measure" <> '' then
            PurchLine.Validate("Unit of Measure Code", IndentLine."Purch. Unit of Measure");
        PurchLine."Indent No." := IndentLine."Document No.";

        PurchLine."Indent Line No." := IndentLine."Line No.";
        PurchLine."Item Make Code" := IndentLine."Item Make Code";
        PurchLine."Item Make Name" := IndentLine."Item Make Name";
        PurchLine.Critical := IndentLine."Critical Item";
        PurchLine.MRP := IndentLine.MRP;
        PurchLine.Scheme := IndentLine.Scheme;
        PurchLine."SNo." := IndentLine."SNo.";
        PurchLine."Incl Free Qty in Sale Rate" := IndentLine."Incl Free Qty in Sale Rate";
        PurchLine."Indent Line Remarks" := IndentLine.Remarks;
        if IndentLine.Remarks = 'Free Qty' then
            PurchLine.FOC := true;
        PurchLine.Insert(true);
        UpdateIndentLine(IndentLine);
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
                        if PurchLine.FOC then begin
                            PurchLine.Validate("Direct Unit Cost", 0);
                        end else begin
                            PurchLine.Validate("Direct Unit Cost", PRC.Price);
                        end;
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

    local procedure GroupIndentLines()
    var
        IndentLine: Record "E3 Indent Line";
        SelectedIndentLine: Record "E3 Indent Line";
        SelectedLines: Record "E3 Indent Line" temporary;
        CurrentLine: Record "E3 Indent Line" temporary;
        GetGroupingIndentLinesPage: Page "E3 Get Groupping Indent Lines";

        ProcessedGroups: Dictionary of [Text, Boolean];
        GroupKey: Text;
        TotalQty: Decimal;
        FirstIndentLine: Record "E3 Indent Line";
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Released Stock Issue Purchase", true);
        IndentLine.SetFilter(Remarks, 'PO Qty|Free Qty');
        IndentLine.SetRange("PO Created", false);

        if IndentLine.IsEmpty() then
            Error('No indent lines are available for grouping.');

        GetGroupingIndentLinesPage.SetTableView(IndentLine);
        GetGroupingIndentLinesPage.LookupMode(true);

        if GetGroupingIndentLinesPage.RunModal() <> Action::LookupOK then
            exit;

        GetGroupingIndentLinesPage.SetSelectionFilter(SelectedIndentLine);

        if not SelectedIndentLine.FindSet() then
            exit;
        repeat
            SelectedLines := SelectedIndentLine;
            SelectedLines.Insert();
        until SelectedIndentLine.Next() = 0;

        SelectedLines.Reset();

        if SelectedLines.FindSet() then
            repeat
                CurrentLine := SelectedLines;
                CurrentLine.Insert();
            until SelectedLines.Next() = 0;
        CurrentLine.Reset();

        if CurrentLine.FindSet() then
            repeat
                GroupKey :=
                    CurrentLine."No." + '|' +
                    CurrentLine.Description + '|' +
                    CurrentLine.Remarks;
                if not ProcessedGroups.ContainsKey(GroupKey) then begin

                    ProcessedGroups.Add(GroupKey, true);

                    TotalQty := 0;
                    Clear(FirstIndentLine);
                    SelectedLines.Reset();
                    SelectedLines.SetRange("No.", CurrentLine."No.");
                    SelectedLines.SetRange(Description, CurrentLine.Description);
                    SelectedLines.SetRange(Remarks, CurrentLine.Remarks);
                    if SelectedLines.FindSet() then
                        repeat
                            TotalQty := TotalQty + SelectedLines."Requested Qty";
                            if FirstIndentLine."Document No." = '' then
                                FirstIndentLine.Get(SelectedLines."Document No.", SelectedLines."Line No.");
                        until SelectedLines.Next() = 0;
                    if FirstIndentLine."Document No." <> '' then begin
                        if TotalQty <> 0 then begin
                            CreateGroupedPurchaseLine(FirstIndentLine, TotalQty);

                        end;

                    end;

                    SelectedLines.Reset();
                    SelectedLines.SetRange("No.", CurrentLine."No.");
                    SelectedLines.SetRange(Description, CurrentLine.Description);
                    SelectedLines.SetRange(Remarks, CurrentLine.Remarks);
                    if SelectedLines.FindSet() then
                        repeat

                            if IndentLine.Get(SelectedLines."Document No.", SelectedLines."Line No.") then begin
                                IndentLine."Purchase Order No." := Rec."Document No.";
                                IndentLine."PO Created" := true;
                                IndentLine."Closed Indent Grouped Line" := true;
                                IndentLine.Modify(true);
                            end;
                        until SelectedLines.Next() = 0;
                end;
            until CurrentLine.Next() = 0;
        CurrPage.Update(false);
        Message('Selected indent lines have been grouped and added to the purchase order.');
    end;

    local procedure IsGroupProcessed(
        var GroupLine: Record "E3 Indent Line" temporary;
        ItemNo: Code[20];
        Description: Text[100]): Boolean
    begin
        GroupLine.Reset();
        GroupLine.SetRange("No.", ItemNo);
        GroupLine.SetRange(Description, Description);

        exit(GroupLine.FindFirst());
    end;


    local procedure CreateGroupedPurchaseLine(
    FirstIndentLine: Record "E3 Indent Line";
    TotalQty: Decimal)
    var
        PurchLine: Record "Purchase Line";
        Location: Record Location;
    begin
        if FirstIndentLine."No." = '' then
            exit;

        if TotalQty = 0 then
            exit;

        PurchLine.Init();

        PurchLine."Document Type" := Rec."Document Type";
        PurchLine."Document No." := Rec."Document No.";
        PurchLine."Line No." := GetNextPurchaseLineNo();
        PurchLine.Validate(Type, PurchLine.Type::Item);
        PurchLine.Validate("No.", FirstIndentLine."No.");

        PurchLine.Description := FirstIndentLine.Description;

        // GROUPED QUANTITY
        PurchLine.Validate(Quantity, TotalQty);

        PurchLine.Validate("Direct Unit Cost", FirstIndentLine."Unit Cost");

        // if FirstIndentLine."Location Code" <> '' then
        //     PurchLine.Validate("Location Code",FirstIndentLine."Location Code");
        if Location.Get(FirstIndentLine."Location Code") then
            PurchLine.Validate("GST Credit", Location."GST Credit");

        if FirstIndentLine."Purch. Unit of Measure" <> '' then
            PurchLine.Validate("Unit of Measure Code", FirstIndentLine."Purch. Unit of Measure");

        // PurchLine."Indent No." := FirstIndentLine."Document No.";
        // PurchLine."Indent Line No." := FirstIndentLine."Line No.";
        PurchLine."Item Make Code" := FirstIndentLine."Item Make Code";
        PurchLine."Item Make Name" := FirstIndentLine."Item Make Name";
        PurchLine.Critical := FirstIndentLine."Critical Item";
        PurchLine.MRP := FirstIndentLine.MRP;
        PurchLine.Scheme := FirstIndentLine.Scheme;
        PurchLine."SNo." := FirstIndentLine."SNo.";
        PurchLine."Incl Free Qty in Sale Rate" := FirstIndentLine."Incl Free Qty in Sale Rate";
        PurchLine."Indent Line Remarks" := FirstIndentLine.Remarks;
        // FREE QTY = FOC
        if FirstIndentLine.Remarks = 'Free Qty' then
            PurchLine.FOC := true;

        PurchLine.Insert(true);
    end;

}