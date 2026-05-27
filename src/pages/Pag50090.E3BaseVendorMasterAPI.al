page 50090 "E3 Vendor API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'VendorAPI';
    DelayedInsert = true;
    EntityName = 'vendorAPI';
    EntitySetName = 'vendorAPIs';
    PageType = API;
    SourceTable = Vendor;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(county; Rec.County)
                {
                    Caption = 'County';
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(mobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(stateCode; Rec."State Code")
                {
                    Caption = 'State Code';
                }
                field(pANNo; Rec."P.A.N. No.")
                {
                    Caption = 'P.A.N. No.';
                }
                field(gstVendorType; Rec."GST Vendor Type")
                {
                    Caption = 'GST Vendor Type';
                }
                field(gstRegistrationNo; Rec."GST Registration No.")
                {
                    Caption = 'GST Registration No.';
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    local procedure DuplicateCheck()
    var
        Vendor: Record Vendor;
    begin
        Vendor.SetRange("No.", Rec."No.");
        if not Vendor.IsEmpty then
            error('Duplicate Entry');
    end;
}
