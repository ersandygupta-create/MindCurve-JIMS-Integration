page 50260 "B Subpage"
{
    PageType = ListPart;
    SourceTable = "B";
    Caption = 'Allocation Receipt List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Customer Code"; Rec."Customer Code") { ApplicationArea = All; }
                field("Receipt Date"; Rec."Receipt Date") { ApplicationArea = All; }
                field("Receipt Amount"; Rec."Receipt Amount") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SelectAllocation)
            {
                ApplicationArea = All;
                Caption = 'Select Allocation';
                Image = Checkmark;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ParentCard: Page "A Card";
                begin
                    if Rec."Document No." = '' then
                        exit;

                    // Pass control to the parent card to update state and refresh Subpage C
                    CurrPage.Update(true);
                end;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    var
        RecordA: Record "A";
    begin
        if Rec."Document No." = '' then
            exit;

        // Update parent table A tracking fields so subpage C knows which line is currently active
        if RecordA.Get(Rec."Document No.") then begin
            if (RecordA."Selected Allocation Entry No." <> Rec."Entry No.") or
               (RecordA."Selected Customer Code" <> Rec."Customer Code") then begin
                RecordA."Selected Allocation Entry No." := Rec."Entry No.";
                RecordA."Selected Customer Code" := Rec."Customer Code";
                RecordA.Modify(false);

                // Forces parent page buffers to refresh UI immediately

            end;
        end;
        CurrPage.Update(false);
        //CurrPage.Update(true);
    end;

    local procedure refreshpage()
    begin
        if Rec."Document No." = '' then
            exit;

        // Pass control to the parent card to update state and refresh Subpage C
        CurrPage.Update(true);
    end;

}