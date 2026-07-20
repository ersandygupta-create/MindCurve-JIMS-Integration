page 50142 "E3 Item Category Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "E3 Item Category Master";
    Editable = true;
    Caption = 'Item Category Master';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field';
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Filter Item Type"; Rec."Filter Item Type")
                {
                    ToolTip = 'Specifies the value of the Filter Item Type field';
                    ApplicationArea = All;
                }
                field(SaleRateProfitMargin; Rec.SaleRateProfitMargin)
                {
                    ToolTip = 'Specifies the value of the Sale Rate Profit Margin field';
                    ApplicationArea = All;
                }
                field(IsSent; Rec.IsSent)
                {
                    ToolTip = 'Specifies the value of the Is Sent field';
                    ApplicationArea = All;
                    Editable = true;
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
                Caption = 'Send Data to DB';
                ToolTip = 'Sends the data to staging tables for processing';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = SendTo;
                trigger OnAction()
                var
                    ItemCategory: Record "E3 Item Category Master";
                    ItemCategoryMgmt: Codeunit "E3 Item Category Mgmt.";
                begin
                    ItemCategory.Get(Rec.Code);
                    if ItemCategory.IsSent then
                        Error('This record has already been sent.');

                    if ItemCategoryMgmt.SendItemCategoryDetails(ItemCategory) then begin
                        ItemCategory.Get(Rec.Code);
                        ItemCategory."First Sent" := true;
                        ItemCategory.Modify();
                        Message('Data sent successfully.')
                    end else
                        Message('Failed to send data.');
                end;

            }
        }
    }
}
