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
            field("Margin Code"; Rec."Margin Code")
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
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemIntegrationMgmt: Codeunit "E3 Item Integration Mgmt.";
                    E3Item: Record Item;
                    TotalItems: Integer;
                    ProcessedItems: Integer;
                begin
                    // Get all Item records
                    if E3Item.FindSet() then begin
                        TotalItems := E3Item.Count();

                        repeat
                            ItemIntegrationMgmt.MultipleSendToJIMS(E3Item);
                            ProcessedItems += 1;
                        until E3Item.Next() = 0;
                    end;

                    Message(
                        '%1 Item records have been created/updated in the Item Integration Log.',
                        ProcessedItems);
                end;
            }

        }
    }
}