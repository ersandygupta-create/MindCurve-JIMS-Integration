page 50175 "E3 GRN Work Sheet List"
{
    PageType = List;
    SourceTable = "E3 GRN Work Sheet Header";
    Caption = 'GRN List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 GRN Work Sheet Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document ID"; Rec."Document ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique document ID.';
                }
                field("Voucher Date"; Rec."Voucher Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher date.';
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplier code.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                }
                field("OH Net Amount"; Rec."OH Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SendToDB)
            {
                Caption = 'Send Data to DB';
                Image = SendTo;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Sends the selected GRN Work Sheet to the database.';

                trigger OnAction()
                var
                    GRNWorkSheetMgmt: Codeunit "E3 GRN Work Sheet Mgmt.";
                begin
                    Rec.TestField("Document ID");

                    if not Confirm(
                         StrSubstNo('Do you want to send GRN %1 to the DB?', Rec."Document ID"))
                    then
                        exit;

                    if GRNWorkSheetMgmt.SendGRNWorkSheetDetails(Rec."Document ID") then begin
                        Message('GRN %1 has been sent successfully.', Rec."Document ID");
                        CurrPage.Update(true);
                    end else
                        Error('Failed to send GRN %1. Please check the Response field.', Rec."Document ID");
                end;
            }
        }
    }
}