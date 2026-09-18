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
    Permissions = tabledata "Vendor Adv. Pay. Ag. PO" = rm;
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
                        if rec."Document No" = '' then
                            Rec.Insert();
                        AdvancePoAmt.Reset();
                        AdvancePoAmt.SetRange("Entry Type", rec."Entry Type");
                        AdvancePoAmt.SetRange("Purchase Order No.", rec."Purchase Order No.");
                        if AdvancePoAmt.FindFirst() then;
                        AdvancePo.Reset();
                        AdvancePo.SetRange("Entry Type", rec."Entry Type");
                        AdvancePo.SetRange("Purchase Order No.", rec."Purchase Order No.");
                        AdvancePo.SetFilter("Document No", '<>%1', Rec."Document No");
                        AdvancePo.CalcSums("Basic Amount");
                        if Rec."Basic Amount" + AdvancePo."Basic Amount" > Rec."Total PO Amount" then
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
                field("GST Amount"; Rec."GST Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the GST Amount field';
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
            action("Advance Request Receipt")
            {
                ApplicationArea = All;
                Caption = 'Print Advance Request Receipt';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Print the Advance Request Receipt.';

                trigger OnAction()
                var
                    AdvanceRequest: Record "Vendor Adv. Pay. Ag. PO";
                begin
                    // 1. Save page changes & release active SQL write transaction
                    CurrPage.SaveRecord();
                    Commit();

                    // 2. Prepare filter buffer
                    AdvanceRequest.Reset();
                    AdvanceRequest.SetRange("Document No", Rec."Document No");

                    // 3. Run report modally with Request Page (true)
                    Report.RunModal(
                        Report::"E3 Advance Request Receipt",
                        false,  // ReqWindow = true (Allowed because Commit released transaction)
                        false,
                        AdvanceRequest
                    );
                end;
            }
            action(ReleaseDoc)
            {
                Caption = 'Release';
                ToolTip = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    rec.Release := true;
                end;
            }
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Executes immediately when pressing Down Arrow to create a line
        Rec.Insert(); // Call your table initialization codeunit/method
        Rec."Advance Due Date" := WorkDate();
    end;


    var
        VendorAdvancePayAgainstPO: Record "Vendor Adv. Pay. Ag. PO";

}
