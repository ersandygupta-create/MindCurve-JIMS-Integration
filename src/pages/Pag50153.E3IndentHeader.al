page 50153 "E3 Indent Card"
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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Indent No.';
                }

                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                }

                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
            }

            group("Dimensions")
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Business Unit';
                }
                field("Business Unit Name"; Rec."Business Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Department Code';
                }

                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            group("Location Information")
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Site Code"; Rec."Site Code")
                {
                    ApplicationArea = All;
                }

                field("Site Name"; Rec."Site Name")
                {
                    ApplicationArea = All;
                }
            }
            part(IndentLines; "E3 Indent Line Subform")
            {
                ApplicationArea = All;
                Caption = 'Indent Line Subform';
                SubPageLink = "Document No." = FIELD("Document No.");
            }
        }
    }
}