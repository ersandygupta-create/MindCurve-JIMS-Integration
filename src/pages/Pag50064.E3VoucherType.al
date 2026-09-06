page 50064 "E3 Voucher Types"
{
    ApplicationArea = BasicEU, BasicNO;
    Caption = 'Voucher Types';
    PageType = List;
    SourceTable = "E3 Voucher Type";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code that identifies the voucher type.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the voucher type.';
                }
                field("Order Nos."; Rec."Order Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used to automatically assign order numbers for this voucher type.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value of the Entry Type.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                    ToolTip = 'Specifies the item type for the voucher.';
                }
                field("Item Type Name"; Rec."Item Type Name")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the selected item type.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Caption = 'Responsibility Center';
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortcut dimension 1 code.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("GRN Voucher Type Code"; Rec."GRN Voucher Type Code")
                {
                    ApplicationArea = All;
                    Caption = 'GRN Voucher Type Code';
                    ToolTip = 'Specifies the voucher type code used for the goods receipt note.';
                }
                field("GRN Voucher Type Name"; Rec."GRN Voucher Type Name")
                {
                    ApplicationArea = All;
                    Caption = 'GRN Voucher Type Name';
                    Editable = true;
                    ToolTip = 'Specifies the name of the selected GRN voucher type.';
                }
                field("Print Caption"; Rec."Print Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Print Caption.';
                }
                field(Sync; Rec.Sync)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the voucher type is synchronized with the external system.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Purchase Resp. Ctr. Filter" <> '' then
                Rec.SetFilter(
                    "Responsibility Center",
                    UserSetup."Purchase Resp. Ctr. Filter");
    end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     Rec.TestField("GRN Voucher Type Name");
    // end;
}