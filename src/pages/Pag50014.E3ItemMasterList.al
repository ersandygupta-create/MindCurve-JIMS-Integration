page 50014 "E3 Item Master List"
{
    ApplicationArea = All;
    Caption = 'Item List';
    PageType = List;
    Editable = true;
    SourceTable = "E3 HIS Master Staging";
    SourceTableView = SORTING("Entry No.")
                      WHERE("Party Type" = FILTER('Item Master'),
                            IsCreated = FILTER(false));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ItemType; Rec."Item Type 1")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                    ToolTip = 'Specifies the Item Type.';

                    trigger OnValidate()
                    begin
                        SetFieldEditability();
                        CurrPage.Update(false);
                    end;
                }
                field("Material Category"; Rec."Material Category")
                {
                    ApplicationArea = All;
                    Caption = 'Material Category';
                    Editable = MaterialCategoryEditable;
                    ToolTip = 'Specifies the Material Category.';
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Display Name';
                    Editable = NameEditable;
                    ToolTip = 'Specifies the Display Name.';
                }

                field(Strength; Rec.Strength)
                {
                    ApplicationArea = All;
                    Caption = 'Strength';
                    Editable = StrengthEditable;
                    ToolTip = 'Specifies the Strength.';
                }

                field("Material Type"; Rec."Material Type")
                {
                    ApplicationArea = All;
                    Editable = MaterialTypeEditable;
                    ToolTip = 'Specifies the Material Type.';
                }

                field(Specification; Rec.Specification)
                {
                    ApplicationArea = All;
                    Editable = SpecificationEditable;
                    ToolTip = 'Specifies the Specification.';
                }

                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    Editable = ModelEditable;
                    ToolTip = 'Specifies the Model.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Item';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    HISIntegration: Codeunit "E3 HIS Integration Mgmt.";
                    HisMasterStaging: Record "E3 HIS Master Staging";
                begin
                    CurrPage.SetSelectionFilter(HisMasterStaging);

                    if HisMasterStaging.FindSet() then
                        repeat
                            HISIntegration.InitItemMaster1(HisMasterStaging."Entry No.");

                        until HisMasterStaging.Next() = 0;

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetFieldEditability();
    end;

    trigger OnAfterGetRecord()
    begin
        SetFieldEditability();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetFieldEditability();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Party Type" := Rec."Party Type"::"Item Master";
        SetFieldEditability();
    end;

    var
        MaterialCategoryEditable: Boolean;
        NameEditable: Boolean;
        StrengthEditable: Boolean;
        MaterialTypeEditable: Boolean;
        SpecificationEditable: Boolean;
        ModelEditable: Boolean;

    local procedure SetFieldEditability()
    begin
        if UpperCase(Format(Rec."Item Type 1")) = 'PHARMACY' then begin
            // Pharmacy
            MaterialCategoryEditable := true;
            NameEditable := true;
            StrengthEditable := true;

            MaterialTypeEditable := false;
            SpecificationEditable := false;

            ModelEditable := true;
        end else begin
            // Other than Pharmacy
            MaterialCategoryEditable := true;
            NameEditable := false;
            StrengthEditable := false;

            MaterialTypeEditable := true;
            SpecificationEditable := true;

            ModelEditable := true;
        end;
    end;
}