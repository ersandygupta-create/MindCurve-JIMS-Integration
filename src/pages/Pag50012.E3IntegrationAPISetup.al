page 50012 "E3 Integration API Setup"
{
    ApplicationArea = All;
    Caption = 'Integration API Setup';
    PageType = Card;
    SourceTable = "E3 Integration API Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    ToolTip = 'Specifies the value of the Integration Enabled field.';
                }
                field(Username; Rec.Username)
                {
                    ToolTip = 'Specifies the value of the Username field.';
                    Visible = false;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    Visible = false;
                }
                field(Host; Rec.Host)
                {
                    ToolTip = 'Specifies the value of the Host field.';
                    Visible = false;
                }
            }
            group(API)
            {
                Caption = 'API';
                field("Item Type API"; Rec."Item Type API")
                {
                    ToolTip = 'Specifies the value of the Item Type API field.';
                }
                field("Item Type API Enabled"; Rec."Item Type API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Type API Enabled field.';
                }
                field("Item Model API"; Rec."Item Model API")
                {
                    ToolTip = 'Specifies the value of the Item Model API field.';
                }
                field("Item Model API Enabled"; Rec."Item Model API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Model API Enabled field.';
                }
                field("Item Strength API"; Rec."Item Strength API")
                {
                    ToolTip = 'Specifies the value of the Item Strength API field.';
                }
                field("Item Strength API Enabled"; Rec."Item Strength API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Strength API Enabled field.';
                }
                field("Item Property API"; Rec."Item Property API")
                {
                    ToolTip = 'Specifies the value of the Item Property API field.';
                }
                field("Item Property API Enabled"; Rec."Item Property API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Property API Enabled field.';
                }
                field("Medicine SubCat API"; Rec."Medicine SubCat API")
                {
                    ToolTip = 'Specifies the value of the Medicine SubCat API field.';
                }
                field("Medicine SubCat API Enabled"; Rec."Medicine SubCat API Enabled")
                {
                    ToolTip = 'Specifies the value of the Medicine SubCat API Enabled field.';
                }
                field("Sub Group Nature API"; Rec."Sub Group Nature API")
                {
                    ToolTip = 'Specifies the value of the Sub Group Nature API field.';
                }
                field("Sub Group Nature API Enabled"; Rec."Sub Group Nature API Enabled")
                {
                    ToolTip = 'Specifies the value of the Sub Group Nature API Enabled field.';
                }
                field("Item Category API"; Rec."Item Category API")
                {
                    ToolTip = 'Specifies the value of the Item Category API field.';
                }
                field("Item Category API Enabled"; Rec."Item Category API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Category API Enabled field.';
                }
                field("Item Make API"; Rec."Item Make API")
                {
                    ToolTip = 'Specifies the value of the Item Make API field.';
                }
                field("Item Make API Enabled"; Rec."Item Make API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Make API Enabled field.';
                }
                field("Medicine Component API"; Rec."Medicine Component API")
                {
                    ToolTip = 'Specifies the value of the Medicine Component API field.';
                }
                field("Medicine Component API Enabled"; Rec."Medicine Component API Enabled")
                {
                    ToolTip = 'Specifies the value of the Medicine Component API Enabled field.';
                }
                field("Item Speciality API"; Rec."Item Speciality API")
                {
                    ToolTip = 'Specifies the value of the Item Speciality API field.';
                }
                field("Item Speciality API Enabled"; Rec."Item Speciality API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Speciality API Enabled field.';
                }
                field("Material Category API"; Rec."Material Category API")
                {
                    ToolTip = 'Specifies the value of the Material Category API field.';
                }
                field("Material Category API Enabled"; Rec."Material Category API Enabled")
                {
                    ToolTip = 'Specifies the value of the Material Category API Enabled field.';
                }
                field("Material Type API"; Rec."Material Type API")
                {
                    ToolTip = 'Specifies the value of the Material Type API field.';
                }
                field("Material Type API Enabled"; Rec."Material Type API Enabled")
                {
                    ToolTip = 'Specifies the value of the Material Type API Enabled field.';
                }
                field("Restricted Group API"; Rec."Restricted Group API")
                {
                    ToolTip = 'Specifies the value of the Restricted Group API field.';
                }
                field("Restricted Group API Enabled"; Rec."Restricted Group API Enabled")
                {
                    ToolTip = 'Specifies the value of the Restricted Group API Enabled field.';
                }
                field("Medicine Composition API"; Rec."Medicine Composition API")
                {
                    ToolTip = 'Specifies the value of the Medicine Composition API field.';
                }
                field("Medicine Composition API Enabled"; Rec."Medi Composition API Enabled")
                {
                    ToolTip = 'Specifies the value of the Medicine Composition API Enabled field.';
                }
                field("Sub Group Site API"; Rec."Sub Group Site API")
                {
                    ToolTip = 'Specifies the value of the Sub Group Site API field.';
                }
                field("Sub Group Site API Enabled"; Rec."Sub Group Site API Enabled")
                {
                    ToolTip = 'Specifies the value of the Sub Group Site API Enabled field.';
                }
                field("Item Master API"; Rec."Item Master API")
                {
                    ToolTip = 'Specifies the value of the Item Master API Enabled field.';
                }
                field("Item Master API Enabled"; Rec."Item Master API Enabled")
                {
                    ToolTip = 'Specifies the value of the Item Master API Enabled field.';
                }
            }
        }
    }
}