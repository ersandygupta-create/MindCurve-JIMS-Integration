pageextension 50064 "Item Ext" extends "Item Card"
{
    layout
    {
        addlast(content)
        {
            group("JIMS Attributes")
            {
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Category field.';
                }
                field("Material Category"; Rec."Material Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Meterial Category field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Model field.';
                }
                field(Strength; Rec.Strength)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Strength field.';
                }
                field("Medicine Group"; Rec."Medicine Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Group field.';
                }
                field("Rate Margin Fix"; Rec."Rate Margin Fix")
                {
                    ApplicationArea = All;
                    Caption = 'Rate/Margin Fix';
                    ToolTip = 'Specifies the value of Rate Margin Fix field.';
                }
                field("Medicine Manufacturer"; Rec."Medicine Manufacturer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Manufacturer field.';
                }
                field("Medicine Company"; Rec."Medicine Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Medicine Company field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TestField("Base Unit of Measure");
        exit(true);
    end;

}