page 50226 "E3 HIS Issue Indent Line"
{
    PageType = ListPart;
    SourceTable = "E3 Indent Line";
    ApplicationArea = All;
    Caption = 'Issue Indent Lines';
    AutoSplitKey = true;
    DelayedInsert = true;
    SourceTableView = where("Released Stock Issue Purchase" = const(true));

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field("Released Stock Issue Purchase"; Rec."Released Stock Issue Purchase")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
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
                    //Visible = false;
                    Editable = IsLineEditable;
                }
                field(MRP; Rec.MRP)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created PO Qty"; Rec."Created PO Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Scheme; Rec.Scheme)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty Per Purch. Unit of Measure"; Rec."Qty Per Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Free Qty"; Rec."Free Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Free Qty';
                    ToolTip = 'Specifies the free quantity.';
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                    Caption = 'PO Qty';
                    ToolTip = 'Specifies the purchase order quantity.';
                }
                field("Incl Free Qty in Sale Rate"; Rec."Incl Free Qty in Sale Rate")
                {
                    ApplicationArea = All;
                    Caption = 'Include Free Qty in Sale Rate';
                    ToolTip = 'Specifies whether the free quantity is included when calculating the sale rate.';
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
            action(SplitIndent)
            {
                ApplicationArea = All;
                Caption = 'Split Indent';
                Image = Split;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Break the indent into the number of lines calculated by the split factor.';

                trigger OnAction()
                begin
                    if Rec."Split Line" then
                        Error('This indent line has already been split.');

                    SplitIndentLine(Rec);

                    Rec.Validate("Split Line", true);
                    Rec.Modify(true);

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
            action("Revalidate")
            {
                ApplicationArea = All;
                Caption = 'Revalidate Purchase Price';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ReValidatePurchasePrice();
                    CurrPage.Update(false);
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

    local procedure ValidatePurchasePrice()
    var
        RCLine: Record "E3 Rate Contract Line";
        IndentLine: Record "E3 Indent Line";
    begin
        if RCLine.FindSet() then
            repeat
                if RCLine."Product No." <> '' then begin

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");
                    IndentLine.SetRange(Type, IndentLine.Type::Item);
                    IndentLine.SetRange("No.", RCLine."Product No.");
                    IndentLine.SetRange("Item Make Code", RCLine."Make Code");

                    if IndentLine.FindFirst() then begin
                        IndentLine.Validate("Unit Cost", RCLine.Price);
                        IndentLine.Validate(MRP, RCLine.MRP);
                        IndentLine.Validate(Scheme, RCLine.Scheme);
                        IndentLine.Validate("Created PO Qty", RCLine.Quantity);
                        IndentLine.Validate("Free Qty", RCLine."Free Qty");
                        IndentLine.Validate("PO Qty", RCLine."PO Qty");
                        IndentLine."Incl Free Qty in Sale Rate" := RCLine."Incl Free Qty in Sale Rate";
                        IndentLine.Modify(true);
                    end;
                end;
            until RCLine.Next() = 0;
    end;

    local procedure ReValidatePurchasePrice()
    var
        RCLine: Record "E3 Rate Contract Line";
        IndentLine: Record "E3 Indent Line";
        Changed: Boolean;
    begin
        RCLine.Reset();

        if RCLine.FindSet() then
            repeat
                if RCLine."Product No." <> '' then begin

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");
                    IndentLine.SetRange(Type, IndentLine.Type::Item);
                    IndentLine.SetRange("No.", RCLine."Product No.");
                    IndentLine.SetRange("Item Make Code", RCLine."Make Code");

                    if IndentLine.FindFirst() then begin
                        Changed := false;

                        if IndentLine."Unit Cost" <> RCLine.Price then begin
                            IndentLine.Validate("Unit Cost", RCLine.Price);
                            Changed := true;
                        end;

                        if IndentLine.MRP <> RCLine.MRP then begin
                            IndentLine.Validate(MRP, RCLine.MRP);
                            Changed := true;
                        end;

                        if IndentLine.Scheme <> RCLine.Scheme then begin
                            IndentLine.Validate(Scheme, RCLine.Scheme);
                            Changed := true;
                        end;

                        if IndentLine."Created PO Qty" <> RCLine.Quantity then begin
                            IndentLine.Validate("Created PO Qty", RCLine.Quantity);
                            Changed := true;
                        end;

                        if IndentLine."Free Qty" <> RCLine."Free Qty" then begin
                            IndentLine.Validate("Free Qty", RCLine."Free Qty");
                            Changed := true;
                        end;

                        if IndentLine."PO Qty" <> RCLine."PO Qty" then begin
                            IndentLine.Validate("PO Qty", RCLine."PO Qty");
                            Changed := true;
                        end;

                        if IndentLine."Incl Free Qty in Sale Rate" <>
                           RCLine."Incl Free Qty in Sale Rate"
                        then begin
                            IndentLine."Incl Free Qty in Sale Rate" :=
                                RCLine."Incl Free Qty in Sale Rate";
                            Changed := true;
                        end;

                        if Changed then
                            IndentLine.Modify(true);
                    end;
                end;
            until RCLine.Next() = 0;
    end;

    procedure SplitIndentLine(var IndentLine: Record "E3 Indent Line")
    var
        NewLine: Record "E3 Indent Line";
        SplitFactor: Integer;
        ApprovedQty: Decimal;
        FreeQty: Decimal;
        POQty: Decimal;
        POQtyLine: Decimal;
        FreeQtyLine: Decimal;
        RejectQtyLine: Decimal;
        NextLineNo: Integer;
    begin
        // Get original quantities
        ApprovedQty := IndentLine."Approved Qty";
        FreeQty := IndentLine."Free Qty";
        POQty := IndentLine."PO Qty";

        // Validate Approved Qty
        if ApprovedQty <= 0 then
            Error('Approved Qty must be greater than zero.');

        if (POQty + FreeQty) <= 0 then
            Error('PO Qty + Free Qty must be greater than zero.');

        SplitFactor := Round(
            ApprovedQty / (POQty + FreeQty),
            1,
            '<');

        if SplitFactor < 1 then
            Error(
                'Split Factor is %1. Split is not possible.',
                SplitFactor);

        POQtyLine := SplitFactor * POQty;
        FreeQtyLine := SplitFactor * FreeQty;

        RejectQtyLine := ApprovedQty - POQtyLine - FreeQtyLine;

        if RejectQtyLine < 0 then
            Error(
                'Reject Qty cannot be negative.\Approved Qty: %1\PO Qty: %2\Free Qty: %3',
                ApprovedQty,
                POQtyLine,
                FreeQtyLine);

        NewLine.Reset();
        NewLine.SetRange("Document No.", IndentLine."Document No.");

        if NewLine.FindLast() then
            NextLineNo := NewLine."Line No." + 10000
        else
            NextLineNo := 10000;
        NewLine.Init();
        NewLine.TransferFields(IndentLine, false);

        NewLine."Line No." := NextLineNo;

        NewLine.Validate("Requested Qty", POQtyLine);
        NewLine.Validate("Approved Qty", POQtyLine);

        NewLine."PO Qty" := POQty;
        NewLine."Free Qty" := 0;

        NewLine.Remarks := 'PO Qty';

        NewLine.Insert(true);

        NextLineNo += 10000;

        NewLine.Init();
        NewLine.TransferFields(IndentLine, false);

        NewLine."Line No." := NextLineNo;

        NewLine.Validate("Requested Qty", FreeQtyLine);
        NewLine.Validate("Approved Qty", FreeQtyLine);

        NewLine."PO Qty" := 0;
        NewLine."Free Qty" := FreeQty;

        NewLine.Remarks := 'Free Qty';
        NewLine."Unit Cost" := 0;

        NewLine.Insert(true);

        if RejectQtyLine > 0 then begin

            NextLineNo += 10000;

            NewLine.Init();
            NewLine.TransferFields(IndentLine, false);

            NewLine."Line No." := NextLineNo;

            NewLine.Validate("Requested Qty", RejectQtyLine);
            NewLine.Validate("Approved Qty", RejectQtyLine);

            NewLine."PO Qty" := 0;
            NewLine."Free Qty" := 0;

            NewLine.Remarks := 'Reject Qty';

            NewLine."Unit Cost" := 0;

            NewLine.Insert(true);
        end;

        Message(
            'Split completed.\Split Factor: %1\PO Qty: %2\Free Qty: %3\Reject Qty: %4',
            SplitFactor,
            POQtyLine,
            FreeQtyLine,
            RejectQtyLine);
    end;



}