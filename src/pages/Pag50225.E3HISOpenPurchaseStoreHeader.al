page 50225 "E3 HIS Receipt Indent Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "E3 Indent Header";
    Caption = 'Receipt Indent Header Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = IsEditable;
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Indent No.';
                    ApplicationArea = All;
                    AssistEdit = true;
                    Editable = IsPageEditable;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Type of the field.';
                    Visible = false;
                }
                field("Indentor Code"; Rec."Indenter Code")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field("Indenter Name"; Rec."Indenter Name")
                {
                    ApplicationArea = All;
                }
                field("Requested To"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }

                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Prepared Date"; Rec."Prepared Date")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                    trigger OnValidate()
                    begin
                        if Rec."Request Date" = 0D then
                            Error('Request Date must be entered before Prepared Date.');

                        if Rec."Prepared Date" < Rec."Request Date" then
                            Error(
                                'Prepared Date (%1) cannot be earlier than Request Date (%2).',
                                Rec."Prepared Date",
                                Rec."Request Date");
                    end;
                }
                field("Voucher Type Code"; Rec."Voucher Type Code")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field("Voucher Type Name"; Rec."Voucher Type Name")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field("Approval Date Time"; Rec."Approval Date Time")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
            }

            group("Dimensions")
            {
                Editable = IsEditable;
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Business Unit';
                    Editable = IsPageEditable;
                }
                field("Business Unit Name"; Rec."Business Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                    Caption = 'Department Code';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Department Code"; Rec."To Department Code")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field("To Department Name"; Rec."To Department Name")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }

                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Location Code"; Rec."To Location Code")
                {
                    ApplicationArea = All;
                    Editable = IsPageEditable;
                }

                field("To Location Name"; Rec."To Location Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(IndentLines; "E3 HIS Issue Indent Line")
            {
                ApplicationArea = All;
                Caption = 'Release Indent Line Subform';
                Editable = IsEditable;
                SubPageLink = "Document No." = FIELD("Document No.");
            }
        }
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"E3 Indent Header"), "No." = field("Document No.");
            }
            systempart(Control1000000050; Notes)
            {
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Prepare)
            {
                ApplicationArea = All;
                Caption = 'Prepare';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepares the selected indent lines for creating a purchase order.';

                trigger OnAction()
                begin
                    //PrepareIndent();
                end;
            }
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Release the approved HIS indent.';

                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    SelectAllIndentLines();
                    ValidateIndentPurchasePrice();
                    SplitIndentSchemeLines();
                    Rec."Purchase Released" := true;
                    Rec."Closed Purchase Receipt" := true;
                    Rec.Modify(true);
                    UpdateIndentLinesAfterRelease();

                    Message(
                        'Indent %1 has been marked as Released.',
                        Rec."Document No.");

                    CurrPage.Update(false);
                end;

            }

            action(ReopenIndent)
            {
                Caption = 'Reopen Indent';
                ApplicationArea = All;
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                Visible = Rec.Status = Rec.Status::Approved;
                ToolTip = 'Reopens the approved indent for modification.';

                trigger OnAction()
                begin
                    if not Confirm('Do you want to reopen this approved indent?', false) then
                        exit;

                    Rec."Relese for Store" := false;
                    Rec."Relese for Purchase" := false;
                    Rec.Released := false;
                    Rec.Modify(true);

                    CurrPage.Update(true);

                    Message('Indent %1 has been reopened, successfully.', Rec."Document No.");
                end;
            }
        }
    }
    var
        IsPageEditable: Boolean;
        IsEditable: Boolean;
        ShowApprovalActions: Boolean;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Request Date" := WorkDate();
        Rec."Source Type" := Rec."Source Type"::HIS
    end;

    trigger OnOpenPage()
    var
    begin
        Rec."Source Type" := "E3 Indent Source Type"::HIS;
        IsEditable := Rec.Status <> Rec.Status::Approved;
        SetPageEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetPageEditable();
    end;

    local procedure SetPageEditable()
    begin
        IsPageEditable :=
        (Rec.Status <> Rec.Status::"Pending Approval") and
        (Rec.Status <> Rec.Status::Approved) and
        (not Rec."Short Close Indent");

        IsEditable := IsPageEditable;

        ShowApprovalActions := Rec.Status <> Rec.Status::Approved;
    end;

    local procedure SelectAllIndentLines()
    var
        IndentLine: Record "E3 Indent Line";
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."Document No.");
        if IndentLine.FindSet() then
            repeat
                if not IndentLine.Select then begin
                    IndentLine.Select := true;
                    IndentLine.Modify(true);
                end;
            until IndentLine.Next() = 0;
    end;

    local procedure ValidateIndentPurchasePrice()
    var
        RCLine: Record "E3 Rate Contract Line";
        IndentLine: Record "E3 Indent Line";
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

    local procedure SplitIndentSchemeLines()
    var
        IndentLine: Record "E3 Indent Line";
        LineToSplit: Record "E3 Indent Line";
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."Document No.");
        IndentLine.SetRange(Select, true);
        IndentLine.SetRange("Split Line", false);

        if IndentLine.FindSet() then
            repeat
                if IndentLine.Scheme <> '' then begin
                    LineToSplit := IndentLine;
                    SplitOneIndentLine(LineToSplit);

                    IndentLine.Get(IndentLine."Document No.", IndentLine."Line No.");
                    IndentLine."Split Line" := true;
                    IndentLine.Modify(true);
                end;

            until IndentLine.Next() = 0;
    end;

    local procedure SplitOneIndentLine(
    var IndentLine: Record "E3 Indent Line")
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
        ApprovedQty := IndentLine."Approved Qty";
        FreeQty := IndentLine."Free Qty";
        POQty := IndentLine."PO Qty";

        if ApprovedQty <= 0 then
            Error('Approved Qty must be greater than zero for Item %1.',
                IndentLine."No.");

        if (POQty + FreeQty) <= 0 then
            Error('PO Qty + Free Qty must be greater than zero for Item %1.',
                IndentLine."No.");

        SplitFactor := Round(ApprovedQty / (POQty + FreeQty), 1, '<');
        //ak
        if SplitFactor < 1 then begin
            IndentLine.Remarks := 'Reject Qty';
            IndentLine.Modify(true);
            exit;
        end;//ak

        POQtyLine := SplitFactor * POQty;
        FreeQtyLine := SplitFactor * FreeQty;
        RejectQtyLine := ApprovedQty - POQtyLine - FreeQtyLine;

        if RejectQtyLine < 0 then
            Error('Reject Qty cannot be negative.\' + 'Approved Qty: %1\' + 'PO Qty: %2\' + 'Free Qty: %3',
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
        NewLine.Select := false;
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
        NewLine.Select := false;

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
            NewLine.Select := false;
            NewLine.Validate("Requested Qty", RejectQtyLine);
            NewLine.Validate("Approved Qty", RejectQtyLine);
            NewLine."PO Qty" := 0;
            NewLine."Free Qty" := 0;
            NewLine.Remarks := 'Reject Qty';
            NewLine."Unit Cost" := 0;

            NewLine.Insert(true);
        end;
    end;

    local procedure UpdateIndentLinesAfterRelease()
    var
        IndentLine: Record "E3 Indent Line";
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."Document No.");
        if IndentLine.FindSet() then
            repeat
                IndentLine."Purchase Released" := Rec."Purchase Released";
                if IndentLine.Scheme = '' then
                    IndentLine.Remarks := 'PO Qty';
                IndentLine.Modify(true);
            until IndentLine.Next() = 0;
    end;
}