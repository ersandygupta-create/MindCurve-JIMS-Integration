pageextension 50093 "E3 Item Journal Ext" extends "Item Journal"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(lotNo; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No field';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(ImportAppliesToEntries)
            {
                ApplicationArea = All;
                Caption = 'Import Applies-to Entries';
                ToolTip = 'Upload item tracking applications for journal lines in the current batch.';

                trigger OnAction()
                var
                    TrackingImport: Codeunit "Item Tracking CSV Import";
                begin
                    CurrPage.SaveRecord();
                    TrackingImport.ImportAppliesToEntries(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}