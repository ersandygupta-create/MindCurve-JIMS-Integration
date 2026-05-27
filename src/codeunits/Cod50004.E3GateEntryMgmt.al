codeunit 50004 "E3 Gate Entry Mgmt."
{
    TableNo = 50013;

    trigger OnRun()
    begin
        GateEntryHeader.COPY(Rec);
        Code;
        Rec := GateEntryHeader;
    end;

    var
        Text16500: Label 'Do you want to Post the Gate Entry?';
        GateEntryHeader: Record 50013;
        GateEntryPost: Codeunit 50006;
        Text16501: Label 'Gate Entry Posted successfully.';

    local procedure "Code"()
    begin
        IF NOT CONFIRM(Text16500, FALSE) THEN
            EXIT;
        GateEntryPost.RUN(GateEntryHeader);
        COMMIT;
        MESSAGE(Text16501);
    end;

}