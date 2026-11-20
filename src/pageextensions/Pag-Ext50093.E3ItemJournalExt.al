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
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(TrackingAppliesToEntryNo; Rec."E3 Tracking Applies-to Entry")
            {
                ApplicationArea = All;
                Caption = 'Tracking Applies-to Entry';
                BlankZero = true;
                ToolTip = 'Enter a posted inbound item ledger entry to apply it to the full journal line quantity in Item Tracking Lines.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ItemLedgerEntries: Page "Item Ledger Entries";
                begin
                    Rec.TestField("Item No.");
                    ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                    ItemLedgerEntry.SetRange("Variant Code", Rec."Variant Code");
                    ItemLedgerEntry.SetRange("Location Code", Rec."Location Code");
                    ItemLedgerEntry.SetRange(Positive, true);
                    ItemLedgerEntry.SetRange(Open, true);
                    ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
                    if Rec."Lot No." <> '' then
                        ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");

                    ItemLedgerEntries.SetTableView(ItemLedgerEntry);
                    ItemLedgerEntries.LookupMode(true);
                    if ItemLedgerEntries.RunModal() <> Action::LookupOK then
                        exit(false);

                    ItemLedgerEntries.GetRecord(ItemLedgerEntry);
                    Text := Format(ItemLedgerEntry."Entry No.");
                    exit(true);
                end;
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