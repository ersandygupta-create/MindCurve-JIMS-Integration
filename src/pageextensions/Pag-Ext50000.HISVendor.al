pageextension 50000 "E3 HIS Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("E3 HIS Code"; Rec."E3 HIS Code")
            {
                ApplicationArea = All;
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("E3 MSME Type"; Rec."E3 MSME Type")
            {
                ApplicationArea = All;
                Editable = true;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("MSME No."; Rec."E3 MSME No.")
            {
                ApplicationArea = All;
                Editable = true;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the MSME No. field';
            }
            field("E3 Auto E-Mail"; Rec."E3 Auto E-Mail")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("DL No."; Rec."DL No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("Name2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Caption = 'Name 2';
                ToolTip = 'Specifies the value of the Name 2 field';
            }
            field("Bank Integration"; Rec."Bank Integration")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Integration Enabled';
                ToolTip = 'Indicates whether bank integration is enabled for this vendor.';
            }

        }
    }
    actions
    {
        addafter(PayVendor)
        {
            action(CreateOrderAddress)
            {
                ApplicationArea = All;
                Caption = 'Generate Order Address';
                ToolTip = 'Generate Order Address';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Create;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    GenerateOrderAddress(Rec);
                end;

            }
        }
    }
    procedure GenerateOrderAddress(var VendorRec: Record Vendor)
    begin
        PurchPayable.Get();
        if (PurchPayable."E3 Order Address Number" <> '') then begin
            OrderAddress.Reset();
            OrderAddress.SetRange("Vendor No.", VendorRec."No.");
            if OrderAddress.Find('-') then begin
                if Confirm('Do you want to create a new Order Address for Vendor %1?', false, VendorRec."No.") then begin
                    OrderAddress.Code := NoSeqMgmt.GetNextNo(PurchPayable."E3 Order Address Number");
                    OrderAddress."Vendor No." := VendorRec."No.";
                    OrderAddress.Address := '';
                    OrderAddress."Address 2" := '';
                    OrderAddress."ARN No." := '';
                    OrderAddress.City := '';
                    OrderAddress.State := '';
                    OrderAddress."GST Registration No." := '';
                    OrderAddress."Country/Region Code" := '';
                    State.Get(VendorRec."State Code");
                    OrderAddress.Name := VendorRec.Name + '-' + State."State Code (GST Reg. No.)";
                    OrderAddress."Name 2" := VendorRec."Name 2";
                    OrderAddress."Post Code" := '';
                    OrderAddress."Phone No." := '';
                    OrderAddress."E-Mail" := '';
                    OrderAddress.Insert();
                    CurrPage.Update();
                    Message('Order Address generated for Vendor %1.', VendorRec."No.");
                end;

            end
            else begin
                OrderAddress.Code := NoSeqMgmt.GetNextNo(PurchPayable."E3 Order Address Number");
                OrderAddress."Vendor No." := VendorRec."No.";
                OrderAddress.Address := VendorRec.Address;
                OrderAddress."Address 2" := VendorRec."Address 2";
                OrderAddress."ARN No." := VendorRec."ARN No.";
                OrderAddress.City := VendorRec.City;
                OrderAddress.State := VendorRec."State Code";
                OrderAddress."GST Registration No." := VendorRec."GST Registration No.";
                OrderAddress."Country/Region Code" := VendorRec."Country/Region Code";
                State.Get(VendorRec."State Code");
                OrderAddress.Name := VendorRec.Name + '-' + State."State Code (GST Reg. No.)";
                OrderAddress."Name 2" := VendorRec."Name 2";
                OrderAddress."Post Code" := VendorRec."Post Code";
                OrderAddress."Phone No." := VendorRec."Phone No.";
                OrderAddress."E-Mail" := VendorRec."E-Mail";
                OrderAddress.Insert();
                CurrPage.Update();
                Message('Order Address generate for Vendor %1.', VendorRec."No.");
            end;
        end else
            Error('Order Address Number sequence is not found in Purchase & Payble Setup.');

    end;

    var
        OrderAddress: Record "Order Address";
        PurchPayable: Record "Purchases & Payables Setup";
        NoSeqMgmt: Codeunit "No. Series";
        recVendor: Record Vendor;
        recTDSEntry: Record "TDS Entry";
        State: Record State;

}
