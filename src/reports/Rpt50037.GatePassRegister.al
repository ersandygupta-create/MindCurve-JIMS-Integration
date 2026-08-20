report 50037 "Gate Pass Register"
{
    Caption = 'Gate Pass Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50037.GatePassRegister.rdl';

    dataset
    {
        dataitem(GateEntryHeader; "E3 Posted Gate Entry Header")
        {

            RequestFilterFields = "Document No.", "Posting Date", "Gate Pass Type", "Entry Type";

            column(CompanyShortName; 'JIMS')
            {
            }
            column(FinancialYear; FinancialYear)
            {
            }
            column(LocationAdd; LocationAdd)
            {
            }
            column(LocationAdd2; LocationAdd2)
            {
            }
            column(LocationPhoneNo; LocationPhoneNo)
            {
            }
            column(EntryTypeFilter; EntryType)
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }

            column(DocumentNoFilter; DocumentNo)
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Status; Status)
            {

            }
            column(Posted_Entry_No_; "Posted Entry No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }

            column(From_Department_Code; "From Department Code")
            {
            }
            column(From_Department_Name; "From Department Name")
            {
            }
            column(ToDept; ToDept)
            { }
            column(FromDept; FromDept)
            { }
            column(Vendor_Name; "Vendor Name")
            {
            }

            column(PurposeCode; "Purpose Code")
            {
            }

            column(Location_Code; "To Destination Code")
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(SystemCreatedBy; userc."User Name")
            {
            }
            column(Vehicle_No_; Mode)
            {
            }

            //Paty No.
            column(Party_No; "Vendor No.")
            {
            }
            column(Purpose_Description; "Purpose Description")
            {
            }
            column(Person; Person)
            {
            }
            column(BU; "Shortcut Dimension 1 Code")
            {
            }
            column(Expected_Return_Date; "Expected Return Date")
            {
            }
            column(Reference_Document_No_; "Reference Document No.")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(FromDate; FromDateFilter)
            {
            }

            column(ToDate; ToDateFilter)
            {
            }

            column(PrintedBy; userc."User Name")
            {
            }
            column(EntryType; "Entry Type")
            {
            }

            column(GatePassTypeFilter; GatePassType)
            {
            }
            column(GatePassType; GatePassType)
            {
            }
            column(FromDepartmentFilter; GateEntryHeader.GetFilter("From Department Name"))
            {
            }
            column(DestinationFilter; GateEntryHeader.GetFilter("To Destination Code"))
            {
            }


            // trigger OnPreDataItem()
            // begin
            //     FromDateFilter := '';
            //     ToDateFilter := '';
            // end;


            dataitem(GateEntryLine; "E3 Posted Gate Entry Line")
            {
                DataItemLink = "Document No." = field("Document No.");

                column(Item_No_; "Item No.")
                {
                }
                column(ItemName; "Item Name")
                {
                }
                column(UnitOfMeasurement; "Unit of Measurement")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Quantity_Received; "Quantity Received")
                {
                }
                column(Estimated_Value_Receive; "Estimated Value Receive")
                {
                }
                column(EstimatedValue; "Estimated Value")
                {
                }

                column(AssetNo; "Asset No.")
                {
                }
                column(Fixed_Asset_Name; "Fixed Asset Name")
                {
                }
                column(Serial_No_; "Serial No.")
                {
                }
                column(LineRemarks; Specification)
                {
                }

            }
            trigger OnAfterGetRecord()
            begin
                FinancialYear := '2026-27';
                // LocationAdd := '';
                ToDestination := '';
                LocationAdd2 := '';
                LocationPhoneNo := '';
                LocationName := '';
                DocumentNo := GetFilter("Document No.");
                GatePassType := GetFilter("Gate Pass Type");
                EntryType := GetFilter("Entry Type");
                FromDateFilter := GetRangeMin("Posting Date");
                ToDateFilter := GetRangeMax("Posting Date");
                FromDept := "From Department Name";
                //  if Location.Get(Location) then;
                if GateEntryHeader."To Destination Code" <> '' then begin
                    Location.Reset();
                    Location.SetRange(Code, GateEntryHeader."Shortcut Dimension 1 Code");
                    if userc.Get(SystemCreatedBy) then;

                    if Location.FindFirst() then begin
                        LocationAdd := Location.Address;
                        LocationAdd2 := Location."Address 2";
                        LocationPhoneNo := Location."Phone No.";
                        LocationName := Location.Name;
                    end;
                end;
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
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {

                    // }
                }
            }
        }

        actions
        {
            // area(processing)
            // {
            //     action(LayoutName)
            //     {

            //     }
            // }
        }
    }
    var
        GateNo: Code[20];
        EmployeeCode: Code[30];
        PersonMode: Text[100];
        EstdDate: Date;
        PostingDate: Date;
        PurposeCode: Code[30];
        DepartmentCode: Code[40];
        ToDestination: Text[100];
        RemarksTxt: Text[250];
        Location: Record Location;
        LocationAdd: Text[200];
        LocationCode: Text[20];
        LocationAdd2: Text[100];
        LocationPhoneNo: Text[30];
        LocationName: Text[100];
        UserC: Record User;
        FromDateFilter: Date;
        ToDateFilter: Date;
        FromDept: Text[100];
        ToDept: Text[100];
        EntryType: Text[100];
        GatePassType: Text[250];
        DocumentNo: Text[100];
        FinancialYear: Text[10];

}