page 50107 "E3 Posted Gate Ent Outward Hdr"
{
    Caption = 'Gate Entry Outward Header';
    PageType = Document;
    DelayedInsert = true;
    RefreshOnActivate = true;
    SourceTable = "E3 Posted Gate Entry Header";
    SourceTableView = sorting("Posted Entry No.") order(descending) where("Entry Type" = Filter(Outward));
    Editable = false;


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
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field';
                    ApplicationArea = All;
                    //Visible = false;
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
                    ToolTip = 'Specifies the value of the From Department Code field';
                    ApplicationArea = All;
                }
                field("From Department Name"; Rec."From Department Name")
                {
                    ToolTip = 'Specifies the value of the From Department Name field';
                    ApplicationArea = All;
                }
                field("To Destination Code"; Rec."To Destination Code")
                {
                    ToolTip = 'Specifies the value of the To Destination Code field';
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
            part(HISPurchaseSubform; "E3Posted Gate Ent Outward Line")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Outward Document No." = FIELD("Outward Document No.");
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
}