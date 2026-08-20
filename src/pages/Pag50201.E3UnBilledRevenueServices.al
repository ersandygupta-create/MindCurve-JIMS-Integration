page 50201 "E3 UnBilled Service Revenue"
{
    Caption = 'Create UnBilled Service Revenue';
    PageType = List;
    SourceTable = "E3 UnBilled Service Revenue";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = sorting("Entry No.") order(descending) where(Created = filter(false));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service revenue entry number.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document Date';
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of service.';
                }
                field("GL Account Name"; Rec."GL Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account name.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }
                field("Service Category"; Rec."Service Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service category.';
                }
                field("Service Item ID"; Rec."Service Item ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service item ID.';
                }
                field("Service Item Name"; Rec."Service Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service item name.';
                }
                field("Service Item Code"; Rec."Service Item Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service item code.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service quantity.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service rate.';
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross amount.';
                }
                field("MOU Discount"; Rec."MOU Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the MOU discount amount.';
                }
                field("AddOn Discount"; Rec."AddOn Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the add-on discount amount.';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount after discounts.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location name.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created the record.';
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the record was created.';
                }
                field("Payor Code"; Rec."Payor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payor code.';
                }
                field("Payor Category"; Rec."Payor Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payor category.';
                }
                field("Payor Name"; Rec."Payor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payor name.';
                }
                field("Service Line No."; Rec."Service Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service line number.';
                }
                field("Department ID"; Rec."Department ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department ID.';
                }
                field("Facility ID"; Rec."Facility ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the facility ID.';
                }
                field("Header ID"; Rec."Header ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the header ID.';
                }
                field("Net Payable Amount"; Rec."Net Payable Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net payable amount.';
                }
                field("Validation HIS Key"; Rec."Validation HIS Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the validation key received from HIS.';
                }
                field("Reg. No."; Rec."Reg. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the registration number.';
                }
                field(UHID; Rec.UHID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique hospital identification number of the patient.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the patient.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create UnBilled Entries")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Unbilled Entries action.';
                Caption = 'Create UnBilled Entries';
                trigger OnAction();
                var
                    HISIntegration: Codeunit "E3 HIS Integration Mgmt.";
                begin
                    HISIntegration.InitGenJnlLinesUnBilledEntries();

                end;
            }
        }
    }
}