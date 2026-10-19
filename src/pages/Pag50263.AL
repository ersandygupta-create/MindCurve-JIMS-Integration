page 50263 "A List"
{
    PageType = List;
    SourceTable = "A";
    Caption = 'Organization Receipts';
    CardPageId = "A Card"; // This automatically links the list row to your card page!
    ApplicationArea = All;
    UsageCategory = Lists; // Makes it searchable under "Lists" in Tell Me

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Selected Allocation Entry No."; Rec."Selected Allocation Entry No.") { ApplicationArea = All; }
                field("Selected Customer Code"; Rec."Selected Customer Code") { ApplicationArea = All; }
            }
        }
    }
}