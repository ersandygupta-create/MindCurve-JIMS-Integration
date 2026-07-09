page 50106 "E3Posted Gate Ent Outward List"
{
    ApplicationArea = All;
    Caption = 'Gate Entry Outward List';
    PageType = List;
    Editable = false;
    CardPageId = "E3 Posted Gate Ent Outward Hdr";
    InsertAllowed = false;
    SourceTable = "E3 Posted Gate Entry Header";
    SourceTableView = sorting("Posted Entry No.") order(descending) where("Entry Type" = filter(Outward));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gate Pass Type"; Rec."Gate Pass Type")
                {
                    ToolTip = 'Specifies the value of the Gate Pass Type field';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    Caption = 'Posted Outward No.';
                    ApplicationArea = All;
                }
                field("Posted Gate Entry Outward No."; Rec."Posted Gate Entry Outward No.")
                {
                    ToolTip = 'Posted Gate Entry Outward No.';
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ToolTip = 'Specifies the value of the Purpose Code field';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Purpose Description"; Rec."Purpose Description")
                {
                    ToolTip = 'Specifies the value of the Purpose Description field';
                    ApplicationArea = All;
                }
                field(Mode; Rec.Mode)
                {
                    ToolTip = 'Specifies the value of the Mode field';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                    ApplicationArea = All;
                }
                field("From Department Code"; Rec."From Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field';
                    ApplicationArea = All;
                    Caption = 'From Department Code';
                }
                field("From Department Name"; Rec."From Department Name")
                {
                    ToolTip = 'Specifies the value of the To Department Code field';
                    ApplicationArea = All;
                }
                field("To Destination Code"; Rec."To Destination Code")
                {
                    ToolTip = 'Specifies the value of the To Destination field';
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field';
                    ApplicationArea = All;
                    Caption = 'Party No.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field';
                    ApplicationArea = All;
                    Caption = 'Party Name';
                }
                field(Person; Rec.Person)
                {
                    ToolTip = 'Specifies the value of the Person field';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the GRN ID field';
                    ApplicationArea = All;
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies the value of the Expected Return Date field';
                    ApplicationArea = All;
                }
                field("Reference Document No."; Rec."Reference Document No.")
                {
                    ToolTip = 'Specifies the value of the Reference Document No. field';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field';
                    ApplicationArea = All;
                }
            }
        }
    }


}