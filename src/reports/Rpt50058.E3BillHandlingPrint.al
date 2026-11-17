report 50058 "E3 Bill Handling Print"
{
    Caption = 'Bill Handle';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50058.E3BillHandlingPrint.rdl';

    dataset
    {
        dataitem(BillHandling; "E3 Bill Handling")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "No.", "Location Code", "Posting Date", "Vendor Code";
            column(EntryNo; "Entry No.") { }
            column(DocumentNo; "No.") { }
            column(PostingDate; "Posting Date") { }
            column(LocationCode; "Location Code") { }
            column(VoucherTypeName; "Voucher Type Name") { }
            column(VendorName; "Vendor Name") { }
            column(GRNNo; "GRN No.") { }
            column(GRNDate; "GRN Date") { }
            column(BillHandlingNo; "Bill Handling No.") { }
            column(DocumentDate; "Challan Date") { }
            column(DueDate; "Due Date") { }
            column(Remarks; Remarks) { }
            column(PreparedBy; "Created By") { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(LocationName; LocationRec.Name) { }
            column(LocationName2; LocationRec."Name 2") { }
            column(LocationName3; LocationRec."Name 3") { }
            column(LocationAddress; LocationRec.Address) { }
            column(LocationAddress2; LocationRec."Address 2") { }
            column(LocationCity; LocationRec.City) { }
            column(LocationPhone; LocationRec."Phone No.") { }
            column(ToLocationName; ToLocationName) { }
            column(CheckedBy; CheckedBy) { }
            column(PrintedBy; UserId()) { }
            column(PrintedAt; PrintedAt) { }
            // No amount field or reliable amount relation exists in table 50094.
            // Keep the reference layout's Net Amt. cell empty until a source is defined.
            column(NetAmountText; EmptyAmount) { }

            trigger OnAfterGetRecord()
            begin
                Clear(LocationRec);
                if "Location Code" <> '' then
                    if not LocationRec.Get("Location Code") then
                        Clear(LocationRec);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(ToLocationNameInput; ToLocationName)
                    {
                        Caption = 'To Location Code';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the destination printed on this report; it is not stored in the bill handling table.';
                    }
                    field(CheckedByInput; CheckedBy)
                    {
                        Caption = 'Checked By';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the person who accepted the bills in accounts.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        PrintedAt := CurrentDateTime();
    end;

    var
        CompanyInfo: Record "Company Information";
        LocationRec: Record Location;
        ToLocationName: Text[100];
        CheckedBy: Text[100];
        EmptyAmount: Text[1];
        PrintedAt: DateTime;
}
