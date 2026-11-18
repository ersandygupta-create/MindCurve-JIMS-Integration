codeunit 50066 "E3 Transfer Journal Document"
{
    Access = Internal;
    TableNo = "E3 Transfer Header";

    trigger OnRun()
    var
        TransferJournalMgmt: Codeunit "E3 Transfer Journal Mgmt.";
    begin
        TransferJournalMgmt.ProcessTransferDocument(Rec."Document Number", AutoTransferJournal);
    end;

    var
        AutoTransferJournal: Boolean;

    procedure SetAutoTransferJournal(NewAutoTransferJournal: Boolean)
    begin
        AutoTransferJournal := NewAutoTransferJournal;
    end;
}
