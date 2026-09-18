pageextension 50017 "E3 HIS Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("E3 RCM"; Rec."E3 RCM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RCM field.';
            }
        }
        addbefore("No.")
        {
            field("Voucher Type"; Rec."Voucher Type")
            {
                ApplicationArea = All;
                Caption = 'Voucher Type';
                Editable = Rec."Voucher Type" = '';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
        }

    }
    actions
    {
        addafter(Action3)
        {
            action("Cancel SO")
            {
                ApplicationArea = All;
                Caption = 'Cancel SO';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Cancel sales Order from Indent.';

                trigger OnAction()
                var
                    salesline: record "sales Line";
                begin
                    salesline.reset();
                    salesline.SetRange("Document Type", rec."Document Type");
                    salesline.SetRange("Document No.", Rec."No.");
                    if salesline.FindSet() then
                        repeat
                            cancleIndentLine(salesline);
                        until salesline.Next() = 0;

                    Message('sales Order has been canceled from indent;');
                end;
            }
        }
    }
    local procedure cancleIndentLine(var salesLine: Record "sales Line")
    var
        IndentLine: Record "E3 Indent Line";
    begin
        if salesLine."Qty. Invoiced (Base)" = 0 then begin
            IndentLine.Reset();
            //  IndentLine.SetRange("Order Line No.", salesLine."Line No.");
            IndentLine.SetRange("sales Order No.", salesLine."Document No.");
            IndentLine.SetRange("No.", salesLine."No.");
            if IndentLine.FindSet() then
                repeat
                    IndentLine."Order Line No." := 0;
                    IndentLine."sales Order No." := '';
                    IndentLine."SO Created" := false;
                    IndentLine.Modify();
                    salesLine.Delete(true);
                //Sandeep
                until IndentLine.Next() = 0;
        end else
            Message('sales line %1 is partially shipped so it line can not be canceled.', salesLine."Line No.");
    end;

}