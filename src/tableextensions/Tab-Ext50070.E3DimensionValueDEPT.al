tableextension 50070 "E3 Dimension Value Ext" extends "Dimension Value"
{
    trigger OnBeforeInsert()
    begin
        GeneralLedgerSetup.Get();
        if (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 1 Code") or
           (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 2 Code") then begin
            UserSetup.Get(UserId());
            if not UserSetup."Dimension Value Editable" then
                Error('You do not have permission to create a new Global Dimension 1 or Global Dimension 2 Code.');
        end;
    end;

    trigger OnBeforeModify()
    begin
        GeneralLedgerSetup.Get();
        if (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 1 Code") or
           (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 2 Code") then begin
            UserSetup.Get(UserId());
            if not UserSetup."Dimension Value Editable" then
                Error('You do not have permission to modify a Global Dimension 1 or Global Dimension 2 Code.');
        end;
    end;

    trigger OnBeforeDelete()
    begin
        GeneralLedgerSetup.Get();
        if (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 1 Code") or
           (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 2 Code") then begin
            UserSetup.Get(UserId());
            if not UserSetup."Dimension Value Editable" then
                Error('You do not have permission to delete a Global Dimension 1 or Global Dimension 2 Code.');
        end;
    end;

    trigger OnBeforeRename()
    begin
        GeneralLedgerSetup.Get();
        if (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 1 Code") or
           (Rec."Dimension Code" = GeneralLedgerSetup."Global Dimension 2 Code") then begin
            UserSetup.Get(UserId());
            if not UserSetup."Dimension Value Editable" then
                Error('You do not have permission to rename a Global Dimension 1 or Global Dimension 2 Code.');
        end;
    end;

    var
        UserSetup: Record "User Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
}