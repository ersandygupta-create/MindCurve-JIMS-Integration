page 50188 "E3 RC Discount List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 RC Discount Header";
    SourceTableView = sorting("Document No.") order(descending) where(Status = filter(Draft));
    Caption = 'Purchase Discount List';
    CardPageId = "E3 RC Discount Card";
    //Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rate contract document number.';
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
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the rate contract.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency code.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the rate contract.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the rate contract.';
                }
                field("Approve Date"; Rec."Approve Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the rate contract was approved.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who approved the rate contract.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) then
            Error('User Setup is not defined for user %1.', UserId);

        if not UserSetup."Purchase Disc Agreement" then
            Error(
                'You do not have permission to access Purchase Discount Agreement.');
    end;

}