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
                    Caption = 'Indent No.';
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
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
                field(Indentor; Rec.Indentor)
                {
                    ApplicationArea = All;
                }
                field("Approval Date Time"; Rec."Approval Date Time")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
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
                field("To Department Code"; Rec."To Department Code")
                {
                    ApplicationArea = All;
                }
                field("To Department Name"; Rec."To Department Name")
                {
                    ApplicationArea = All;
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
                    Visible = false;
                }

                field("Site Name"; Rec."Site Name")
                {
                    ApplicationArea = All;
                    Visible = false;
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