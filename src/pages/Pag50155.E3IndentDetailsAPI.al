page 50155 "E3 Indent Header API"
{
    PageType = API;
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    Caption = 'Indent Details API';
    EntityName = 'indentDetail';
    EntitySetName = 'indentDetails';
    SourceTable = "E3 Indent Header";
    DelayedInsert = true;
    ApplicationArea = All;
    ODataKeyFields = "Document No.";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(requestedBy; Rec."Requested By")
                {
                    Caption = 'Requested By';
                }
                field(requestDate; Rec."Request Date")
                {
                    Caption = 'Request Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(locationName; Rec."Location Name")
                {
                    Caption = 'Location Name';
                }
                field(departmentName; Rec."Department Name")
                {
                    Caption = 'Department Name';
                }
                field(expectedReciveDate; Rec."Expected Receive Date")
                {
                    Caption = 'Expected Receive Date';
                }
                field(approvedBy; Rec."Approved By")
                {
                    Caption = 'Approved By';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(businessUnitName; Rec."Business Unit Name")
                {
                    Caption = 'Business Unit Name';
                }
                field(indentor; Rec.Indenter)
                {
                    Caption = 'Indenter';
                }
                field(remarks; Rec.Remarks)
                {
                    Caption = 'Remarks';
                }
                field(toDepartmentCode; Rec."To Department Code")
                {
                    Caption = 'To Department Code';
                }
                field(toDepartmentName; Rec."To Department Name")
                {
                    Caption = 'To Department Name';
                }
                field(approvalDateTime; Rec."Approval Date Time")
                {
                    Caption = 'Approval Date Time';
                }
            }
            part(IndentLine; "E3 Indent Line API")
            {
                Caption = 'Lines';
                EntityName = 'indentLine';
                EntitySetName = 'indentLines';
                SubPageLink = "Document No." = field("Document No.");
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
        IndentHdr: Record "E3 Indent Header";
    begin
        IndentHdr.SetRange("Document No.", Rec."Document No.");
        if not IndentHdr.IsEmpty then
            error('Duplicate Entry');
    end;
}