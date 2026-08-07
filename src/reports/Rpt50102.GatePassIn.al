report 50102 "E3 Gate Inward Print"
{

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50102.GatePassIn.rdl';

    dataset
    {
        dataitem(GateEntryHeader; "E3 Gate Entry Header")
        {
            RequestFilterFields = "Document No.";


            column(GateNo; GateNo)
            {
            }
            column(PostedNo; "Document No.")
            { }
            column(Reference_Document_No_; "Reference Document No.")
            {
            }
            column(Purpose_Description; "Purpose Description")
            {
            }
            column(To_Destination_Name; "To Destination Name")
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }

            column(LocationCode; "To Destination Code")
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
            column(Vendor_Name; "Vendor Name")
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

            column(PurposeCode; "Purpose Code")
            {
            }
            column(From_Department_Name; "From Department Name")
            {
            }

            column(ToDestination; "To Destination Code")
            {
            }
            column(Expected_Return_Date; "Expected Return Date")
            {
            }

            column(Remarks; Remarks)
            {
            }
            column(PreparedBy; PreparedByName)
            {
            }
            column(PrintedBy; PrintedByName)
            {
            }
            column(PrintedDateTime; CurrentDateTime())
            {
            }
            column(GatePassDateTime; SystemCreatedAt)
            {
            }
            column(GateOutDate; GateOutDate)
            {
            }

            column(GateOutTime; GateOutTime)
            {
            }
            column(Posting_Date; "Posting Date")
            { }
            column(OutwardPostingDate; OutwardPostingDate)
            {
            }

            column(OutwardPostingDateTime; OutwardPostingDateTime)
            {
            }



            dataitem(GateEntryLine; "E3 Gate Entry Line")
            {
                DataItemLink = "Document No." = field("Document No.");

                column(Line_No_; "Line No.")
                {

                }
                column(SNo; SNo)
                {
                }
                column(ItemName; "Item Name")
                {
                }
                column(Serial_No_; "Serial No.")
                {

                }

                column(Quantity_Received; "Quantity Received")
                {
                }

                column(UnitOfMeasurement; "Unit of Measurement")
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
                column(LineRemarks; Specification)
                {
                }


                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                    LocationAdd := '';
                    ToDestination := '';
                    LocationAdd2 := '';
                    LocationPhoneNo := '';
                    LocationName := '';

                    Location.Reset();
                    Location.SetRange(Code, GateEntryHeader."Shortcut Dimension 1 Code");
                    if UserC.Get(SystemCreatedBy) then
                        PreparedByName := UserC."Full Name";



                    if Location.FindFirst() then begin
                        LocationAdd := Location.Address;
                        LocationAdd2 := Location."Address 2";
                        LocationPhoneNo := Location."Phone No.";
                        LocationName := Location.Name;
                    end;

                end;

            }


            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);

                if UserC.Get(UserSecurityId()) then
                    PrintedByName := UserC."Full Name";

                //Getout Date & time logic
                GateOutDate := 0D;
                GateOutTime := 0T;
                GateOutHeader.Reset();
                GateOutHeader.SetRange("Document No.", "Reference Document No.");
                if GateOutHeader.FindFirst() then begin
                    GateOutDate := DT2Date(GateOutHeader.SystemCreatedAt);
                    GateOutTime := DT2Time(GateOutHeader.SystemCreatedAt);
                end;
                Clear(OutwardPostingDate);
                Clear(OutwardPostingDateTime);

                OutwardHeader.Reset();
                OutwardHeader.SetRange("Document No.", GateEntryHeader."Document No.");

                if OutwardHeader.FindFirst() then begin
                    OutwardPostingDate := OutwardHeader."Posting Date";
                    OutwardPostingDateTime := OutwardHeader.SystemCreatedAt;
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
        GateLine: Record "E3 Gate Entry Line";
        Sno: Integer;
        companyinfo: Record "company information";
        PrintedByName: Text[100];
        PreparedByName: Text[100];
        GateOutHeader: Record "E3 Gate Entry Header";
        GateOutDate: Date;
        GateOutTime: Time;
        OutwardHeader: Record "E3 Gate Entry Header";
        OutwardPostingDate: Date;
        OutwardPostingDateTime: DateTime;



}