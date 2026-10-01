pageextension 50080 "E3 Item List Ext" extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field(Name; Rec.Name)
            {
                ToolTip = 'Specify A value Name field.';
                ApplicationArea = All;
                Editable = false;
            }
            field("CommonItem No."; Rec."Common Item No.")
            {
                Caption = 'Common Item No.';
                ApplicationArea = All;
                Editable = false;
            }
            field("Manual Code"; Rec."Manual Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Margin Code"; Rec."E3 Margin Code")
            {
                ApplicationArea = All;
            }
            field("Item Make Code"; Rec."Item Make Code")
            {
                Caption = 'Medicine Company / Brand-Make Code';
                ApplicationArea = all;
            }
            field("Make Name"; Rec."Make Name")
            {
                Caption = 'Medicine Company / Brand-Make Name';
                ApplicationArea = All;
            }
            field("Margin Fix"; Rec."Margin Fix")
            {
                Caption = 'RC Type';
                ApplicationArea = All;
            }
            field("Composition Name"; Rec."Composition Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Composition Name for the item.';
            }
            field("Category Name"; Rec."Category Name")
            {
                ApplicationArea = All;
                Caption = 'Category Name';
                ToolTip = 'Specifies the category name of the item.';
            }
            field("Medicine SubCategory Name"; Rec."Medicine SubCategory Name")
            {
                ApplicationArea = All;
                Caption = 'Medicine SubCategory Name';
                ToolTip = 'Specifies the medicine subcategory name of the item.';
            }
            field("Item Type Name"; Rec."Item Type Name")
            {
                ApplicationArea = All;
                Caption = 'Item Type Name';
                ToolTip = 'Specifies the item type name of the item.';
            }
        }
    }

    actions
    {
        addafter(NewFromPicture)
        {
            action("Item Master List")
            {
                ApplicationArea = All;
                Caption = 'Create Item List';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Opens the Item Master List.';
                RunObject = Page "E3 Item Master List";
            }
            action(SendAllItemsToLog)
            {
                ApplicationArea = All;
                Caption = 'Send All Items to Log';
                Image = CreateDocument;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemIntegrationMgmt: Codeunit "E3 Item Integration Mgmt.";
                    E3Item: Record Item;
                    ProcessedItems: Integer;
                begin
                    CurrPage.SetSelectionFilter(E3Item);
                    if E3Item.FindSet() then
                        repeat
                            ItemIntegrationMgmt.MultipleSendToJIMS(E3Item);
                            E3Item."Item Sync Status" := true;
                            E3Item.Modify(true);
                            ProcessedItems += 1;
                        until E3Item.Next() = 0;
                    CurrPage.Update(false);

                    Message('%1 Item records have been processed.', ProcessedItems);
                end;

            }

        }
    }
}