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
            RequestFilterFields = "Bill Handling No.";
            column(EntryNo; "Entry No.") { }
            column(DocumentNo; "No.") { }
            column(PostingDate; SystemCreatedAt) { }
            column(LocationCode; "Location Code") { }
            column(VoucherTypeName; "Voucher Type Name") { }
            column(VendorName; "Vendor Name") { }
            column(GRNNo; "GRN No.") { }
            column(GRNDate; "GRN Date") { }
            column(BillHandlingNo; "Bill Handling No.") { }
            column(DocumentDate; "Challan Date") { }
            column(DueDate; "Due Date") { }
            column(Challan_No_; "Challan No.") { }
            column(Challan_Date; "Challan Date") { }
            column(Event_Name; "Event Name") { }
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
            column(NetAmountText; "Net Amount") { }

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
        PrintedAt: DateTime;
}
