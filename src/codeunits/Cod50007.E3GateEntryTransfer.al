codeunit 50007 "E3 Gate Entry Transfer"
{
    procedure CreateInwardEntry(var OutwardHeader: Record "E3 Gate Entry Header")
    var
        OutwardLine: Record "E3 Gate Entry Line";
        InwardHeader: Record "E3 Gate Entry Header";
        InwardLine: Record "E3 Gate Entry Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        OutwardLine.Reset();
        OutwardLine.SetRange("Document No.", OutwardHeader."Document No.");
        OutwardLine.SetFilter("Ship Qty", '>%1', 0);

        if not OutwardLine.FindFirst() then
            Error('No shipped quantity available.');

        InwardHeader.Init();
        InwardHeader."Entry Type" := InwardHeader."Entry Type"::Inward;
        InwardHeader."Gate Pass Type" := OutwardHeader."Gate Pass Type";
        InwardHeader."Document No." := OutwardHeader."Document No.";
        InwardHeader."Purpose Code" := OutwardHeader."Purpose Code";
        InwardHeader."Vehicle No." := OutwardHeader."Vehicle No.";
        InwardHeader."Department Code" := OutwardHeader."Department Code";
        InwardHeader."To Destination" := OutwardHeader."To Destination";
        InwardHeader."Posting Date/Time" := CurrentDateTime;
        InwardHeader."Vendor No." := OutwardHeader."Vendor No.";
        InwardHeader."Vendor Name" := OutwardHeader."Vendor Name";
        InwardHeader."Employee Code" := OutwardHeader."Employee Code";
        InwardHeader.Status := OutwardHeader.Status;
        InwardHeader."Expected Return Date" := OutwardHeader."Expected Return Date";
        InwardHeader."Reference Document No." := OutwardHeader."Document No.";
        InwardHeader.Remarks := OutwardHeader.Remarks;

        //If using No. Series
        InwardHeader."Document No." :=
            NoSeriesMgt.GetNextNo('INWARD', Today, true);

        InwardHeader.Insert(true);

        // Create Inward Lines
        OutwardLine.Reset();
        OutwardLine.SetRange("Document No.", OutwardHeader."Document No.");
        OutwardLine.SetFilter("Ship Qty", '>%1', 0);

        if OutwardLine.FindSet() then
            repeat
                InwardLine.Init();

                InwardLine."Document No." := InwardHeader."Document No.";
                InwardLine."Line No." := OutwardLine."Line No.";
                InwardLine."Item No." := OutwardLine."Item No.";
                InwardLine."Item Name" := OutwardLine."Item Name";
                InwardLine.Quantity := OutwardLine.Quantity;
                InwardLine.Quantity := OutwardLine."Ship Qty";
                InwardLine."Variant Code" := OutwardLine."Variant Code";
                InwardLine."Unit of Measurement" := OutwardLine."Unit of Measurement";
                InwardLine."Estimated Value" := OutwardLine."Estimated Value";
                InwardLine."Asset No." := OutwardLine."Asset No.";
                InwardLine."Serial No." := OutwardLine."Serial No.";
                InwardLine."Lot No." := OutwardLine."Lot No.";
                InwardLine.Remarks := OutwardLine.Remarks;

                InwardLine.Insert();

            until OutwardLine.Next() = 0;

        Message(
            'Inward Entry %1 created successfully.',
            InwardHeader."Document No.");
    end;
}