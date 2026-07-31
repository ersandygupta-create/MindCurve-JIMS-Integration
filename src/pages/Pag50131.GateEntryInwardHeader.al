page 50131 "E3 Gate Entry Inward Header"
{
    Caption = 'Gate Entry Inward Header';
    PageType = Document;
    DelayedInsert = false;
    RefreshOnActivate = true;
    SourceTable = "E3 Gate Entry Header";
    SourceTableView = sorting("Entry No.") where("Entry Type" = Filter(Inward));


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
                    Caption = 'To Destination';
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
                    Caption = 'Party Code';
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
                    Editable = false;
                    Visible = true;
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the value of the Expected Return Date field';
                    ApplicationArea = All;
                }
                field("Posted Gate Entry Outward No."; Rec."Posted Gate Entry Outward No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted Gate Entry Outward No. field';
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
            part(HISPurchaseSubform; "E3 Gate Entry Inward Subform")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = FIELD("Document No.");
                Caption = 'Gate Entry Inward Line';
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
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Po&st")
                {
                    Caption = 'Po&st';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        GateTransfer: Codeunit "E3 Gate Entry Transfer";
                        PurchPaybleSetup: Record "Purchases & Payables Setup";
                        PostedGateEntryHeader: Record "E3 Gate Entry Header";
                        Inward: Boolean;
                    begin
                        // Validate Status
                        Rec.TestField(Status, Rec.Status::Approved);

                        PurchPaybleSetup.Get();
                        PurchPaybleSetup.TestField("Posted Gate Entry Inward No.");

                        Inward := true;

                        if Rec."Gate Pass Type" = Rec."Gate Pass Type"::"Non-Returnable" then begin
                            Message('Inward cannot be created for Gate Pass Type Non-Returnable.');
                            Inward := false;
                        end;

                        // Print Posted Inward Gate Entry
                        PostedGateEntryHeader.Reset();
                        PostedGateEntryHeader.SetRange("Entry No.", Rec."Entry No.");

                        if PostedGateEntryHeader.FindLast() then
                            Report.RunModal(
                                Report::"E3 Gate Inward Print",
                                false,
                                false,
                                PostedGateEntryHeader);

                        // Post Inward Gate Entry
                        GateTransfer.PostOutwardGateEntry(Rec, Inward);


                        CurrPage.Close();
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Rec."Entry Type" := Rec."Entry Type"::Inward;

    end;

}