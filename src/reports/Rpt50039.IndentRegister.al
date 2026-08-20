report 50039 "Indent Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Indent Register';
    RDLCLayout = './src/reports/Rpt50039.IndentRegister.rdl';

    dataset
    {
        dataitem(E3IndentHeader; "E3 Indent Header")

        {
            RequestFilterFields = "Request Date", "Status";
            column(Document_No_; "Document No.")
            {

            }
            column(FromDate; FromDateFilter)
            {
            }
            column(ToDate; ToDateFilter)
            {
            }
            column(StatusFilter; StatusFilter)
            {
            }
            column(CompPicture; CompInfo.Picture) { }
            //column(RequestDate; Format("Request Date")) { }
            column(Request_Date; "Request Date")
            {

            }
            column(Requested_By; "Prepared By") { }

            column(ApprovedBy; "Approved By") { }
            column(Department_Name; "Department Name") { }
            column(EntryNo; "Entry No.") { }
            column(Indenter_Name; "Indenter Name") { }
            column(ApprovalDateTime; "Approval Date Time") { }
            column(VoucherTypeCode; "Voucher Type Code") { }
            column(VoucherTypeName; "Voucher Type Name") { }
            column(Status; Status) { }
            column(Remarks; Remarks) { }
            column(LocationName; LocationName) { }
            column(LocationAdd; LocationAdd) { }
            column(LocationAdd2; LocationAdd2) { }
            column(DocumentNoLbl; DocumentNo) { }
            column(RequestDtLbl; RequestDt) { }
            column(RequestedByLbl; RequstedBy) { }
            column(IndentorLbl; Indentor) { }
            column(ApprovedByLbl; ApprovedBy) { }
            column(StatusLbl; Status) { }

            dataitem(IndentLine; "E3 Indent Line")
            {
                DataItemLink = "Document No." = field("Document No.");
                DataItemLinkReference = E3IndentHeader;

                column(LineNo; "Line No.") { }
                column(Type; Type) { }
                column(ItemNo; "No.") { }
                column(Description; Description) { }
                column(UnitofMeasure; "Unit of Measure") { }
                //column(CriticalItem; "Critical Item") { }
                column(RequestedQty; "Requested Qty") { }
                column(Requested_Received_Date; "Requested Received Date") { }
                column(ApprovedQty; "Approved Qty") { }
                column(UnitCost; "Unit Cost") { }
                column(Amount; Amount) { }
                column(OrderedQty; "Ordered Qty") { }
                // column(TotalOrderedQty; "First Ordered Qty" + "Second Ordered Qty" + "Third Ordered Qty")
                // {
                // }
                column(ItemMakeName; "Item Make Name") { }
            }
            trigger OnAfterGetRecord()
            begin

                LocationAdd := '';
                LocationAdd2 := '';
                LocationPhoneNo := '';
                LocationName := '';




                Location.Reset();
                Location.SetRange(Code, E3IndentHeader."Shortcut Dimension 1 Code");
                if userc.Get(SystemCreatedBy) then;
                //   if userc.Get(PrintedBy) then;

                if Location.FindFirst() then begin
                    LocationAdd := Location.Address;
                    LocationAdd2 := Location."Address 2";
                    LocationPhoneNo := Location."Phone No.";
                    LocationName := Location.Name;

                end;
            end;

            trigger OnPreDataItem()
            begin
                FromDateFilter := GetRangeMin("Request Date");
                ToDateFilter := GetRangeMax("Request Date");
                StatusFilter := GetFilter("Status");
            end;


        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                // group(GroupName)
                // {
                //     field(Name; SourceExpression)
                //     {

                //     }
                // }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        Location: Record Location;
        LocationAdd: Text[200];
        LocationCode: Text[20];
        LocationAdd2: Text[100];
        LocationPhoneNo: Text[30];
        LocationName: Text[100];
        UserC: Record User;
        DocumentNo: Label 'Indent No.';
        RequestDt: Label 'Request Date';
        RequstedBy: Label 'Requested By';
        Indentor: Label 'Indenter';
        ApprovedBy: Label 'Approved By';
        Status: Label 'Status';
        RequestDate: Date;
        FromDateFilter: Date;
        ToDateFilter: Date;
        StatusFilter: Text;

}