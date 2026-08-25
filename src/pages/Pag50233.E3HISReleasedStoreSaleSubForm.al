page 50233 "HIS Released Sales Indent Line"
{
    PageType = ListPart;
    SourceTable = "E3 Indent Line";
    ApplicationArea = All;
    Caption = 'Released Sales Indents Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Critical Item"; Rec."Critical Item")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsLineEditable;
                }
                field("Requested Qty"; Rec."Requested Qty")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsLineEditable;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsLineEditable;
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SNo."; Rec."SNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify a value SNo. field.';
                }
                field("Requested Received Date"; Rec."Requested Received Date")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = IsLineEditable;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
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
    var
        IsLineEditable: Boolean;
        IsApprovedQtyEditable: Boolean;
        IndentHeader: Record "E3 Indent Header";

    trigger OnOpenPage()
    begin
        SetEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditable();
    end;

    local procedure SetEditable()
    begin
        IsLineEditable := true;
        IsApprovedQtyEditable := false;

        if IndentHeader.Get(Rec."Document No.") then begin
            case IndentHeader.Status of
                IndentHeader.Status::Open:
                    begin
                        IsLineEditable := true;
                        IsApprovedQtyEditable := true;
                    end;

                IndentHeader.Status::"Pending Approval":
                    begin
                        IsLineEditable := false;
                        IsApprovedQtyEditable := true;
                    end;

                IndentHeader.Status::Approved:
                    begin
                        IsLineEditable := false;
                        IsApprovedQtyEditable := false;
                    end;
            end;
        end;
    end;

    local procedure CreateSplitLines(var SelectedLine: Record "E3 Indent Line"; SplitQty: Decimal)
    var
        NewLine: Record "E3 Indent Line";
        LastLine: Record "E3 Indent Line";
        NextLineNo: Integer;
        UnitAmount: Decimal;
        QuoteAmt: Decimal;
    begin
        // Validation
        if SplitQty <= 0 then
            Error('Split Qty must be greater than zero.');

        if SplitQty > SelectedLine."Approved Qty" then
            Error(
                'Split Qty (%1) cannot be greater than Approved Qty (%2).',
                SplitQty,
                SelectedLine."Approved Qty");

        // if SelectedLine."Ordered Qty" <= 0 then
        //     Error('Ordered Qty must be greater than 0 before splitting.');

        // if SplitQty > SelectedLine."Ordered Qty" then
        //     Error(
        //         'Split Qty (%1) cannot be greater than Ordered Qty (%2).',
        //         SplitQty,
        //         SelectedLine."Approved Qty");
        if SelectedLine."Approved Qty" <> 0 then
            UnitAmount := SelectedLine.Amount / SelectedLine."Approved Qty";

        if SelectedLine."Approved Qty" <> 0 then
            QuoteAmt := SelectedLine."Quotation Amount" / SelectedLine."Approved Qty";

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
        //SelectedLine.Validate("Ordered Qty", SelectedLine."Approved Qty" - SplitQty);

        SelectedLine."Split Line" := true;
        SelectedLine."SplitedLines" := false;

        SelectedLine.Modify(true);

        Message('Split line created successfully.');
    end;

}