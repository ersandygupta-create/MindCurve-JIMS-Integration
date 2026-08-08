page 50161 "E3 Quotation Card"
{
    Caption = 'Purchase Indent Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Document;
    SourceTable = "E3 Indent Header";
    SourceTableView = WHERE(Status = FILTER(Approved), "Release Indent" = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Indent No.';
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the indent number of the Indent No.';
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the Prepared by of the field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the request date of the Request Date.';
                }
                field("Voucher Type Code"; Rec."Voucher Type Code")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the voucher type code of the Voucher Type Code.';
                }
                field("Voucher Type Name"; Rec."Voucher Type Name")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the voucher type name of the Voucher Type Name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the status of the Status.';
                }

                field("Prepared Date"; Rec."Prepared Date")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the Prepared date of the Prepared Date.';
                }

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ToolTip = 'Specifies the approved by of the Approved By.';
                }
            }
            part("Quotation"; "E3 Vendor Quotation")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                Visible = true;
            }
        }
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"E3 Indent Header"), "No." = field("Document No.");
            }
            systempart(Control1000000031; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreatePO)
            {
                Caption = 'Create Purchase Order';
                ApplicationArea = All;
                Image = CreateDoc;

                trigger OnAction()
                var
                    Location: Record Location;
                    IndentLine: Record "E3 Indent Line";
                    PONos: Text[200];
                    WarningRequired: Boolean;
                begin
                    if not Confirm('Do you want to create Purchase Order?', true) then
                        exit;
                    Rec.TestField("Location Code");

                    Location.Get(Rec."Location Code");
                    Location.TestField("E3 Indent PO Series");

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");
                    IndentLine.SetRange("Vendor PO Creation", true);

                    if IndentLine.FindSet() then
                        repeat
                            if IndentLine."Ordered Qty" > IndentLine."Approved Qty" then
                                WarningRequired := true;

                            if IndentLine."Ordered Qty" <= 0 then
                                Error(
                                    'Ordered Qty must be greater than zero for Item %1, Line No. %2.',
                                    IndentLine."No.",
                                    IndentLine."Line No.");
                        until IndentLine.Next() = 0;

                    // Show warning only
                    if WarningRequired then
                        if not Confirm(
                            'Warning: Ordered Qty is greater than Approved Qty.\Do you want to continue creating the Purchase Order?',
                            false)
                        then
                            exit;

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");

                    Clear(CreatePurchaseOrders);
                    CreatePurchaseOrders.SetNoSeries(Location."E3 Indent PO Series");
                    CreatePurchaseOrders.SetTableView(IndentLine);
                    CreatePurchaseOrders.RunModal();

                    Clear(PONos);

                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."Document No.");

                    if IndentLine.FindSet() then
                        repeat
                            if IndentLine."Purchase Order No." <> '' then begin
                                if StrPos(
                                    ',' + PONos + ',',
                                    ',' + IndentLine."Purchase Order No." + ',') = 0
                                then begin
                                    if PONos = '' then
                                        PONos := IndentLine."Purchase Order No."
                                    else
                                        PONos += ', ' + IndentLine."Purchase Order No.";
                                end;
                            end;
                        until IndentLine.Next() = 0;

                    if PONos <> '' then
                        Message(
                            'Purchase Order(s) created successfully.%1PO No.(s): %2',
                            '\',
                            PONos)
                    else
                        Message('Purchase Order created successfully.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        HeaderEditable := Rec.Status <> Rec.Status::Approved;
    end;

    var
        IndentLine: Record "E3 Indent Line";
        IndentHeader: Record "E3 Indent Header";
        CreatePurchaseOrders: Report "E3 Create Purchase Order";
        HeaderEditable: Boolean;
}