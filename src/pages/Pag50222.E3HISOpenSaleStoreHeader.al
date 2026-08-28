page 50222 "E3 HIS Release Indent Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "E3 Indent Header";
    Caption = 'Release Indent Header Card';

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
            part(IndentLines; "E3 HIS Release Indent Line")
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
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Release the approved HIS indent.';

                trigger OnAction()
                var
                    IndentLine: Record "E3 Indent Line";
                    CheckIndentLine: Record "E3 Indent Line";
                    TotalLines: Integer;
                    CompletedLines: Integer;
                    ReleasedSalesLines: Integer;
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    IndentLine.Reset();
                    IndentLine.SetRange(
                        "Document No.",
                        Rec."Document No.");
                    IndentLine.SetRange("Select", true);

                    if not IndentLine.FindSet() then begin
                        Message('Please select at least one line.');
                        exit;
                    end;

                    repeat
                        if not IndentLine."Released Stock Issue Purchase" then begin
                            IndentLine."Released Stock Issue" := true;

                            IndentLine."Sales Released" := true;

                            ReleasedSalesLines += 1;
                        end;

                        IndentLine."Select" := false;

                        IndentLine.Modify(true);

                    until IndentLine.Next() = 0;

                    CheckIndentLine.Reset();
                    CheckIndentLine.SetRange("Document No.", Rec."Document No.");

                    TotalLines := 0;
                    CompletedLines := 0;

                    if CheckIndentLine.FindSet() then
                        repeat
                            TotalLines += 1;

                            if CheckIndentLine."Released Stock Issue" and
                               CheckIndentLine."Released Stock Issue Purchase"
                            then
                                CompletedLines += 1;

                        until CheckIndentLine.Next() = 0;
                    if ReleasedSalesLines > 0 then
                        Rec."Sales Released" := true;
                    if (TotalLines > 0) and
                       (CompletedLines = TotalLines)
                    then
                        Rec."Closed Stock Issue" := true
                    else
                        Rec."Closed Stock Issue" := false;


                    Rec.Modify(true);
                    if CompletedLines < TotalLines then
                        Message(
                            '%1 Stock Sale line(s) released. %2 line(s) are still pending. Indent is not closed.',
                            ReleasedSalesLines,
                            TotalLines - CompletedLines)
                    else
                        Message(
                            'All Stock Issue lines have both Stock Issue and Purchase releases. Indent %1 has been closed.',
                            Rec."Document No.");


                    CurrPage.Update(false);
                end;
            }


            action(ReleaseForIndentsPurchase)
            {
                ApplicationArea = All;
                Caption = 'Release for Indents Purchase';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Release the indent for purchase processing.';

                trigger OnAction()
                var
                    IndentLine: Record "E3 Indent Line";
                    CheckIndentLine: Record "E3 Indent Line";
                    SelectedLines: Integer;
                    TotalLines: Integer;
                    CompletedLines: Integer;
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    IndentLine.Reset();
                    IndentLine.SetRange(
                        "Document No.",
                        Rec."Document No.");
                    IndentLine.SetRange("Select", true);

                    if not IndentLine.FindSet() then begin
                        Message(
                            'Please select at least one indent line for Purchase.');
                        exit;
                    end;

                    repeat
                        IndentLine."Released Stock Issue Purchase" := true;

                        // Clear selection after processing
                        IndentLine."Select" := false;

                        IndentLine.Modify(true);

                        SelectedLines += 1;

                    until IndentLine.Next() = 0;
                    Rec."Relese for Purchase" := true;
                    CheckIndentLine.Reset();
                    CheckIndentLine.SetRange("Document No.", Rec."Document No.");

                    TotalLines := 0;
                    CompletedLines := 0;

                    if CheckIndentLine.FindSet() then
                        repeat
                            TotalLines += 1;

                            if CheckIndentLine."Released Stock Issue" and
                               CheckIndentLine."Released Stock Issue Purchase"
                            then
                                CompletedLines += 1;

                        until CheckIndentLine.Next() = 0;

                    if (TotalLines > 0) and
                       (CompletedLines = TotalLines)
                    then
                        Rec."Closed Stock Issue" := true
                    else
                        Rec."Closed Stock Issue" := false;


                    Rec.Modify(true);

                    if CompletedLines < TotalLines then
                        Message(
                            '%1 selected indent line(s) have been released for Purchase. %2 line(s) are still pending. Indent is not closed.',
                            SelectedLines,
                            TotalLines - CompletedLines)
                    else
                        Message(
                            '%1 selected indent line(s) have been released for Purchase. All Stock Issue lines are now completed and the indent is closed.',
                            SelectedLines);


                    CurrPage.Update(false);
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


}