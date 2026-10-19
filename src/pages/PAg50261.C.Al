page 50261 "C Subpage"
{
    PageType = ListPart;
    SourceTable = "C";
    Caption = 'Bill Application List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Customer Code"; Rec."Customer Code") { ApplicationArea = All; }
                field("Applied Amount"; Rec."Applied Amount") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetData)
            {
                ApplicationArea = All;
                Caption = 'Get Data';
                Image = GetLines;

                trigger OnAction()
                var
                    RecordA: Record "A";
                    RecordC: Record "C";
                    NextLineNo: Integer;
                begin
                    // 1. Get parent table A record to find the currently selected entry
                    if not RecordA.Get(Rec."Document No.") then
                        exit;

                    if RecordA."Selected Allocation Entry No." = 0 then
                        error('Please select a line in Subpage B first.');

                    // 2. Calculate next sequential Line No. for this specific allocation entry
                    RecordC.Reset();
                    RecordC.SetRange("Document No.", Rec."Document No.");
                    RecordC.SetRange("Allocation Entry No.", RecordA."Selected Allocation Entry No.");
                    if RecordC.FindLast() then
                        NextLineNo := RecordC."Line No." + 1
                    else
                        NextLineNo := 1;

                    // 3. Insert record linked to Table B's active entry
                    RecordC.Init();
                    RecordC."Document No." := Rec."Document No.";
                    RecordC."Allocation Entry No." := RecordA."Selected Allocation Entry No.";
                    RecordC."Line No." := NextLineNo;
                    RecordC."Customer Code" := RecordA."Selected Customer Code";
                    RecordC."Applied Amount" := 500.00; // Sample value insertion
                    RecordC.Insert(true);

                    // 4. Refresh subpage UI
                    CurrPage.Update(false);
                end;
            }
        }
    }
    procedure SetCustomerFilter(DocNo: Code[20]; AllocationEntryNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Document No.", DocNo);
        Rec.SetRange("Allocation Entry No.", AllocationEntryNo);
        CurrPage.Update(false);
    end;

    procedure SetAllocationFilter(DocNo: Code[20]; AllocationEntryNo: Integer)
    begin
        Rec.Reset();
        Rec.SetRange("Document No.", DocNo);
        Rec.SetRange("Allocation Entry No.", AllocationEntryNo);
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // Every time Subpage C refreshes, update its filter directly from Table A
        UpdateAllocationFilter();
    end;

    procedure UpdateAllocationFilter()
    var
        RecordA: Record "A";
        DocNo: Code[20];
    begin
        DocNo := Rec.GetFilter("Document No.");
        if DocNo = '' then
            DocNo := Rec."Document No.";

        if DocNo <> '' then begin
            if RecordA.Get(DocNo) then begin
                // Directly filter Table C based on Table A's active tracking field
                Rec.SetRange("Document No.", DocNo);
                Rec.SetRange("Allocation Entry No.", RecordA."Selected Allocation Entry No.");
            end;
        end;
    end;
}