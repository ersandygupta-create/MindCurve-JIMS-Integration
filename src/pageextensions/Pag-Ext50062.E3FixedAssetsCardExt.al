pageextension 50062 "E3 HIS Fixed Assets Card" extends "Fixed Asset Card"
{
    layout

    {
        modify(FAPostingGroup)
        {
            Caption = 'Assets Item Group';
        }
        modify("FA Subclass Code")
        {
            Caption = 'Assets Item Name Group';
        }
        addafter("Serial No.")
        {
            field("Model No."; Rec."Model No.")
            {
                ApplicationArea = All;
                Caption = 'Model No.';
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the Model No. field.';
            }
        }
        addlast(Content)
        {
            group("FA Attributes")
            {
                Caption = 'JIMS Attributes';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a value BU Code field.';
                }
                field("Sub Location"; Rec."Sub Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a value Sub Location field.';
                }
                field("Assets Category Code"; Rec."Assets Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Assets Item Category Code';
                    ToolTip = 'Specifies the assets category code.';
                }
                field("Assets Category Name"; Rec."Assets Category Name")
                {
                    ApplicationArea = All;
                    Caption = 'Assets Item Category Name';
                    ToolTip = 'Specifies the assets category name.';
                    Editable = false;
                }
                field("Building Code"; Rec."Building Code")
                {
                    ApplicationArea = All;
                    Caption = 'Building Code';
                    //Editable = false;
                    ToolTip = 'Specifies the building code.';
                }
                field("Building Name"; Rec."Building Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the building name.';
                }
                field("Room/Ward No."; Rec."Room/Ward No.")
                {
                    ApplicationArea = All;
                    Caption = 'Room/Ward No.';
                    //Editable = false;
                    ToolTip = 'Specifies the room or ward number.';
                }
                field("Room/Ward Name"; Rec."Room/Ward Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Floor Name';
                    ToolTip = 'Specifies the room or ward name.';
                }
                field("Custodian ID"; Rec."Custodian ID")
                {
                    ApplicationArea = All;
                    Caption = 'Custodian ID';
                    //Editable = false;
                    ToolTip = 'Specifies the custodian ID.';
                }
                field("Custodian Name"; Rec."Custodian Name")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Staff Name';
                    Editable = false;
                    ToolTip = 'Specifies the custodian name.';
                }
                field("Name (Head of Department)"; Rec."Name (Head of Department)")
                {
                    ApplicationArea = All;
                    Caption = 'Incharge/HOD Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the head of department.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'User Department';
                    ToolTip = 'Specifies a value dept code field.';
                }
                field("Assets Name"; Rec."Assets Name")
                {
                    ApplicationArea = All;
                    Caption = 'Assets Card Name';
                    ToolTip = 'Specifies the asset name.';
                }
            }
            part("Fixed Asset Transfer List"; "E3 Fixed Asset Transfer List")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Transfer';
                SubPageLink = "Fixed Assets No" = field("No.");
                ToolTip = 'Displays transfer records for this fixed asset.';

            }
        }
        addlast(factboxes)
        {
            part(QRFactBox; "FA QR Code")
            {
                ApplicationArea = All;
                Caption = 'QR Code';
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }
}