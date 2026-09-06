tableextension 50016 "E3 HIS Purcha Line" extends "Purchase Line"
{
    fields
    {
        field(50000; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50003; "Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50004; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
        field(50005; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;
        }
        field(50006; "Item Make Name"; Text[60])
        {
            Caption = 'Item Make Name';
            DataClassification = CustomerContent;
        }
        field(50007; Critical; Boolean)
        {
            Caption = 'Critical';
            DataClassification = CustomerContent;
        }
        field(50008; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
        }
        field(50009; "SNo."; Integer)
        {
            Caption = 'SNo.';
            DataClassification = CustomerContent;
        }
        field(50010; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }
        field(50011; Scheme; Text[30])
        {
            Caption = 'Scheme';
            DataClassification = CustomerContent;
        }
        field(50012; "Margin Fix"; Enum "E3 Margin Fix")
        {
            Caption = 'Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50013; "Incl Free Qty in Sale Rate"; Boolean)
        {
            Caption = 'Include Free Qty in Sale Rate';
            DataClassification = CustomerContent;
        }
        field(50014; "Entry No."; Code[50])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Margin Code"; Code[20])
        {
            Caption = 'Margin Code';
            DataClassification = CustomerContent;
            tableRelation = "E3 Item Margin"."Margin Code";
        }
        field(50016; "Company Value"; Decimal)
        {
            Caption = 'Company Value';
            DataClassification = CustomerContent;
        }
        field(50017; "Patient Value"; Decimal)
        {
            Caption = 'Patient Value';
            DataClassification = CustomerContent;
        }
        field(50018; "Indent Line Remarks"; Text[200])
        {
            Caption = 'Indent Line Remarks';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Line Remarks"; Text[200])
        {
            Caption = 'Line Remarks';
            DataClassification = CustomerContent;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                PurchHeader: Record "Purchase Header";
                E3ItemMargin: Record "E3 Item Margin";
                Location: Record Location;
            begin
                IF Rec.Type = Rec.Type::Item then begin
                    Item.Get("No.");
                    Validate("E3 Item Type", Item."E3 Item Type");
                    IF PurchHeader.Get("Document Type", "Document No.") then
                        if PurchHeader."E3 Item Type" = PurchHeader."E3 Item Type"::"Non Pharmacy" then
                            IF PurchHeader."E3 Item Type" <> Item."E3 Item Type" then
                                Error('You can''t select other than Non Pharmacy Item %1 !', Item."No.");

                    if Type <> Type::Item then
                        exit;

                    Clear("Item Make Code");
                    Clear("Item Make Name");
                    Clear(Rec."Margin Code");
                    Clear(Rec."Company Value");
                    Clear(Rec."Patient Value");


                    if Item.Get("No.") then begin
                        "Item Make Code" := Item."Item Make Code";
                        "Item Make Name" := Item."Make Name";
                        "Margin Code" := Item."E3 Margin Code";
                        if (Rec."Margin Code" <> '') and
                       (PurchHeader."Shortcut Dimension 1 Code" <> '')
                    then begin

                            E3ItemMargin.Reset();

                            E3ItemMargin.SetRange(
                                "Margin Code",
                                Rec."Margin Code"
                            );

                            E3ItemMargin.SetRange(
                                "Business Unit Code",
                                PurchHeader."Shortcut Dimension 1 Code"
                            );

                            if E3ItemMargin.FindFirst() then begin

                                // Company Value
                                Rec."Company Value" :=
                                    E3ItemMargin."Company Value";

                                // Patient Value
                                Rec."Patient Value" :=
                                    E3ItemMargin."Patient Value";

                                if PurchHeader.Get("Document Type", "Document No.") then begin
                                    if PurchHeader."Location Code" <> '' then begin
                                        if Location.Get(PurchHeader."Location Code") then
                                            "GST Credit" := Location."GST Credit";
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnBeforeValidate()
            begin
                if Rec.FOC then
                    Rec."Direct Unit Cost" := 0;
            end;
        }
        modify(FOC)
        {
            trigger OnAfterValidate()
            begin
                if Rec.FOC then
                    Rec."Direct Unit Cost" := 0;
            end;
        }
    }
}
