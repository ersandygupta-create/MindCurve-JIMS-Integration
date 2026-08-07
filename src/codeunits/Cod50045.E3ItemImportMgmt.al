codeunit 50045 "E3 Item Import Mgmt"
{
    procedure ImportItems()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        SheetName: Text;
        InS: InStream;
        RowNo: Integer;
    begin
        if not UploadIntoStream(
            'Select Excel File',
            '',
            'Excel Files (*.xlsx)|*.xlsx',
            FileName,
            InS)
        then
            exit;

        SheetName := ExcelBuffer.SelectSheetsNameStream(InS);

        ExcelBuffer.OpenBookStream(InS, SheetName);
        ExcelBuffer.ReadSheet();

        RowNo := 2;

        while GetCellValue(ExcelBuffer, RowNo, 1) <> '' do begin
            ImportItem(ExcelBuffer, RowNo);
            RowNo += 1;
        end;

        Message('Items imported successfully.');
    end;

    local procedure ImportItem(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer)
    var
        Item: Record Item;
        IsNew: Boolean;
        ItemNo: Code[20];
        ItemType: Enum "Item Type";
    begin
        ItemNo := CopyStr(GetCellValue(ExcelBuffer, RowNo, 1), 1, MaxStrLen(Item."No."));

        IsNew := not Item.Get(ItemNo);

        if IsNew then begin
            Item.Init();
            Item.Validate("No.", ItemNo);
            Item.Insert(true); // Insert only once
        end;

        Item.Validate(Description, GetCellValue(ExcelBuffer, RowNo, 2));

        // 3
        Item.Validate(Name, GetCellValue(ExcelBuffer, RowNo, 3));

        // 4
        Item.Validate(Type, GetItemType(GetCellValue(ExcelBuffer, RowNo, 4)));

        // 5
        Item.Validate("No. 2", GetCellValue(ExcelBuffer, RowNo, 5));

        // 6
        Item.Validate("Item Group Name", GetCellValue(ExcelBuffer, RowNo, 6));

        // 7
        Item.Validate("GST Group Code", GetCellValue(ExcelBuffer, RowNo, 7));

        // 8
        Item.Validate("HSN/SAC Code", GetCellValue(ExcelBuffer, RowNo, 8));

        // 9
        SetItemType(Item, GetCellValue(ExcelBuffer, RowNo, 9), RowNo);

        // 10
        Item.Validate(SkuName, GetCellValue(ExcelBuffer, RowNo, 10));

        // 11
        Item.Validate("Purch. Unit of Measure",
            ValidateUOM(GetCellValue(ExcelBuffer, RowNo, 11), RowNo));

        // 12
        Item.Validate("Sales Unit of Measure",
            ValidateUOM(GetCellValue(ExcelBuffer, RowNo, 12), RowNo));

        // 13
        // Item.Validate("Purchase Unit Conversion Rate",
        //     EvaluateDecimal(GetCellValue(ExcelBuffer, RowNo, 13)));

        // // 14
        // Item.Validate("Sales Unit Conversion Rate",
        //     EvaluateDecimal(GetCellValue(ExcelBuffer, RowNo, 14)));

        // 15
        Item.Validate("Model Name", GetCellValue(ExcelBuffer, RowNo, 15));

        // 16
        Item.Validate("Strength Name", GetCellValue(ExcelBuffer, RowNo, 16));

        // 17
        Item.Validate("Property List Name", GetCellValue(ExcelBuffer, RowNo, 17));

        // 18
        SetCategory(Item, GetCellValue(ExcelBuffer, RowNo, 18), RowNo);

        // 19
        Item.Validate("Medicine SubCategory Name", GetCellValue(ExcelBuffer, RowNo, 19));

        // 20
        Item.Validate("Material Category Name", GetCellValue(ExcelBuffer, RowNo, 20));

        // 21
        Item.Validate("Material Type Name", GetCellValue(ExcelBuffer, RowNo, 21));

        // 22
        Item.Validate("Marketing Company Name", GetCellValue(ExcelBuffer, RowNo, 22));

        // 23
        Item.Validate("Medicine Manufacturer Name", GetCellValue(ExcelBuffer, RowNo, 23));

        // 24
        Item.Validate("Res. Group Name", GetCellValue(ExcelBuffer, RowNo, 24));

        // 25
        Item.Validate("Medicine Company Name", GetCellValue(ExcelBuffer, RowNo, 25));

        // 26
        Item.Validate("Manual Code", GetCellValue(ExcelBuffer, RowNo, 26));

        // 27
        Item.Validate("Division Name", GetCellValue(ExcelBuffer, RowNo, 27));

        // 28
        Item.Validate("Speciality Name", GetCellValue(ExcelBuffer, RowNo, 28));

        // 29
        Item.Validate(IsActive, EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 29)));

        // 30
        Item.Validate("Barcode Active", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 30)));

        // 31
        Item.Validate("Consignment Item", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 31)));

        // 32
        Item.Validate("Narcotics Control Substances", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 32)));

        // 33
        Item.Validate("Sale Returnable Item", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 33)));

        // 34
        Item.Validate("Sale Rate Editable", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 34)));

        // 35
        Item.Validate("Incl Free Qty in Sale Rate", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 35)));

        // 36
        Item.Validate("Sale Discount Allow", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 36)));

        // 37
        Item.Validate("Quatation Required", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 37)));

        // 38
        Item.Validate("Allow MRP Discount", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 38)));

        // 39
        Item.Validate("Margin Fix", GetMarginFix((GetCellValue(ExcelBuffer, RowNo, 39))));

        // 40
        Item.Validate(Remarks, GetCellValue(ExcelBuffer, RowNo, 40));

        // 41
        Item.Validate("Allow Negative Stock", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 41)));

        // 42
        Item.Validate("Is Indent Mandatory", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 42)));

        // 43
        Item.Validate("Is Common", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 43)));

        // 44
        Item.Validate("Scheme on Qty", EvaluateDecimal(GetCellValue(ExcelBuffer, RowNo, 44)));

        // 45
        Item.Validate("Scheme Free Qty", EvaluateDecimal(GetCellValue(ExcelBuffer, RowNo, 45)));

        // 46
        Item.Validate("Is Life Saving", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 46)));

        // 47
        Item.Validate("Is High Value", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 47)));

        // 48
        Item.Validate("Is Flow Through", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 48)));

        // 49
        Item.Validate("Is Billed Item", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 49)));

        // 50
        Item.Validate(Packing, GetCellValue(ExcelBuffer, RowNo, 50));

        // 51
        Item.Validate("Psychotropic Substance", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 51)));

        // 52
        Item.Validate("Schedule H1", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 52)));

        // 53
        Item.Validate("Formulary Drug", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 53)));

        // 54
        Item.Validate("Anti TB", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 54)));

        // 55
        Item.Validate(Antibiotic, EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 55)));

        // 56
        Item.Validate(Capex, EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 56)));

        // 57
        Item.Validate("PO Mandatory", EvaluateBoolean(GetCellValue(ExcelBuffer, RowNo, 57)));

        // 58
        Item.Validate("E3 Margin Code", GetCellValue(ExcelBuffer, RowNo, 58));

        // 59
        Item.Validate("Tolerance Shortage", EvaluateDecimal(GetCellValue(ExcelBuffer, RowNo, 59)));

        // 60
        Item.Validate("Tolerance excess", EvaluateDecimal(GetCellValue(ExcelBuffer, RowNo, 60)));

        // 61
        Item.Validate("Item Category Code", GetCellValue(ExcelBuffer, RowNo, 61));
        Item.Modify(true); // Save changes for both new and existing items
    end;

    local procedure EvaluateBoolean(Value: Text): Boolean
    var
        Txt: Text;
    begin
        Txt := UpperCase(DelChr(Value, '=', ' '));

        case Txt of
            'TRUE', 'YES', 'Y', '1':
                exit(true);
            'FALSE', 'NO', 'N', '0', '':
                exit(false);
            else
                Error('Invalid Boolean Value : %1', Value);
        end;
    end;

    local procedure GetItemType(ItemTypeTxt: Text): Enum "Item Type"
    begin
        ItemTypeTxt := DelChr(ItemTypeTxt, '<>', ' ');

        case UpperCase(ItemTypeTxt) of
            'INVENTORY':
                exit("Item Type"::Inventory);
            'SERVICE':
                exit("Item Type"::Service);
            'NON-INVENTORY':
                exit("Item Type"::"Non-Inventory");
            else
                Error(
                  'Invalid Item Type ''%1''. Valid values are Inventory, Service, Non-Inventory.',
                  ItemTypeTxt);
        end;
    end;

    local procedure GetMarginFix(MarginTypeTxt: Text): Enum "E3 Margin Fix"
    begin
        case UpperCase(MarginTypeTxt) of
            '':
                exit("E3 Margin Fix"::" ");
            ' ':
                exit("E3 Margin Fix"::"Margin Fix");
            'AMOUNT':
                exit("E3 Margin Fix"::"Rate Fix");
            else
                Error(
                    'Invalid Margin Type ''%1''. Valid values are Percentage or Amount.',
                    MarginTypeTxt);
        end;
    end;

    local procedure EvaluateDecimal(Value: Text): Decimal
    var
        DecValue: Decimal;
    begin
        if Value = '' then
            exit(0);

        if not Evaluate(DecValue, Value) then
            Error('Invalid Decimal Value : %1', Value);

        exit(DecValue);
    end;

    local procedure ValidateUOM(UOMCode: Text; RowNo: Integer): Code[10]
    var
        UOM: Record "Unit of Measure";
    begin
        UOMCode := CopyStr(DelChr(UOMCode, '=', ' '), 1, MaxStrLen(UOM.Code));

        if UOMCode = '' then
            exit('');

        if not UOM.Get(UOMCode) then
            Error(
                'Row %1 : Unit of Measure "%2" does not exist.',
                RowNo,
                UOMCode);

        exit(UOM.Code);
    end;

    local procedure SetItemType(var Item: Record Item; ItemTypeName: Text; RowNo: Integer)
    var
        ItemType: Record "E3 Item Type";
    begin
        if ItemTypeName = '' then
            exit;

        ItemType.Reset();
        ItemType.SetRange(Name, ItemTypeName);

        if not ItemType.FindFirst() then
            Error(
                'Row %1 : Item Type "%2" does not exist.',
                RowNo,
                ItemTypeName);

        Item.Validate("Item Type", ItemType.Code);
        Item.Validate("Item Type Name", ItemType.Name);
    end;

    local procedure SetCategory(var Item: Record Item; CategoryName: Text; RowNo: Integer)
    var
        Category: Record "E3 Item Category Master";
    begin
        if CategoryName = '' then
            exit;

        Category.Reset();
        Category.SetRange(Name, CategoryName);

        if not Category.FindFirst() then
            Error(
              'Row %1 : Category "%2" does not exist.',
              RowNo,
              CategoryName);

        Item.Validate("Category Code", Category.Code);
        Item.Validate("Category Name", Category.Name);
    end;

    local procedure GetCellValue(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text");

        exit('');
    end;

    local procedure GetColumnNo(var ExcelBuffer: Record "Excel Buffer" temporary; HeaderName: Text): Integer
    begin
        ExcelBuffer.Reset();
        ExcelBuffer.SetRange("Row No.", 1);

        if ExcelBuffer.FindSet() then
            repeat
                if UpperCase(DelChr(ExcelBuffer."Cell Value as Text", '=', ' ')) =
                   UpperCase(DelChr(HeaderName, '=', ' ')) then
                    exit(ExcelBuffer."Column No.");
            until ExcelBuffer.Next() = 0;

        Error('Column "%1" not found in Excel.', HeaderName);
    end;

    local procedure GetCellValueByHeader(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; HeaderName: Text): Text
    begin
        exit(GetCellValue(ExcelBuffer, RowNo, GetColumnNo(ExcelBuffer, HeaderName)));
    end;

}