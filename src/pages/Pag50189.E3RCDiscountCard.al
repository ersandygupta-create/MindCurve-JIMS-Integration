page 50189 "E3 RC Discount Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "E3 RC Discount Header";
    Caption = 'Purchase Discount Card';
    // InsertAllowed = false;
    // ModifyAllowed = false;
    // DelayedInsert = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate contract document number.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the rate contract.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the rate contract.';
                }
                field(Supplier; Rec.Supplier)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the rate contract is for a make or supplier.';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the vendor name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the status of the rate contract.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency code.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the rate contract.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the rate contract.';
                }
                field("Approve Date"; Rec."Approve Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the approval date of the rate contract.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the user who approved the rate contract.';
                }
            }
            part(Lines; "E3 RC Discount Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                ToolTip = 'Approves the rate contract.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Active;
                    Rec."Approve Date" := WorkDate();
                    Rec."Approved By" := CopyStr(UserId(), 1, MaxStrLen(Rec."Approved By"));
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Date" := WorkDate();
    end;
}