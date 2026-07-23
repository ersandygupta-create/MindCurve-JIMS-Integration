page 50162 "E3 Vendor Quotation"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "E3 Indent Line";
    SourceTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
    ApplicationArea = All;
    Caption = 'Indent Quotation';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Visible = false;
                    ToolTip = 'Specifies the quotation document number.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Visible = false;
                    ToolTip = 'Specifies the line number of the quotation.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the line Shortcut Dimension 1 Code of the quotation.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'No.';
                    ToolTip = 'Specifies the item number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the item.';
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Indent Line Remarks';
                    ToolTip = 'Specifies the Remarks field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Critical Item"; Rec."Critical Item")
                {
                    Caption = 'Critical Item';
                    ToolTip = 'Specifies the Critical Item of the item.';
                }
                field(Quantity; Rec."Requested Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Requested Quantity';
                    ToolTip = 'Specifies the required quantity.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the required Amount.';
                }
                field("Created PO Qty"; Rec."Created PO Qty")
                {
                    ToolTip = 'Specifies the required Created PO Qty.';
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ToolTip = 'Specifies the required Approved Qty.';
                    Editable = false;
                }
                field("Ordered Qty"; Rec."Ordered Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Ordered Qty';
                    Editable = true;
                    ToolTip = 'Specifies the ordered quantity.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code';
                    Editable = true;
                    ToolTip = 'Specifies the currency code of the vendor.';
                }
                field("Price"; Rec."Quotation Price")
                {
                    ApplicationArea = All;
                    Caption = 'Quotation Price';
                    Editable = true;
                    ToolTip = 'Specifies the quoted unit price from the vendor.';
                }
                field("discount %"; Rec."discount %")
                {
                    ApplicationArea = All;
                    Caption = 'Discount %';
                    ToolTip = 'Specifies the discount percentage offered by the vendor.';
                }
                field("Quotation Amount"; Rec."Quotation Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Quotation Amount';
                    ToolTip = 'Specifies the total amount quoted by the vendor.';
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Terms';
                    ToolTip = 'Specifies the payment terms agreed for the quotation or purchase, such as advance payment, credit period, or payment schedule.';
                }
                field("Delivery Time"; Rec."Delivery Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Delivery Terms';
                    ToolTip = 'Specifies the expected delivery time or delivery terms provided by the vendor.';
                }
                field("AMC Amount"; Rec."AMC Amount")
                {
                    ApplicationArea = All;
                    Caption = 'AMC Amount';
                    ToolTip = 'Specifies the Annual Maintenance Contract (AMC) amount quoted by the vendor.';
                }
                field("CMC Amount"; Rec."CMC Amount")
                {
                    ApplicationArea = All;
                    Caption = 'CMC Amount';
                    ToolTip = 'Specifies the Comprehensive Maintenance Contract (CMC) amount quoted by the vendor.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the number of the vendor.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    ToolTip = 'Specifies the name of the vendor.';
                }
                field("Qoutation Remarks"; Rec."Quotation Remarks")
                {
                    ApplicationArea = All;
                    Caption = 'Remarks';
                    ToolTip = 'Specifies additional remarks for the quotation.';
                }
                field("Vendor PO Creation"; Rec."Vendor PO Creation")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor PO Creation';
                    ToolTip = 'Specifies whether the vendor purchase order has been created.';
                }
                field("Split Line"; Rec."Split Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the Split Line Boolean.';
                }
                field("Quotation Type"; Rec."Quotation Type")
                {
                    ApplicationArea = All;
                    Caption = 'Quotation Type';
                    Visible = false;
                    ToolTip = 'Specifies the quotation ranking (L1, L2, or L3).';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Split Qty")
            {
                Caption = 'Split Qty';
                ApplicationArea = All;
                Image = Split;

                trigger OnAction()
                var
                    SplitQtyPage: Page "E3 Split Qty";
                    SplitQty: Integer;
                begin
                    // Only allow approved quantity
                    if Rec."Approved Qty" <= 0 then
                        Error('Approved Qty must be greater than zero.');

                    // Open popup
                    if SplitQtyPage.RunModal() = Action::OK then begin
                        SplitQty := SplitQtyPage.GetSplitQty();

                        if SplitQty <= 0 then
                            Error('Split Qty must be greater than zero.');

                        if SplitQty > Rec."Approved Qty" then
                            Error(
                              'Split Qty cannot be greater than Approved Qty (%1).',
                              Rec."Approved Qty");

                        // Create copied lines
                        CreateSplitLines(Rec, SplitQty);

                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
    local procedure CreateSplitLines(var SelectedLine: Record "E3 Indent Line"; SplitQty: Decimal)
    var
        NewLine: Record "E3 Indent Line";
        LastLine: Record "E3 Indent Line";
        NextLineNo: Integer;
        UnitAmount: Decimal;
    begin
        // Validation
        if SplitQty <= 0 then
            Error('Split Qty must be greater than zero.');

        if SplitQty > SelectedLine."Approved Qty" then
            Error(
                'Split Qty (%1) cannot be greater than Approved Qty (%2).',
                SplitQty,
                SelectedLine."Approved Qty");
        if SelectedLine."Requested Qty" <> 0 then
            UnitAmount := SelectedLine.Amount / SelectedLine."Requested Qty";

        // Get Next Line No.
        LastLine.Reset();
        LastLine.SetRange("Document No.", SelectedLine."Document No.");
        if LastLine.FindLast() then
            NextLineNo := LastLine."Line No." + 10000
        else
            NextLineNo := 10000;

        // Create New Split Line
        NewLine.Init();
        NewLine.TransferFields(SelectedLine);

        NewLine."Line No." := NextLineNo;
        NewLine.Validate("Requested Qty", SplitQty);
        NewLine.Validate("Approved Qty", SplitQty);
        //NewLine.Validate("Ordered Qty", SplitQty);

        NewLine."Split Line" := false;
        NewLine."SplitedLines" := true;

        NewLine.Insert(true);

        // Update Original Line
        SelectedLine.Validate("Requested Qty", SelectedLine."Requested Qty" - SplitQty);
        SelectedLine.Validate("Approved Qty", SelectedLine."Approved Qty" - SplitQty);
        SelectedLine.Validate("Ordered Qty", SelectedLine."Approved Qty" - SplitQty);

        SelectedLine."Split Line" := true;
        SelectedLine."SplitedLines" := false;

        SelectedLine.Modify(true);

        Message('Split line created successfully.');
    end;

    trigger OnAfterGetCurrRecord()
    var
        IndentHeader: Record "E3 Indent Header";
    begin
        if (Rec."Shortcut Dimension 1 Code" = '') and
           IndentHeader.Get(Rec."Document No.")
        then
            if IndentHeader."Shortcut Dimension 1 Code" <> '' then begin
                Rec.Validate("Shortcut Dimension 1 Code", IndentHeader."Shortcut Dimension 1 Code");
                Rec.Modify();
            end;
    end;
}
