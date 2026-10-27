page 50271 "E3 Fixed Asset Transfer List"
{
    Caption = 'Fixed Asset Transfer List';
    PageType = CardPart;
    SourceTable = "E3 Fixed Asset Transfer";
    ApplicationArea = All;
    UsageCategory = Documents;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the transfer entry number.';
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transfer date.';
                }
                field("Fixed Assets No"; Rec."Fixed Assets No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fixed asset number.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit dimension code.';
                }
                field("From FA Location Code"; Rec."From FA Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source fixed asset location code.';
                }
                field("From FA Location Name"; Rec."From FA Location Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source fixed asset location name.';
                }
                field("From Building Code"; Rec."From Building Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source building code.';
                }
                field("From Building Name"; Rec."From Building Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source building name.';
                }
                field("From Room/Ward No. Code"; Rec."From Room/Ward No. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source room or ward code.';
                }
                field("From Room/Ward No. Name"; Rec."From Room/Ward No. Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source room or ward name.';
                }
                field("To Building Code"; Rec."To Building Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination building code.';
                }
                field("To Building Name"; Rec."To Building Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination building name.';
                }
                field("To Room/Ward No. Code"; Rec."To Room/Ward No. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination room or ward code.';
                }
                field("To Room/Ward No. Name"; Rec."To Room/Ward No. Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination room or ward name.';
                }
                field("To FA Location Code"; Rec."To FA Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination fixed asset location code.';
                }
                field("To FA Location Name"; Rec."To FA Location Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination fixed asset location name.';
                }
                field("From Department"; Rec."From Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source department.';
                }
                field("To Department"; Rec."To Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination department.';
                }
                field("From Custodian Code"; Rec."From Custodian Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source custodian code.';
                }
                field("From Custodian Name"; Rec."From Custodian Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source custodian name.';
                }
                field("Name (Head of Department)"; Rec."Name (Head of Department)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the source head of department name.';
                }
                field("To Custodian Code"; Rec."To Custodian Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the destination custodian code.';
                }
                field("To Custodian Name"; Rec."To Custodian Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination custodian name.';
                }
                field("To Name (Head of Department)"; Rec."To Name (Head of Department)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the destination head of department name.';
                }
            }
        }
    }
}