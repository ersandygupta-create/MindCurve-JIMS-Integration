pageextension 50062 "E3 HIS Fixed Assets Card" extends "Fixed Asset Card"
{
    layout

    {
        addafter("Serial No.")
        {
            field("Model No."; Rec."Model No.")
            {
                ApplicationArea = All;
                Caption = 'Model No.';
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the Model No. field.';
            }
        }
        addlast(Content)
        {
            group("FA Attributes")
            {
                Caption = 'JIMS Attributes';
                field("Building Code"; Rec."Building Code")
                {
                    ApplicationArea = All;
                    Caption = 'Building Code';
                    Editable = false;
                    ToolTip = 'Specifies the building code.';
                }
                field("Room/Ward No."; Rec."Room/Ward No.")
                {
                    ApplicationArea = All;
                    Caption = 'Room/Ward No.';
                    Editable = false;
                    ToolTip = 'Specifies the room or ward number.';
                }
                field("Custodian ID"; Rec."Custodian ID")
                {
                    ApplicationArea = All;
                    Caption = 'Custodian ID';
                    Editable = false;
                    ToolTip = 'Specifies the custodian ID.';
                }
                field("Custodian Name"; Rec."Custodian Name")
                {
                    ApplicationArea = All;
                    Caption = 'Custodian Name';
                    Editable = false;
                    ToolTip = 'Specifies the custodian name.';
                }
                field("Name (Head of Department)"; Rec."Name (Head of Department)")
                {
                    ApplicationArea = All;
                    Caption = 'Name (Head of Department)';
                    Editable = false;
                    ToolTip = 'Specifies the name of the head of department.';
                }
            }
            part("Fixed Asset Transfer List"; "E3 Fixed Asset Transfer List")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Transfer';
                SubPageLink = "Fixed Assets No" = field("No.");
                ToolTip = 'Displays transfer records for this fixed asset.';

            }
        }
        addlast(factboxes)
        {
            part(QRFactBox; "FA QR Code")
            {
                ApplicationArea = All;
                Caption = 'QR Code';
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }
    // actions
    // {
    //     addafter(Action39)
    //     {
    //         action("Generate QR Code")
    //         {
    //             Image = QRCode;
    //             ApplicationArea = All;
    //             Caption = 'Generate QR Code';
    //             Promoted = true;
    //             PromotedCategory = Process;

    //             trigger OnAction()
    //             var
    //                 SwissQRHelper: Codeunit "Swiss QR Code Helper";
    //                 TempBlob: Codeunit "Temp Blob";
    //                 InS: InStream;
    //                 FileName: Text;
    //                 FARec: Record "Fixed Asset";
    //             begin
    //                 FARec := Rec;

    //                 SwissQRHelper.GenerateQRCodeImage(FARec."No.", TempBlob);

    //                 if TempBlob.HasValue() then begin
    //                     FileName := FARec."No." + '_QRCode.png';
    //                     TempBlob.CreateInStream(InS);
    //                     Clear(FARec."QR Code");
    //                     FARec."QR Code".ImportStream(InS, FileName, 'image/png');

    //                     FARec.Modify(true);
    //                     Message('QR Code generated for FA %1', FARec."No.");
    //                 end else
    //                     Error('Failed to generate QR Code.');
    //             end;
    //         }
    //     }
    // }
    trigger OnAfterGetRecord()
    var
        SwissQRHelper: Codeunit "Swiss QR Code Helper";
        TempBlob: Codeunit "Temp Blob";
        SourceText: Text;
        InS: InStream;
        FileName: Text;
    begin
        if (Rec."No." <> '') then begin
            SwissQRHelper.GenerateQRCodeImage(Rec."No.", TempBlob);
            if TempBlob.HasValue() then begin
                FileName := Rec."No." + '_QRCode.png';
                TempBlob.CreateInStream(InS);
                Clear(Rec."QR Code");
                Rec."QR Code".ImportStream(InS, FileName, 'image/png');

                Rec.Modify(false);
            end;
        end;
    end;
}