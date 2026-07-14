page 50014 "E3 Item Master List"
{
    ApplicationArea = All;
    Caption = 'Item List';
    PageType = List;
    DelayedInsert = true;
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
                field(ItemType; Rec."Item Type 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                    ToolTip = 'Specifies the Item Type.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        SetFieldEditability();
                        CurrPage.Update(false);
                    end;
                }
                field("Material Category"; Rec."Material Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Material Category';
                    Editable = MaterialCategoryEditable;
                    ToolTip = 'Specifies the Material Category.';
                }

                field("Display Name"; Rec."Display Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    Editable = NameEditable;
                    ToolTip = 'Specifies the Display Name.';
                }

                field(Strength; Rec."Strength Code")
                {
                    ApplicationArea = All;
                    Caption = 'Strength';
                    Editable = StrengthEditable;
                    ToolTip = 'Specifies the Strength.';
                }

                field("Material Type Code"; Rec."Material Type Code")
                {
                    ApplicationArea = All;
                    Editable = MaterialTypeEditable;
                    ToolTip = 'Specifies the Material Type.';
                }

                field(Specification; Rec."Specification Code")
                {
                    ApplicationArea = All;
                    Editable = SpecificationEditable;
                    ToolTip = 'Specifies the Specification.';
                }

                field(Model; Rec."Model Code")
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
                    Item: Record Item;
                    NewItemDesc: Text;
                begin
                    CurrPage.SetSelectionFilter(HisMasterStaging);

                    if HisMasterStaging.FindSet() then
                        repeat
                            // Build Item Description
                            if UpperCase(Format(HisMasterStaging."Item Type 1 Name")) = 'PHARMACY' then
                                NewItemDesc :=
                                    HisMasterStaging."Material Category Name" + '-' +
                                    HisMasterStaging."Display Name" + '-' +
                                    HisMasterStaging."Strength Name" + '-' +
                                    HisMasterStaging."Model Name"
                            else
                                NewItemDesc :=
                                    HisMasterStaging."Material Category Name" + '-' +
                                    HisMasterStaging."Material Type Name" + '-' +
                                    HisMasterStaging."Specification Name" + '-' +
                                    HisMasterStaging."Model Name";

                            // Validate duplicate description
                            Item.Reset();
                            Item.SetRange(Description, NewItemDesc);
                            if Item.FindFirst() then
                                Error(
                                    'Item Description "%1" already exists in Item No. %2.',
                                    NewItemDesc,
                                    Item."No.");

                            // Create Item
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
        if UpperCase(Format(Rec."Item Type 1 Name")) = 'PHARMACY' then begin
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