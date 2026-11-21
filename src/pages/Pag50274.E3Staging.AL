page 50274 "E3 Item Adj. Staging"
{
    PageType = List;
    SourceTable = "E3 Item Adj. Staging";
    Caption = 'Item Adjustment Staging';
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for the staging line.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date for the adjustment entry.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of inventory entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number associated with the entry.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number being adjusted.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the item or adjustment.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inventory location code.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity for the entry.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code.';
                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit amount.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.';
                }
                field("BU Code"; Rec."BU Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business unit code.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number.';
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source item ledger entry number, if applicable.';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Error';
                    ApplicationArea = All;

                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Error Message';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Validate)
            {
                Caption = 'Validate';


                trigger OnAction()
                var
                    Stagging: Record 50105;
                begin
                    Stagging.Reset();
                    Stagging.SetRange(Error, false);
                    Stagging.SetFilter("Item Ledger Entry No.", '<>%1', 0);
                    if Stagging.FindSet() then
                        repeat
                            recvalidate(Stagging);
                        until Stagging.Next() = 0;
                    markAllDocument();
                end;

            }
            action(clearAll)
            {
                Caption = 'Clear All';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Stagging: Record 50105;
                begin
                    Stagging.Reset();
                    if Stagging.FindSet(true) then
                        repeat
                            if Stagging.Error or (Stagging.ErrorMessage <> '') then begin
                                Stagging.Error := false;
                                Stagging.ErrorMessage := '';
                                Stagging.Modify(true);
                            end;
                        until Stagging.Next() = 0;
                end;
            }
        }
    }
    local procedure recvalidate(recstaging: Record 50105)
    var
        ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset();
        ILE.SetRange("Entry No.", recstaging."Item Ledger Entry No.");
        ILE.SetRange("Item No.", recstaging."Item No.");
        ILE.SetRange("Document No.", recstaging."Document No.");
        ILE.SetRange(Open, true);
        if ILE.Find('-') then begin
            if (abs(ILE.Quantity) = recstaging.Quantity) then
                exit
            else begin
                recstaging.Error := true;
                recstaging.ErrorMessage := 'Quantity did not match';
                recstaging.Modify(false);
            end;
        end
        else begin
            recstaging.Error := true;
            recstaging.ErrorMessage := 'Entry no not found in item ledger';
            recstaging.Modify(false);

        end;

    end;

    local procedure markAllDocument()
    var
        staging: Record 50105;
        ErrorStaging: Record 50105;
    begin

        staging.Reset();
        staging.SetRange(Error, true);
        if staging.FindSet() then
            repeat
                ErrorStaging.Reset();
                ErrorStaging.SetRange("Document No.", staging."Document No.");
                if not ErrorStaging.IsEmpty() then
                    ErrorStaging.ModifyAll(Error, true, false);
            until staging.Next() = 0;
    end;
}