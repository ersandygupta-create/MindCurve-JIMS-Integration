page 50134 "E3 Gate Entry Outward Header"
{
    Caption = 'Gate Entry Outward Header';
    PageType = Document;
    DelayedInsert = true;
    RefreshOnActivate = true;
    SourceTable = "E3 Gate Entry Header";
    SourceTableView = sorting("Entry No.") where("Entry Type" = Filter(Outward));


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
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
                    Editable = false;
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field';
                    ApplicationArea = All;
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
                field("From Department Code"; Rec."From Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field';
                    ApplicationArea = All;
                    Caption = 'From Department Code';
                }
                field("From Department Name"; Rec."From Department Name")
                {
                    ToolTip = 'Specifies the value of the To Department Code field';
                    ApplicationArea = All;
                }
                field("To Destination Code"; Rec."To Destination Code")
                {
                    ToolTip = 'Specifies the value of the To Destination field';
                    ApplicationArea = All;
                    Caption = 'To Destination Code';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                }
                field("To Destination Name"; Rec."To Destination Name")
                {
                    ToolTip = 'Specifies the value of the To Destination Name field';
                    ApplicationArea = All;
                    Caption = 'To Destination Name';
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
                    Editable = false;
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
            part(HISPurchaseSubform; "E3 Gate Entry Outward Subform")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = FIELD("Document No.");
                Caption = 'Gate Entry Outward Line';
            }
        }
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"E3 Gate Entry Header"), "No." = field("Document No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Ship)
            {
                Caption = 'Ship';
                Image = Shipment;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    GateTransfer: Codeunit "E3 Gate Entry Transfer";
                    Inward: Boolean;
                    PurchPaybleSetup: Record "Purchases & Payables Setup";
                    GateEntryHeader: Record "E3 Gate Entry Header";
                begin
                    if Rec.Status <> Rec.Status::Approved then
                        Error('You can ship only when the Gate Pass status is Approved.');

                    PurchPaybleSetup.Get();
                    PurchPaybleSetup.TestField("Posted Gate Entry Outward No.");

                    Inward := true;

                    if Rec."Gate Pass Type" = Rec."Gate Pass Type"::"Non-Returnable" then begin
                        Message('Inward cannot be created for Gate Pass Type Non-Returnable.');
                        Inward := false;
                    end;

                    // Print Posted Gate Pass
                    GateEntryHeader.Reset();
                    GateEntryHeader.SetRange("Entry No.", Rec."Entry No."); // Change field if required

                    if GateEntryHeader.FindLast() then
                        Report.RunModal(
                            Report::"Gate OutWard Print",
                            false,
                            false,
                            GateEntryHeader);
                    // Post Gate Pass
                    GateTransfer.PostOutwardGateEntry(Rec, Inward);


                end;
            }
            action(SendApproval)
            {
                Caption = 'Send Approval';
                Image = SendApprovalRequest;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Send the Gate Pass for approval.';

                trigger OnAction()
                begin
                    if (Rec.Status <> Rec.Status::Open) and
                       (Rec.Status <> Rec.Status::Cancelled) then
                        Error('Only Open or Cancelled documents can be sent for approval.');

                    if not Confirm('Do you want to send this Gate Pass for approval?', true) then
                        exit;

                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.Modify(true);

                    Message('Gate Pass has been sent for approval.');
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        ResponsibiltyCenter: Record "Responsibility Center";
    begin
        Rec."Posting Date" := WorkDate();
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId());
        If UserSetup.Find('-') then begin
            ResponsibiltyCenter.Reset();
            ResponsibiltyCenter.SetRange(Code, UserSetup."Purchase Resp. Ctr. Filter");
            if ResponsibiltyCenter.Find('-') then;
        end;
        Rec."Entry Type" := Rec."Entry Type"::Outward;
        PurchasesPayablesSetup.Get();
        PurchasesPayablesSetup.TestField("Gate Entry Nos.");

        Rec."No. Series" := PurchasesPayablesSetup."Gate Entry Nos.";
        Rec."Document No." := NoSeries.GetNextNo(Rec."No. Series", WorkDate(), true);
        Rec."Shortcut Dimension 1 Code" := ResponsibiltyCenter."Global Dimension 1 Code";
    end;

}