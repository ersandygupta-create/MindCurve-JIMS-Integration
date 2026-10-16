page 50254 "E3 All Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Indent Line";
    Caption = 'Indent Summary';
    SourceTableView = where("PO Created" = const(false));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Document No of the indent line.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of the indent line.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the item or resource.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the description of the indent line.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure for the indent line.';
                }
                field("Indent Qty"; Rec."Indent Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity requested in the indent.';
                }
                field("Indent Approved Qty"; Rec."Indent Approved Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity approved against the indent.';
                }
                field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit of measure used for purchasing the item.';
                }
                field("Qty Per Purch. Unit of Measure"; Rec."Qty Per Purch. Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity contained in one purchase unit of measure.';
                }
                field("Requested Qty"; Rec."Requested Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the requested quantity for the purchase.';
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity approved for purchase.';
                }
                field("Short Qty Requisition"; Rec."Short Qty Requisition")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortage quantity after comparing the approved quantity with the purchase quantity.';
                }
                field("Short Qty Approved"; Rec."Short Qty Approved")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortage quantity based on the approved indent quantity.';
                }
                field("Short Qty Order"; Rec."Short Qty Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortage quantity based on the purchase order quantity.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unit cost of the item.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total amount for the indent line.';
                }
                field("Item Make Code"; Rec."Item Make Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the item make code associated with the indent line.';
                }
                field("Item Make Name"; Rec."Item Make Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the item make.';
                }
                field("Requested Received Date"; Rec."Requested Received Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the requested date for receiving the item.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies additional remarks for the indent line.';
                }
                field(IndentRemarks; Rec."Quotation Remarks")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Indent Remarks';
                    ToolTip = 'Specifies additional remarks for the indent line.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the entry number of the indent line.';
                }
                field("SNo."; Rec."SNo.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the serial number of the indent line.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the shortcut dimension code assigned to the indent line.';
                }
                field("Critical Item"; Rec."Critical Item")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the item is marked as a critical item.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Purchase Order no of indent line.';
                }
                field("Cancel Indent Remark"; Rec."Cancel Indent Remark")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Indent Remark';
                    ToolTip = 'Specifies the remark entered when the indent line is cancelled.';
                }
                field(IsSent; Rec.IsSent)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IsSent from API.';
                }
                field(Response; Rec.Response)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the field API Response.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action("Cancel Indent")
            {
                ApplicationArea = All;
                Caption = 'Cancel Indent';
                ToolTip = 'Cancel selected indent lines and enter a cancellation reason.';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                Visible = CancelIndentAllowed;

                trigger OnAction()
                var
                    SelectedIndentLine: Record "E3 Indent Line";
                    CancelIndentDialog: Page "E3 Cancel Indent Dialog";
                    CancelReason: Text[250];
                    CancellationRemark: Text;
                    CancelledCount: Integer;
                    SkippedCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedIndentLine);

                    if SelectedIndentLine.IsEmpty() then
                        Error('Please select at least one indent line.');

                    // Open popup to enter cancellation details
                    if CancelIndentDialog.RunModal() <> Action::OK then
                        exit;

                    CancelReason := CancelIndentDialog.GetCancelReason();

                    if CancelReason = '' then
                        Error('Please enter a cancellation reason.');

                    if not Confirm(
                        'Do you want to cancel all selected indent lines?',
                        false)
                    then
                        exit;

                    CancelledCount := 0;
                    SkippedCount := 0;

                    if SelectedIndentLine.FindSet(true) then
                        repeat
                            if SelectedIndentLine."Cancel Indent Remark" <> '' then
                                SkippedCount += 1
                            else begin
                                CancellationRemark :=
                                    StrSubstNo(
                                        '%1 - Indent Cancelled %2 qty',
                                        CancelReason,
                                        SelectedIndentLine."Requested Qty");

                                SelectedIndentLine."Cancel Indent Remark" :=
                                    CopyStr(
                                        CancellationRemark,
                                        1,
                                        MaxStrLen(
                                            SelectedIndentLine."Cancel Indent Remark"));

                                SelectedIndentLine.Modify(true);
                                CancelledCount += 1;
                            end;
                        until SelectedIndentLine.Next() = 0;

                    CurrPage.Update(false);

                    Message(
                        'Cancellation completed.\' +
                        'Cancelled: %1\' +
                        'Skipped (already cancelled): %2',
                        CancelledCount,
                        SkippedCount);
                end;
            }
            action("Send Data to DB")
            {
                Caption = 'Send Data to DB';
                ApplicationArea = All;
                Image = SendTo;
                Visible = CancelIndentAllowed;
                ToolTip = 'Send the selected indent lines to the Send To JIMS API.';

                trigger OnAction()
                var
                    SelectedIndentLine: Record "E3 Indent Line";
                    IndentCancelStatusMgmt: Codeunit "E3 Canceled Indent Status Mgmt";
                    SentCount: Integer;
                    FailedCount: Integer;
                    SkippedCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedIndentLine);

                    // if SelectedIndentLine."SNo." <> 0 then
                    //     Error('S.No. cannot be 0. Please select a valid indent line.');

                    if SelectedIndentLine.IsEmpty() then
                        Error('Please select at least one indent line.');

                    if not Confirm(
                        'Do you want to send the selected cancellation records to JIMS?',
                        false)
                    then
                        exit;

                    SentCount := 0;
                    FailedCount := 0;
                    SkippedCount := 0;

                    if SelectedIndentLine.FindSet() then
                        repeat
                            if (SelectedIndentLine."Cancel Indent Remark" = '') or
                               (SelectedIndentLine."SNo." = 0)
                            then
                                SkippedCount += 1
                            else
                                if IndentCancelStatusMgmt.SendIndentCancelLineDetails(
                                    SelectedIndentLine)
                                then
                                    SentCount += 1
                                else
                                    FailedCount += 1;
                        until SelectedIndentLine.Next() = 0;

                    Message(
                        'JIMS processing completed.\Successfully sent: %1\Failed: %2\Skipped (blank remark or SNo. = 0): %3',
                        SentCount,
                        FailedCount,
                        SkippedCount);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetCancelIndentVisibility();
    end;

    local procedure SetCancelIndentVisibility()
    begin
        CancelIndentAllowed := false;

        if UserSetup.Get(UserId) then
            CancelIndentAllowed := UserSetup."Cancel Indent Allowed";
    end;

    var
        UserSetup: Record "User Setup";
        CancelIndentAllowed: Boolean;
}
