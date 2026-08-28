table 50051 "E3 Indent Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Indent Header';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;

        }
        field(2; "Prepared By"; Text[60])
        {
            Caption = 'Prepared By';
            DataClassification = CustomerContent;
            //TableRelation = "E3 Indenter Master"."Indenter Name" where("Indenter Type" = filter("Requested By"));

            // trigger OnValidate()
            // var
            //     IndenterMaster: Record "E3 Indenter Master";
            //     IndentLine: Record "E3 Indent Line";
            // begin
            //     Clear("Shortcut Dimension 2 Code");
            //     Clear("Department Name");
            //     Clear("Shortcut Dimension 1 Code");
            //     Clear("Business Unit Name");
            //     Clear("Location Code");
            //     Clear("Location Name");

            //     IndenterMaster.Reset();
            //     IndenterMaster.SetRange("Indenter Name", "Prepared By");
            //     IndenterMaster.SetRange("Indenter Type", IndenterMaster."Indenter Type"::"Requested By");

            //     if IndenterMaster.FindFirst() then begin
            //         Validate("Shortcut Dimension 2 Code", IndenterMaster."Department Code");
            //         "Department Name" := IndenterMaster."Department Name";

            //         Validate("Shortcut Dimension 1 Code", IndenterMaster."Business Unit Code");
            //         "Business Unit Name" := IndenterMaster."Business Unit Name";

            //         Validate("Location Code", IndenterMaster."Default Location Code");
            //         "Location Name" := IndenterMaster."Default Location Name";
            //     end;
            // end;
        }
        field(3; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(4; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Closed;
            Caption = 'Status';
        }
        field(5; "Shortcut Dimension 1 Code"; Code[10])
        {
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
            Editable = true;
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
                IndentLine: Record "E3 Indent Line";
            begin
                "Business Unit Name" := '';
                GLSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                DimensionValue.SetRange(Code, "Shortcut Dimension 1 Code");

                if DimensionValue.FindFirst() then
                    "Business Unit Name" := DimensionValue.Name;

            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = true;
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                "Department Name" := '';
                GLSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                DimensionValue.SetRange(Code, "Shortcut Dimension 2 Code");

                if DimensionValue.FindFirst() then
                    "Department Name" := DimensionValue.Name;
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = true;
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
            trigger OnValidate()
            var
                LocationRec: Record Location;
            begin
                "Location Name" := '';
                if LocationRec.Get("Location Code") then
                    "Location Name" := LocationRec.Name
                else
                    "Location Name" := '';
            end;
        }
        field(8; "Location Name"; Text[100])
        {
            Caption = 'Location Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(9; "Department Name"; Text[100])
        {
            Caption = 'Department Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(10; "To Location Code"; Code[20])
        {
            Caption = 'To Location Code';
            Editable = true;
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
            trigger OnValidate()
            var
                LocationRec: Record Location;
            begin
                "To Location Name" := '';
                if LocationRec.Get("To Location Code") then
                    "To Location Name" := LocationRec.Name
                else
                    "To Location Name" := '';
            end;
        }
        field(11; "To Location Name"; Text[100])
        {
            Caption = 'To Location Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(12; "Prepared Date"; Date)
        {
            Caption = 'Prepared Date';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                IndentLine: Record "E3 Indent Line";
            begin
                IndentLine.Reset();
                IndentLine.SetRange("Document No.", "Document No.");

                if IndentLine.FindSet() then
                    repeat
                        IndentLine."Requested Received Date" := "Prepared Date";
                        IndentLine.Modify(true);
                    until IndentLine.Next() = 0;
            end;
        }
        field(13; "Approved By"; Text[100])
        {
            Caption = 'Approved By';
            DataClassification = CustomerContent;
        }
        field(14; "Entry No."; Code[50])
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                IndentLine: Record "E3 Indent Line";
                IndentHeader: Record "E3 Indent Header";
            begin
                // Duplicate Entry No. Validation
                IndentHeader.Reset();
                IndentHeader.SetRange("Entry No.", "Entry No.");
                IndentHeader.SetFilter("Document No.", '<>%1', "Document No.");

                if IndentHeader.FindFirst() then
                    Error('Entry No. %1 already exists. Duplicate Entry No. is not allowed.', "Entry No.");

                IndentLine.Reset();
                IndentLine.SetRange("Document No.", "Document No.");

                if IndentLine.FindSet() then
                    repeat
                        IndentLine."Entry No." := "Entry No.";
                        IndentLine.Modify(true);
                    until IndentLine.Next() = 0;
            end;
        }
        field(15; "Business Unit Name"; Text[100])
        {
            Caption = 'Business Unit Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(16; "Indenter Code"; Text[60])
        {
            Caption = 'Indenter Code';
            DataClassification = CustomerContent;
            //TableRelation = "E3 Indenter Master"."Indenter Name" where("Indenter Type" = filter(Indenter));
            // trigger OnValidate()
            // var
            //     IndenterMaster: Record "E3 Indenter Master";
            // begin
            //     Clear("Indenter Name");
            //     Clear("To Location Code");
            //     Clear("To Location Name");
            //     Clear("To Department Code");
            //     Clear("To Department Name");

            //     IndenterMaster.Reset();
            //     IndenterMaster.SetRange("Indenter Name", "Indenter Code");
            //     IndenterMaster.SetRange("Indenter Type", IndenterMaster."Indenter Type"::Indenter);

            //     if IndenterMaster.FindFirst() then begin
            //         "Indenter Name" := IndenterMaster."Indenter Name";

            //         "To Location Code" := IndenterMaster."Default Location Code";
            //         "To Location Name" := IndenterMaster."Default Location Name";

            //         "To Department Code" := IndenterMaster."Department Code";
            //         "To Department Name" := IndenterMaster."Department Name";
            //     end;
            // end;
        }
        field(17; Remarks; Text[100])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(18; "To Department Code"; Code[20])
        {
            Caption = 'To Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
            Editable = true;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                "To Department Name" := '';
                GLSetup.Get();
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
                DimensionValue.SetRange(Code, "To Department Code");

                if DimensionValue.FindFirst() then
                    "To Department Name" := DimensionValue.Name;
            end;
        }
        field(19; "To Department Name"; Text[100])
        {
            Caption = 'To Department Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(20; "Approval Date Time"; DateTime)
        {
            Caption = 'Approval Date Time';
            DataClassification = CustomerContent;
        }
        field(21; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(22; "Voucher Type Code"; Code[10])
        {
            Caption = 'Voucher Type Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Voucher Type".Code;
            trigger OnValidate()
            var
                VoucherType: Record "E3 Voucher Type";
            begin
                if VoucherType.Get("Voucher Type Code") then
                    "Voucher Type Name" := VoucherType.Description
                else
                    Clear("Voucher Type Name");
            end;
        }
        field(23; "Voucher Type Name"; Text[80])
        {
            Caption = 'Voucher Type Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(24; "Indenter Name"; Text[100])
        {
            Caption = 'Indenter Name';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(25; Amount; Decimal)
        {
            CalcFormula = Sum("E3 Indent Line"."Amount" where("Document No." = field("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = "Currency".Code;
        }
        field(27; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(28; "Budget Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Budgeted,Non-Budgeted';
            OptionMembers = Budgeted,"Non-Budgeted";
        }
        field(29; "Budgeted Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(30; "Procurement Type"; Enum "E3 Capex Type")
        {
            Caption = 'Procurement Type';
            DataClassification = CustomerContent;
        }
        field(31; "Release Indent"; Boolean)
        {
            Caption = 'Release Indent';
            DataClassification = CustomerContent;
        }
        field(32; "Source Type"; Enum "E3 Indent Source Type")
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(33; "Short Close Indent"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(34; "Relese for Store"; Boolean)
        {
            Caption = 'Relese for Store';
            DataClassification = CustomerContent;
        }
        field(35; Released; Boolean)
        {
            Caption = 'Released';
            DataClassification = CustomerContent;
        }
        field(36; "Store Sale"; Boolean)
        {
            Caption = 'Store Sale';
            DataClassification = CustomerContent;
        }
        field(37; "Sales Released"; Boolean)
        {
            Caption = 'Sales Released';
            DataClassification = CustomerContent;
        }
        field(38; "Purchase Released"; Boolean)
        {
            Caption = 'Purchase Released';
            DataClassification = CustomerContent;
        }
        field(39; "HIS Approved Indent Closed"; Boolean)
        {
            Caption = 'HIS Approved Indent Closed';
            DataClassification = CustomerContent;
        }
        field(40; "Closed Stock Issue"; Boolean)
        {
            Caption = 'Closed Stock Issue';
            DataClassification = CustomerContent;
        }
        field(41; "Closed Purchase Receipt"; Boolean)
        {
            Caption = 'Closed Purchase Receipt';
            DataClassification = CustomerContent;
        }
        field(42; "Relese for Purchase"; Boolean)
        {
            Caption = 'Relese for Purchase';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Document No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("Indent Nos.");

            "Document No." :=
                NoSeries.GetNextNo(PurchSetup."Indent Nos.", WorkDate());
        end;
    end;

    procedure AssistEdit(OldIndentHeader: Record "E3 Indent Header"): Boolean
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
        IndentHeader: Record "E3 Indent Header";
    begin
        IndentHeader := Rec;

        PurchSetup.Get();
        PurchSetup.TestField("Indent Nos.");

        if NoSeries.LookupRelatedNoSeries(
            PurchSetup."Indent Nos.",
            OldIndentHeader."No. Series",
            IndentHeader."No. Series")
        then begin
            IndentHeader."Document No." := NoSeries.GetNextNo(IndentHeader."No. Series");
            Rec := IndentHeader;
            exit(true);
        end;

        exit(false);
    end;

    procedure UpdateApprovalDetails()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"E3 Indent Header");
        ApprovalEntry.SetRange("Document No.", "Document No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);

        if ApprovalEntry.FindLast() then begin
            "Approved By" := ApprovalEntry."Approver ID";
            "Approval Date Time" := ApprovalEntry."Last Date-Time Modified";
            Modify(false);
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        RecordIndentLine: Record "E3 Indent Line";
    begin
        Testfield(Status, Status::Open);
        RecordIndentLine.Reset();
        RecordIndentLine.SetRange("Document No.", "Document No.");
        RecordIndentLine.DeleteAll(true);
    end;

    trigger OnRename()
    begin

    end;

    local procedure DocumentAttachmentNotExist(IndentHeader: Record "E3 Indent Header"): Boolean
    var
        DocumentAttachment: Record "Document Attachment";
    begin
        DocumentAttachment.SetRange("Table ID", Database::"E3 Indent Header");
        DocumentAttachment.SetRange("No.", IndentHeader."Document No.");
        exit(DocumentAttachment.IsEmpty());
    end;

    procedure ShortCloseIndent(var IndentHeader: Record "E3 Indent Header")
    var
        IndentLine: Record "E3 Indent Line";
        UserSetup: Record "User Setup";
        ShortCloseLbl: Label 'Do you want to short close this indent?';
        AlreadyClosedLbl: Label 'Indent is already short closed.';
        SuccessLbl: Label 'Indent No. %1 has been short closed.';
        UnauthorizedLbl: Label 'User %1 is not authorized to Short Close Indent.';
    begin
        // Check authorization
        UserSetup.Get(UserId);
        if not UserSetup."Short Close Indent" then
            Error(UnauthorizedLbl, UserId);

        // Check if already short closed
        if IndentHeader."Short Close Indent" then
            Error(AlreadyClosedLbl);

        // Check lines exist
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", IndentHeader."Document No.");
        if not IndentLine.FindFirst() then
            Error('No indent lines exist.');

        // Confirmation
        if not Confirm(ShortCloseLbl, false) then
            exit;

        // Update Header
        IndentHeader."Short Close Indent" := true;
        IndentHeader.Status := IndentHeader.Status::Closed;
        IndentHeader.Modify(true);

        // Update Lines
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", IndentHeader."Document No.");

        if IndentLine.FindSet() then
            repeat
                IndentLine."Short Close" := true;

                // Optional: Close remaining quantity
                IndentLine."Approved Qty" := 0;
                IndentLine.Modify(true);
            until IndentLine.Next() = 0;

        Message(SuccessLbl, IndentHeader."Document No.");
    end;

}