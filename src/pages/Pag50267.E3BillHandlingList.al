
page 50267 "E3 Bill Handling List"
{
    PageType = List;
    SourceTable = "E3 Bill Handling";
    Caption = 'Bill Handling List';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Voucher Type Code"; Rec."Voucher Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type code.';
                }
                field("Voucher Type Name"; Rec."Voucher Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the voucher type name.';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor code.';

                    trigger OnValidate()
                    begin
                        if VendorRec.Get(Rec."Vendor Code") then
                            Rec."Vendor Name" := VendorRec.Name
                        else
                            Rec."Vendor Name" := '';
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the vendor name.';
                }
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the challan number.';
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the challan date.';
                }
                field("GRN No."; Rec."GRN No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the goods receipt note number.';
                }
                field("GRN Date"; Rec."GRN Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the goods receipt note date.';
                }
                field("Bill Handling No."; Rec."Bill Handling No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill handling number.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill due date.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remarks for bill handling.';
                }
                field("Event Name"; Rec."Event Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event name.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    ToolTip = 'Specifies the user who created this record.';
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Created At';
                    ToolTip = 'Specifies the date and time when this record was created.';
                    Editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Modified By';
                    ToolTip = 'Specifies the user who last modified this record.';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Modified At';
                    ToolTip = 'Specifies the date and time when this record was last modified.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenVendor)
            {
                Caption = 'Open Vendor';
                ApplicationArea = All;
                Image = Vendor;
                ToolTip = 'Opens the selected vendor card.';

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    if Rec."Vendor Code" = '' then
                        Error('Please select a Vendor Code first.');

                    Vendor.Get(Rec."Vendor Code");
                    Page.Run(Page::"Vendor Card", Vendor);
                end;
            }
        }
    }

    var
        VendorRec: Record Vendor;
}
