page 50167 "E3 HIS Indent Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "E3 Indent Header";
    Caption = 'Indent Header';

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
            part(IndentLines; "E3 HIS Indent Line Subform")
            {
                ApplicationArea = All;
                Caption = 'Indent Line Subform';
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
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                Image = Approval;

                action(SendApproval)
                {
                    Caption = 'Send Approval Request';
                    ApplicationArea = All;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ShowApprovalActions;

                    trigger OnAction()
                    var
                        IndentApproval: Codeunit "E3 Indent Approval Mgmt.";
                        IndentLine: Record "E3 Indent Line";
                    begin
                        IndentLine.SetRange("Document No.", Rec."Document No.");

                        if IndentLine.FindSet() then
                            repeat
                                if IndentLine."Requested Qty" <= 0 then
                                    Error(
                                      'Requested Qty must be greater than 0 for Line No. %1.',
                                      IndentLine."Line No.");

                                if IndentLine."Approved Qty" <= 0 then
                                    Error(
                                      'Approved Qty must be greater than 0 for Line No. %1.',
                                      IndentLine."Line No.");
                            until IndentLine.Next() = 0;

                        IndentApproval.OnSendIndentDocForApproval(Rec);

                        CurrPage.Update(true);
                    end;
                }

                action(CancelApproval)
                {
                    Caption = 'Cancel Approval Request';
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ShowApprovalActions;

                    trigger OnAction()
                    var
                        IndentApproval: Codeunit "E3 Indent Approval Mgmt.";
                    begin
                        IndentApproval.OnCancelIndentApprovalRequest(Rec);
                        CurrPage.Update(true);
                    end;
                }
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

                    Rec.Status := Rec.Status::Open; // Change to your initial status if different
                    Rec."Approved By" := '';
                    Rec."Approval Date Time" := 0DT;
                    Rec.Modify(true);

                    CurrPage.Update(true);

                    Message('Indent %1 has been reopened successfully.', Rec."Document No.");
                end;
            }
            action(ApprovalEntries)
            {
                Caption = 'Approval Entries';
                ApplicationArea = All;
                Image = ApprovalEntries;
                RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD("Document No.");
                RunPageView = sorting("Document No.")
                          order(Ascending)
                          where("Table ID" = const(50051));
            }
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release for Store Purchase';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowReleaseActions;
                ToolTip = 'Release the approved HIS indent.';

                trigger OnAction()
                var
                    IndentLine: Record "E3 Indent Line";
                    IndentLineToUpdate: Record "E3 Indent Line";
                    AllLinesCreated: Boolean;
                begin
                    Rec.TestField(Status, Rec.Status::Approved);

                    Rec."Relese for Purchase" := true;

                    // Selected pending lines
                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");
                    IndentLine.SetRange(Select, true);
                    IndentLine.SetRange("Stock Receipt Created", false);

                    if IndentLine.IsEmpty() then
                        Error(
                            'Please select at least one pending line for Stock Receipt.');

                    // Create Stock Receipt for selected lines
                    if IndentLine.FindSet(true) then
                        repeat
                            IndentLineToUpdate.Reset();
                            IndentLineToUpdate.SetRange("Document No.", IndentLine."Document No.");
                            IndentLineToUpdate.SetRange("Line No.", IndentLine."Line No.");

                            if IndentLineToUpdate.FindFirst() then begin
                                IndentLineToUpdate."Stock Receipt Created" := true;
                                IndentLineToUpdate.Select := false;
                                IndentLineToUpdate.Modify(false);
                            end;

                        until IndentLine.Next() = 0;
                    AllLinesCreated := true;

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");

                    if IndentLine.FindSet() then
                        repeat
                            if not IndentLine."Stock Receipt Created" then
                                AllLinesCreated := false;
                        until IndentLine.Next() = 0;

                    if AllLinesCreated then begin
                        Rec."HIS Approved Indent Closed" := true;
                        Rec.Modify(true);

                        Message(
                            'All lines are completed. Indent %1 is now closed.',
                            Rec."Document No.");
                    end
                    else begin
                        Rec."HIS Approved Indent Closed" := false;
                        Rec.Modify(true);

                        Message(
                            'Stock Receipt created for the selected lines of Indent %1. ' +
                            'Some lines are still pending.',
                            Rec."Document No.");
                    end;

                    CurrPage.Update(false);
                end;

            }
            action(ReleaseStockIssue)
            {
                ApplicationArea = All;
                Caption = 'Release for Stock Issue';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowReleaseActions;
                ToolTip = 'Release the approved HIS indent.';

                trigger OnAction()
                var
                    IndentLine: Record "E3 Indent Line";
                    IndentLineToUpdate: Record "E3 Indent Line";
                    AllLinesCreated: Boolean;
                begin
                    Rec.TestField(Status, Rec.Status::Approved);

                    Rec."Relese for Store" := true;

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");
                    IndentLine.SetRange(Select, true);
                    IndentLine.SetRange("Stock Issue Created", false);

                    if IndentLine.IsEmpty() then
                        Error(
                            'Please select at least one pending line for Stock Issue.');

                    if IndentLine.FindSet(true) then
                        repeat
                            IndentLineToUpdate.Reset();
                            IndentLineToUpdate.SetRange("Document No.", IndentLine."Document No.");
                            IndentLineToUpdate.SetRange("Line No.", IndentLine."Line No.");

                            if IndentLineToUpdate.FindFirst() then begin
                                IndentLineToUpdate."Stock Issue Created" := true;
                                IndentLineToUpdate.Select := false;

                                // Use false if OnModify is resetting the Boolean
                                IndentLineToUpdate.Modify(false);
                            end;

                        until IndentLine.Next() = 0;

                    AllLinesCreated := true;

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");

                    if IndentLine.FindSet() then
                        repeat
                            if not IndentLine."Stock Issue Created" then begin
                                AllLinesCreated := false;
                                exit;
                            end;
                        until IndentLine.Next() = 0;


                    Rec."HIS Approved Indent Closed" := AllLinesCreated;

                    Rec.Modify(true);

                    Message(
                        'Stock Issue created for the selected lines of Indent %1.',
                        Rec."Document No.");

                    CurrPage.Update(false);
                end;


            }
        }
    }
    var
        IsPageEditable: Boolean;
        IsEditable: Boolean;
        ShowApprovalActions: Boolean;
        ShowReleaseActions: Boolean;

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
        ShowReleaseActions := Rec.Status = Rec.Status::Approved;
    end;


}