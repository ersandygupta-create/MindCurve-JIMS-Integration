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
    begin
        ItemNo := CopyStr(GetCellValue(ExcelBuffer, RowNo, 1), 1, MaxStrLen(Item."No."));

        IsNew := not Item.Get(ItemNo);

        if IsNew then begin
            Item.Init();
            Item.Validate("No.", ItemNo);
            Item.Insert(true); // Insert only once
        end;

        Item.Validate("No. 2", GetCellValue(ExcelBuffer, RowNo, 2));
        Item.Validate(Description, GetCellValue(ExcelBuffer, RowNo, 3));

        Item.Validate("Base Unit of Measure", ValidateUOM(GetCellValue(ExcelBuffer, RowNo, 4), RowNo));
        Item.Validate("Sales Unit of Measure", ValidateUOM(GetCellValue(ExcelBuffer, RowNo, 5), RowNo));
        Item.Validate("Purch. Unit of Measure", ValidateUOM(GetCellValue(ExcelBuffer, RowNo, 6), RowNo));

        SetItemType(Item, GetCellValueByHeader(ExcelBuffer, RowNo, 'Item Type Name'), RowNo);
        SetCategory(Item, GetCellValueByHeader(ExcelBuffer, RowNo, 'Category Name'), RowNo);

        Item.Modify(true); // Save changes for both new and existing items
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