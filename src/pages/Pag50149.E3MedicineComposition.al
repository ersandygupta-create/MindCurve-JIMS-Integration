page 50149 "E3 Medicine Composition"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Medicine Composition";
    Editable = true;
    Caption = 'Medicine Composition';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'Specifies the value of the Item Name field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Medicine Component Code"; Rec."Medicine Component Code")
                {
                    ToolTip = 'Specifies the value of the Medicine Component Code field';
                    ApplicationArea = All;
                }
                field("Medicine Component Name"; Rec."Medicine Component Name")
                {
                    ToolTip = 'Specifies the value of the Medicine Component Name field';
                    ApplicationArea = All;
                }
                field(Power; Rec.Power)
                {
                    ToolTip = 'Specifies the value of the Power field';
                    ApplicationArea = All;
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure field';
                    ApplicationArea = All;
                }
                field(IsBase; Rec.IsBase)
                {
                    ToolTip = 'Specifies the value of the Is Base field';
                    ApplicationArea = All;
                }
                field(IsSent; Rec.IsSent)
                {
                    ToolTip = 'Specifies the value of the Is Sent field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Response; Rec.Response)
                {
                    ToolTip = 'Specifies the value of the Response field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Sent"; Rec."Last Sent")
                {
                    ToolTip = 'Specifies the value of the Last Sent field';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SENDTOSTAGING)
            {
                ApplicationArea = all;
                Caption = 'Send Data to Staging';
                ToolTip = 'Sends the data to staging tables for processing';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = SendTo;
                trigger OnAction()
                var
                    ItemComp: Record "E3 Medicine Composition";
                    ItemCompMgmt: Codeunit "E3 Medicine Composition Mgmt.";
                begin
                    ItemComp.Get(Rec."Line No.", Rec.Code);
                    if ItemCompMgmt.SendMedicineCompositionMastDetails(ItemComp) then
                        Message('Data sent successfully.')
                    else
                        Message('Failed to send data.');
                end;
            }
        }
    }
}
