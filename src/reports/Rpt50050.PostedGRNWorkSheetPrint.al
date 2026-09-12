report 50050 "E3 GRN Work Sheet"
{
    Caption = 'GRN Work Sheet';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50050.PostedGRNWOrkSheetPrint.rdl';

    dataset
    {
        dataitem(Header; "E3 GRN Work Sheet Header")
        {
            RequestFilterFields = "Document ID";

            column(Document_ID; "Document ID")
            {
            }
            column(Voucher_Type; "Voucher Type")
            {
            }
            column(Prefix; Prefix)
            {
            }
            column(Voucher_Date; "Voucher Date")
            {
            }
            column(Department_Code; "Department Code")
            {
            }
            column(Department_Name; "Department Name")
            {
            }
            column(Supplier_Code; "Supplier Code")
            {
            }
            column(Place_of_Supply; "Place of Supply")
            {
            }
            column(Remark; Remark)
            {
            }
            column(Purchase_Challan_No; "Purchase Challan No.")
            {
            }
            column(Purchase_Challan_Date; "Purchase Challan Date")
            {
            }

            column(Gross_Amount; "OH Amount Gross")
            {
            }
            column(Discount_Amount; "OH Amount Discount")
            {
            }
            column(Taxable_Amount; "OH Amount Taxable")
            {
            }
            column(CGST_Amount; "OH Amount CGST")
            {
            }
            column(SGST_Amount; "OH Amount SGST")
            {
            }
            column(IGST_Amount; "OH Amount IGST")
            {
            }
            column(UGST_Amount; "OH Amount UGST")
            {
            }
            column(Total_Amount; "OH Amount Total")
            {
            }
            column(Final_Discount_Percent; "OH Final Discount %")
            {
            }
            column(Final_Discount_Amount; "OH Final Discount Amount")
            {
            }
            column(Round_Off; "OH Round Off")
            {
            }
            column(Net_Amount; "OH Net Amount")
            {
            }
            column(Landed_Value; "OH Landed Value")
            {
            }

            column(Prepared_By; "Prepared By")
            {
            }
            column(Prepared_Date; "Prepared Date")
            {
            }
            column(Approved_By; "Approved By")
            {
            }
            column(Approval_Date_Time; "Approval Date Time")
            {
            }

            column(Business_Unit_Code; "Business Unit Code")
            {
            }
            column(Business_Unit_Name; "Business Unit Name")
            {
            }
            column(RCM_Applicable; "RCM Applicable")
            {
            }
            column(Party_Type; "Party Type")
            {
            }
            column(GSTIN; GSTIN)
            {
            }
            column(E_Way_Bill_No; "E-Way Bill No.")
            {
            }
            column(E_Way_Bill_Date; "E-Way Bill Date")
            {
            }
            column(LR_No; "LR No.")
            {
            }
            column(LR_Date; "LR Date")
            {
            }
            column(GST_Location; "GST Location")
            {
            }
            column(Status; Status)
            {
            }
            column(Legal_Entity; "Legal Entity")
            {
            }

            // Company Information
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Company_Address_2; CompanyInfo."Address 2")
            {
            }
            column(Company_City; CompanyInfo.City)
            {
            }
            column(Company_Post_Code; CompanyInfo."Post Code")
            {
            }
            column(Company_Phone; CompanyInfo."Phone No.")
            {
            }
            column(Company_Email; CompanyInfo."E-Mail")
            {
            }
            column(Company_GSTIN; CompanyInfo."VAT Registration No.")
            {
            }
            column(Vendor_Code; VendorCode)
            {
            }
            column(Vendor_Name; VendorName)
            {
            }
            column(Vendor_GSTIN; VendorGSTIN)
            {
            }
            column(Vendor_PAN; VendorPANNo)
            {
            }
            column(Vendor_Email; VendorEmail)
            {
            }
            column(Vendor_Address; VendorAddress)
            {
            }
            column(Vendor_City; City)
            {
            }
            column(Location_Name; LocationName)
            {
            }
            column(Location_Name_2; LocName2)
            {
            }
            column(Location_Name_3; LocName3)
            {
            }
            column(Location_Address; LocationAdd)
            {
            }
            column(Location_Email; LocationEmail)
            {
            }
            column(Location_Phone_No; LocationPhoneNo)
            {
            }
            column(Location_GSTIN; LocationGSTIN)
            {
            }
            column(Vendor_Post_Code; PostCode)
            {
            }
            dataitem(Line; "E3 GRN Work Sheet Line")
            {
                DataItemLink = "Document ID" = field("Document ID");

                DataItemTableView =
                    sorting("Document ID", "Line No.");

                column(Line_No; "Line No.")
                {
                }
                column(Indent_Document_ID; "Indent Document ID")
                {
                }
                column(Indent_Line_No; "Indent Line No.")
                {
                }
                column(Item_Code; "Item Code")
                {
                }
                column(Item_Name; "Item Name")
                {
                }
                column(Department_Code_Line; "Department Code")
                {
                }
                column(Department_Name_Line; "Department Name")
                {
                }
                column(Unit_Code; "Unit Code")
                {
                }
                column(HSN_Code; "HSN Code")
                {
                }

                column(Indent_SKU_Qty; "Indent SKU Qty")
                {
                }
                column(Received_SKU_Qty; "Received SKU Qty")
                {
                }
                column(Rec_SKU_QTY; "Rec SKU QTY")
                {
                }

                column(Rate; Rate)
                {
                }
                column(Gross_Amount_Line; "Gross Amount")
                {
                }
                column(Discount_Amount_Line; "Discount Amount")
                {
                }
                column(Discount_Percent; "Discount %")
                {
                }
                column(Taxable_Amount_Line; "Taxable Amount")
                {
                }

                column(CGST_Percent; "CGST %")
                {
                }
                column(CGST_Amount_Line; "CGST Amount")
                {
                }
                column(SGST_Percent; "SGST %")
                {
                }
                column(SGST_Amount_Line; "SGST Amount")
                {
                }
                column(IGST_Percent; "IGST %")
                {
                }
                column(IGST_Amount_Line; "IGST Amount")
                {
                }
                column(UGST_Percent; "UGST %")
                {
                }
                column(UGST_Amount_Line; "UGST Amount")
                {
                }

                column(Final_Discount_Percent_Line; "Final Discount %")
                {
                }
                column(Final_Discount_Amount_Line; "Final Discount Amount")
                {
                }
                column(Net_Amount_Line; "Net Amount")
                {
                }
                column(Landed_SKU_Value; "Landed SKU Value")
                {
                }
                column(Landed_SKU_Rate; "Landed SKU Rate")
                {
                }

                column(MRP; MRP)
                {
                }
                column(SKU_MRP; "SKU MRP")
                {
                }
                column(Sale_Rate; "Sale Rate")
                {
                }
                column(SKU_Sale_Rate; "SKU Sale Rate")
                {
                }
                column(Staff_Sale_Rate; "Staff Sale Rate")
                {
                }
                column(SKU_Staff_Sale_Rate; "SKU Staff Sale Rate")
                {
                }

                column(Barcode; Barcode)
                {
                }
                column(Batch_No; "Batch No.")
                {
                }
                column(Manufacturing_Date; "Manufacturing Date")
                {
                }
                column(Expiry_Date; "Expiry Date")
                {
                }
                column(Item_Make_Code; "Item Make Code")
                {
                }
                column(GST_Type_Code; "GST Type Code")
                {
                }
                column(Item_GST_Nature; "Item GST Nature")
                {
                }
                column(Line_Remark; Remark)
                {
                }
                column(Line_Status; Status)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Clear(VendorCode);
                    Clear(VendorName);
                    Clear(VendorGSTIN);
                    Clear(VendorPANNo);
                    Clear(VendorEmail);
                    Clear(VendorAddress);
                    Clear(City);
                    Clear(PostCode);

                    Vendor.Reset();
                    Vendor.SetRange("No.", Header."Supplier Code");

                    if Vendor.FindFirst() then begin
                        VendorCode := Vendor."No.";
                        VendorName := Vendor.Name;
                        VendorGSTIN := Vendor."GST Registration No.";
                        VendorPANNo := Vendor."P.A.N. No.";
                        VendorEmail := Vendor."E-Mail";
                        VendorAddress := Vendor.Address + ' ' + Vendor."Address 2";
                        City := Vendor.City;
                        PostCode := Vendor."Post Code";
                    end;
                    LocationAdd := '';
                    LocationEmail := '';
                    LocationPhoneNo := '';
                    LocationGSTIN := '';
                    LocationName := '';
                    LocName2 := '';
                    LocName3 := '';

                    if "Department Code" <> '' then begin
                        Location.Reset();
                        Location.SetRange(Code, "Department Code");

                        if Location.FindFirst() then begin
                            LocationName := Location.Name;
                            LocName2 := Location."Name 2";
                            LocName3 := Location."Name 3";
                            LocationAdd :=
                                Location.Address + ', ' +
                                Location."Address 2" + ', ' +
                                Location.City + ', ' +
                                Format(Location."Post Code");
                            LocationEmail := Location."E-Mail";
                            LocationPhoneNo := Location."Phone No.";
                            LocationGSTIN := Location."GST Registration No.";
                        end;
                    end;

                end;


            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        VendorCode: Code[20];
        VendorName: Text[100];
        VendorGSTIN: Code[20];
        VendorPANNo: Code[20];
        VendorEmail: Text[80];
        VendorAddress: Text[200];
        City: Text[30];
        PostCode: Code[20];
        Location: Record Location;
        LocationAdd: Text[250];
        LocationEmail: Text[80];
        LocationPhoneNo: Text[30];
        LocationGSTIN: Text[20];
        LocationName: Text[100];
        LocName2: Text[50];
        LocName3: Text[50];


    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;
}
