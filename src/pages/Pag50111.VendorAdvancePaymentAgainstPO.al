page 50111 "Vendor Advance Pay. Against PO"
{

    ApplicationArea = All;
    Caption = 'Vendor Advance Payment Against PO';
    PageType = List;
    SourceTable = "Vendor Adv. Pay. Ag. PO";
    UsageCategory = Lists;
    Editable = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No";
                rec."Document No")
                {
                    Caption = 'Document No.';
                    ToolTip = 'Document No.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name field';
                }
                field("Basic Amount"; Rec."Basic Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Basic Amount field';

                    trigger OnValidate()
                    var
                        AdvancePo: Record "Vendor Adv. Pay. Ag. PO";
                        AdvancePoAmt: Record "Vendor Adv. Pay. Ag. PO";
                    begin

                        AdvancePoAmt.Reset();
                        AdvancePoAmt.SetRange("Entry Type", rec."Entry Type");
                        AdvancePoAmt.SetRange("Purchase Order No.", rec."Purchase Order No.");
                        if AdvancePoAmt.FindFirst() then;
                        AdvancePo.Reset();
                        AdvancePo.SetRange("Entry Type", rec."Entry Type");
                        AdvancePo.SetRange("Purchase Order No.", rec."Purchase Order No.");
                        AdvancePo.CalcSums("Basic Amount");
                        if Rec."Basic Amount" + AdvancePo."Basic Amount" > AdvancePoAmt."Total PO Amount" then
                            Error('Amount can not be greater than PO Amount.');

                    end;
                }
                field("Advance Request Date";
                rec."Advance Request Date")
                {
                    Caption = 'Advance Request Date';
                    ToolTip = 'Advance Request Date';
                }
                field("Advance Due Date";
                Rec."Advance Due Date")
                {
                    Caption = 'Advance Due Date';
                    ToolTip = 'Advance Due Date';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field';
                }
                field("Total PO Amount"; Rec."Total PO Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total PO Amount field';
                }

                field("Total Applied Amount"; Rec."Total Applied Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = false;
                    ToolTip = 'Specifies the value of the Total Applied Amount field';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining Amount field';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purchase Order No. field';
                }
                field("PO Date"; Rec."PO Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PO Date field';
                }
                field(Release;
                Rec.Release)
                {
                    Caption = 'Release';
                    ToolTip = 'Release';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry Type field';
                }

                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Code field';
                }
                field("BU Code"; rec."BU Code")
                {
                    Caption = 'Business Unit';
                    ToolTip = 'Business Unit';
                }
            }
        }

    }

    actions
    {
        area(navigation)
        {
            action("Update Remaining Amount")
            {
                Caption = 'Update Remaining Amount';
                ToolTip = 'Update Remaining Amount';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VendorAdvancePayAgainstPO: Record "Vendor Adv. Pay. Ag. PO";
                begin
                    IF Confirm('Do you want to update the Remaining Amount') then begin
                        VendorAdvancePayAgainstPO.Reset();
                        VendorAdvancePayAgainstPO.SetRange("Entry Type", Rec."Entry Type");
                        VendorAdvancePayAgainstPO.SetRange("Purchase Order No.", Rec."Purchase Order No.");
                        VendorAdvancePayAgainstPO.SetRange("Document No", rec."Document No");
                        IF VendorAdvancePayAgainstPO.FindFirst() then begin
                            VendorAdvancePayAgainstPO.CalcFields(VendorAdvancePayAgainstPO."Total Applied Amount");
                            IF VendorAdvancePayAgainstPO."Total Applied Amount" <> 0 then begin
                                VendorAdvancePayAgainstPO."Remaining Amount" := VendorAdvancePayAgainstPO."Total PO Amount" - VendorAdvancePayAgainstPO."Total Applied Amount";
                                VendorAdvancePayAgainstPO.Modify();
                            end;
                        end;
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        VendorAdvancePayAgainstPO.Reset();
        VendorAdvancePayAgainstPO.SetRange("Entry Type", Rec."Entry Type");
        VendorAdvancePayAgainstPO.SetRange("Purchase Order No.", Rec."Purchase Order No.");
        VendorAdvancePayAgainstPO.SetRange("Document No", rec."Document No");
        IF VendorAdvancePayAgainstPO.FindFirst() then begin
            VendorAdvancePayAgainstPO.CalcFields(VendorAdvancePayAgainstPO."Total Applied Amount");
            //IF VendorAdvancePayAgainstPO."Total Applied Amount" <> 0 then begin
            VendorAdvancePayAgainstPO."Remaining Amount" := VendorAdvancePayAgainstPO."Basic Amount" - VendorAdvancePayAgainstPO."Total Applied Amount";
            VendorAdvancePayAgainstPO.Modify();
            //  end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        VendorAdvancePayAgainstPO.Reset();
        VendorAdvancePayAgainstPO.SetRange("Entry Type", Rec."Entry Type");
        VendorAdvancePayAgainstPO.SetRange("Purchase Order No.", Rec."Purchase Order No.");
        VendorAdvancePayAgainstPO.SetRange("Document No", rec."Document No");

        IF VendorAdvancePayAgainstPO.FindFirst() then begin
            VendorAdvancePayAgainstPO.CalcFields(VendorAdvancePayAgainstPO."Total Applied Amount");
            // IF VendorAdvancePayAgainstPO."Total Applied Amount" <> 0 then begin
            VendorAdvancePayAgainstPO."Remaining Amount" := VendorAdvancePayAgainstPO."Basic Amount" - VendorAdvancePayAgainstPO."Total Applied Amount";
            VendorAdvancePayAgainstPO.Modify();
            //end;
        end;
    end;


    var
        VendorAdvancePayAgainstPO: Record "Vendor Adv. Pay. Ag. PO";

}
