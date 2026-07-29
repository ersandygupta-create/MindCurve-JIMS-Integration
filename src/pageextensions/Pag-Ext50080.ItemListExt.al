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
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(SendAllToJIMS)
            {
                ApplicationArea = All;
                Caption = 'Send All to JIMS';
                Image = SendTo;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemRec: Record Item;
                    E3IntegrationMgmt: Codeunit "E3 Item Integration Mgmt.";
                    CountItem: Integer;
                begin
                    CurrPage.SetSelectionFilter(ItemRec);
                    if not Confirm('Do you want to send all items to JIMS?', false) then
                        exit;

                    CountItem := 0;
                    ItemRec.Reset();

                    if ItemRec.FindSet() then
                        repeat
                            E3IntegrationMgmt.MultipleSendToJIMS(ItemRec);
                            CountItem += 1;
                        until ItemRec.Next() = 0;

                    //Message('%1 items have been added to the Item Log.', CountItem);
                end;
            }
            action(ImportItems)
            {
                Caption = 'Import Items';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Import Items from an Excel file.';

                trigger OnAction()
                var
                    ItemImportMgmt: Codeunit "E3 Item Import Mgmt";
                begin
                    ItemImportMgmt.ImportItems();

                    CurrPage.Update(false);
                end;
            }
        }
    }
}