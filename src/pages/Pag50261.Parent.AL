page 50262 "A Card"
{
    PageType = Card;
    SourceTable = "A";
    Caption = 'Organization Receipt Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { ApplicationArea = All; }
            }

            // Middle Subpage (Table B)
            part(SubpageB; "B Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both; // Critical: allows subpage to sync back to parent
            }

            // Bottom Subpage (Table C - filtered dynamically by parent's selected allocation entry)
            part(SubpageC; "C Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                // "Allocation Entry No." = FIELD("Selected Allocation Entry No.");
                UpdatePropagation = Both;
            }
        }
    }
    /*  trigger OnAfterGetCurrRecord()
      begin
          if Rec."No." <> '' then begin
              Rec.Find(); // Pull latest changes made by Subpage B
              CurrPage.SubpageC.Page.SetAllocationFilter(Rec."No.", Rec."Selected Allocation Entry No.");
          end;
      end;*/
    // Public procedure to safely push the filter down to Subpage C without AL0161 errors
    // Public procedure to safely push the filter down to Subpage C
    trigger OnAfterGetCurrRecord()
    begin
        FilterSubpageC(Rec."Selected Allocation Entry No.");
    end;

    procedure FilterSubpageC(EntryNo: Integer)
    begin
        CurrPage.SubpageC.Page.SetAllocationFilter(Rec."No.", EntryNo);
    end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     if Rec."No." <> '' then
    //         CurrPage.Update(false);
    // end;
}