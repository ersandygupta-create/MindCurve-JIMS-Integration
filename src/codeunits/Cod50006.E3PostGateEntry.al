codeunit 50006 "E3 Post Gate Entry"
{
    TableNo = 50013;

    trigger OnRun()
    begin
        GateEntryHeader := Rec;
        WITH GateEntryHeader DO BEGIN
            TESTFIELD("Posting Date/Time");
            TESTFIELD("Document No.");

            GateEntryLine.Reset();
            GateEntryLine.SETRANGE("Document No.", "Document No.");
            IF NOT GateEntryLine.FIND('-') THEN
                ERROR(Text16500);

            IF GateEntryLine.FindSet() THEN
                REPEAT
                UNTIL GateEntryLine.Next() = 0;

            IF GUIALLOWED THEN
                Window.OPEN(
                  '#1###########################\\' +
                  Text16501);
            IF GUIALLOWED THEN
                Window.UPDATE(1, STRSUBSTNO('%1 %2', Text16502, "Document No."));


            IF ModifyHeader THEN BEGIN
                MODIFY;
                COMMIT;
            END;

            GateEntryLine.LOCKTABLE;

            PostedGateEntryHeader.INIT;
            PostedGateEntryHeader.TRANSFERFIELDS(GateEntryHeader);
            PostedGateEntryHeader."Document No." := "Document No.";

            IF GUIALLOWED THEN
                Window.UPDATE(1, STRSUBSTNO(Text16503, "Document No.", PostedGateEntryHeader."Document No."));
            PostedGateEntryHeader.INSERT;

            GateEntryLine.RESET;
            GateEntryLine.SETRANGE("Document No.", "Document No.");
            LineCount := 0;
            IF GateEntryLine.FINDSET THEN
                REPEAT
                    LineCount += 1;
                    IF GUIALLOWED THEN
                        Window.UPDATE(2, LineCount);
                    PostedGateEntryLine.INIT;
                    PostedGateEntryLine.TRANSFERFIELDS(GateEntryLine);
                    PostedGateEntryLine."Document No." := PostedGateEntryHeader."Document No.";
                    PostedGateEntryLine.INSERT;
                UNTIL GateEntryLine.NEXT = 0;

            DELETE;
            GateEntryLine.DELETEALL;
        END;
        IF GUIALLOWED THEN
            Window.CLOSE;
        Rec := GateEntryHeader;
    end;

    var
        GateEntryHeader: Record 50013;
        GateEntryLine: Record 50014;
        PostedGateEntryHeader: Record 50044;
        PostedGateEntryLine: Record 50045;
        Text16500: Label 'There is nothing to post.';
        Text16501: Label 'Posting Lines #2######\';
        Text16502: Label 'Gate Entry.';
        Text16503: Label 'Gate Entry %1 -> Posted Gate Entry %2.';
        NoSeriesMgt: Codeunit "No. Series";
        Window: Dialog;
        ModifyHeader: Boolean;
        LineCount: Integer;


}