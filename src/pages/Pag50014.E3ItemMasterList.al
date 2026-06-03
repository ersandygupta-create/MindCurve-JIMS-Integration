page 50014 "E3 Item Master List"
{

    ApplicationArea = All;
    Caption = 'Item List';
    PageType = List;
    Editable = true;
    SourceTableView = SORTING("Entry No.") WHERE("Party Type" = FILTER('Item Master'), IsCreated = FILTER(false));
    SourceTable = "E3 HIS Master Staging";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ItemType; Rec."Item Type 1")
                {
                    ToolTip = 'Specifies the value of the Item Type field';
                    ApplicationArea = All;
                    Caption = 'Item Type';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("Material Category"; Rec."Material Category")
                {
                    ToolTip = 'Specifies the value of the Material Category field';
                    ApplicationArea = All;
                    Caption = 'Material Category';
                }
                field(Strength; Rec.Strength)
                {
                    ToolTip = 'Specifies the value of the Strength field';
                    ApplicationArea = All;
                    Caption = 'Strength';
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
                PromotedOnly = true;

                trigger OnAction()
                var
                    HISIntegration: Codeunit "E3 HIS Integration Mgmt.";
                    HisMasterStaging: Record "E3 HIS Master Staging";

                begin
                    // Get all selected records
                    CurrPage.SetSelectionFilter(HisMasterStaging);

                    if HisMasterStaging.IsEmpty() then
                        Error('Please select at least one record.');

                    // Loop through selected records
                    if HisMasterStaging.FindSet() then
                        repeat
                            HISIntegration.InitItemMaster1(HisMasterStaging."Entry No.");
                        until HisMasterStaging.Next() = 0;
                    Message('Selected items processed successfully.');
                end;
            }


        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Party Type" := Rec."Party Type"::"Item Master";
    end;
}
