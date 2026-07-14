pageextension 50085 "E3 Inventory Setup Ext" extends "Inventory Setup"
{
    layout
    {
        addlast(Numbering)
        {
            group("Master No. Series")
            {
                Caption = 'Item Master No. Series';
                field("Item Model Nos."; Rec."Item Model Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Item Model.';
                }

                field("Item Strength Nos."; Rec."Item Strength Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Item Strength.';
                }

                field("Medicine SubCategory Nos."; Rec."Medicine SubCategory Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Medicine SubCategory.';
                }

                field("Item Category Nos."; Rec."Item Category Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Item Category.';
                }

                field("Item Make Nos."; Rec."Item Make Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Item Make.';
                }

                field("Medicine Company Nos."; Rec."Medicine Company Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Medicine Company.';
                }

                field("Medicine Component Nos."; Rec."Medicine Component Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Medicine Component.';
                }

                field("Item Speciality Nos."; Rec."Item Speciality Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Item Speciality.';
                }

                field("Material Category Nos."; Rec."Material Category Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Material Category.';
                }

                field("Material Type Nos."; Rec."Material Type Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Material Type.';
                }

                field("Restricted Group Nos."; Rec."Restricted Group Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for Restricted Group.';
                }
            }
        }
    }
}