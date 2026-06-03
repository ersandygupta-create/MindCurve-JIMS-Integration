codeunit 50000 "E3 HIS Integration Mgmt."
{
    Permissions = tabledata "Purch. Inv. Header" = rm,
    tabledata "Purch. Inv. Line" = rm,
    tabledata "Purch. Cr. Memo Hdr." = rm,
    tabledata "Purch. Cr. Memo Line" = rm;

    trigger OnRun()
    begin
    end;

    procedure InitVendorMaster(EntryNo: Integer)
    var
        VendorRec: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        Vendor1: Record Vendor;
        VendBankAccount: Record "Vendor Bank Account";
        PANNo: Code[10];
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Vendor Creation Enabled") THEN
            EXIT;
        HisMasterStaging.RESET();
        HisMasterStaging.SETRANGE("Entry No.", EntryNo);
        HisMasterStaging.SETRANGE(IsCreated, FALSE);
        HisMasterStaging.SETRANGE("Party Type", HisMasterStaging."Party Type"::Vendor);
        HisMasterStaging.SETFILTER("Error Description", '%1', '');
        HisMasterStaging.SETFILTER("HIS Code", '<>%1', '');
        IF HisMasterStaging.FINDSET() THEN
            REPEAT
                HisMasterStaging.TestField("Gen. Bus. Posting Group");
                HisMasterStaging.TestField("VENDOR Posting Group");

                HisMasterStaging.TestField("HIS Code");

                Vendor1.RESET();
                Vendor1.SETRANGE("E3 HIS Code", HisMasterStaging."HIS Code");
                IF NOT Vendor1.FINDFIRST() THEN BEGIN
                    VendorPostingGroup.RESET();
                    VendorPostingGroup.SETRANGE(Code, HisMasterStaging."Vendor Posting Group");
                    IF VendorPostingGroup.FINDFIRST() THEN BEGIN
                        HisMasterStaging.TESTFIELD("State Code");
                        HisMasterStaging.TESTFIELD("GST Vendor Type");
                        IF HisMasterStaging."GST Vendor Type" <> HisMasterStaging."GST Vendor Type"::Unregistered THEN BEGIN
                            HisMasterStaging.TESTFIELD("GST Registration No.");
                            IF (HisMasterStaging."GST Registration No." <> '') AND (HisMasterStaging."P.A.N. No." <> COPYSTR(HisMasterStaging."GST Registration No.", 3, 10)) THEN
                                ERROR(SamePANErr);

                        END;
                        // IF HisMasterStaging."GST Registration No." <> '' THEN BEGIN
                        //     Vendor1.RESET();
                        //     Vendor1.SETRANGE(Vendor1."GST Registration No.", HisMasterStaging."GST Registration No.");
                        //     IF Vendor1.FINDSET() THEN
                        //         REPEAT
                        //             ERROR('Same GST Registration No. is already Exist Vendor No. %1 & Vendor Name %2', Vendor1."No.", Vendor1.Name);
                        //         UNTIL Vendor1.NEXT() = 0;
                        // END;
                        //HisMasterStaging.TESTFIELD("P.A.N. No.");
                        //HisMasterStaging.TESTFIELD("Payment Terms Code");
                        VendorRec.INIT();
                        VendorRec.VALIDATE("No.", HisMasterStaging."HIS Code");
                        VendorRec.VALIDATE(Name, HisMasterStaging.Name);
                        VendorRec."Name 2" := COPYSTR(HisMasterStaging."Name 2", 1, 50);
                        ;
                        VendorRec.Address := COPYSTR(HisMasterStaging.Address, 1, 50);
                        VendorRec."Address 2" := COPYSTR(HisMasterStaging."Address 2", 1, 50);
                        VendorRec.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        VendorRec.VALIDATE(City, HisMasterStaging.City);
                        VendorRec.Contact := HisMasterStaging.Contact;
                        VendorRec."Phone No." := HisMasterStaging."Phone No.";
                        VendorRec.INSERT();
                        VendorRec.VALIDATE("Vendor Posting Group", HisMasterStaging."Vendor Posting Group");
                        VendorRec.VALIDATE("Country/Region Code", HisMasterStaging."Country/Region Code");
                        VendorRec.VALIDATE("Gen. Bus. Posting Group", 'GEN');//HisMasterStaging."Gen. Bus. Posting Group");
                        VendorRec.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        VendorRec.Validate("Country/Region Code", HisMasterStaging.County);
                        //VendorRec.VALIDATE(County, HisMasterStaging.County);
                        VendorRec.VALIDATE("State Code", HisMasterStaging."State Code");
                        VendorRec.Validate("Global Dimension 1 Code", HisMasterStaging."Global Dimension 1 Code");
                        VendorRec.Validate("Location Code", HisMasterStaging."Global Dimension 1 Code");
                        VendorRec.Validate("Responsibility Center", HisMasterStaging."Global Dimension 1 Code");
                        //VendorRec.Validate("EDC Security Center Code", HisMasterStaging."Global Dimension 1 Code");
                        VendorRec."P.A.N. No." := HisMasterStaging."P.A.N. No.";
                        VendorRec."GST Registration No." := HisMasterStaging."GST Registration No.";
                        VendorRec."GST Vendor Type" := HisMasterStaging."GST Vendor Type";
                        VendorRec."E3 MSME Type" := HisMasterStaging."MSME Type";
                        VendorRec."E3 MSME No." := HisMasterStaging."MSME No.";
                        VendorRec."Application Method" := HisMasterStaging."Application Method";
                        VendorRec."Payment Terms Code" := HisMasterStaging."Payment Terms Code";
                        VendorRec."ARN No." := HisMasterStaging."GST Registration No.";
                        GSTState := COPYSTR(HisMasterStaging."GST Registration No.", 1, 2);
                        //IF HisMasterStaging."GST Vendor Type" <> HisMasterStaging."GST Vendor Type"::Unregistered THEN BEGIN
                        if HisMasterStaging."GST Registration No." <> '' then begin
                            recState.RESET();
                            recState.SETRANGE(recState.Code, HisMasterStaging."State Code");
                            IF recState.FINDFIRST() THEN
                                IF recState."State Code (GST Reg. No.)" <> GSTState THEN
                                    ERROR('Wrong State code for Enterded GSTIN');
                            PANNo := COPYSTR(HisMasterStaging."GST Registration No.", 3, 10);
                            IF HisMasterStaging."P.A.N. No." <> PANNo THEN
                                ERROR('Difference in PAN with Reference GST Registration No.');
                            VendorRec."GST Vendor Type" := VendorRec."GST Vendor Type"::Registered;
                        END;
                        VendorRec."E3 HIS Code" := HisMasterStaging."HIS Code";
                        VendorRec."E3 HIS Type" := HisMasterStaging."HIS Type";
                        VendorRec.MODIFY();
                        IF HisMasterStaging."Bank Account No." <> '' THEN begin
                            VendBankAccount.Init();
                            VendBankAccount.VALIDATE("Vendor No.", VendorRec."No.");
                            VendBankAccount.VALIDATE(Code, 'HIS' + '-' + COPYSTR(VendorRec."No.", 1, 16));
                            VendBankAccount.VALIDATE(Name, HisMasterStaging."VC Bank Account Name");
                            VendBankAccount.VALIDATE(Address, HisMasterStaging.Address);
                            VendBankAccount.VALIDATE("Address 2", HisMasterStaging."Address 2");
                            VendBankAccount.VALIDATE("Bank Account No.", HisMasterStaging."Bank Account No.");
                            VendBankAccount.VALIDATE("Bank Branch No.", HisMasterStaging."Bank Branch No.");
                            VendBankAccount.VALIDATE("E3 IFSC Code", HisMasterStaging."IFSC Code");
                            VendBankAccount.Validate("Post Code", HisMasterStaging."Bank Post Code");
                            VendBankAccount.Validate(City, HisMasterStaging."Bank City");
                            VendBankAccount.Insert();
                        end;

                        HisMasterStaging."Vendor/Customer Code" := VendorRec."No.";
                        HisMasterStaging.IsCreated := TRUE;
                        HisMasterStaging."Modified by" := UserId;
                        HisMasterStaging."Modified Date Time" := CurrentDateTime;
                        HisMasterStaging.MODIFY();
                        MESSAGE('Vendor has been created Successfully');
                    END ELSE BEGIN
                        HisMasterStaging."Error Description" := 'Check Vendor Posting Group';
                        MESSAGE('Vendor Posting Group not Exists');
                    END;
                    HisMasterStaging.MODIFY();
                END;
            UNTIL HisMasterStaging.NEXT() = 0
        ELSE
            Error('HIS Code is missing.Kindly check Error Desciption');
    end;

    procedure InitDoctorMaster(EntryNo: Integer)
    var
        VendorRec: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        Vendor1: Record Vendor;
        VendBankAccount: Record "Vendor Bank Account";
        PANNo: Code[10];
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Vendor Creation Enabled") THEN
            EXIT;
        HisMasterStaging.RESET();
        HisMasterStaging.SETRANGE("Entry No.", EntryNo);
        HisMasterStaging.SETRANGE(IsCreated, FALSE);
        HisMasterStaging.SETRANGE("Party Type", HisMasterStaging."Party Type"::Doctor);
        HisMasterStaging.SETFILTER("Error Description", '%1', '');
        HisMasterStaging.SETFILTER("HIS Code", '<>%1', '');
        IF HisMasterStaging.FINDSET() THEN
            REPEAT
                HisMasterStaging.TestField("Gen. Bus. Posting Group");
                HisMasterStaging.TestField("VENDOR Posting Group");

                HisMasterStaging.TestField("HIS Code");

                Vendor1.RESET();
                Vendor1.SETRANGE("E3 HIS Code", HisMasterStaging."HIS Code");
                IF NOT Vendor1.FINDFIRST() THEN BEGIN
                    VendorPostingGroup.RESET();
                    VendorPostingGroup.SETRANGE(Code, HisMasterStaging."Vendor Posting Group");
                    IF VendorPostingGroup.FINDFIRST() THEN BEGIN
                        HisMasterStaging.TESTFIELD("State Code");
                        HisMasterStaging.TESTFIELD("GST Vendor Type");
                        IF HisMasterStaging."GST Vendor Type" <> HisMasterStaging."GST Vendor Type"::Unregistered THEN BEGIN
                            HisMasterStaging.TESTFIELD("GST Registration No.");
                            IF (HisMasterStaging."GST Registration No." <> '') AND (HisMasterStaging."P.A.N. No." <> COPYSTR(HisMasterStaging."GST Registration No.", 3, 10)) THEN
                                ERROR(SamePANErr);

                        END;

                        HisMasterStaging.TESTFIELD("P.A.N. No.");
                        //HisMasterStaging.TESTFIELD("Payment Terms Code");
                        VendorRec.INIT();
                        VendorRec.VALIDATE("No.", HisMasterStaging."HIS Code");
                        VendorRec.VALIDATE(Name, HisMasterStaging.Name);
                        VendorRec."Name 2" := COPYSTR(HisMasterStaging."Name 2", 1, 50);
                        ;
                        VendorRec.Address := COPYSTR(HisMasterStaging.Address, 1, 50);
                        VendorRec."Address 2" := COPYSTR(HisMasterStaging."Address 2", 1, 50);
                        VendorRec.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        VendorRec.VALIDATE(City, HisMasterStaging.City);
                        VendorRec.Contact := HisMasterStaging.Contact;
                        VendorRec."Phone No." := HisMasterStaging."Phone No.";
                        VendorRec.INSERT();
                        VendorRec.VALIDATE("Vendor Posting Group", HisMasterStaging."Vendor Posting Group");
                        VendorRec.VALIDATE("Country/Region Code", HisMasterStaging."Country/Region Code");
                        VendorRec.VALIDATE("Gen. Bus. Posting Group", HisMasterStaging."Gen. Bus. Posting Group");
                        VendorRec.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        VendorRec.Validate("Country/Region Code", HisMasterStaging.County);
                        VendorRec.VALIDATE(County, HisMasterStaging.County);
                        VendorRec.VALIDATE("State Code", HisMasterStaging."State Code");
                        VendorRec.Validate("Global Dimension 1 Code", HisMasterStaging."Global Dimension 1 Code");
                        VendorRec."P.A.N. No." := HisMasterStaging."P.A.N. No.";
                        VendorRec."GST Registration No." := HisMasterStaging."GST Registration No.";
                        VendorRec."GST Vendor Type" := HisMasterStaging."GST Vendor Type";
                        VendorRec."E3 MSME Type" := HisMasterStaging."MSME Type";
                        VendorRec."E3 MSME No." := HisMasterStaging."MSME No.";
                        VendorRec."Application Method" := HisMasterStaging."Application Method";
                        VendorRec."Payment Terms Code" := HisMasterStaging."Payment Terms Code";
                        VendorRec."ARN No." := HisMasterStaging."GST Registration No.";
                        GSTState := COPYSTR(HisMasterStaging."GST Registration No.", 1, 2);
                        //IF HisMasterStaging."GST Vendor Type" <> HisMasterStaging."GST Vendor Type"::Unregistered THEN BEGIN
                        if HisMasterStaging."GST Registration No." <> '' then begin
                            recState.RESET();
                            recState.SETRANGE(recState.Code, HisMasterStaging."State Code");
                            IF recState.FINDFIRST() THEN
                                IF recState."State Code (GST Reg. No.)" <> GSTState THEN
                                    ERROR('Wrong State code for Enterded GSTIN');
                            PANNo := COPYSTR(HisMasterStaging."GST Registration No.", 3, 10);
                            IF HisMasterStaging."P.A.N. No." <> PANNo THEN
                                ERROR('Difference in PAN with Reference GST Registration No.');
                            VendorRec."GST Vendor Type" := VendorRec."GST Vendor Type"::Registered;
                        END;
                        VendorRec."E3 HIS Code" := HisMasterStaging."HIS Code";
                        VendorRec."E3 HIS Type" := HisMasterStaging."HIS Type";
                        VendorRec.MODIFY();
                        IF HisMasterStaging."Bank Account No." <> '' THEN begin
                            VendBankAccount.Init();
                            VendBankAccount.VALIDATE("Vendor No.", VendorRec."No.");
                            VendBankAccount.VALIDATE(Code, 'HIS' + '-' + COPYSTR(VendorRec."No.", 1, 16));
                            VendBankAccount.VALIDATE(Name, HisMasterStaging."VC Bank Account Name");
                            VendBankAccount.VALIDATE(Address, HisMasterStaging.Address);
                            VendBankAccount.VALIDATE("Address 2", HisMasterStaging."Address 2");
                            VendBankAccount.VALIDATE("Bank Account No.", HisMasterStaging."Bank Account No.");
                            VendBankAccount.VALIDATE("Bank Branch No.", HisMasterStaging."Bank Branch No.");
                            VendBankAccount.VALIDATE("E3 IFSC Code", HisMasterStaging."IFSC Code");
                            VendBankAccount.Validate("Post Code", HisMasterStaging."Bank Post Code");
                            VendBankAccount.Validate(City, HisMasterStaging."Bank City");
                            VendBankAccount.Insert();
                        end;

                        HisMasterStaging."Vendor/Customer Code" := VendorRec."No.";
                        HisMasterStaging.IsCreated := TRUE;
                        HisMasterStaging."Modified by" := UserId;
                        HisMasterStaging."Modified Date Time" := CurrentDateTime;
                        HisMasterStaging.MODIFY();
                        MESSAGE('Doctor has been created Successfully');
                    END ELSE BEGIN
                        HisMasterStaging."Error Description" := 'Check Doctor Posting Group';
                        MESSAGE('Doctor Posting Group not Exists');
                    END;
                    HisMasterStaging.MODIFY();
                END;
            UNTIL HisMasterStaging.NEXT() = 0
        ELSE
            Error('HIS Code is missing.Kindly check Error Desciption');
    end;



    procedure InitCustomerMaster(EntryNo: Integer)
    var
        Customer1: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        Customer: Record "Customer";
        CustBankAccount: Record "Customer Bank Account";
    BEGIN
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Customer Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Custom Gen. Bus. Posting Group");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Customer Creation Enabled") THEN
            EXIT;
        HisMasterStaging.RESET();
        HisMasterStaging.SETRANGE("Party Type", HisMasterStaging."Party Type"::Customer);
        HisMasterStaging.SETRANGE("Entry No.", EntryNo);
        HisMasterStaging.SETRANGE(IsCreated, FALSE);
        HisMasterStaging.SETFILTER("HIS Code", '<>%1', '');
        HisMasterStaging.SETFILTER("Error Description", '%1', '');
        IF HisMasterStaging.FINDSET() THEN
            REPEAT
                HisMasterStaging.TestField("Gen. Bus. Posting Group");
                HisMasterStaging.TestField("Customer Posting Group");

                HisMasterStaging.TestField("HIS Code");
                Customer1.RESET();
                Customer1.SETRANGE("E3 HIS Code", HisMasterStaging."HIS Code");
                IF NOT Customer1.FINDFIRST() THEN BEGIN
                    CustomerPostingGroup.RESET();
                    CustomerPostingGroup.SETRANGE(Code, HisMasterStaging."Customer Posting Group");
                    IF CustomerPostingGroup.FINDFIRST() THEN BEGIN
                        //HisMasterStaging.TESTFIELD("Global Dimension 1 Code");
                        IF HisMasterStaging."GST Registration No." <> '' THEN BEGIN
                            Customer1.RESET();
                            Customer1.SETRANGE("GST Registration No.", HisMasterStaging."GST Registration No.");
                            IF Customer1.FINDSET() THEN
                                REPEAT
                                    ERROR('Same GST Registration No. is already Exist Customer No. %1 & Customer Name %2', Customer1."No.", Customer1.Name);
                                UNTIL Customer1.NEXT() = 0;
                        END;
                        Customer.INIT();
                        Customer.VALIDATE("No.", HisMasterStaging."HIS Code");
                        Customer.VALIDATE(Name, HisMasterStaging.Name);
                        Customer."Name 2" := COPYSTR(HisMasterStaging."Name 2", 1, 50);
                        Customer.Address := HisMasterStaging.Address;
                        Customer."Address 2" := HisMasterStaging."Address 2";
                        Customer.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        Customer.VALIDATE(City, HisMasterStaging.City);
                        Customer.Contact := HisMasterStaging.Contact;
                        Customer."Phone No." := HisMasterStaging."Phone No.";
                        Customer.INSERT();
                        Customer.VALIDATE("Customer Posting Group", HisMasterStaging."Customer Posting Group");
                        Customer.VALIDATE("Country/Region Code", HisMasterStaging."Country/Region Code");
                        Customer.VALIDATE("Gen. Bus. Posting Group", HisMasterStaging."Gen. Bus. Posting Group");
                        Customer.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        Customer.Validate("Country/Region Code", HisMasterStaging.County);
                        //Customer.VALIDATE(County, HisMasterStaging.County);
                        Customer.VALIDATE("State Code", HisMasterStaging."State Code");
                        Customer."P.A.N. No." := HisMasterStaging."P.A.N. No.";
                        Customer."GST Registration No." := HisMasterStaging."GST Registration No.";
                        if HisMasterStaging."GST Registration No." <> '' then
                            Customer."GST Customer Type" := Customer."GST Customer Type"::Registered;
                        //Customer."GST Customer Type" := HisMasterStaging."GST Customer Type";
                        Customer."ARN No." := HisMasterStaging."GST Registration No.";
                        Customer.VALIDATE("E3 HIS Code", HisMasterStaging."HIS Code");
                        Customer.Validate("Global Dimension 1 Code", HisMasterStaging."Global Dimension 1 Code");
                        Customer.Validate("Location Code", HisMasterStaging."Global Dimension 1 Code");
                        Customer.Validate("Responsibility Center", HisMasterStaging."Global Dimension 1 Code");
                        //Customer.Validate("EDC Security Center Code", HisMasterStaging."Global Dimension 1 Code");
                        IF HisMasterStaging."GST Customer Type" = HisMasterStaging."GST Customer Type"::Registered then
                            IF (HisMasterStaging."GST Registration No." <> '') AND (HisMasterStaging."P.A.N. No." <> COPYSTR(HisMasterStaging."GST Registration No.", 3, 10)) THEN
                                ERROR(SamePANErr);

                        Customer."E3 HIS Code" := HisMasterStaging."HIS Code";
                        Customer."E3 HIS Type" := HisMasterStaging."HIS Type";
                        Customer.MODIFY();
                        IF HisMasterStaging."Bank Account No." <> '' THEN begin
                            CustBankAccount.Init();
                            CustBankAccount.VALIDATE("Customer No.", Customer."No.");
                            CustBankAccount.VALIDATE(Code, 'HIS' + '-' + COPYSTR(Customer."No.", 1, 16));
                            CustBankAccount.VALIDATE(Name, HisMasterStaging."VC Bank Account Name");
                            CustBankAccount.VALIDATE(Address, HisMasterStaging.Address);
                            CustBankAccount.VALIDATE("Address 2", HisMasterStaging."Address 2");
                            CustBankAccount.VALIDATE("Bank Account No.", HisMasterStaging."Bank Account No.");
                            CustBankAccount.VALIDATE("Bank Branch No.", HisMasterStaging."Bank Branch No.");
                            CustBankAccount.VALIDATE("E3 IFSC Code", HisMasterStaging."IFSC Code");
                            CustBankAccount.Validate("Post Code", HisMasterStaging."Bank Post Code");
                            CustBankAccount.Validate(City, HisMasterStaging."Bank City");
                            CustBankAccount.Insert();
                        end;

                        HisMasterStaging."Vendor/Customer Code" := Customer."No.";
                        HisMasterStaging.IsCreated := TRUE;
                        HisMasterStaging."Modified by" := USERID;
                        HisMasterStaging."Modified Date Time" := CurrentDateTime;
                        HisMasterStaging.MODIFY();
                        MESSAGE('Customer has been created Successfully');
                    END ELSE
                        HisMasterStaging."Error Description" := 'Check Customer Posting Group';
                    HisMasterStaging.MODIFY();
                END;
            UNTIL HisMasterStaging.NEXT() = 0
        ELSE
            Error('HIS Code is missing.Kindly check Error Desciption');
    END;

    procedure ItemSendForPendingApproval(EntryNo: Integer)
    var
        HISMasterStagging: Record "E3 HIS Master Staging";
    begin
        HisMasterStaging.Reset();
        HisMasterStaging.SetRange("Entry No.", EntryNo);
        HisMasterStaging.SetFilter("Item Status", '%1', "E3 HIS Item Status"::New);
        if HisMasterStaging.find('-') then begin
            HisMasterStaging."Item Status" := "E3 HIS Item Status"::"Pending Approval";
            HisMasterStaging.Modify(true);
            Message('Item No %1 has been successfully send for Pending Approval.', HisMasterStaging."Entry No.");
        end;
    end;

    procedure ItemSendForApproval(EntryNo: Integer)
    var
        HISMasterStagging: Record "E3 HIS Master Staging";
    begin
        HisMasterStaging.Reset();
        HisMasterStaging.SetRange("Entry No.", EntryNo);
        HisMasterStaging.SetFilter("Item Status", '%1', "E3 HIS Item Status"::"Pending Approval");
        if HisMasterStaging.find('-') then begin
            HisMasterStaging."Item Status" := "E3 HIS Item Status"::Approved;
            HisMasterStaging.Modify(true);
            Message('Item No %1 has been successfully Approved.', HisMasterStaging."Entry No.");
        end;
    end;

    procedure ItemRejectApproval1(EntryNo: Integer)
    var
        HISMasterStaging: Record "E3 HIS Master Staging";
    begin
        HISMasterStaging.Reset();
        HISMasterStaging.SetRange("Entry No.", EntryNo);
        HISMasterStaging.SetFilter("Item Status", '%1', "E3 HIS Item Status"::"Pending Approval", "E3 HIS Item Status"::Approved);

        if HISMasterStaging.FindFirst() then begin
            HISMasterStaging."Item Status" := "E3 HIS Item Status"::New;
            HISMasterStaging.Modify(true);
            Message('Item No %1 has been Rejected.', HISMasterStaging."Entry No.");
        end else begin
            Message('No item found in Pending Approval status for Entry No. %1.', EntryNo);
        end;
    end;

    procedure ItemRejectApproval2(EntryNo: Integer)
    var
        HISMasterStaging: Record "E3 HIS Master Staging";
    begin
        HISMasterStaging.Reset();
        HISMasterStaging.SetRange("Entry No.", EntryNo);
        HISMasterStaging.SetFilter("Item Status", '%1', "E3 HIS Item Status"::"Approved", "E3 HIS Item Status"::Approved);

        if HISMasterStaging.FindFirst() then begin
            HISMasterStaging."Item Status" := "E3 HIS Item Status"::New;
            HISMasterStaging.Modify(true);
            Message('Item No %1 has been Rejected.', HISMasterStaging."Entry No.");
        end else begin
            Message('No item found in Pending Approval status for Entry No. %1.', EntryNo);
        end;
    end;


    procedure InitItemMaster(EntryNo: Integer)
    var
        Item1: Record Item;
        InventoryPostingGroup: Record "Inventory Posting Group";
        Item: Record "item";
        ItemUnitofMeasure: Record "Item Unit of Measure";
        HISUOMMapping: Record "E3 HIS UOM Mapping";
        InventorySetup: Record "Inventory Setup";
        NoSeriesMgmt: Codeunit "No. Series";

    BEGIN
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Item Creation Enabled", TRUE);

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Item Creation Enabled") THEN
            EXIT;

        HisMasterStaging.RESET();
        HisMasterStaging.SETRANGE("Party Type", HisMasterStaging."Party Type"::Item);
        HisMasterStaging.SETRANGE("Entry No.", EntryNo);
        HisMasterStaging.SETRANGE(IsCreated, FALSE);
        HisMasterStaging.SETFILTER(Name, '<>%1', '');
        HisMasterStaging.SETFILTER("Error Description", '%1', '');
        IF HisMasterStaging.FINDSET() THEN
            REPEAT
                //HisMasterStaging.TestField("Inventory Posting Group");
                HisMasterStaging.TestField("Gen. Prod. Posting Group");
                HisMasterStaging.TestField("Base Unit of Measure");
                //HisMasterStaging.TestField("HIS Code");
                Item1.RESET();
                //Item1.SETRANGE("No.", HisMasterStaging."HIS Code");
                Item1.SETRANGE(Description, HisMasterStaging.Name);
                IF NOT Item1.FINDFIRST() THEN BEGIN
                    // InventoryPostingGroup.RESET();
                    // InventoryPostingGroup.SETRANGE(Code, HisMasterStaging."Inventory Posting Group");
                    // IF InventoryPostingGroup.FINDFIRST() THEN BEGIN
                    Item.INIT();
                    //Item.VALIDATE("No.", HisMasterStaging."HIS Code");
                    InventorySetup.Get();
                    InventorySetup.TESTFIELD("Item Nos.");
                    Item."No." := NoSeriesMgmt.GetNextNo(InventorySetup."Item Nos.", Today, true);

                    Item.VALIDATE(Description, HisMasterStaging."Name");
                    Item.INSERT();
                    Item.VALIDATE(Item."Item Category Code", HisMasterStaging."Item Category Code");
                    Item.VALIDATE(item."Gen. Prod. Posting Group", HisMasterStaging."Gen. Prod. Posting Group");
                    //Item.VALIDATE(item."Inventory Posting Group", HisMasterStaging."Inventory Posting Group");

                    HISUOMMapping.Get(HisMasterStaging."Base Unit of Measure");

                    Item.Validate("Base Unit of Measure", HISUOMMapping."UOM Code");
                    Item.Validate("GST Group Code", HisMasterStaging."GST Group Code");
                    Item.Validate("HSN/SAC Code", HisMasterStaging."HSN/SAC Code");
                    Item.Validate("GST Credit", HisMasterStaging."GST Credit");
                    Item.Validate(Type, HisMasterStaging."Inventory-NonInventory");
                    //Item.Validate("EDC Purchase Allowed", HisMasterStaging."Purchase Allowed");
                    Item."E3 HIS Type" := HisMasterStaging."HIS Type";
                    Item."E3 Item Type" := HisMasterStaging."Item Type";
                    Item.Modify();
                    IF HisMasterStaging."Base Unit of Measure" <> '' then begin
                        ItemUnitofMeasure.INIT();
                        ItemUnitofMeasure."Item No." := Item."No.";
                        ItemUnitofMeasure.Code := Item."Base Unit of Measure";
                        ItemUnitofMeasure."Qty. per Unit of Measure" := 1;
                        IF NOT ItemUnitofMeasure.Insert() then
                            ItemUnitofMeasure.Modify();

                    end;
                    IF HisMasterStaging."Global Dimension 1 Code" <> '' THEN begin
                        GeneralLedgerSetup.Get();
                        DefaultDimension.INIT();
                        DefaultDimension."Table ID" := 27;
                        DefaultDimension."No." := HisMasterStaging."HIS Code";
                        DefaultDimension."Dimension Code" := GeneralLedgerSetup."Global Dimension 1 Code";
                        DefaultDimension."Dimension Value Code" := HisMasterStaging."Global Dimension 1 Code";
                        DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
                        DefaultDimension.INSERT();
                    end;
                    IF HisMasterStaging."Global Dimension 2 Code" <> '' THEN begin
                        GeneralLedgerSetup.Get();
                        DefaultDimension.INIT();
                        DefaultDimension."Table ID" := 27;
                        DefaultDimension."No." := HisMasterStaging."HIS Code";
                        DefaultDimension."Dimension Code" := GeneralLedgerSetup."Global Dimension 2 Code";
                        DefaultDimension."Dimension Value Code" := HisMasterStaging."Global Dimension 2 Code";
                        DefaultDimension."Value Posting" := DefaultDimension."Value Posting"::"Same Code";
                        DefaultDimension.INSERT();
                    end;
                    HisMasterStaging."Vendor/Customer Code" := Item."No.";
                    HisMasterStaging.IsCreated := TRUE;
                    HisMasterStaging."Modified by" := USERID;
                    HisMasterStaging."Modified Date Time" := CurrentDateTime;
                    HisMasterStaging.MODIFY();
                    MESSAGE('Item has been created Successfully');
                END ELSE
                    HisMasterStaging."Error Description" := 'Check Inventory Posting Group';
                HisMasterStaging.MODIFY();
            //END;
            UNTIL HisMasterStaging.NEXT() = 0
        ELSE
            Error('Kindly Check Error Description');

    END;

    //ak

    procedure InitItemMaster1(EntryNo: Integer)
    var
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
        NoSeriesMgmt: Codeunit "No. Series";
        ItemRec: Record Item;
        NewItemDesc: text;
        masterStaging: Record "E3 HIS Master Staging";
    begin
        IntegrationSetup.Get();
        IntegrationSetup.TestField("Integration Enabled", true);
        IntegrationSetup.TestField("Item Creation Enabled", true);

        HisMasterStaging.Reset();
        HisMasterStaging.SetRange("Party Type", HisMasterStaging."Party Type"::"Item Master");
        HisMasterStaging.SetRange("Entry No.", EntryNo);
        HisMasterStaging.SetRange(IsCreated, false);
        HisMasterStaging.SetFilter(Name, '<>%1', '');

        if HisMasterStaging.FindSet() then
            repeat
                NewItemDesc := HisMasterStaging.Name + '-' + HisMasterStaging."Material Category" + '-' + HisMasterStaging.Strength;
                ItemRec.Reset();
                ItemRec.SetRange(Description, NewItemDesc);
                if not ItemRec.FindFirst() then begin
                    Item.INIT();
                    //Item.VALIDATE("No.", HisMasterStaging."HIS Code");
                    InventorySetup.Get();
                    InventorySetup.TESTFIELD("Item Nos.");
                    Item."No." := NoSeriesMgmt.GetNextNo(InventorySetup."Item Nos.", Today, true);
                    Item.VALIDATE(Description, NewItemDesc);
                    Item.Validate("Material Category", HisMasterStaging."Material Category");
                    Item.Validate(Strength, HisMasterStaging.Strength);
                    Item.Validate("Item Type", HisMasterStaging."Item Type 1");
                    Item.INSERT();

                    masterStaging := HisMasterStaging;
                    masterStaging.IsCreated := true;
                    masterStaging.Modify(true)
;
                end;

            until HisMasterStaging.Next() = 0;

    end;    //ak

    procedure CollectionValidation()
    var
        temRevenueStaging: Record "E3 HIS Revenue Staging Table";
        GLAccountMapping: Record "E3 HIS GL Accounts Mapping";
        MOPSetupMissing: Text[70];
        DocumentType: Text[70];
    begin
        temRevenueStaging.Reset();
        temRevenueStaging.SetRange("General Entries Created", false);
        if temRevenueStaging.FindSet() then
            repeat
                temRevenueStaging."Error Description" := '';
                MOPSetupMissing := '';
                DocumentType := '';
                GLAccountMapping.Reset();
                GLAccountMapping.SetRange(Type, GLAccountMapping.Type::MOP);
                GLAccountMapping.SetRange("MOP Code", temRevenueStaging."Mode of Payment");
                if not GLAccountMapping.FindFirst() then
                    MOPSetupMissing := Text.StrSubstNo('MOP %1 setup missing', temRevenueStaging."Mode of Payment");
                if temRevenueStaging."Mode of Payment" = '' then
                    MOPSetupMissing := 'MOP can not be blank';
                GLAccountMapping.Reset();
                GLAccountMapping.SetRange(Type, GLAccountMapping.Type::Collection);
                GLAccountMapping.SetRange("Service/Station Head", temRevenueStaging."HIS Document Type");
                if not GLAccountMapping.FindFirst() then
                    DocumentType := text.StrSubstNo('Collection Type %1 setup missing', temRevenueStaging."HIS Document Type");
                if temRevenueStaging."HIS Document Type" = '' then
                    DocumentType := 'Coll type can not be blank';
                temRevenueStaging."Error Description" := MOPSetupMissing + ' ' + DocumentType;
                temRevenueStaging.Modify(true);
            until temRevenueStaging.Next() = 0;
    end;


    procedure CollectionHISDocumentDateValidation(HISRevenueStaging: Record "E3 HIS Revenue Staging Table"): Boolean
    var
        AllowPostingDate: Record "HIS Allow Posting Date";
        DocDate: Date;
    begin
        DocDate := HISRevenueStaging."Document Date";

        AllowPostingDate.Reset();
        AllowPostingDate.SetRange("Code Unit Name", '50003');

        AllowPostingDate.SetFilter("From Date", '<=%1', DocDate);
        AllowPostingDate.SetFilter("To Date", '>=%1', DocDate);

        if not AllowPostingDate.FindFirst() then begin
            message('Document Date %1 is not allowed. Allowed date range not defined for %2.', DocDate, '50003 Table Allow Integration Setup From date and To Date');
            EXIT(TRUE);
        end
        else
            EXIT(FALSE);
    end;

    procedure InitGenJnlLineRevenueStaging()
    var
        GenJournalLine: Record "Gen. Journal Line";
        HISGLAccountMapping: Record "E3 HIS GL Accounts Mapping";
        intLineNo: Integer;
        MOPLbl: Label 'MOP Setup not found for Mode of payment %1.';
        DocumentTypeLbl: Label 'Setup not found for Document Type %1.';
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");
        IntegrationSetup.TESTFIELD("Custom Gen. Bus. Posting Group");

        IntegrationSetupLine.Reset();
        IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Revenue);
        IntegrationSetupLine.FindFirst();
        IntegrationSetupLine.TestField("General Journal Template Code");
        IntegrationSetupLine.TestField("General Journal Batch Code");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Revenue Creation Enabled") THEN
            EXIT;

        HISRevenueStaging.RESET();
        HISRevenueStaging.SETFILTER(HISRevenueStaging."General Entries Created", '%1', FALSE);
        HISRevenueStaging.SETFILTER(HISRevenueStaging.Amount, '<>%1', 0);
        //HISRevenueStaging.SetFilter("Error Description", '%1', '');
        //HISRevenueStaging.SETFILTER(HISRevenueStaging."Account No.", '<>%1', '');
        IF HISRevenueStaging.FINDSET() THEN
            if not CollectionHISDocumentDateValidation(HISRevenueStaging) then begin
                REPEAT
                    GenJournalLine.RESET();
                    GenJournalLine.SETRANGE("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.SETRANGE("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    IF GenJournalLine.FINDLAST() THEN
                        intLineNo := GenJournalLine."Line No."
                    ELSE
                        intLineNo := 10000;

                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    intLineNo += 10000;
                    GenJournalLine."Line No." := intLineNo;
                    GenJournalLine.VALIDATE("Document Type", HISRevenueStaging."Document Type");
                    GenJournalLine.VALIDATE("Document No.", HISRevenueStaging."Document No.");
                    GenJournalLine.VALIDATE("Posting Date", HISRevenueStaging."Document Date");

                    HISGLAccountMapping.Reset();
                    HISGLAccountMapping.SetRange(Type, HISGLAccountMapping.Type::MOP);
                    HISGLAccountMapping.SetRange("MOP Code", HISRevenueStaging."Mode of Payment");
                    if HISGLAccountMapping.FindFirst() then begin

                        GenJournalLine.VALIDATE("Account Type", HISGLAccountMapping."Account Type");
                        GenJournalLine.VALIDATE("Account No.", HISGLAccountMapping."Account No.");
                    end ELSE
                        Error(MOPLbl, HISRevenueStaging."Mode of Payment");

                    GenJournalLine.VALIDATE(Amount, HISRevenueStaging.Amount);
                    GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Cheque Date", HISRevenueStaging."Cheque Date");
                    GenJournalLine.VALIDATE("Cheque No.", COPYSTR(HISRevenueStaging."Cheque No.", 1, 10));
                    if HISRevenueStaging."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISRevenueStaging."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISRevenueStaging."Shortcut Dimension 1 Code");
                    end;

                    if HISRevenueStaging."Shortcut Dimension 1 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueStaging."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISRevenueStaging."Cheque No.");
                    GenJournalLine."E3 Narration" := COPYSTR(HISRevenueStaging."Line Narration", 1, 50);
                    GenJournalLine."E3 HIS Module" := HISRevenueStaging."HIS Module";
                    GenJournalLine."E3 HIS Document Type" := COPYSTR(HISRevenueStaging."HIS Document Type", 1, 60);
                    GenJournalLine."E3 UTR No." := HISRevenueStaging."Cheque No.";
                    GenJournalLine."E3 Sub Group Code" := HISRevenueStaging."Sub Group";
                    GenJournalLine."E3 Receipt No." := COPYSTR(HISRevenueStaging."Receipt No.", 1, 20);
                    GenJournalLine."E3 UHID" := HISRevenueStaging.UHID;
                    GenJournalLine."E3 Validation Key" := HISRevenueStaging."Validation HIS Key";
                    GenJournalLine."E3 Store Code" := HISRevenueStaging."Store Code";
                    GenJournalLine."E3 Patient Name" := HISRevenueStaging."Patient Name";
                    GenJournalLine."E3 Transaction Type" := HISRevenueStaging.TRANSACTION_TYPE;
                    GenJournalLine."E3 Encounter No." := HISRevenueStaging."Encounter No.";
                    GenJournalLine.INSERT();

                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    intLineNo += 10000;
                    GenJournalLine."Line No." := intLineNo;
                    GenJournalLine.VALIDATE("Document Type", HISRevenueStaging."Document Type");
                    GenJournalLine.VALIDATE("Document No.", HISRevenueStaging."Document No.");
                    GenJournalLine.VALIDATE("Posting Date", HISRevenueStaging."Document Date");

                    HISGLAccountMapping.Reset();
                    HISGLAccountMapping.SetRange(Type, HISGLAccountMapping.Type::Collection);
                    HISGLAccountMapping.SetRange("Service/Station Head", HISRevenueStaging."HIS Document Type");
                    if HISGLAccountMapping.FindFirst() then begin

                        GenJournalLine.VALIDATE("Account Type", HISGLAccountMapping."Account Type");
                        GenJournalLine.VALIDATE("Account No.", HISGLAccountMapping."Account No.");
                    end ELSE
                        Error(DocumentTypeLbl, HISRevenueStaging."HIS Document Type");

                    GenJournalLine.VALIDATE(Amount, -HISRevenueStaging.Amount);
                    GenJournalLine.validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Cheque Date", HISRevenueStaging."Cheque Date");
                    GenJournalLine.VALIDATE("Cheque No.", COPYSTR(HISRevenueStaging."Cheque No.", 1, 10));
                    if HISRevenueStaging."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISRevenueStaging."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISRevenueStaging."Shortcut Dimension 1 Code");
                    end;

                    if HISRevenueStaging."Shortcut Dimension 1 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueStaging."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISRevenueStaging."External Document No.");
                    GenJournalLine."E3 Narration" := COPYSTR(HISRevenueStaging."Line Narration", 1, 50);
                    GenJournalLine."E3 HIS Module" := HISRevenueStaging."HIS Module";
                    GenJournalLine."E3 HIS Document Type" := COPYSTR(HISRevenueStaging."HIS Document Type", 1, 60);
                    GenJournalLine."E3 UTR No." := HISRevenueStaging."Cheque No.";
                    GenJournalLine."E3 Sub Group Code" := HISRevenueStaging."Sub Group";
                    GenJournalLine."E3 Receipt No." := COPYSTR(HISRevenueStaging."Receipt No.", 1, 20);
                    GenJournalLine."E3 UHID" := HISRevenueStaging.UHID;
                    GenJournalLine."E3 Validation Key" := HISRevenueStaging."Validation HIS Key";
                    GenJournalLine."E3 Store Code" := HISRevenueStaging."Store Code";
                    GenJournalLine."E3 Patient Name" := HISRevenueStaging."Patient Name";
                    GenJournalLine."E3 Transaction Type" := HISRevenueStaging.TRANSACTION_TYPE;
                    GenJournalLine."E3 Encounter No." := HISRevenueStaging."Encounter No.";
                    GenJournalLine.INSERT();

                    HISRevenueStaging."Created By" := USERID;
                    HISRevenueStaging."Created Date Time" := CURRENTDATETIME;
                    HISRevenueStaging."General Entries Created" := TRUE;
                    HISRevenueStaging.MODIFY();
                UNTIL HISRevenueStaging.NEXT() = 0;
            end;

    end;
    //ak

    procedure SettHISDocumentDateValidation(HISSettlementStaging: Record "E3 HIS Settlement Staging"): Boolean
    var
        AllowPostingDate: Record "HIS Allow Posting Date";
        DocDate: Date;
    begin
        DocDate := HISSettlementStaging."Document Date";

        AllowPostingDate.Reset();
        AllowPostingDate.SetRange("Code Unit Name", '50017');

        AllowPostingDate.SetFilter("From Date", '<=%1', DocDate);
        AllowPostingDate.SetFilter("To Date", '>=%1', DocDate);

        if not AllowPostingDate.FindFirst() then begin
            message('Document Date %1 is not allowed. Allowed date range not defined for %2.', DocDate, '50017 Table Allow Integration Setup From date and To Date');
            EXIT(TRUE);
        end
        else
            EXIT(FALSE);
    end;


    procedure SettlementValidation()
    var
        SettlementStaging: Record "E3 HIS Settlement Staging";
        GLAccountMapping: Record "E3 HIS GL Accounts Mapping";
        CustMappingSetup: Record "E3 HIS Customer Mapping";
        SettSetupMissing: Text[60];
        HisDocumentType: Text[60];
    begin
        SettlementStaging.Reset();
        SettlementStaging.SetRange("General Entries Created", false);
        if SettlementStaging.FindSet() then
            repeat
                SettlementStaging."Error Description" := '';
                SettSetupMissing := '';
                HisDocumentType := '';
                CustMappingSetup.Reset();
                CustMappingSetup.SetRange("HIS Code", SettlementStaging."Bal. Account No");
                if not CustMappingSetup.FindFirst() then
                    SettSetupMissing := Text.StrSubstNo('Customer %1 setup missing', SettlementStaging."Bal. Account No");
                if SettlementStaging."Bal. Account No" = '' then
                    SettSetupMissing := 'Customer can not be blank';
                GLAccountMapping.Reset();
                GLAccountMapping.SetRange(Type, GLAccountMapping.Type::Settlement);
                GLAccountMapping.SetRange("Service/Station Head", SettlementStaging."HIS Document Type");
                if not GLAccountMapping.FindFirst() then
                    HisDocumentType := text.StrSubstNo('Settlement Type %1 setup missing', SettlementStaging."HIS Document Type");
                if SettlementStaging."HIS Document Type" = '' then
                    HisDocumentType := 'Sett type can not be blank';
                SettlementStaging."Error Description" := SettSetupMissing + ' ' + HisDocumentType;
                SettlementStaging.Modify(true);
            until SettlementStaging.Next() = 0;

    end;

    procedure InitGenJnlLineSettlementStaging()
    var
        GenJournalLine: Record "Gen. Journal Line";
        HISGLAccountMapping: Record "E3 HIS GL Accounts Mapping";
        intLineNo: Integer;
        MOPLbl: Label 'MOP Setup not found for Mode of payment %1.';
        DocumentTypeLbl: Label 'Setup not found for Document Type %1.';
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");
        IntegrationSetup.TESTFIELD("Custom Gen. Bus. Posting Group");

        IntegrationSetupLine.Reset();
        IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Revenue);
        IntegrationSetupLine.FindFirst();
        IntegrationSetupLine.TestField("General Journal Template Code");
        IntegrationSetupLine.TestField("General Journal Batch Code");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Revenue Creation Enabled") THEN
            EXIT;

        //SettlementValidation();
        //Commit();

        HISSettlementStaging.RESET();
        HISSettlementStaging.SETFILTER(HISSettlementStaging."General Entries Created", '%1', FALSE);
        HISSettlementStaging.SETFILTER(HISSettlementStaging.Amount, '<>%1', 0);
        //HISSettlementStaging.SetFilter("Error Description", '%1', '');
        //HISRevenueStaging.SETFILTER(HISRevenueStaging."Account No.", '<>%1', '');
        IF HISSettlementStaging.FINDSET() THEN
            if not SettHISDocumentDateValidation(HISSettlementStaging) then begin
                REPEAT
                    GenJournalLine.RESET();
                    GenJournalLine.SETRANGE("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.SETRANGE("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    IF GenJournalLine.FINDLAST() THEN
                        intLineNo := GenJournalLine."Line No."
                    ELSE
                        intLineNo := 10000;

                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    intLineNo += 10000;
                    GenJournalLine."Line No." := intLineNo;
                    GenJournalLine.VALIDATE("Document Type", HISSettlementStaging."Document Type");
                    GenJournalLine.VALIDATE("Document No.", HISSettlementStaging."Document No.");
                    GenJournalLine.VALIDATE("Posting Date", HISSettlementStaging."Document Date");

                    HISGLAccountMapping.Reset();
                    HISGLAccountMapping.SetRange(Type, HISGLAccountMapping.Type::Settlement);
                    HISGLAccountMapping.SetRange("MOP Code", HISSettlementStaging."HIS Document Type");
                    if HISGLAccountMapping.FindFirst() then begin

                        GenJournalLine.VALIDATE("Account Type", HISGLAccountMapping."Account Type");
                        GenJournalLine.VALIDATE("Account No.", HISGLAccountMapping."Account No.");
                    end ELSE
                        Error(MOPLbl, HISSettlementStaging."HIS Document Type");//ak

                    GenJournalLine.VALIDATE(Amount, HISSettlementStaging.Amount);
                    //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Cheque Date", HISSettlementStaging."Cheque Date");
                    GenJournalLine.VALIDATE("Cheque No.", COPYSTR(HISSettlementStaging."Cheque No.", 1, 10));
                    GenJournalLine.validate("Bal. Account Type", HISSettlementStaging."Bal. Account Type");
                    GenJournalLine.validate("Bal. Account No.", HISSettlementStaging."Bal. Account No");
                    if HISSettlementStaging."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISSettlementStaging."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISSettlementStaging."Shortcut Dimension 1 Code");
                    end;

                    if HISSettlementStaging."Shortcut Dimension 2 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISSettlementStaging."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISSettlementStaging."External Document No.");
                    GenJournalLine."E3 Narration" := COPYSTR(HISSettlementStaging."Line Narration", 1, 50);
                    GenJournalLine."E3 HIS Module" := HISSettlementStaging."HIS Module";
                    GenJournalLine."E3 HIS Document Type" := COPYSTR(HISSettlementStaging."HIS Document Type", 1, 60);
                    GenJournalLine."E3 UTR No." := HISSettlementStaging."Cheque No.";
                    GenJournalLine."E3 Sub Group Code" := HISSettlementStaging."Sub Group";
                    GenJournalLine."E3 Receipt No." := COPYSTR(HISSettlementStaging."Receipt No.", 1, 20);
                    GenJournalLine."E3 UHID" := HISSettlementStaging.UHID;
                    GenJournalLine."E3 Validation Key" := HISSettlementStaging."Validation HIS Key";
                    GenJournalLine."E3 Store Code" := HISSettlementStaging."Store Code";
                    GenJournalLine."E3 Patient Name" := HISSettlementStaging."Patient Name";
                    GenJournalLine."E3 Transaction Type" := HISSettlementStaging.TRANSACTION_TYPE;
                    GenJournalLine."E3 Sponsor Code" := HISSettlementStaging."Sponsor Code";
                    GenJournalLine."E3 Sponsor Name" := HISSettlementStaging."Sponsor Name";

                    GenJournalLine.INSERT();

                    // GenJournalLine.INIT();
                    // GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    // GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    // intLineNo += 10000;
                    // GenJournalLine."Line No." := intLineNo;
                    // GenJournalLine.VALIDATE("Document Type", HISSettlementStaging."Document Type");
                    // GenJournalLine.VALIDATE("Document No.", HISSettlementStaging."Document No.");
                    // GenJournalLine.VALIDATE("Posting Date", HISSettlementStaging."Document Date");

                    // GenJournalLine.VALIDATE(Amount, -HISSettlementStaging.Amount);
                    // GenJournalLine.validate("Account Type", HISSettlementStaging."Bal. Account Type");
                    // GenJournalLine.validate("Account No.", HISSettlementStaging."Bal. Account No");
                    // GenJournalLine.VALIDATE("Cheque Date", HISSettlementStaging."Cheque Date");
                    // GenJournalLine.VALIDATE("Cheque No.", COPYSTR(HISSettlementStaging."Cheque No.", 1, 10));
                    // if HISSettlementStaging."Shortcut Dimension 1 Code" <> '' then begin
                    //     GenJournalLine.VALIDATE("Location Code", HISSettlementStaging."Shortcut Dimension 1 Code");
                    //     GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISSettlementStaging."Shortcut Dimension 1 Code");
                    // end;

                    // if HISSettlementStaging."Shortcut Dimension 1 Code" <> '' then
                    //     GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISSettlementStaging."Shortcut Dimension 2 Code"));

                    // GenJournalLine.VALIDATE("External Document No.", HISSettlementStaging."External Document No.");
                    // GenJournalLine."E3 Narration" := COPYSTR(HISSettlementStaging."Line Narration", 1, 50);
                    // GenJournalLine."E3 HIS Module" := HISSettlementStaging."HIS Module";
                    // GenJournalLine."E3 HIS Document Type" := COPYSTR(HISSettlementStaging."HIS Document Type", 1, 60);
                    // GenJournalLine."E3 UTR No." := HISSettlementStaging."Cheque No.";
                    // GenJournalLine."E3 Sub Group Code" := HISSettlementStaging."Sub Group";
                    // GenJournalLine."E3 Receipt No." := COPYSTR(HISSettlementStaging."Receipt No.", 1, 20);
                    // GenJournalLine."E3 UHID" := HISSettlementStaging.UHID;
                    // GenJournalLine."E3 Validation Key" := HISSettlementStaging."Validation HIS Key";
                    // GenJournalLine."E3 Store Code" := HISSettlementStaging."Store Code";
                    // GenJournalLine."E3 Patient Name" := HISSettlementStaging."Patient Name";
                    // GenJournalLine."E3 Transaction Type" := HISSettlementStaging.TRANSACTION_TYPE;
                    // GenJournalLine."E3 Sponsor Code" := HISSettlementStaging."Sponsor Code";
                    // GenJournalLine."E3 Sponsor Name" := HISSettlementStaging."Sponsor Name";
                    // GenJournalLine.INSERT();

                    HISSettlementStaging."Created By" := USERID;
                    HISSettlementStaging."Created Date Time" := CURRENTDATETIME;
                    HISSettlementStaging."General Entries Created" := TRUE;
                    HISSettlementStaging.MODIFY();
                UNTIL HISSettlementStaging.NEXT() = 0;

            end;
    end;

    //ak

    procedure InitGenJnlLineDoctorPayoutEntries()
    var
        GenJournalLine: Record "Gen. Journal Line";
        HISGLAccountMapping: Record "E3 HIS GL Accounts Mapping";
        intLineNo: Integer;
        MOPLbl: Label 'Doctor Setup not found for Mode of payment %1.';
        DocumentTypeLbl: Label 'Setup not found for Document Type %1.';
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");
        IntegrationSetup.TESTFIELD("Custom Gen. Bus. Posting Group");

        IntegrationSetupLine.Reset();
        IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Revenue);
        IntegrationSetupLine.FindFirst();
        IntegrationSetupLine.TestField("General Journal Template Code");
        IntegrationSetupLine.TestField("General Journal Batch Code");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Revenue Creation Enabled") THEN
            EXIT;

        HISDoctorPayoutEntries.RESET();
        HISDoctorPayoutEntries.SETFILTER(HISDoctorPayoutEntries."General Entries Created", '%1', FALSE);
        HISDoctorPayoutEntries.SETFILTER(HISDoctorPayoutEntries.Amount, '<>%1', 0);
        //HISRevenueStaging.SETFILTER(HISRevenueStaging."Account No.", '<>%1', '');
        IF HISDoctorPayoutEntries.FINDSET() THEN
            REPEAT
                GenJournalLine.RESET();
                GenJournalLine.SETRANGE("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                GenJournalLine.SETRANGE("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                IF GenJournalLine.FINDLAST() THEN
                    intLineNo := GenJournalLine."Line No."
                ELSE
                    intLineNo := 10000;

                GenJournalLine.INIT();
                GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                intLineNo += 10000;
                GenJournalLine."Line No." := intLineNo;
                GenJournalLine.VALIDATE("Document Type", HISDoctorPayoutEntries."Document Type");
                GenJournalLine.VALIDATE("Document No.", HISDoctorPayoutEntries."Document No.");
                GenJournalLine.VALIDATE("Posting Date", HISDoctorPayoutEntries."Document Date");

                HISGLAccountMapping.Reset();
                HISGLAccountMapping.SetRange(Type, HISGLAccountMapping.Type::Doctor);
                //HISGLAccountMapping.SetRange("MOP Code", HISDoctorPayoutEntries."Mode of Payment");//ak
                HISGLAccountMapping.SetRange("MOP Code", HISDoctorPayoutEntries."HIS Document Type");
                if HISGLAccountMapping.FindFirst() then begin

                    GenJournalLine.VALIDATE("Bal. Account Type", HISGLAccountMapping."Account Type");
                    GenJournalLine.VALIDATE("Bal. Account No.", HISGLAccountMapping."Account No.");
                end ELSE
                    Error(MOPLbl, HISDoctorPayoutEntries."HIS Document Type");//ak

                GenJournalLine.VALIDATE(Amount, -HISDoctorPayoutEntries.Amount);
                GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
                GenJournalLine.validate("Account No.", HISDoctorPayoutEntries."Bal. Account No");
                if HISDoctorPayoutEntries."Shortcut Dimension 1 Code" <> '' then begin
                    GenJournalLine.VALIDATE("Location Code", HISDoctorPayoutEntries."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISDoctorPayoutEntries."Shortcut Dimension 1 Code");
                end;

                if HISDoctorPayoutEntries."Shortcut Dimension 1 Code" <> '' then
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISDoctorPayoutEntries."Shortcut Dimension 2 Code"));

                GenJournalLine.VALIDATE("External Document No.", HISDoctorPayoutEntries."External Document No.");
                GenJournalLine."E3 Narration" := COPYSTR(HISDoctorPayoutEntries."Line Narration", 1, 50);
                GenJournalLine."E3 HIS Document Type" := COPYSTR(HISDoctorPayoutEntries."HIS Document Type", 1, 60);
                GenJournalLine."E3 UHID" := HISSettlementStaging.UHID;
                GenJournalLine."E3 Encounter No." := HISDoctorPayoutEntries."Encounter No.";
                GenJournalLine."E3 Receipt No." := HISDoctorPayoutEntries."IP No.";
                GenJournalLine."E3 Patient Name" := HISDoctorPayoutEntries."Patient Name";
                GenJournalLine."E3 Transaction Type" := HISDoctorPayoutEntries.TRANSACTION_TYPE;
                GenJournalLine.INSERT();

                // GenJournalLine.INIT();
                // GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                // GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                // intLineNo += 10000;
                // GenJournalLine."Line No." := intLineNo;
                // GenJournalLine.VALIDATE("Document Type", HISDoctorPayoutEntries."Document Type");
                // GenJournalLine.VALIDATE("Document No.", HISDoctorPayoutEntries."Document No.");
                // GenJournalLine.VALIDATE("Posting Date", HISDoctorPayoutEntries."Document Date");

                // GenJournalLine.VALIDATE(Amount, -HISDoctorPayoutEntries.Amount);
                // GenJournalLine.validate("Account Type", HISDoctorPayoutEntries."Account Type");
                // GenJournalLine.validate("Account No.", HISDoctorPayoutEntries."Bal. Account No");
                // if HISDoctorPayoutEntries."Shortcut Dimension 1 Code" <> '' then begin
                //     GenJournalLine.VALIDATE("Location Code", HISDoctorPayoutEntries."Shortcut Dimension 1 Code");
                //     GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISDoctorPayoutEntries."Shortcut Dimension 1 Code");
                // end;

                // if HISDoctorPayoutEntries."Shortcut Dimension 1 Code" <> '' then
                //     GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISDoctorPayoutEntries."Shortcut Dimension 2 Code"));

                // GenJournalLine.VALIDATE("External Document No.", HISDoctorPayoutEntries."External Document No.");
                // GenJournalLine."E3 Narration" := COPYSTR(HISDoctorPayoutEntries."Line Narration", 1, 50);
                // GenJournalLine."E3 HIS Document Type" := COPYSTR(HISDoctorPayoutEntries."HIS Document Type", 1, 60);
                // GenJournalLine."E3 UHID" := HISDoctorPayoutEntries.UHID;
                // GenJournalLine."E3 Encounter No." := HISDoctorPayoutEntries."Encounter No.";
                // GenJournalLine."E3 Receipt No." := HISDoctorPayoutEntries."IP No.";
                // GenJournalLine."E3 Patient Name" := HISDoctorPayoutEntries."Patient Name";
                // GenJournalLine."E3 Transaction Type" := HISDoctorPayoutEntries.TRANSACTION_TYPE;
                // GenJournalLine.INSERT();

                // HISDoctorPayoutEntries."Created By" := USERID;
                // HISDoctorPayoutEntries."Created Date Time" := CURRENTDATETIME;
                HISDoctorPayoutEntries."General Entries Created" := TRUE;
                HISDoctorPayoutEntries.MODIFY();
            UNTIL HISDoctorPayoutEntries.NEXT() = 0;

    end;

    //ak
    procedure ConsHISDocumentDateValidation(HISConsumptionEntry1: Record "E3 HIS Consumption Entries"): Boolean
    var
        AllowPostingDate: Record "HIS Allow Posting Date";
        DocDate: Date;

    begin
        DocDate := HISConsumptionEntry1."Posting Date";

        AllowPostingDate.Reset();
        AllowPostingDate.SetRange("Code Unit Name", '50009');

        AllowPostingDate.SetFilter("From Date", '<=%1', DocDate);
        AllowPostingDate.SetFilter("To Date", '>=%1', DocDate);

        if not AllowPostingDate.FindFirst() then begin
            message('Document Date %1 is not allowed. Allowed date range not defined for %2.', DocDate, '50009 Table Allow Integration Setup From date and To Date');
            EXIT(TRUE);
        end
        else
            EXIT(FALSE);
    end;


    procedure InitGenJnlLineConsumptionEntry()
    var
        GenJournalLine: Record "Gen. Journal Line";
        HISGLAccountMapping: Record "E3 HIS Item Mapping";
        HISConsumptionEntry: Record "E3 HIS Consumption Entries";
        intLineNo: Integer;
        MOPLbl: Label 'Item Mapping Setup not found for Item Category %1.';
        DocumentTypeLbl: Label 'Setup not found for Entry No. %1.';

    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Vendor Gen. Bus. Posting Group");
        IntegrationSetup.TESTFIELD("Custom Gen. Bus. Posting Group");

        IntegrationSetupLine.Reset();
        IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Consumption);
        IntegrationSetupLine.FindFirst();
        IntegrationSetupLine.TestField("General Journal Template Code");
        IntegrationSetupLine.TestField("General Journal Batch Code");

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Consumption Creation Enabled") THEN
            EXIT;

        HISConsumptionEntry.RESET();
        HISConsumptionEntry.SETFILTER(HISConsumptionEntry."General Entries Created", '%1', FALSE);
        HISConsumptionEntry.SETFILTER(HISConsumptionEntry.Amount, '<>%1', 0);
        //HISConsumptionEntry.SetFilter("Error Description", '%1', '');
        ;
        //HISRevenueStaging.SETFILTER(HISRevenueStaging."Account No.", '<>%1', '');
        IF HISConsumptionEntry.FINDSET() THEN
            if not ConsHISDocumentDateValidation(HISConsumptionEntry) then begin
                REPEAT
                    GenJournalLine.RESET();
                    GenJournalLine.SETRANGE("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.SETRANGE("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    IF GenJournalLine.FINDLAST() THEN
                        intLineNo := GenJournalLine."Line No."
                    ELSE
                        intLineNo := 1;

                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    intLineNo += 1;
                    GenJournalLine."Line No." := intLineNo;
                    GenJournalLine.VALIDATE("Document Type", HISConsumptionEntry."Document Type");
                    GenJournalLine.VALIDATE("Document No.", HISConsumptionEntry."Document No.");
                    GenJournalLine.VALIDATE("Posting Date", HISConsumptionEntry."Posting Date");

                    HISGLAccountMapping.Reset();
                    HISGLAccountMapping.SetRange("Entry Type", HISGLAccountMapping."Entry Type"::Consumption);
                    HISGLAccountMapping.SetRange("Item Category Code", HISConsumptionEntry."Item Category Code");
                    if HISGLAccountMapping.FindFirst() then begin
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.VALIDATE("Account No.", HISGLAccountMapping."G/L Account No.");
                    end ELSE
                        Error(DocumentTypeLbl, HISConsumptionEntry."Entry No.");

                    GenJournalLine.VALIDATE(Amount, HISConsumptionEntry.Amount);
                    GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                    HISGLAccountMapping.Reset();
                    HISGLAccountMapping.SetRange("Entry Type", HISGLAccountMapping."Entry Type"::"Purchase Order");
                    HISGLAccountMapping.SetRange("Item Category Code", HISConsumptionEntry."Item Category Code");
                    if HISGLAccountMapping.FindFirst() then
                        GenJournalLine.VALIDATE("Bal. Account No.", HISGLAccountMapping."G/L Account No.")
                    ELSE
                        Error(DocumentTypeLbl, HISRevenueStaging."HIS Document Type");

                    if HISConsumptionEntry."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISConsumptionEntry."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISConsumptionEntry."Shortcut Dimension 1 Code");
                    end;

                    if HISConsumptionEntry."Shortcut Dimension 1 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISConsumptionEntry."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISConsumptionEntry."External Document No.");
                    GenJournalLine."E3 Narration" := COPYSTR(HISConsumptionEntry."Line Narration", 1, 50);
                    GenJournalLine."E3 HIS Module" := HISConsumptionEntry."HIS Module";
                    GenJournalLine."E3 HIS Document Type" := COPYSTR(HISConsumptionEntry."HIS Document Type", 1, 60);
                    GenJournalLine."E3 Sub Group Code" := HISConsumptionEntry."Sub Group";
                    GenJournalLine."E3 Receipt No." := COPYSTR(HISConsumptionEntry."Receipt No.", 1, 20);
                    GenJournalLine."E3 UHID" := HISConsumptionEntry.UHID;
                    GenJournalLine."E3 Validation Key" := HISConsumptionEntry."Validation HIS Key";
                    GenJournalLine."E3 Store Code" := HISConsumptionEntry."Store Code";
                    GenJournalLine."E3 Patient Name" := HISConsumptionEntry."Patient Name";
                    GenJournalLine."E3 Transaction Type" := HISConsumptionEntry.TRANSACTION_TYPE;
                    GenJournalLine."E3 Speciality" := HISConsumptionEntry.Speciality;
                    GenJournalLine.INSERT();

                    HISConsumptionEntry."Created By" := USERID;
                    HISConsumptionEntry."Created Date Time" := CURRENTDATETIME;
                    HISConsumptionEntry."General Entries Created" := TRUE;
                    HISConsumptionEntry.MODIFY();
                UNTIL HISConsumptionEntry.NEXT() = 0;

            end;
    end;

    procedure InitEmployeeMaster(EntryNo: Integer)
    var
        Employee: Record Employee;
        EmployeePostingGroup: Record "Employee Posting Group";
        Employee1: Record Employee;
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Employee Creation Enabled", TRUE);

        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Employee Creation Enabled") THEN
            EXIT;

        HisMasterStaging.RESET();
        HisMasterStaging.SETRANGE("Entry No.", EntryNo);
        HisMasterStaging.SETRANGE(IsCreated, FALSE);
        HisMasterStaging.SETRANGE("Party Type", HisMasterStaging."Party Type"::Employee);
        HisMasterStaging.SETFILTER("Error Description", '%1', '');
        HisMasterStaging.SETFILTER("HIS Code", '<>%1', '');
        IF HisMasterStaging.FINDSET() THEN
            REPEAT
                HisMasterStaging.TestField("HIS Code");

                Employee1.RESET();
                Employee1.SETRANGE("No.", HisMasterStaging."HIS Code");
                IF NOT Employee1.FINDFIRST() THEN BEGIN
                    EmployeePostingGroup.RESET();
                    EmployeePostingGroup.SETRANGE(Code, HisMasterStaging."Employee Posting Group");
                    IF EmployeePostingGroup.FINDFIRST() THEN BEGIN
                        IF HisMasterStaging."GST Registration No." <> '' THEN BEGIN
                            Employee1.RESET();
                            Employee1.SETRANGE(Employee1."Phone No.", HisMasterStaging."Phone No.");
                            IF Employee1.FINDFIRST() THEN
                                REPEAT
                                    ERROR('Same Phone No. is already Exist Employee No. %1 & Employee Name %2', Employee1."No.", Employee1.FullName());
                                UNTIL Employee1.NEXT() = 0;
                        END;
                        Employee.INIT();
                        Employee.VALIDATE("No.", HisMasterStaging."HIS Code");
                        Employee.VALIDATE("First Name", HisMasterStaging.Name);
                        Employee."Last Name" := COPYSTR(HisMasterStaging."Name 2", 1, 30);
                        Employee.Address := COPYSTR(HisMasterStaging.Address, 1, 50);
                        Employee."Address 2" := COPYSTR(HisMasterStaging."Address 2", 1, 50);
                        Employee.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        Employee.VALIDATE(City, HisMasterStaging.City);
                        Employee."Phone No." := HisMasterStaging."Phone No.";
                        Employee.INSERT();
                        Employee.VALIDATE("Employee Posting Group", HisMasterStaging."Employee Posting Group");
                        Employee.VALIDATE("Country/Region Code", HisMasterStaging."Country/Region Code");
                        Employee.VALIDATE("Post Code", HisMasterStaging."Post Code");
                        //Employee.VALIDATE(County, HisMasterStaging.County);
                        Employee."Application Method" := HisMasterStaging."Application Method";
                        Employee.MODIFY();
                        HisMasterStaging."Vendor/Customer Code" := Employee."No.";
                        HisMasterStaging.IsCreated := TRUE;
                        HisMasterStaging."Modified by" := UserId;
                        HisMasterStaging."Modified Date Time" := CurrentDateTime;
                        HisMasterStaging.MODIFY();
                        MESSAGE('Employee has been created Successfully');
                    END ELSE BEGIN
                        HisMasterStaging."Error Description" := 'Check Employee Posting Group';
                        MESSAGE('Employee Posting Group not Exists');
                    END;
                    HisMasterStaging.MODIFY();
                END;
            UNTIL HisMasterStaging.NEXT() = 0
        ELSE
            Error('HIS Code is missing.Kindly check Error Desciption');
    end;

    procedure RevenueInvoiceValidation(RecordType: option; DocumentType: Option; DocumentNo: Code[20])
    var
        RevenueSetup: Record "E3 HIS GL Accounts Mapping";
        HISItemMapping: Record "E3 HIS Item Mapping";
        HISCustMapping: Record "E3 HIS Customer Mapping";
        Customer: Record Customer;
        txtHSNCode: Text[100];
        HSNSAC: Record "HSN/SAC";
        txtSalesAccount: Text[100];
        GSTGroup: Record "GST Group";
        GSTGroupCode: Code[20];
        LineCount: Integer;
    begin
        LineCount := 0;
        txtHSNCode := '';
        txtSalesAccount := '';
        txtHSNCode := '';
        GSTGroupCode := '';
        IntegrationSetup.Get();

        HISRevenueHeader.RESET();
        HISRevenueHeader.SetRange("Record Type", RecordType);
        HISRevenueHeader.SetRange("Document Type", DocumentType);
        HISRevenueHeader.SETRANGE("Document No.", DocumentNo);
        IF HISRevenueHeader.FINDFIRST() THEN BEGIN
            HISRevenueHeader."Error 1" := FALSE;
            HISRevenueHeader."Error 2" := FALSE;
            HISRevenueHeader."Error 3" := FALSE;
            HISRevenueHeader."Error 4" := FALSE;
            HISRevenueHeader."Error Description" := '';
            HISRevenueHeader.MODIFY();
        END;

        HISRevenueLine.RESET();
        HISRevenueLine.SetRange("Record Type", RecordType);
        HISRevenueLine.SetRange("Document Type", DocumentType);
        HISRevenueLine.SETRANGE("Document No.", DocumentNo);
        HISRevenueLine.SetRange("Package Patient", false);  //Check if not required
        IF HISRevenueLine.FINDFIRST() THEN BEGIN
            REPEAT
                LineCount += 1;
                //if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                IF HISRevenueLine."HSN Code" <> '' THEN begin
                    if HISRevenueLine."GST Group Code" = '' then
                        GSTGroupCode := 'Must not be Blank';

                    HSNSAC.RESET();
                    HSNSAC.SetRange("GST Group Code", HISRevenueLine."GST Group Code");
                    HSNSAC.SETRANGE(Code, HISRevenueLine."HSN Code");
                    IF NOT HSNSAC.FINDFIRST() THEN
                        txtHSNCode := 'Create New HSN Code'
                END;

                IF HISRevenueLine."GST Group Code" <> '' THEN BEGIN
                    if HISRevenueLine."HSN Code" = '' then
                        txtHSNCode := 'HSN Code must have value.';

                    GSTGroup.RESET();
                    GSTGroup.SETRANGE(GSTGroup.Code, HISRevenueLine."GST Group Code");
                    IF NOT GSTGroup.FINDFIRST() THEN
                        GSTGroupCode := 'Create New GST Group';
                END;
                //End;

                IF HISRevenueLine."Account No." = '' THEN begin
                    HISRevenueHeader.RESET();
                    HISRevenueHeader.SetRange("Record Type", HISRevenueLine."Record Type");
                    HISRevenueHeader.SetRange("Document Type", HISRevenueLine."Document Type");
                    HISRevenueHeader.SETRANGE("Document No.", HISRevenueLine."Document No.");
                    IF HISRevenueHeader.FINDFIRST() THEN begin
                        RevenueSetup.Reset();
                        RevenueSetup.SetRange("Service/Station Head", HISRevenueHeader."HIS Document Type");
                        RevenueSetup.SetRange("HIS Code", HISRevenueLine."Service Item Code");
                        RevenueSetup.SetRange(Package, HISRevenueLine."Package Patient");
                        if not RevenueSetup.FindFirst() then
                            txtSalesAccount := 'Revenue Account Missing'
                        else
                            if (RevenueSetup."Account No." <> '') and (RevenueSetup."Discount G/L Account" <> '') and (RevenueSetup."MOU Discount G/L Account" <> '') then begin
                                HISRevenueLine."Account Type" := RevenueSetup."Account Type";
                                HISRevenueLine."Account No." := RevenueSetup."Account No.";
                                HISRevenueLine."Discount G/L Account" := RevenueSetup."Discount G/L Account";
                                HISRevenueLine."MOU Discount G/L Account" := RevenueSetup."MOU Discount G/L Account";
                                if HISRevenueLine."Shortcut Dimension 1 Code" = '' then
                                    HISRevenueLine."Shortcut Dimension 1 Code" := HISRevenueHeader."Shortcut Dimension 1 Code";
                                HISRevenueLine.Modify(false);
                            end else
                                txtSalesAccount := 'Revenue or Discounts Account Missing';
                    end;
                end;


            UNTIL HISRevenueLine.NEXT() = 0;

            HISRevenueHeader.RESET();
            HISRevenueHeader.SetRange("Record Type", HISRevenueLine."Record Type");
            HISRevenueHeader.SetRange("Document Type", HISRevenueLine."Document Type");
            HISRevenueHeader.SETRANGE("Document No.", HISRevenueLine."Document No.");
            IF HISRevenueHeader.FINDFIRST() THEN begin
                if HISRevenueHeader."No. of Lines" <> LineCount then
                    HISRevenueHeader."Error Description" := 'Line count mismatch.';

                if HISRevenueHeader."Posting Date" = 0D then
                    HISRevenueHeader."Posting Date" := HISRevenueHeader."Document Date";

                if HISRevenueHeader."Location Code" = '' then
                    HISRevenueHeader."Location Code" := HISRevenueHeader."Shortcut Dimension 1 Code";

                if HISRevenueHeader."Customer No." = '' then begin
                    HISCustMapping.Reset();
                    HISCustMapping.SetRange("HIS Code", HISRevenueHeader."Payer Code");
                    if HISCustMapping.FindFirst() then begin
                        Customer.Reset();
                        Customer.SetRange("No.", HISCustMapping."Customer No.");
                        if Customer.FindFirst() then begin
                            HISRevenueHeader."Customer No." := Customer."No.";
                            HISRevenueHeader."Customer Name" := Customer.Name;
                            HISRevenueHeader.Modify();
                        end else
                            HISRevenueHeader."Error Description" := 'Customer does not exists.';
                    end else
                        HISRevenueHeader."Error Description" := 'Customer Mapping Missing';
                end;

                IF (HISRevenueHeader."Customer Name" = '') OR (txtHSNCode <> '') OR (txtSalesAccount <> '') OR (GSTGroupCode <> '') THEN
                    HISRevenueHeader."Error Description" := 'Kindly Check Customer,HSN Code,GST Group Code';
                // ELSE
                //     HISRevenueHeader."Error Description" := '';

                HISRevenueHeader.MODIFY();
            end;
        END ELSE BEGIN
            HISRevenueHeader.RESET();
            HISRevenueHeader.SetRange("Record Type", RecordType);
            HISRevenueHeader.SetRange("Document Type", DocumentType);
            HISRevenueHeader.SETRANGE("Document No.", DocumentNo);
            IF HISRevenueHeader.FINDFIRST() THEN BEGIN
                HISRevenueLine.RESET();
                HISRevenueLine.SetRange("Record Type", HISRevenueHeader."Record Type");
                HISRevenueLine.SetRange("Document Type", HISRevenueHeader."Document Type");
                HISRevenueLine.SETRANGE("Document No.", HISRevenueHeader."Document No.");
                IF NOT HISRevenueLine.FINDFIRST() THEN
                    HISRevenueHeader."Error Description" := 'Integration Line is Empty';
                HISRevenueHeader.MODIFY();
            END;
        END;

        HISRevenueHeader.RESET();
        HISRevenueHeader.SetRange("Record Type", HISRevenueLine."Record Type");
        HISRevenueHeader.SetRange("Document Type", HISRevenueLine."Document Type");
        HISRevenueHeader.SETRANGE("Document No.", HISRevenueLine."Document No.");
        IF HISRevenueHeader.FINDFIRST() THEN BEGIN
            IF (HISRevenueHeader."Customer Name" = '') THEN
                HISRevenueHeader."Error 1" := TRUE
            ELSE
                HISRevenueHeader."Error 1" := FALSE;
            IF (txtSalesAccount <> '') THEN
                HISRevenueHeader."Error 2" := TRUE
            ELSE
                HISRevenueHeader."Error 2" := FALSE;
            IF (txtHSNCode <> '') THEN
                HISRevenueHeader."Error 3" := TRUE
            ELSE
                HISRevenueHeader."Error 3" := FALSE;
            IF (GSTGroupCode <> '') THEN
                HISRevenueHeader."Error 4" := TRUE
            ELSE
                HISRevenueHeader."Error 4" := FALSE;
            HISRevenueHeader.MODIFY();
        END;
        Commit();
    end;

    procedure RevenueInvoiceReValidation(RecordType: option; DocumentType: Option; DocumentNo: Code[20])
    var
        RevenueSetup: Record "E3 HIS GL Accounts Mapping";
        HISItemMapping: Record "E3 HIS Item Mapping";
        HISCustMapping: Record "E3 HIS Customer Mapping";
        txtHSNCode: Text[100];
        HSNSAC: Record "HSN/SAC";
        txtSalesAccount: Text[100];
        GSTGroup: Record "GST Group";
        GSTGroupCode: Code[20];
        txtHSNCodeNew: Text[100];
        Customer: Record Customer;
        LineCount: Integer;
    BEGIN
        LineCount := 0;
        txtHSNCode := '';
        txtSalesAccount := '';
        txtHSNCodeNew := '';
        GSTGroupCode := '';
        IntegrationSetup.Get();

        HISRevenueHeader.RESET();
        HISRevenueHeader.SetRange("Record Type", RecordType);
        HISRevenueHeader.SetRange("Document Type", DocumentType);
        HISRevenueHeader.SETRANGE("Document No.", DocumentNo);
        IF HISRevenueHeader.FINDFIRST() THEN BEGIN
            HISRevenueHeader."Error 1" := FALSE;
            HISRevenueHeader."Error 2" := FALSE;
            HISRevenueHeader."Error 3" := FALSE;
            HISRevenueHeader."Error 4" := FALSE;
            HISRevenueHeader."Error Description" := '';
            HISRevenueHeader.MODIFY();
        END;

        HISRevenueLine.RESET();
        HISRevenueLine.SetRange("Record Type", RecordType);
        HISRevenueLine.SetRange("Document Type", DocumentType);
        HISRevenueLine.SETRANGE("Document No.", DocumentNo);
        HISRevenueLine.SetRange("Package Patient", false);  //Check if exceluded
        IF HISRevenueLine.FINDFIRST() THEN BEGIN
            REPEAT
                LineCount += 1;
                // IF HISRevenueLine."HSN Code" = '' THEN BEGIN
                //     txtHSNCode := 'HSN Code';
                // END;
                //if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                if HISRevenueLine."HSN Code" <> '' then begin
                    if HISRevenueLine."GST Group Code" = '' then
                        GSTGroupCode := 'Must not be Blank';

                    HSNSAC.RESET();
                    HSNSAC.SetRange("GST Group Code", HISRevenueLine."GST Group Code");
                    HSNSAC.SETRANGE(Code, HISRevenueLine."HSN Code");
                    IF NOT HSNSAC.FINDFIRST() THEN
                        txtHSNCodeNew := 'HSN Code New';
                end;

                IF HISRevenueLine."GST Group Code" <> '' THEN BEGIN
                    if HISRevenueLine."HSN Code" = '' then
                        txtHSNCodeNew := 'HSN Code must have value.';

                    GSTGroup.Reset();
                    GSTGroup.SetRange(Code, HISRevenueLine."GST Group Code");
                    IF NOT GSTGroup.FINDFIRST() THEN
                        GSTGroupCode := 'GST Group';
                END;
                //End;

                IF HISRevenueLine."Account No." = '' THEN BEGIN
                    HISRevenueHeader.RESET();
                    HISRevenueHeader.SetRange("Record Type", RecordType);
                    HISRevenueHeader.SetRange("Document Type", DocumentType);
                    HISRevenueHeader.SETRANGE("Document No.", DocumentNo);
                    IF HISRevenueHeader.FINDFIRST() THEN begin
                        RevenueSetup.Reset();
                        RevenueSetup.SetRange("Service/Station Head", HISRevenueHeader."HIS Document Type");
                        RevenueSetup.SetRange("HIS Code", HISRevenueLine."Service Item Code");
                        RevenueSetup.SetRange(Package, HISRevenueLine."Package Patient");
                        if not RevenueSetup.FindFirst() then
                            txtSalesAccount := 'Revenue Account Missing'
                        else
                            if (RevenueSetup."Account No." <> '') and (RevenueSetup."Discount G/L Account" <> '') and (RevenueSetup."MOU Discount G/L Account" <> '') then begin
                                HISRevenueLine."Account Type" := RevenueSetup."Account Type";
                                HISRevenueLine."Account No." := RevenueSetup."Account No.";
                                HISRevenueLine."Discount G/L Account" := RevenueSetup."Discount G/L Account";
                                HISRevenueLine."MOU Discount G/L Account" := RevenueSetup."MOU Discount G/L Account";
                                if HISRevenueLine."Shortcut Dimension 1 Code" = '' then
                                    HISRevenueLine."Shortcut Dimension 1 Code" := HISRevenueHeader."Shortcut Dimension 1 Code";
                                HISRevenueLine.Modify(false);
                            end else
                                txtSalesAccount := 'Revenue or Discounts Account Missing';
                    END;
                end;
            UNTIL HISRevenueLine.NEXT() = 0;

            HISRevenueHeader.RESET();
            HISRevenueHeader.SetRange("Record Type", RecordType);
            HISRevenueHeader.SetRange("Document Type", DocumentType);
            HISRevenueHeader.SETRANGE("Document No.", DocumentNo);
            IF HISRevenueHeader.FINDFIRST() THEN begin
                if HISRevenueHeader."No. of Lines" <> LineCount then
                    HISRevenueHeader."Error Description" := 'Line count mismatch.';

                if HISRevenueHeader."Posting Date" = 0D then
                    HISRevenueHeader."Posting Date" := HISRevenueHeader."Document Date";

                if HISRevenueHeader."Location Code" = '' then
                    HISRevenueHeader."Location Code" := HISRevenueHeader."Shortcut Dimension 1 Code";

                if HISRevenueHeader."Customer No." = '' then begin
                    HISCustMapping.Reset();
                    HISCustMapping.SetRange("HIS Code", HISRevenueHeader."Payer Code");
                    if HISCustMapping.FindFirst() then begin
                        Customer.Reset();
                        Customer.SetRange("No.", HISCustMapping."Customer No.");
                        if Customer.FindFirst() then begin
                            HISRevenueHeader."Customer No." := Customer."No.";
                            HISRevenueHeader."Customer Name" := Customer.Name;
                            HISRevenueHeader.Modify();
                        end else
                            HISRevenueHeader."Error Description" := 'Customer does not exists.';
                    end else
                        HISRevenueHeader."Error Description" := 'Customer Mapping Missing';
                end else begin
                    Customer.Reset();
                    Customer.SetRange("No.", HISRevenueHeader."Customer No.");
                    if Customer.FindFirst() then begin
                        HISRevenueHeader."Customer Name" := Customer.Name;
                        HISRevenueHeader.Modify();
                    end;
                end;

                IF (HISRevenueHeader."Customer Name" = '') OR (txtHSNCodeNew <> '') OR (txtSalesAccount <> '') OR (GSTGroupCode <> '') THEN
                    HISRevenueHeader."Error Description" := 'Revalidation Error found';
                // ELSE
                //     HISRevenueHeader."Error Description" := '';

                IF HISRevenueHeader."Customer Name" <> '' THEN BEGIN
                    HISRevenueHeader."Error 1" := FALSE
                END;

                IF txtSalesAccount = '' THEN
                    HISRevenueHeader."Error 2" := FALSE;

                IF txtHSNCodeNew = '' THEN
                    HISRevenueHeader."Error 3" := FALSE;

                IF GSTGroupCode = '' THEN
                    HISRevenueHeader."Error 4" := FALSE;

                HISRevenueHeader.MODIFY();
            end;
        END ELSE BEGIN
            HISRevenueHeader.RESET();
            HISRevenueHeader.SetRange("Record Type", RecordType);
            HISRevenueHeader.SetRange("Document Type", DocumentType);
            HISRevenueHeader.SETRANGE("Document No.", DocumentNo);
            IF HISRevenueHeader.FINDFIRST() THEN BEGIN
                HISRevenueLine.RESET();
                HISRevenueLine.SetRange("Record Type", HISRevenueLine."Record Type");
                HISRevenueLine.SetRange("Document Type", HISRevenueLine."Document Type");
                HISRevenueLine.SETRANGE("Document No.", HISRevenueHeader."Document No.");
                IF NOT HISRevenueLine.FINDFIRST() THEN
                    HISRevenueHeader."Error Description" := 'Integration Line is Empty';
                HISRevenueHeader.MODIFY();
            END;
        END;
        Commit();
    END;

    procedure CheckRevenueHISDocumentDate(HISRevenueHeader: Record "E3 HIS Revenue Header")
    var
        AllowPostingDate: Record "HIS Allow Posting Date";
        DocDate: Date;
    begin
        DocDate := HISRevenueHeader."Document Date";

        AllowPostingDate.Reset();
        AllowPostingDate.SetRange("Code Unit Name", '50011');

        AllowPostingDate.SetFilter("From Date", '<=%1', DocDate);
        AllowPostingDate.SetFilter("To Date", '>=%1', DocDate);

        if not AllowPostingDate.FindFirst() then
            Error('Document Date %1 is not allowed. Allowed date range not defined for %2.', DocDate, '50011 Allow Integration Setup From date and To Date');
    end;

    procedure InitRevenueInvoice(RecordType: Option; DocumentType: Option; DocumentNo: CODE[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        GenJournalLine: Record "Gen. Journal Line";
        InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary;
        PostGenJnlLine: Codeunit "Gen. Jnl.-Post Line";
        AmountToCustomer: Decimal;
        PatientPayble: Decimal;
        LineNo: Integer;
    begin
        AmountToCustomer := 0;
        PatientPayble := 0;
        IntegrationSetup.GET();
        //IntegrationSetup.testfield("Account Type");
        IntegrationSetup.testfield("Account No.");

        RevenueInvoiceValidation(RecordType, documentType, DocumentNo);

        HISRevenueHeader.RESET();
        HISRevenueHeader.SETRANGE(HISRevenueHeader."Document No.", DocumentNo);
        HISRevenueHeader.SETRANGE("Record Type", RecordType);
        HISRevenueHeader.SETRANGE("Document Type", DocumentType);
        HISRevenueHeader.SETRANGE(HISRevenueHeader."Create Revenue", FALSE);
        HISRevenueHeader.SETFILTER(HISRevenueHeader."Customer No.", '<>%1', '');
        HISRevenueHeader.SETFILTER(HISRevenueHeader."Error Description", '%1', '');
        HISRevenueHeader.SETFILTER(HISRevenueHeader."No. of Lines", '<>%1', 0);
        HISRevenueHeader.SETRANGE(HISRevenueHeader."Error 1", FALSE);
        HISRevenueHeader.SETRANGE(HISRevenueHeader."Error 2", FALSE);
        HISRevenueHeader.SETRANGE(HISRevenueHeader."Error 3", FALSE);
        HISRevenueHeader.SETRANGE(HISRevenueHeader."Error 4", FALSE);
        IF HISRevenueHeader.FINDFIRST() THEN BEGIN

            CheckRevenueHISDocumentDate(HISRevenueHeader);//ak

            if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                SalesHeader.INIT();
                IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN BEGIN
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice
                END ELSE
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

                SalesHeader."No." := HISRevenueHeader."Document No.";
                SalesHeader.INSERT(TRUE);
                SalesHeader.VALIDATE("Sell-to Customer No.", HISRevenueHeader."Customer No.");
                SalesHeader.VALIDATE("Order Date", HISRevenueHeader."Document Date");
                if HISRevenueHeader."Posting Date" <> 0D then
                    SalesHeader.VALIDATE("Posting Date", HISRevenueHeader."Posting Date")
                else
                    SalesHeader.Validate("Posting Date", HISRevenueHeader."Document Date");
                SalesHeader.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");
                if HISRevenueHeader."Location Code" <> '' then
                    SalesHeader.VALIDATE("Location Code", HISRevenueHeader."Location Code")
                else
                    SalesHeader.Validate("Location Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 1 Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueHeader."Shortcut Dimension 2 Code"));
                SalesHeader.VALIDATE("Posting No. Series", '');
                SalesHeader.VALIDATE("Posting No.", HISRevenueHeader."Document No.");
                SalesHeader.Validate("Reference Invoice No.", HISRevenueHeader."Reference Invoice No.");
                //Code
                //SalesHeader."E3 HIS Module" := HISRevenueHeader."E3 HIS Module";
                SalesHeader."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                SalesHeader."E3 UHID" := HISRevenueHeader."UHID";
                SalesHeader."E3 Patient Name" := HISRevenueHeader."Patient Name";
                SalesHeader."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                SalesHeader."E3 Doctor Name" := HISRevenueHeader.Doctor;
                SalesHeader."E3 Speciality" := HISRevenueHeader."Speciality";
                SalesHeader."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                SalesHeader."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                SalesHeader."E3 Payer Code" := HISRevenueHeader."Payer Code";
                SalesHeader."E3 Payer Name" := HISRevenueHeader."Payer Name";
                SalesHeader.MODIFY();
            end else begin
                IntegrationSetupLine.Reset();
                IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Revenue);
                IntegrationSetupLine.FindFirst();
                IntegrationSetupLine.TestField("General Journal Template Code");
                IntegrationSetupLine.TestField("General Journal Batch Code");
            end;

            LineNo := 0;
            if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                HISRevenueLine.RESET();
                HISRevenueLine.SetRange("Record Type", HISRevenueHeader."Record Type");
                HISRevenueLine.SetRange("document Type", HISRevenueHeader."document Type");
                HISRevenueLine.SETRANGE(HISRevenueLine."Document No.", SalesHeader."No.");
                HISRevenueLine.SetRange("Package Patient", false);
                IF HISRevenueLine.FINDFIRST() THEN
                    REPEAT
                        LineNo += 10000;
                        SalesLine.INIT();
                        SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine.VALIDATE("Line No.", LineNo);
                        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
                        SalesLine.VALIDATE("No.", HISRevenueLine."Account No.");
                        SalesLine.VALIDATE(Quantity, HISRevenueLine.Qty);
                        SalesLine.VALIDATE(SalesLine."Unit Price", HISRevenueLine.Amount);
                        SalesLine.VALIDATE("GST Group Code", DELCHR(CONVERTSTR(HISRevenueLine."GST Group Code", '.', ' ')));
                        SalesLine.VALIDATE("HSN/SAC Code", HISRevenueLine."HSN Code");
                        SalesLine.VALIDATE("Location Code", SalesHeader."Location Code");
                        SalesLine.VALIDATE(SalesLine."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                        SalesLine.VALIDATE(SalesLine."Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                        SalesLine.Description := COPYSTR(HISRevenueLine."Item Name", 1, 100);
                        SalesLine.VALIDATE(SalesLine."GST Credit", HISRevenueLine."Credit Type");
                        SalesLine.VALIDATE("Line Discount Amount", -1 * HISRevenueLine.Discount);
                        SalesLine.INSERT(TRUE);
                    UNTIL HISRevenueLine.NEXT() = 0;
            end else begin
                InvoicePostingBuffer.DeleteAll();
                AmountToCustomer := 0;
                PatientPayble := 0;

                HISRevenueLine.RESET();
                HISRevenueLine.SetRange("Record Type", HISRevenueHeader."Record Type");
                HISRevenueLine.SetRange("document Type", HISRevenueHeader."document Type");
                HISRevenueLine.SETRANGE(HISRevenueLine."Document No.", HISRevenueHeader."Document No.");
                HISRevenueLine.SetRange("Package Patient", false);
                IF HISRevenueLine.FINDFIRST() THEN
                    REPEAT
                        AmountToCustomer += HISRevenueLine."Payor Payable";
                        PatientPayble += HISRevenueLine."Patient Payable";

                        InvoicePostingBuffer.SetRange("G/L Account", HISRevenueLine."Account No.");
                        InvoicePostingBuffer.SetRange("Global Dimension 1 Code", HISRevenueLine."Shortcut Dimension 1 Code");
                        InvoicePostingBuffer.SetRange("Global Dimension 2 Code", HISRevenueLine."Shortcut Dimension 2 Code");
                        if InvoicePostingBuffer.FindFirst() then begin
                            InvoicePostingBuffer.Amount := InvoicePostingBuffer.Amount + (-(HISRevenueLine.Amount));
                            InvoicePostingBuffer.Modify();
                        end else begin
                            InvoicePostingBuffer.Init();
                            InvoicePostingBuffer."Group ID" := HISRevenueLine."Account No." + ';' + HISRevenueLine."Shortcut Dimension 1 Code" + ';' + HISRevenueLine."Shortcut Dimension 2 Code";
                            InvoicePostingBuffer.Type := InvoicePostingBuffer.Type::"G/L Account";
                            InvoicePostingBuffer."G/L Account" := HISRevenueLine."Account No.";
                            InvoicePostingBuffer."Global Dimension 1 Code" := HISRevenueLine."Shortcut Dimension 1 Code";
                            InvoicePostingBuffer."Global Dimension 2 Code" := HISRevenueLine."Shortcut Dimension 2 Code";
                            InvoicePostingBuffer.Amount := -(HISRevenueLine.Amount);
                            InvoicePostingBuffer.Insert();
                        end;

                        if HISRevenueLine.Discount <> 0 then begin
                            //AmountToCustomer += HISRevenueLine.Discount;
                            InvoicePostingBuffer.SetRange("G/L Account", HISRevenueLine."Discount G/L Account");
                            InvoicePostingBuffer.SetRange("Global Dimension 1 Code", HISRevenueLine."Shortcut Dimension 1 Code");
                            InvoicePostingBuffer.SetRange("Global Dimension 2 Code", HISRevenueLine."Shortcut Dimension 2 Code");
                            if InvoicePostingBuffer.FindFirst() then begin
                                InvoicePostingBuffer.Amount := InvoicePostingBuffer.Amount + (-HISRevenueLine.Discount);
                                InvoicePostingBuffer.Modify();
                            end else begin
                                InvoicePostingBuffer.Init();
                                InvoicePostingBuffer."Group ID" := HISRevenueLine."Account No." + ';' + HISRevenueLine."Shortcut Dimension 1 Code" + ';' + HISRevenueLine."Shortcut Dimension 2 Code" + ';Discount';
                                InvoicePostingBuffer.Type := InvoicePostingBuffer.Type::"G/L Account";
                                InvoicePostingBuffer."G/L Account" := HISRevenueLine."Discount G/L Account";
                                InvoicePostingBuffer."Global Dimension 1 Code" := HISRevenueLine."Shortcut Dimension 1 Code";
                                InvoicePostingBuffer."Global Dimension 2 Code" := HISRevenueLine."Shortcut Dimension 2 Code";
                                InvoicePostingBuffer.Amount := -HISRevenueLine.Discount;
                                InvoicePostingBuffer.Insert();
                            end;
                        end;

                        if HISRevenueLine."MOU Discount" <> 0 then begin
                            //AmountToCustomer += HISRevenueLine.Discount;
                            InvoicePostingBuffer.SetRange("G/L Account", HISRevenueLine."MOU Discount G/L Account");
                            InvoicePostingBuffer.SetRange("Global Dimension 1 Code", HISRevenueLine."Shortcut Dimension 1 Code");
                            InvoicePostingBuffer.SetRange("Global Dimension 2 Code", HISRevenueLine."Shortcut Dimension 2 Code");
                            if InvoicePostingBuffer.FindFirst() then begin
                                InvoicePostingBuffer.Amount := InvoicePostingBuffer.Amount + (-HISRevenueLine."MOU Discount");
                                InvoicePostingBuffer.Modify();
                            end else begin
                                InvoicePostingBuffer.Init();
                                InvoicePostingBuffer."Group ID" := HISRevenueLine."Account No." + ';' + HISRevenueLine."Shortcut Dimension 1 Code" + ';' + HISRevenueLine."Shortcut Dimension 2 Code" + ';MOUDiscount';
                                InvoicePostingBuffer.Type := InvoicePostingBuffer.Type::"G/L Account";
                                InvoicePostingBuffer."G/L Account" := HISRevenueLine."MOU Discount G/L Account";
                                InvoicePostingBuffer."Global Dimension 1 Code" := HISRevenueLine."Shortcut Dimension 1 Code";
                                InvoicePostingBuffer."Global Dimension 2 Code" := HISRevenueLine."Shortcut Dimension 2 Code";
                                InvoicePostingBuffer.Amount := -HISRevenueLine."MOU Discount";
                                InvoicePostingBuffer.Insert();
                            end;
                        end;
                    UNTIL HISRevenueLine.NEXT() = 0;

                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                GenJournalLine.SetRange("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                if GenJournalLine.FindLast() then
                    LineNo := GenJournalLine."Line No."
                else
                    LineNo := 0;

                InvoicePostingBuffer.Reset();
                InvoicePostingBuffer.SetFilter(Amount, '<>0');
                if InvoicePostingBuffer.FindSet() then
                    repeat
                        LineNo += 10000;
                        GenJournalLine.INIT();
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                        GenJournalLine."Line No." := LineNo;
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
                        ELSE
                            IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                                GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

                        GenJournalLine.VALIDATE("Document No.", HISRevenueHeader."Document No.");
                        GenJournalLine.VALIDATE("Document Date", HISRevenueHeader."Document Date");
                        GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Posting Date");
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.VALIDATE("Account No.", InvoicePostingBuffer."G/L Account");
                        GenJournalLine."Location Code" := HISRevenueHeader."Location Code";
                        GenJournalLine."Your Reference" := HISRevenueHeader."Reference Invoice No.";
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                            GenJournalLine.VALIDATE(Amount, InvoicePostingBuffer.Amount)
                        else
                            GenJournalLine.VALIDATE(Amount, -InvoicePostingBuffer.Amount);
                        //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                        //GenJournalLine.Validate("Bal. Account No.", HISRevenueHeader."Customer No.");
                        if InvoicePostingBuffer."Global Dimension 1 Code" <> '' then begin
                            GenJournalLine.VALIDATE("Location Code", InvoicePostingBuffer."Global Dimension 1 Code");
                            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", InvoicePostingBuffer."Global Dimension 1 Code");
                        end;

                        if InvoicePostingBuffer."Global Dimension 2 Code" <> '' then
                            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(InvoicePostingBuffer."Global Dimension 2 Code"));

                        GenJournalLine.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");

                        GenJournalLine."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                        GenJournalLine."E3 UHID" := HISRevenueHeader."UHID";
                        GenJournalLine."E3 Patient Name" := HISRevenueHeader."Patient Name";
                        GenJournalLine."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                        GenJournalLine."E3 Doctor Name" := HISRevenueHeader.Doctor;
                        GenJournalLine."E3 Speciality" := HISRevenueHeader."Speciality";
                        GenJournalLine."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                        GenJournalLine."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                        GenJournalLine."E3 Payer Code" := HISRevenueHeader."Payer Code";
                        GenJournalLine."E3 Payer Name" := HISRevenueHeader."Payer Name";
                        if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                            PostGenJnlLine.RunWithCheck(GenJournalLine)
                        else
                            GenJournalLine.INSERT();
                    until InvoicePostingBuffer.Next() = 0;

                if PatientPayble <> 0 then begin
                    LineNo += 10000;
                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    GenJournalLine."Line No." := LineNo;
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
                    ELSE
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

                    GenJournalLine.VALIDATE("Document No.", HISRevenueHeader."Document No.");
                    GenJournalLine.VALIDATE("Document Date", HISRevenueHeader."Document Date");
                    GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Posting Date");
                    GenJournalLine.VALIDATE("Account Type", IntegrationSetup."Account Type");
                    GenJournalLine.VALIDATE("Account No.", IntegrationSetup."Account No.");
                    GenJournalLine."Location Code" := HISRevenueHeader."Location Code";
                    GenJournalLine."Your Reference" := HISRevenueHeader."Reference Invoice No.";
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE(Amount, PatientPayble)
                    else
                        GenJournalLine.Validate(Amount, -PatientPayble);
                    //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                    //GenJournalLine.Validate("Bal. Account No.", HISRevenueHeader."Customer No.");
                    if HISRevenueHeader."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                    end;

                    if HISRevenueHeader."Shortcut Dimension 2 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueHeader."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");

                    GenJournalLine."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                    GenJournalLine."E3 UHID" := HISRevenueHeader."UHID";
                    GenJournalLine."E3 Patient Name" := HISRevenueHeader."Patient Name";
                    GenJournalLine."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                    GenJournalLine."E3 Doctor Name" := HISRevenueHeader.Doctor;
                    GenJournalLine."E3 Speciality" := HISRevenueHeader."Speciality";
                    GenJournalLine."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                    GenJournalLine."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                    GenJournalLine."E3 Payer Code" := HISRevenueHeader."Payer Code";
                    GenJournalLine."E3 Payer Name" := HISRevenueHeader."Payer Name";
                    if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                        PostGenJnlLine.RunWithCheck(GenJournalLine)
                    else
                        GenJournalLine.INSERT();
                end;

                if AmountToCustomer <> 0 then begin
                    LineNo += 10000;
                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    GenJournalLine."Line No." := LineNo;
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
                    ELSE
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

                    GenJournalLine.VALIDATE("Document No.", HISRevenueHeader."Document No.");
                    GenJournalLine.VALIDATE("Document Date", HISRevenueHeader."Document Date");
                    GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Posting Date");
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
                    GenJournalLine.VALIDATE("Account No.", HISRevenueHeader."Customer No.");
                    GenJournalLine."Location Code" := HISRevenueHeader."Location Code";
                    GenJournalLine."Your Reference" := HISRevenueHeader."Reference Invoice No.";
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE(Amount, AmountToCustomer)
                    else
                        GenJournalLine.VALIDATE(Amount, -AmountToCustomer);
                    //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                    //GenJournalLine.Validate("Bal. Account No.", HISRevenueHeader."Customer No.");
                    if HISRevenueHeader."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                    end;

                    if HISRevenueHeader."Shortcut Dimension 2 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueHeader."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");

                    GenJournalLine."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                    GenJournalLine."E3 UHID" := HISRevenueHeader."UHID";
                    GenJournalLine."E3 Patient Name" := HISRevenueHeader."Patient Name";
                    GenJournalLine."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                    GenJournalLine."E3 Doctor Name" := HISRevenueHeader.Doctor;
                    GenJournalLine."E3 Speciality" := HISRevenueHeader."Speciality";
                    GenJournalLine."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                    GenJournalLine."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                    GenJournalLine."E3 Payer Code" := HISRevenueHeader."Payer Code";
                    GenJournalLine."E3 Payer Name" := HISRevenueHeader."Payer Name";
                    if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                        PostGenJnlLine.RunWithCheck(GenJournalLine)
                    else
                        GenJournalLine.INSERT();
                end;
            end;
            HISRevenueHeader."Create Revenue" := TRUE;
            if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                HISRevenueHeader."Posted Document No." := HISRevenueHeader."Document No.";
            HISRevenueHeader.MODIFY();
            if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                Commit();
        END;
    end;

    procedure PostGenJnlLineEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        GenJournalLine1: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);


        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Revenue Creation Enabled") THEN
            EXIT;

        GenJnlLine.RESET();
        GenJnlLine.SETFILTER(GenJnlLine."Account No.", '%1', '');
        GenJnlLine.SETFILTER(GenJnlLine.Amount, '%1', 0);
        IF GenJnlLine.FINDFIRST() THEN BEGIN
            GenJnlLine.DELETEALL;
        END;

        HISIntegrationSetupLine.Reset();
        HISIntegrationSetupLine.SetFilter(Type, '<>%1', IntegrationSetupLine.Type::Consumption);
        IF HISIntegrationSetupLine.FindSet() then
            repeat
                GenJnlLine.RESET();
                GenJnlLine.SETRANGE("Journal Template Name", HISIntegrationSetupLine."General Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", HISIntegrationSetupLine."General Journal Batch Code");
                IF GenJnlLine.FindSet() THEN
                    REPEAT
                        GenJournalLine1.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJournalLine1.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJournalLine1.SETRANGE("Document No.", GenJnlLine."Document No.");
                        GenJournalLine1.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                        IF GenJournalLine1.FINDFIRST() THEN
                            REPEAT
                                GenJnlPostBatch.RUN(GenJournalLine1);
                            UNTIL GenJournalLine1.NEXT() = 0;
                    UNTIL GenJnlLine.NEXT() = 0
                else
                    Error('There is no HIS Entries Pending for the Posting');
            until HISIntegrationSetupLine.Next() = 0;

    end;

    procedure PostGenJnlLineConsumptionEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        GenJournalLine1: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        IntegrationSetup.GET();
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Consumption Creation Enabled", TRUE);


        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Consumption Creation Enabled") THEN
            EXIT;

        GenJnlLine.RESET();
        GenJnlLine.SETFILTER(GenJnlLine."Account No.", '%1', '');
        GenJnlLine.SETFILTER(GenJnlLine.Amount, '%1', 0);
        IF GenJnlLine.FINDFIRST() THEN BEGIN
            GenJnlLine.DELETEALL();
        END;

        IntegrationSetupLine.Reset();
        IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Consumption);
        IF HISIntegrationSetupLine.FindFirst() then
            repeat
                GenJnlLine.RESET();
                GenJnlLine.SETRANGE("Journal Template Name", HISIntegrationSetupLine."General Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", HISIntegrationSetupLine."General Journal Batch Code");
                IF GenJnlLine.FINDFIRST() THEN
                    REPEAT
                        GenJournalLine1.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJournalLine1.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJournalLine1.SETRANGE("Document No.", GenJnlLine."Document No.");
                        GenJournalLine1.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                        IF GenJournalLine1.FINDFIRST() THEN
                            REPEAT
                                GenJnlPostBatch.RUN(GenJournalLine1);
                            UNTIL GenJournalLine1.NEXT() = 0;
                    UNTIL GenJnlLine.NEXT() = 0
                else
                    Error('No Consumption Entries are Pending for Posting');
            until HISIntegrationSetupLine.Next() = 0;
    end;

    local procedure GetMappedDimension(HISCCode: Code[20]): Code[20]
    var
        LGeneralLedgerSetup: Record "General Ledger Setup";
        DimensionMapping: Record "E3 HIS GL Accounts Mapping";
    begin
        if HISCCode = '' then
            exit('');

        LGeneralLedgerSetup.Get();

        DimensionMapping.Reset();
        DimensionMapping.SetRange(Type, DimensionMapping.Type::Dimension);
        DimensionMapping.SetRange("Dimension Code", LGeneralLedgerSetup."Global Dimension 2 Code");
        DimensionMapping.SetRange("HIS Code", HISCCode);
        if DimensionMapping.FindFirst() then
            exit(DimensionMapping."Department Code");
    end;

    local procedure GetMappedDimension5(HISCCode: Code[20]): Code[20]
    var
        LGeneralLedgerSetup: Record "General Ledger Setup";
        DimensionMapping: Record "E3 HIS GL Accounts Mapping";
    begin
        if HISCCode = '' then
            exit('');

        LGeneralLedgerSetup.Get();

        DimensionMapping.Reset();
        DimensionMapping.SetRange(Type, DimensionMapping.Type::Dimension);
        DimensionMapping.SetRange("Dimension Code", LGeneralLedgerSetup."Shortcut Dimension 5 Code");
        DimensionMapping.SetRange("HIS Code", HISCCode);
        if DimensionMapping.FindFirst() then
            exit(DimensionMapping."Department Code");
    end;


    procedure CreateAndPostRevenueInvoice(var HISRevenueHeader: Record "E3 HIS Revenue Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        GenJournalLine: Record "Gen. Journal Line";
        InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary;
        PostGenJnlLine: Codeunit "Gen. Jnl.-Post Line";
        AmountToCustomer: Decimal;
        PatientPayble: Decimal;
        LineNo: Integer;
    begin
        AmountToCustomer := 0;
        PatientPayble := 0;
        IntegrationSetup.GET();
        //IntegrationSetup.testfield("Account Type");
        IntegrationSetup.testfield("Account No.");

        RevenueInvoiceValidation(HISRevenueHeader);

        IF not HISRevenueHeader."Create Revenue" THEN BEGIN
            if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                SalesHeader.INIT();
                IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN BEGIN
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice
                END ELSE
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

                SalesHeader."No." := HISRevenueHeader."Document No.";
                SalesHeader.INSERT(TRUE);
                SalesHeader.VALIDATE("Sell-to Customer No.", HISRevenueHeader."Customer No.");
                SalesHeader.VALIDATE("Order Date", HISRevenueHeader."Document Date");
                if HISRevenueHeader."Posting Date" <> 0D then
                    SalesHeader.VALIDATE("Posting Date", HISRevenueHeader."Posting Date")
                else
                    SalesHeader.Validate("Posting Date", HISRevenueHeader."Document Date");
                SalesHeader.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");
                if HISRevenueHeader."Location Code" <> '' then
                    SalesHeader.VALIDATE("Location Code", HISRevenueHeader."Location Code")
                else
                    SalesHeader.Validate("Location Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 1 Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueHeader."Shortcut Dimension 2 Code"));
                SalesHeader.VALIDATE("Posting No. Series", '');
                SalesHeader.VALIDATE("Posting No.", HISRevenueHeader."Document No.");
                SalesHeader.Validate("Reference Invoice No.", HISRevenueHeader."Reference Invoice No.");
                //Code
                //SalesHeader."E3 HIS Module" := HISRevenueHeader."E3 HIS Module";
                SalesHeader."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                SalesHeader."E3 UHID" := HISRevenueHeader."UHID";
                SalesHeader."E3 Patient Name" := HISRevenueHeader."Patient Name";
                SalesHeader."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                SalesHeader."E3 Doctor Name" := HISRevenueHeader.Doctor;
                SalesHeader."E3 Speciality" := HISRevenueHeader."Speciality";
                SalesHeader."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                SalesHeader."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                SalesHeader."E3 Payer Code" := HISRevenueHeader."Payer Code";
                SalesHeader."E3 Payer Name" := HISRevenueHeader."Payer Name";
                SalesHeader.MODIFY();
            end else begin
                IntegrationSetupLine.Reset();
                IntegrationSetupLine.SetRange(Type, IntegrationSetupLine.Type::Revenue);
                IntegrationSetupLine.FindFirst();
                IntegrationSetupLine.TestField("General Journal Template Code");
                IntegrationSetupLine.TestField("General Journal Batch Code");
            end;

            LineNo := 0;
            if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                HISRevenueLine.RESET();
                HISRevenueLine.SetRange("Record Type", HISRevenueHeader."Record Type");
                HISRevenueLine.SetRange("document Type", HISRevenueHeader."document Type");
                HISRevenueLine.SETRANGE(HISRevenueLine."Document No.", SalesHeader."No.");
                HISRevenueLine.SetRange("Package Patient", false);
                IF HISRevenueLine.FINDFIRST() THEN
                    REPEAT
                        LineNo += 10000;
                        SalesLine.INIT();
                        SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine.VALIDATE("Line No.", LineNo);
                        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
                        SalesLine.VALIDATE("No.", HISRevenueLine."Account No.");
                        SalesLine.VALIDATE(Quantity, HISRevenueLine.Qty);
                        SalesLine.VALIDATE(SalesLine."Unit Price", HISRevenueLine.Amount);
                        SalesLine.VALIDATE("GST Group Code", DELCHR(CONVERTSTR(HISRevenueLine."GST Group Code", '.', ' ')));
                        SalesLine.VALIDATE("HSN/SAC Code", HISRevenueLine."HSN Code");
                        SalesLine.VALIDATE("Location Code", SalesHeader."Location Code");
                        SalesLine.VALIDATE(SalesLine."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                        SalesLine.VALIDATE(SalesLine."Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                        SalesLine.Description := COPYSTR(HISRevenueLine."Item Name", 1, 100);
                        SalesLine.VALIDATE(SalesLine."GST Credit", HISRevenueLine."Credit Type");
                        SalesLine.VALIDATE("Line Discount Amount", -1 * HISRevenueLine.Discount);
                        SalesLine.INSERT(TRUE);
                    UNTIL HISRevenueLine.NEXT() = 0;
            end else begin
                InvoicePostingBuffer.DeleteAll();
                AmountToCustomer := 0;
                PatientPayble := 0;

                HISRevenueLine.RESET();
                HISRevenueLine.SetRange("Record Type", HISRevenueHeader."Record Type");
                HISRevenueLine.SetRange("document Type", HISRevenueHeader."document Type");
                HISRevenueLine.SETRANGE(HISRevenueLine."Document No.", HISRevenueHeader."Document No.");
                HISRevenueLine.SetRange("Package Patient", false);
                IF HISRevenueLine.FINDFIRST() THEN
                    REPEAT
                        AmountToCustomer += HISRevenueLine."Payor Payable";
                        PatientPayble += HISRevenueLine."Patient Payable";

                        InvoicePostingBuffer.SetRange("G/L Account", HISRevenueLine."Account No.");
                        InvoicePostingBuffer.SetRange("Global Dimension 1 Code", HISRevenueLine."Shortcut Dimension 1 Code");
                        InvoicePostingBuffer.SetRange("Global Dimension 2 Code", HISRevenueLine."Shortcut Dimension 2 Code");
                        if InvoicePostingBuffer.FindFirst() then begin
                            InvoicePostingBuffer.Amount := InvoicePostingBuffer.Amount + (-(HISRevenueLine.Amount));
                            InvoicePostingBuffer.Modify();
                        end else begin
                            InvoicePostingBuffer.Init();
                            InvoicePostingBuffer."Group ID" := HISRevenueLine."Account No." + ';' + HISRevenueLine."Shortcut Dimension 1 Code" + ';' + HISRevenueLine."Shortcut Dimension 2 Code";
                            InvoicePostingBuffer.Type := InvoicePostingBuffer.Type::"G/L Account";
                            InvoicePostingBuffer."G/L Account" := HISRevenueLine."Account No.";
                            InvoicePostingBuffer."Global Dimension 1 Code" := HISRevenueLine."Shortcut Dimension 1 Code";
                            InvoicePostingBuffer."Global Dimension 2 Code" := HISRevenueLine."Shortcut Dimension 2 Code";
                            InvoicePostingBuffer.Amount := -(HISRevenueLine.Amount);
                            InvoicePostingBuffer.Insert();
                        end;

                        if HISRevenueLine.Discount <> 0 then begin
                            //AmountToCustomer += HISRevenueLine.Discount;
                            InvoicePostingBuffer.SetRange("G/L Account", HISRevenueLine."Discount G/L Account");
                            InvoicePostingBuffer.SetRange("Global Dimension 1 Code", HISRevenueLine."Shortcut Dimension 1 Code");
                            InvoicePostingBuffer.SetRange("Global Dimension 2 Code", HISRevenueLine."Shortcut Dimension 2 Code");
                            if InvoicePostingBuffer.FindFirst() then begin
                                InvoicePostingBuffer.Amount := InvoicePostingBuffer.Amount + (-HISRevenueLine.Discount);
                                InvoicePostingBuffer.Modify();
                            end else begin
                                InvoicePostingBuffer.Init();
                                InvoicePostingBuffer."Group ID" := HISRevenueLine."Account No." + ';' + HISRevenueLine."Shortcut Dimension 1 Code" + ';' + HISRevenueLine."Shortcut Dimension 2 Code" + ';Discount';
                                InvoicePostingBuffer.Type := InvoicePostingBuffer.Type::"G/L Account";
                                InvoicePostingBuffer."G/L Account" := HISRevenueLine."Discount G/L Account";
                                InvoicePostingBuffer."Global Dimension 1 Code" := HISRevenueLine."Shortcut Dimension 1 Code";
                                InvoicePostingBuffer."Global Dimension 2 Code" := HISRevenueLine."Shortcut Dimension 2 Code";
                                InvoicePostingBuffer.Amount := -HISRevenueLine.Discount;
                                InvoicePostingBuffer.Insert();
                            end;
                        end;

                        if HISRevenueLine."MOU Discount" <> 0 then begin
                            //AmountToCustomer += HISRevenueLine.Discount;
                            InvoicePostingBuffer.SetRange("G/L Account", HISRevenueLine."MOU Discount G/L Account");
                            InvoicePostingBuffer.SetRange("Global Dimension 1 Code", HISRevenueLine."Shortcut Dimension 1 Code");
                            InvoicePostingBuffer.SetRange("Global Dimension 2 Code", HISRevenueLine."Shortcut Dimension 2 Code");
                            if InvoicePostingBuffer.FindFirst() then begin
                                InvoicePostingBuffer.Amount := InvoicePostingBuffer.Amount + (-HISRevenueLine."MOU Discount");
                                InvoicePostingBuffer.Modify();
                            end else begin
                                InvoicePostingBuffer.Init();
                                InvoicePostingBuffer."Group ID" := HISRevenueLine."Account No." + ';' + HISRevenueLine."Shortcut Dimension 1 Code" + ';' + HISRevenueLine."Shortcut Dimension 2 Code" + ';MOUDiscount';
                                InvoicePostingBuffer.Type := InvoicePostingBuffer.Type::"G/L Account";
                                InvoicePostingBuffer."G/L Account" := HISRevenueLine."MOU Discount G/L Account";
                                InvoicePostingBuffer."Global Dimension 1 Code" := HISRevenueLine."Shortcut Dimension 1 Code";
                                InvoicePostingBuffer."Global Dimension 2 Code" := HISRevenueLine."Shortcut Dimension 2 Code";
                                InvoicePostingBuffer.Amount := -HISRevenueLine."MOU Discount";
                                InvoicePostingBuffer.Insert();
                            end;
                        end;
                    UNTIL HISRevenueLine.NEXT() = 0;

                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                GenJournalLine.SetRange("Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                if GenJournalLine.FindLast() then
                    LineNo := GenJournalLine."Line No."
                else
                    LineNo := 0;

                InvoicePostingBuffer.Reset();
                InvoicePostingBuffer.SetFilter(Amount, '<>0');
                if InvoicePostingBuffer.FindSet() then
                    repeat
                        LineNo += 10000;
                        GenJournalLine.INIT();
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                        GenJournalLine."Line No." := LineNo;
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
                        ELSE
                            IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                                GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

                        GenJournalLine.VALIDATE("Document No.", HISRevenueHeader."Document No.");
                        GenJournalLine.VALIDATE("Document Date", HISRevenueHeader."Document Date");
                        if HISRevenueHeader."Posting Date" <> 0D then
                            GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Posting Date")
                        else
                            GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Document Date");
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.VALIDATE("Account No.", InvoicePostingBuffer."G/L Account");
                        GenJournalLine."Location Code" := HISRevenueHeader."Location Code";
                        GenJournalLine."Your Reference" := HISRevenueHeader."Reference Invoice No.";
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                            GenJournalLine.VALIDATE(Amount, InvoicePostingBuffer.Amount)
                        else
                            GenJournalLine.VALIDATE(Amount, -InvoicePostingBuffer.Amount);
                        //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                        //GenJournalLine.Validate("Bal. Account No.", HISRevenueHeader."Customer No.");
                        if InvoicePostingBuffer."Global Dimension 1 Code" <> '' then begin
                            GenJournalLine.VALIDATE("Location Code", InvoicePostingBuffer."Global Dimension 1 Code");
                            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", InvoicePostingBuffer."Global Dimension 1 Code");
                        end;

                        if InvoicePostingBuffer."Global Dimension 2 Code" <> '' then
                            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(InvoicePostingBuffer."Global Dimension 2 Code"));

                        GenJournalLine.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");

                        GenJournalLine."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                        GenJournalLine."E3 UHID" := HISRevenueHeader."UHID";
                        GenJournalLine."E3 Patient Name" := HISRevenueHeader."Patient Name";
                        GenJournalLine."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                        GenJournalLine."E3 Doctor Name" := HISRevenueHeader.Doctor;
                        GenJournalLine."E3 Speciality" := HISRevenueHeader."Speciality";
                        GenJournalLine."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                        GenJournalLine."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                        GenJournalLine."E3 Payer Code" := HISRevenueHeader."Payer Code";
                        GenJournalLine."E3 Payer Name" := HISRevenueHeader."Payer Name";
                        if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                            PostGenJnlLine.RunWithCheck(GenJournalLine)
                        else
                            GenJournalLine.INSERT();
                    until InvoicePostingBuffer.Next() = 0;

                if PatientPayble <> 0 then begin
                    LineNo += 10000;
                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    GenJournalLine."Line No." := LineNo;
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
                    ELSE
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

                    GenJournalLine.VALIDATE("Document No.", HISRevenueHeader."Document No.");
                    GenJournalLine.VALIDATE("Document Date", HISRevenueHeader."Document Date");
                    if HISRevenueHeader."Posting Date" <> 0D then
                        GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Posting Date")
                    else
                        GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Document Date");
                    GenJournalLine.VALIDATE("Account Type", IntegrationSetup."Account Type");
                    GenJournalLine.VALIDATE("Account No.", IntegrationSetup."Account No.");
                    GenJournalLine."Location Code" := HISRevenueHeader."Location Code";
                    GenJournalLine."Your Reference" := HISRevenueHeader."Reference Invoice No.";
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE(Amount, PatientPayble)
                    else
                        GenJournalLine.Validate(Amount, -PatientPayble);
                    //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                    //GenJournalLine.Validate("Bal. Account No.", HISRevenueHeader."Customer No.");
                    if HISRevenueHeader."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                    end;

                    if HISRevenueHeader."Shortcut Dimension 2 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueHeader."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");

                    GenJournalLine."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                    GenJournalLine."E3 UHID" := HISRevenueHeader."UHID";
                    GenJournalLine."E3 Patient Name" := HISRevenueHeader."Patient Name";
                    GenJournalLine."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                    GenJournalLine."E3 Doctor Name" := HISRevenueHeader.Doctor;
                    GenJournalLine."E3 Speciality" := HISRevenueHeader."Speciality";
                    GenJournalLine."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                    GenJournalLine."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                    GenJournalLine."E3 Payer Code" := HISRevenueHeader."Payer Code";
                    GenJournalLine."E3 Payer Name" := HISRevenueHeader."Payer Name";
                    if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                        PostGenJnlLine.RunWithCheck(GenJournalLine)
                    else
                        GenJournalLine.INSERT();
                end;

                if AmountToCustomer <> 0 then begin
                    LineNo += 10000;
                    GenJournalLine.INIT();
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Template Name", IntegrationSetupLine."General Journal Template Code");
                    GenJournalLine.VALIDATE(GenJournalLine."Journal Batch Name", IntegrationSetupLine."General Journal Batch Code");
                    GenJournalLine."Line No." := LineNo;
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
                    ELSE
                        IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::"Revenue Cancel") AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::"Credit Memo") THEN
                            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

                    GenJournalLine.VALIDATE("Document No.", HISRevenueHeader."Document No.");
                    GenJournalLine.VALIDATE("Document Date", HISRevenueHeader."Document Date");
                    if HISRevenueHeader."Posting Date" <> 0D then
                        GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Posting Date")
                    else
                        GenJournalLine.VALIDATE("Posting Date", HISRevenueHeader."Document Date");
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
                    GenJournalLine.VALIDATE("Account No.", HISRevenueHeader."Customer No.");
                    GenJournalLine."Location Code" := HISRevenueHeader."Location Code";
                    GenJournalLine."Your Reference" := HISRevenueHeader."Reference Invoice No.";
                    IF (HISRevenueHeader."Record Type" = HISRevenueHeader."Record Type"::Revenue) AND (HISRevenueHeader."Document Type" = HISRevenueHeader."Document Type"::Invoice) THEN
                        GenJournalLine.VALIDATE(Amount, AmountToCustomer)
                    else
                        GenJournalLine.VALIDATE(Amount, -AmountToCustomer);
                    //GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                    //GenJournalLine.Validate("Bal. Account No.", HISRevenueHeader."Customer No.");
                    if HISRevenueHeader."Shortcut Dimension 1 Code" <> '' then begin
                        GenJournalLine.VALIDATE("Location Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", HISRevenueHeader."Shortcut Dimension 1 Code");
                    end;

                    if HISRevenueHeader."Shortcut Dimension 2 Code" <> '' then
                        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GetMappedDimension(HISRevenueHeader."Shortcut Dimension 2 Code"));

                    GenJournalLine.VALIDATE("External Document No.", HISRevenueHeader."External Document No.");

                    GenJournalLine."E3 HIS Document Type" := HISRevenueHeader."HIS Document Type";
                    GenJournalLine."E3 UHID" := HISRevenueHeader."UHID";
                    GenJournalLine."E3 Patient Name" := HISRevenueHeader."Patient Name";
                    GenJournalLine."E3 Encounter No." := HISRevenueHeader."Encounter No.";
                    GenJournalLine."E3 Doctor Name" := HISRevenueHeader.Doctor;
                    GenJournalLine."E3 Speciality" := HISRevenueHeader."Speciality";
                    GenJournalLine."E3 Sponsor Code" := HISRevenueHeader."Sponsor Code";
                    GenJournalLine."E3 Sponsor Name" := HISRevenueHeader."Sponsor Name";
                    GenJournalLine."E3 Payer Code" := HISRevenueHeader."Payer Code";
                    GenJournalLine."E3 Payer Name" := HISRevenueHeader."Payer Name";
                    if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                        PostGenJnlLine.RunWithCheck(GenJournalLine)
                    else
                        GenJournalLine.INSERT();
                end;
            end;
            HISRevenueHeader."Create Revenue" := TRUE;
            if IntegrationSetup."Rev./Rev.Cancel Direct Post" then
                HISRevenueHeader."Posted Document No." := HISRevenueHeader."Document No.";
            HISRevenueHeader.MODIFY();
            Commit();
        END;
    end;

    procedure RevenueInvoiceValidation(var LocHISRevenueHeader: Record "E3 HIS Revenue Header")
    var
        RevenueSetup: Record "E3 HIS GL Accounts Mapping";
        HISItemMapping: Record "E3 HIS Item Mapping";
        HISCustMapping: Record "E3 HIS Customer Mapping";
        Customer: Record Customer;
        txtHSNCode: Text[100];
        HSNSAC: Record "HSN/SAC";
        txtSalesAccount: Text[100];
        GSTGroup: Record "GST Group";
        GSTGroupCode: Code[20];
        LineCount: Integer;
    begin
        LineCount := 0;
        txtHSNCode := '';
        txtSalesAccount := '';
        txtHSNCode := '';
        GSTGroupCode := '';
        IntegrationSetup.Get();

        LocHISRevenueHeader."Error 1" := FALSE;
        LocHISRevenueHeader."Error 2" := FALSE;
        LocHISRevenueHeader."Error 3" := FALSE;
        LocHISRevenueHeader."Error 4" := FALSE;
        LocHISRevenueHeader."Error Description" := '';
        LocHISRevenueHeader.MODIFY();

        HISRevenueLine.RESET();
        HISRevenueLine.SetRange("Record Type", LocHISRevenueHeader."Record Type");
        HISRevenueLine.SetRange("Document Type", LocHISRevenueHeader."Document Type");
        HISRevenueLine.SETRANGE("Document No.", LocHISRevenueHeader."Document No.");
        HISRevenueLine.SetRange("Package Patient", false);  //Check if not required
        IF HISRevenueLine.FINDFIRST() THEN BEGIN
            REPEAT
                LineCount += 1;
                if IntegrationSetup."Revenue/Rev. Cancel Handling" = IntegrationSetup."Revenue/Rev. Cancel Handling"::"Via Invoices" then begin
                    IF HISRevenueLine."HSN Code" <> '' THEN begin
                        if HISRevenueLine."GST Group Code" = '' then
                            GSTGroupCode := 'Must not be Blank';

                        HSNSAC.RESET();
                        HSNSAC.SetRange("GST Group Code", HISRevenueLine."GST Group Code");
                        HSNSAC.SETRANGE(Code, HISRevenueLine."HSN Code");
                        IF NOT HSNSAC.FINDFIRST() THEN
                            txtHSNCode := 'Create New HSN Code'
                    END;

                    IF HISRevenueLine."GST Group Code" <> '' THEN BEGIN
                        if HISRevenueLine."HSN Code" = '' then
                            txtHSNCode := 'HSN Code must have value.';

                        GSTGroup.RESET();
                        GSTGroup.SETRANGE(GSTGroup.Code, HISRevenueLine."GST Group Code");
                        IF NOT GSTGroup.FINDFIRST() THEN
                            GSTGroupCode := 'Create New GST Group';
                    END;
                End;

                IF HISRevenueLine."Account No." = '' THEN begin
                    LocHISRevenueHeader.RESET();
                    LocHISRevenueHeader.SetRange("Record Type", HISRevenueLine."Record Type");
                    LocHISRevenueHeader.SetRange("Document Type", HISRevenueLine."Document Type");
                    LocHISRevenueHeader.SETRANGE("Document No.", HISRevenueLine."Document No.");
                    IF LocHISRevenueHeader.FINDFIRST() THEN begin
                        RevenueSetup.Reset();
                        RevenueSetup.SetRange("Service/Station Head", LocHISRevenueHeader."HIS Document Type");
                        RevenueSetup.SetRange("HIS Code", HISRevenueLine."Service Item Code");
                        RevenueSetup.SetRange(Package, HISRevenueLine."Package Patient");
                        if not RevenueSetup.FindFirst() then
                            txtSalesAccount := 'Revenue Account Missing'
                        else
                            if (RevenueSetup."Account No." <> '') and (RevenueSetup."Discount G/L Account" <> '') and (RevenueSetup."MOU Discount G/L Account" <> '') then begin
                                HISRevenueLine."Account Type" := RevenueSetup."Account Type";
                                HISRevenueLine."Account No." := RevenueSetup."Account No.";
                                HISRevenueLine."Discount G/L Account" := RevenueSetup."Discount G/L Account";
                                HISRevenueLine."MOU Discount G/L Account" := RevenueSetup."MOU Discount G/L Account";
                                if HISRevenueLine."Shortcut Dimension 1 Code" = '' then
                                    HISRevenueLine."Shortcut Dimension 1 Code" := LocHISRevenueHeader."Shortcut Dimension 1 Code";
                                HISRevenueLine.Modify(false);
                            end else
                                txtSalesAccount := 'Revenue or Discounts Account Missing';
                    end;
                end;
            UNTIL HISRevenueLine.NEXT() = 0;

            if LocHISRevenueHeader."No. of Lines" <> LineCount then
                LocHISRevenueHeader."Error Description" := 'Line count mismatch.';

            if LocHISRevenueHeader."Posting Date" = 0D then
                LocHISRevenueHeader."Posting Date" := LocHISRevenueHeader."Document Date";

            if LocHISRevenueHeader."Location Code" = '' then
                LocHISRevenueHeader."Location Code" := LocHISRevenueHeader."Shortcut Dimension 1 Code";

            if LocHISRevenueHeader."Customer No." = '' then begin
                HISCustMapping.Reset();
                HISCustMapping.SetRange("HIS Code", LocHISRevenueHeader."Payer Code");
                if HISCustMapping.FindFirst() then begin
                    Customer.Reset();
                    Customer.SetRange("No.", HISCustMapping."Customer No.");
                    if Customer.FindFirst() then begin
                        LocHISRevenueHeader."Customer No." := Customer."No.";
                        LocHISRevenueHeader."Customer Name" := Customer.Name;
                        LocHISRevenueHeader.Modify();
                    end else
                        LocHISRevenueHeader."Error Description" := 'Customer does not exists.';
                end else
                    LocHISRevenueHeader."Error Description" := 'Customer Mapping Missing';
            end;

            IF (LocHISRevenueHeader."Customer Name" = '') OR (txtHSNCode <> '') OR (txtSalesAccount <> '') OR (GSTGroupCode <> '') THEN
                LocHISRevenueHeader."Error Description" := 'Kindly Check Customer,HSN Code,GST Group Code';
            // ELSE
            //     HISRevenueHeader."Error Description" := '';

            LocHISRevenueHeader.MODIFY();
        end;

        HISRevenueLine.RESET();
        HISRevenueLine.SetRange("Record Type", LocHISRevenueHeader."Record Type");
        HISRevenueLine.SetRange("Document Type", LocHISRevenueHeader."Document Type");
        HISRevenueLine.SETRANGE("Document No.", LocHISRevenueHeader."Document No.");
        IF NOT HISRevenueLine.FINDFIRST() THEN begin
            LocHISRevenueHeader."Error Description" := 'Integration Line is Empty';
            LocHISRevenueHeader.MODIFY();
        end;

        IF (LocHISRevenueHeader."Customer Name" = '') THEN
            LocHISRevenueHeader."Error 1" := TRUE
        ELSE
            LocHISRevenueHeader."Error 1" := FALSE;
        IF (txtSalesAccount <> '') THEN
            LocHISRevenueHeader."Error 2" := TRUE
        ELSE
            LocHISRevenueHeader."Error 2" := FALSE;
        IF (txtHSNCode <> '') THEN
            LocHISRevenueHeader."Error 3" := TRUE
        ELSE
            LocHISRevenueHeader."Error 3" := FALSE;
        IF (GSTGroupCode <> '') THEN
            LocHISRevenueHeader."Error 4" := TRUE
        ELSE
            LocHISRevenueHeader."Error 4" := FALSE;
        LocHISRevenueHeader.MODIFY();
        Commit();
    end;

    var
        IntegrationSetup: Record "E3 HIS Integartion Setup";
        IntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        recState: Record State;
        HisMasterStaging: Record "E3 HIS Master Staging";
        HISRevenueStaging: Record "E3 HIS Revenue Staging Table";
        DefaultDimension: Record "Default Dimension";
        HISRevenueHeader: Record "E3 HIS Revenue Header";
        HISRevenueLine: Record "E3 HIS Revenue Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        PurchaseCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";
        DimensionSetEntry: Record "Dimension Set Entry";
        Vendor: Record Vendor;
        CalculateStatistics: Codeunit "Calculate Statistics";
        myInt: Integer;
        GSTState: Code[2];
        SamePANErr: Label 'From postion 3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.';
        HISSettlementStaging: Record "E3 HIS Settlement Staging";
        HISDoctorPayoutEntries: Record "E3 HIS Doctor Payout";


}