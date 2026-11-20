tableextension 50080 "E3 Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50000; "E3 Tracking Applies-to Entry"; Integer)
        {
            Caption = 'Tracking Applies-to Entry';
            DataClassification = CustomerContent;
            TableRelation = "Item Ledger Entry"."Entry No." where(
                "Item No." = field("Item No."),
                "Variant Code" = field("Variant Code"),
                "Location Code" = field("Location Code"),
                Positive = const(true),
                Open = const(true));
        }
    }
    trigger OnAfterInsert()
    begin
        ApplyTrackingEntry();
    end;

    trigger OnAfterModify()
    begin
        if Rec."E3 Tracking Applies-to Entry" <> xRec."E3 Tracking Applies-to Entry" then
            ApplyTrackingEntry();
    end;

    local procedure ApplyTrackingEntry()
    var
        TrackingApplication: Codeunit "Item Tracking Application";
    begin
        if Rec.IsTemporary() or (Rec."E3 Tracking Applies-to Entry" = 0) then
            exit;

        TrackingApplication.ApplyEntryFromJournal(Rec, Rec."E3 Tracking Applies-to Entry");
    end;
}
