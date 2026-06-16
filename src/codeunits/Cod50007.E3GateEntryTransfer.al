codeunit 50007 "E3 Gate Entry Transfer"
{
    procedure PostOutwardGateEntry(var GateEntryHeader: Record "E3 Gate Entry Header")
    var
        GateEntryLine: Record "E3 Gate Entry Line";
        PostedHeader: Record "E3 Posted Gate Entry Header";
        PostedLine: Record "E3 Posted Gate Entry Line";
        NoSeriesMgt: Codeunit "No. Series";
        ShipmentNo: Code[20];
        LastEntryno: Integer;
        PostedGateEntryBuffer: Record "E3 Posted Gate Entry Line";

    begin
        // Validate Lines
        GateEntryLine.Reset();
        GateEntryLine.SetRange("Document No.", GateEntryHeader."Document No.");

        if not GateEntryLine.FindFirst() then
            Error('No lines exist for posting.');

        ShipmentNo := NoSeriesMgt.GetNextNo('SHIPMENT', Today, true);

        PostedHeader.Init();
        PostedHeader.TransferFields(GateEntryHeader);

        PostedHeader."Reference Document No." := ShipmentNo;
        PostedHeader."Posting Date/Time" := CurrentDateTime;

        PostedHeader.Insert(true);

        GateEntryLine.Reset();
        GateEntryLine.SetRange("Document No.", GateEntryHeader."Document No.");

        if GateEntryLine.FindSet() then
            repeat

                PostedGateEntryBuffer.Reset();
                if PostedGateEntryBuffer.FindLast() then
                    LastEntryno := PostedGateEntryBuffer."Entry No." + 1
                else
                    LastEntryno := 1;
                PostedLine.Init();
                PostedLine.TransferFields(GateEntryLine);

                PostedLine."Document No." := PostedHeader."Document No.";
                PostedLine."Posted Entry No." := LastEntryno;
                PostedLine.Insert(true);

            until GateEntryLine.Next() = 0;

        //-----------------------------------------
        // Create Inward Entry
        //-----------------------------------------
        CreateInwardEntry(GateEntryHeader, ShipmentNo);

        //-----------------------------------------
        // Update Original Document Status
        //-----------------------------------------
        GateEntryHeader.Status := GateEntryHeader.Status::Posted;
        GateEntryHeader.Modify(true);
        GateEntryLine.Reset();
        GateEntryLine.SetRange("Document No.", GateEntryHeader."Document No.");
        if GateEntryLine.FindSet() then
            GateEntryLine.DeleteAll();
        GateEntryHeader.DeleteAll();
        Message('Shipment %1 posted successfully and inward entry created.', ShipmentNo);
    end;

    local procedure CreateInwardEntry(var OutwardHeader: Record "E3 Gate Entry Header"; ShipmentNo: Code[20])
    var
        OutwardLine: Record "E3 Gate Entry Line";
        InwardHeader: Record "E3 Gate Entry Header";
        InwardLine: Record "E3 Gate Entry Line";
        NoSeriesMgt: Codeunit "No. Series";
        GateEntrLine: Record "E3 Gate Entry Line";
        LastEntryNo: Integer;
    begin
        //-----------------------------------------
        // Validate Quantity
        //-----------------------------------------
        OutwardLine.Reset();
        OutwardLine.SetRange("Document No.", OutwardHeader."Document No.");
        OutwardLine.SetFilter(Quantity, '>%1', 0);

        if not OutwardLine.FindFirst() then
            Error('No quantity available.');

        //-----------------------------------------
        // Create Inward Header
        //-----------------------------------------
        InwardHeader.Init();

        InwardHeader."Entry Type" := InwardHeader."Entry Type"::Inward;
        InwardHeader."Document No." := NoSeriesMgt.GetNextNo('INWARD', Today, true);
        InwardHeader."Gate Pass Type" := OutwardHeader."Gate Pass Type";
        InwardHeader."Purpose Code" := OutwardHeader."Purpose Code";
        InwardHeader."Vehicle No." := OutwardHeader."Vehicle No.";
        InwardHeader."Department Code" := OutwardHeader."Department Code";
        InwardHeader."To Destination" := OutwardHeader."To Destination";
        InwardHeader."Posting Date/Time" := CurrentDateTime;
        InwardHeader."Vendor No." := OutwardHeader."Vendor No.";
        InwardHeader."Vendor Name" := OutwardHeader."Vendor Name";
        InwardHeader."Employee Code" := OutwardHeader."Employee Code";
        InwardHeader.Status := InwardHeader.Status::Open;
        InwardHeader."Expected Return Date" := OutwardHeader."Expected Return Date";
        InwardHeader."Reference Document No." := OutwardHeader."Document No.";
        InwardHeader.Remarks := OutwardHeader.Remarks;

        InwardHeader.Insert(true);

        OutwardLine.Reset();
        OutwardLine.SetRange("Document No.", OutwardHeader."Document No.");
        OutwardLine.SetFilter(Quantity, '>%1', 0);

        if OutwardLine.FindSet() then
            repeat

                GateEntrLine.Reset();
                If GateEntrLine.FindLast() Then
                    LastEntryNo := GateEntrLine."Entry No." + 1
                else
                    LastEntryNo := 1;
                InwardLine.Init();
                InwardLine."Entry No." := LastEntryNo;
                InwardLine."Document No." := InwardHeader."Document No.";
                InwardLine."Line No." := OutwardLine."Line No.";
                InwardLine."Item No." := OutwardLine."Item No.";
                InwardLine."Item Name" := OutwardLine."Item Name";
                InwardLine.Quantity := OutwardLine.Quantity;
                InwardLine."Cost/Qty" := OutwardLine."Cost/Qty";
                InwardLine."Estimated Value" := OutwardLine."Estimated Value";
                InwardLine."Variant Code" := OutwardLine."Variant Code";
                InwardLine."Unit of Measurement" := OutwardLine."Unit of Measurement";
                InwardLine."Estimated Value Receive" := OutwardLine."Qty to Receive" * OutwardLine."Cost/Qty";
                InwardLine."Asset No." := OutwardLine."Asset No.";
                InwardLine."Serial No." := OutwardLine."Serial No.";
                InwardLine."Lot No." := OutwardLine."Lot No.";
                InwardLine.Remarks := OutwardLine.Remarks;

                InwardLine.Insert();

            until OutwardLine.Next() = 0;
    end;
}