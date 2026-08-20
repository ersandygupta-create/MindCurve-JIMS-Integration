report 50035 "E3 Gate OutWard Print"
{
    Caption = 'Gate Outward Print';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50035.GatePassOut.rdl';

    dataset
    {
        dataitem(GateEntryHeader; "E3 Posted Gate Entry Header")
        {
            RequestFilterFields = "Document No.";

            column(GateNo; "Document No.")
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(LocationName; LocationName)
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

            column(GatePassType; "Gate Pass Type")
            {
            }
            column(GatePassDateTime; SystemCreatedAt)
            {
            }
            column(Vendor_Name; "Vendor Name")
            {
            }
            column(To_Destination_Name; "To Destination Name")
            {

            }


            column(Vendor_No_; "Vendor No.")
            {
            }

            column(Person; Person)
            {
            }
            column(Vehicle_No_; Mode)
            {
            }

            column(Posting_Date; "Posting Date")
            {
            }

            column(Purpose_Description; "Purpose Description")
            {
            }
            column(From_Department_Name; "From Department Name")
            {
            }
            column(Expected_Return_Date; "Expected Return Date")
            {
            }

            column(ToDestination; "To Destination Code")
            {
            }
            column(Reference_Document_No_; "Reference Document No.")
            {
            }

            column(Remarks; Remarks)
            {
            }
            column(SystemCreatedBy; userc."Full Name")
            {
            }
            column(PrintedBy; PrintedByName)
            {
            }
            column(PrintedDateTime; CurrentDateTime())
            {
            }
            dataitem(GateEntryLine; "E3 Posted Gate Entry Line")
            {
                DataItemLink = "Document No." = field("Document No.");
                column(ItemName; "Item Name")
                {
                }
                column(SNo; SNo)
                {
                }

                column(Quantity; Quantity)
                {
                }
                column(UnitOfMeasurement; "Unit of Measurement")
                {
                }
                column(Serial_No_; "Serial No.")
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
                column(LineRemarks; Specification)
                {
                }
                trigger OnPreDataItem()
                begin
                    SNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                    LocationAdd := '';
                    ToDestination := '';
                    LocationAdd2 := '';
                    LocationPhoneNo := '';
                    LocationName := '';
                    CompanyInfo.Get();
                    CompanyInfo.CalcFields(Picture);

                    if UserC.Get(UserSecurityId()) then
                        PrintedByName := UserC."Full Name";

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

    }
    var
        GateNo: Code[20];
        GatePassType: Text[50];
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
        Sno: Integer;
        PrintedByName: Text[100];
        companyinfo: Record "company information";


}