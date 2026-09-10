page 50235 "E3 Indent Stock Receipt Card"
{
    Caption = 'Stock Receipt Card';
    PageType = Card;
    SourceTable = "E3 Indent Sale/Purchase Header";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Voucher Type"; Rec."Voucher Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Voucher Type';
                }
                field("Nature Type"; Rec."Nature Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the nature type.';
                    trigger OnValidate()
                    begin
                        UpdateVendorCustomer();
                        CurrPage.Update();
                    end;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type.';
                    trigger OnValidate()
                    begin
                        UpdateVendorCustomer();
                        SetStockTransferSetup();
                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                    // trigger OnAssistEdit()
                    // begin
                    //     if Rec.AssistEdit(xRec) then
                    //         CurrPage.Update();
                    // end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    //Visible = false;
                    ToolTip = 'Specifies whether the transaction is for a vendor or customer.';
                }
                field("Vendor/Customer No."; Rec."Vendor/Customer No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the vendor or customer number.';
                }
                field("Vendor/Customer Name"; Rec."Vendor/Customer Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the vendor or customer name.';
                }
                field("From Location Code"; Rec."From Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                    trigger OnValidate()
                    var
                        Location: Record Location;
                        NoSeries: Codeunit "No. Series";
                    begin
                        if Rec."From Location Code" = '' then
                            exit;

                        Location.Get(Rec."From Location Code");

                        if Location."InterCompany Nos." = '' then
                            Error(
                                'Stock Receipt Issue No. Series is not configured for Location %1.',
                                Rec."From Location Code");

                        Rec."Document No." :=
                            NoSeries.GetNextNo(
                                Location."InterCompany Nos.",
                                WorkDate(),
                                true);
                        UpdateVendorCustomer();
                    end;
                }
                field("From Shortcut Dimension 1 Code"; Rec."From Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit code.';
                }
                field("From Shortcut Dimension 2 Code"; Rec."From Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code.';
                }

                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoice number.';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoice date.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
            }
            group(AmountDetails)
            {
                Caption = 'Amount Details';
                field("Create PO"; Rec."Create PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether a purchase order should be created.';
                }
            }
            group(ErrorDetails)
            {
                Caption = 'Error Details';
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the error description.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies remarks for the document.';
                }
            }
            part(Lines; "E3 Indent Stock Receipt Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("Document No."), "Entry Type" = field("Entry Type"), "Nature Type" = field("Nature Type");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Purchase Order")
            {
                Caption = 'Stock Receipt';
                ApplicationArea = All;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create a purchase order for the selected document.';

                trigger OnAction()
                var
                    InterUnitSalePurchMgt: Codeunit "E3 InterUnit Sale/Purch Mgt.";
                begin
                    if Rec."Document No." = '' then
                        Error('Document No. must not be blank.');

                    if Rec.Type <> Rec.Type::Vendor then
                        Error('Type must be Vendor to create a Purchase Order.');

                    InterUnitSalePurchMgt.InitPurchaseOrder(Rec."Entry Type", Rec."Nature Type", Rec."Document No.");

                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Nature Type" := Rec."Nature Type"::InterUnit;
        Rec."Entry Type" := Rec."Entry Type"::Purchase;
        Rec.Type := Rec.Type::Vendor;
        Rec."Document Date" := Today();
        Rec."Invoice Date" := Today();
        Rec."Posting Date" := Today();
    end;

    local procedure UpdateVendorCustomer()
    var
        StockTransferSetup: Record "E3 Stock Transfer Setup";
        Vendor: Record Vendor;
    begin
        Clear(Rec."Vendor/Customer No.");
        Clear(Rec."Vendor/Customer Name");

        if (Rec."Nature Type" <> Rec."Nature Type"::InterUnit) or
           (Rec."Entry Type" <> Rec."Entry Type"::Purchase) or
           (Rec."From Location Code" = '') then
            exit;

        StockTransferSetup.Reset();
        StockTransferSetup.SetRange("Nature Type", Rec."Nature Type");
        StockTransferSetup.SetRange("Entry Type", Rec."Entry Type");
        StockTransferSetup.SetRange("From Location", Rec."From Location Code");

        if StockTransferSetup.FindFirst() then begin
            Rec."Vendor/Customer No." := StockTransferSetup."Vendor Code";

            if Vendor.Get(Rec."Vendor/Customer No.") then
                Rec."Vendor/Customer Name" := Vendor.Name;
        end;
    end;

    local procedure SetStockTransferSetup()
    var
        StockTransferSetup: Record "E3 Stock Transfer Setup";
    begin
        StockTransferSetup.Reset();
        StockTransferSetup.SetRange("Nature Type", Rec."Nature Type");
        StockTransferSetup.SetRange("Entry Type", Rec."Entry Type");

        if StockTransferSetup.FindFirst() then begin
            Rec."From Location Code" := StockTransferSetup."From Location";
            Rec."From Shortcut Dimension 1 Code" := StockTransferSetup."From BU";
            Rec."From Shortcut Dimension 2 Code" := StockTransferSetup."From Dept";
        end;
    end;

}