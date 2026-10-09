
page 50247 "E3 Posted Pharmacy Sales List"
{
    PageType = List;
    Caption = 'Pharmacy Sales List';
    SourceTable = "E3 Pharmacy Sale Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "E3 Pharmacy Sales Card";
    Editable = false;
    SourceTableView = where("Is Posted" = filter(true));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the internal entry number.';
                }
                field("Entry Number"; Rec."Entry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pharmacy sales entry reference.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                }
                field("Document Number"; Rec."Document Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pharmacy bill number.';
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill date.';
                }
                field("Patient UHID"; Rec."Patient UHID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient UHID.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient name.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                }
                field("OH Amt Net"; Rec."OH Amt Net")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net bill amount.';
                }
                field("Is Created"; Rec."Is Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record has been created.';
                }
                field("Is Posted"; Rec."Is Posted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record has been posted.';
                }
            }
        }
    }
}