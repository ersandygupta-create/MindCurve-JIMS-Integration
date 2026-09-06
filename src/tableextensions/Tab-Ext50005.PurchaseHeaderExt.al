tableextension 50005 "E3 HIS Purchase Header" extends "Purchase Header"
{
    fields
    {
        modify("Document Date")
        {
            trigger OnAfterValidate()
            begin
                ValidateDocumentDate();
            end;
        }
        modify("Order Date")
        {
            trigger OnAfterValidate()
            begin
                ValidateDocumentDate();
            end;
        }
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                ValidateDocumentDate();
            end;
        }
        modify("Buy-from Vendor No.")
        {
            trigger onaftervalidate()
            var
                VoucherType: Record "E3 Voucher Type";
            begin
                if "Voucher Type" = '' then
                    exit;
                VoucherType.Get("Voucher Type");
                Validate("Responsibility Center", VoucherType."Responsibility Center");
            end;
        }
        field(50000; "E3 Capex Type"; Enum "E3 Capex Type")
        {
            Caption = 'Capex Type';
            DataClassification = CustomerContent;
        }
        field(50001; "E3 Work Order Type"; Enum "E3 Work Order Type")
        {
            Caption = 'Work Order Type';
            DataClassification = CustomerContent;
        }

        field(50002; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50004; "E3 Delivery Terms"; Text[150])
        {
            Caption = 'Delivery Terms';
            DataClassification = CustomerContent;
        }
        field(50005; "Store Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Store Name';
        }
        field(50006; "Advance PO"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Advance PO';
            TableRelation = "Vendor Adv. Pay. Ag. PO" where("Vendor Code" = field("Buy-from Vendor No."));
            trigger OnLookup()
            var
                AdvancedPO: Record "Vendor Adv. Pay. Ag. PO";
            begin
                // Check if Advance PO already exists for this Purchase Order
                AdvancedPO.Reset();
                AdvancedPO.SetRange("Purchase Order No.", Rec."No.");
                AdvancedPO.SetRange("Entry Type", AdvancedPO."Entry Type"::"Purchase Order");

                if not AdvancedPO.FindFirst() then begin
                    // Create new record only if it does not exist
                    AdvancedPO.Init();
                    AdvancedPO."Entry Type" := AdvancedPO."Entry Type"::"Purchase Order";
                    AdvancedPO."Purchase Order No." := Rec."No.";
                    AdvancedPO."Vendor Code" := Rec."Buy-from Vendor No.";
                    AdvancedPO."Vendor Name" := Rec."Buy-from Vendor Name";
                    AdvancedPO."PO Date" := Rec."Order Date";
                    AdvancedPO.Insert(true);
                end;

                // Update Purchase Order Advance PO field
                if AdvancedPO."Purchase Order No." <> '' then begin
                    Rec.Validate("Advance PO", AdvancedPO."Purchase Order No.");
                    Rec.Modify(true);
                end;

                // Open existing/new record
                Page.Run(Page::"Vendor Advance Pay. Against PO", AdvancedPO);
            end;

        }
        field(50007; "Purchase Narration"; Text[160])
        {
            Caption = 'Purchase Narration';
            DataClassification = CustomerContent;
        }
        field(50008; "W/S DL No."; Text[60])
        {
            Caption = 'W/S DL No.';
            DataClassification = CustomerContent;
        }
        field(50009; "Retail DL No."; Text[60])
        {
            Caption = 'Retail DL No.';
            DataClassification = CustomerContent;
        }
        field(50010; "E3 Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Exp. CN Value"; Decimal)
        {
            Caption = 'Exp. CN Value';
            DataClassification = CustomerContent;
        }
        field(50012; "Integration PO"; Boolean)
        {
            Caption = 'Integration PO';
            DataClassification = CustomerContent;
        }
        field(50013; "Original Printed"; Boolean)
        {
            Caption = 'Original Printed';
            DataClassification = CustomerContent;
        }
        field(50014; "E3 Send E-Mail"; Boolean)
        {
            Caption = 'E3 Send E-Mail';
            DataClassification = CustomerContent;
        }
        field(50015; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
        }
        field(50016; "Voucher Type"; Code[20])
        {
            Caption = 'Voucher Type';
            DataClassification = CustomerContent;
            TableRelation = "E3 Voucher Type".Code where("Entry Type" = const(Order));
            trigger OnValidate()
            var
                VoucherType: Record "E3 Voucher Type";
                NoSeries: Codeunit "No. Series";
            begin
                if "Voucher Type" = '' then
                    exit;
                VoucherType.Get("Voucher Type");
                // Validate("Responsibility Center", VoucherType."Shortcut Dimension 1 Code");
                // Validate("Shortcut Dimension 1 Code", VoucherType."Shortcut Dimension 1 Code");
                // Validate("Location Code", VoucherType."Location Code");
                "GRN Voucher Type Name" := VoucherType."GRN Voucher Type Name";
                "Print Caption" := VoucherType."Print Caption";
                VoucherType.TestField("Order Nos.");
                if "No." = '' then
                    "No." := NoSeries.GetNextNo(VoucherType."Order Nos.", WorkDate(), true);
                CreateDefaultTerms();
            end;
        }
        field(50017; "GRN Voucher Type Name"; Text[60])
        {
            Caption = 'GRN Voucher Type Name';
            DataClassification = CustomerContent;
        }
        field(50018; "Print Caption"; Text[50])
        {
            Caption = 'Print Caption';
            DataClassification = CustomerContent;
        }
        field(50019; "Price Check"; Boolean)
        {
            Caption = 'Price Check';
            DataClassification = CustomerContent;
        }
    }

    procedure CreateDefaultTerms()
    var
        TermsSetup: Record "E3 Order Terms & Conditions";
        CommentLine: Record "Purch. Comment Line";
        LineNo: Integer;
    begin
        if "Voucher Type" = '' then
            exit;

        CommentLine.Reset();
        CommentLine.SetRange("Document Type", "Document Type");
        CommentLine.SetRange("No.", "No.");

        if not CommentLine.IsEmpty() then
            CommentLine.DeleteAll();

        CommentLine.Reset();
        CommentLine.SetRange("Document Type", "Document Type");
        CommentLine.SetRange("No.", "No.");

        if CommentLine.FindLast() then
            LineNo := CommentLine."Line No." + 10000
        else
            LineNo := 10000;

        TermsSetup.Reset();
        TermsSetup.SetRange("Voucher Type", "Voucher Type");
        TermsSetup.SetRange(Active, true);

        if TermsSetup.FindSet() then
            repeat
                CommentLine.Init();
                CommentLine."Document Type" := "Document Type";
                CommentLine."No." := "No.";
                CommentLine."Line No." := LineNo;
                CommentLine.Date := WorkDate();

                CommentLine."Order Terms" := TermsSetup.Description;
                CommentLine.Comment := TermsSetup."Default Value";

                CommentLine.Insert();

                LineNo += 10000;
            until TermsSetup.Next() = 0;
    end;

    trigger OnBeforeInsert()
    begin
        if "Document Type" = "Document Type"::Order then
            Rec.TestField("Voucher Type");
    end;

    trigger OnBeforeDelete()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."PO Delete" then
                Error(
                    'You do not have permission to delete Purchase Order %1.',
                    "No.");
        end else
            Error(
                'User Setup is not defined for user %1.',
                UserId);
    end;

    local procedure ValidateDocumentDate()
    begin
        if ("Order Date" <> 0D) and
           ("Document Date" < "Order Date")
        then
            Error(
                'Document Date %1 must be greater than or equal to Order Date %2.',
                "Document Date",
                "Order Date");

        if ("Posting Date" <> 0D) and
           ("Document Date" > "Posting Date")
        then
            Error(
                'Document Date %1 must be less than or equal to Posting Date %2.',
                "Document Date",
                "Posting Date");
    end;

}