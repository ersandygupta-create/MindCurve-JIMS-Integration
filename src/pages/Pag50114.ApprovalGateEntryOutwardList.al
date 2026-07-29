page 50114 "E3 Approval Gate Pass Outward"
{
    ApplicationArea = All;
    Caption = 'Approval Gate Pass Outward';
    PageType = List;
    Editable = false;
    //CardPageId = "E3 Gate Entry Outward Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "E3 Gate Entry Header";
    SourceTableView = sorting("Entry No.") where("Entry Type" = filter(Outward), Status = filter("Pending Approval"));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate Pass Type"; Rec."Gate Pass Type")
                {
                    ToolTip = 'Specifies the value of the Gate Pass Type field';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Purpose Description"; Rec."Purpose Description")
                {
                    ToolTip = 'Specifies the value of the Purpose Description field';
                    ApplicationArea = All;
                }
                field(Mode; Rec.Mode)
                {
                    ToolTip = 'Specifies the value of the Mode field';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                    ApplicationArea = All;
                }
                field("To Destination Code"; Rec."To Destination Code")
                {
                    ToolTip = 'Specifies the value of the To Destination field';
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field';
                    ApplicationArea = All;
                    Caption = 'Party No.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field';
                    ApplicationArea = All;
                    Caption = 'Party Name';
                }
                field(Person; Rec.Person)
                {
                    ToolTip = 'Specifies the value of the Person field';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the GRN ID field';
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the value of the Expected Return Date field';
                    ApplicationArea = All;
                }
                field("Reference Document No."; Rec."Reference Document No.")
                {
                    ToolTip = 'Specifies the value of the Reference Document No. field';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApprovalGatePass)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approval;
                ToolTip = 'Approve the Gate Pass document.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Only Gate Passes with Pending Approval status can be approved.');

                    if not Confirm('Do you want to approve this Gate Pass?', true) then
                        exit;

                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify(true);

                    Message('Gate Pass %1 has been approved.', Rec."Document No.");
                    CurrPage.Update(false);
                end;
            }
            action(RejectGatePass)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                ToolTip = 'Reject the Gate Pass document.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Only Gate Passes with Pending Approval status can be rejected.');

                    if not Confirm('Do you want to reject this Gate Pass?', true) then
                        exit;

                    Rec.Status := Rec.Status::Cancelled;
                    Rec.Modify(true);

                    Message('Gate Pass %1 has been rejected.', Rec."Document No.");
                    CurrPage.Update(false);
                end;
            }
            action(OpenRecord)
            {
                ApplicationArea = All;
                Caption = 'Open Gate Pass';
                Image = EditLines;
                ToolTip = 'Open the selected Gate Pass document.';

                trigger OnAction()
                var
                    GateEntryHeader: Record "E3 Gate Entry Header";
                begin
                    GateEntryHeader.Get(Rec."Entry No.");
                    Page.Run(Page::"E3 Gate Entry Outward Header", GateEntryHeader);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) then
            Error('User Setup does not exist for user %1.', UserId());

        if not UserSetup."Gate Pass Approval" then
            Error('You do not have permission to access the Gate Pass Approval page.');
    end;

    var
        myInt: Integer;
}