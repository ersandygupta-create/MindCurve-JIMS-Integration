page 50183 "E3 Rate Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "E3 Rate Contract Header";
    Caption = 'Purchase Price Card';

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
                field("RC Type"; Rec."RC Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of rate contract.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the rate contract.';
                }
                field("Make / Supplier"; Rec."Make / Supplier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the rate contract is for a make or supplier.';
                    trigger OnValidate()
                    begin
                        if Rec."Make / Supplier" = Rec."Make / Supplier"::Make then begin
                            Clear(Rec."Vendor Code");
                            Clear(Rec."Vendor Name");
                        end;

                        if Rec."Make / Supplier" = Rec."Make / Supplier"::Supplier then begin
                            Clear(Rec."Make Code");
                            Clear(Rec."Make Name");
                        end;

                        SetFieldProperties();
                        CurrPage.Update(false);

                    end;
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    Visible = VendorVisible;
                    Editable = VendorEditable;
                    ToolTip = 'Specifies the vendor code.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Visible = VendorVisible;
                    Editable = false;
                    ToolTip = 'Specifies the vendor name.';
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                    Visible = MakeVisible;
                    Editable = MakeEditable;
                    ToolTip = 'Specifies the make code.';
                }
                field("Make Name"; Rec."Make Name")
                {
                    ApplicationArea = All;
                    Visible = MakeVisible;
                    Editable = false;
                    ToolTip = 'Specifies the make name.';
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
            part(Lines; "E3 Rate Contract Subpage")
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
    var
        VendorVisible: Boolean;
        VendorEditable: Boolean;
        MakeVisible: Boolean;
        MakeEditable: Boolean;


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Date" := WorkDate();
    end;

    trigger OnOpenPage()
    begin
        SetFieldProperties();
    end;

    trigger OnAfterGetRecord()
    begin
        SetFieldProperties();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetFieldProperties();
    end;

    local procedure SetFieldProperties()
    begin
        case Rec."Make / Supplier" of
            Rec."Make / Supplier"::Make:
                begin
                    // Make selected
                    VendorVisible := false;
                    VendorEditable := false;

                    MakeVisible := true;
                    MakeEditable := true;
                end;

            Rec."Make / Supplier"::Supplier:
                begin
                    // Supplier selected
                    VendorVisible := true;
                    VendorEditable := true;

                    MakeVisible := false;
                    MakeEditable := false;
                end;

            else begin
                // Default
                VendorVisible := false;
                VendorEditable := false;

                MakeVisible := false;
                MakeEditable := false;
            end;
        end;
    end;

}