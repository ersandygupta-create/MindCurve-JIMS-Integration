
query 50005 "E3 API Item Update Log"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    Caption = 'itemUpdateLog';
    EntityName = 'itemUpdateLog';
    EntitySetName = 'itemUpdateLogs';
    QueryType = API;

    elements
    {
        dataitem(ItemUpdateLog; "E3 API Item Update Log")
        {
            column(entryNo; "Entry No.") { }
            column(itemNo; "No.") { }
            column(no2; "No. 2") { }
            column(description; Description) { }
            column(description2; "Description 2") { }
            column(baseUnitOfMeasure; "Base Unit of Measure") { }
            column(priceUnitConversion; "Price Unit Conversion") { }
            column(type; Type) { }
            column(inventoryPostingGroup; "Inventory Posting Group") { }
            column(blocked; Blocked) { }
            column(lastDateModified; "Last Date Modified") { }
            column(salesUnitOfMeasure; "Sales Unit of Measure") { }
            column(purchUnitOfMeasure; "Purch. Unit of Measure") { }
            column(itemType; "E3 Item Type") { }
            column(category; Category) { }
            column(materialCategory; "Material Category") { }
            column(model; Model) { }
            column(strength; Strength) { }
            column(medicineGroup; "Medicine Group") { }
            column(rateMarginFix; "Rate Margin Fix") { }
            column(medicineManufacturerName; "Medicine Manufacturer Name") { }
            column(medicineCompanyName; "Medicine Company Name") { }
            column(packing; Packing) { }
            column(resGroupName; "Res. Group Name") { }
            column(inclFreeQtyInSaleRate; "Incl Free Qty in Sale Rate") { }
            column(saleDiscountAllow; "Sale Discount Allow") { }
            column(saleRateEditable; "Sale Rate Editable") { }
            column(allowMRPDiscount; "Allow MRP Discount") { }
            column(consignmentItem; "Consignment Item") { }
            column(saleReturnableItem; "Sale Returnable Item") { }
            column(quatationRequired; "Quatation Required") { }
            column(barCodeActive; "BarCode Active") { }
            column(itemTypeName; "Item Type") { }
            column(medicineSubCategoryName; "Medicine SubCategory Name") { }
            column(subGroupNature; "Sub Group Nature") { }
            column(make; Make) { }
            column(medicineComponent; "Medicine Component") { }
            column(specialityName; "Speciality Name") { }
            column(materialType; "Material Type") { }
            column(medicineComposition; "Medicine Composition") { }
            column(subGroupSite; "Sub Group Site") { }
            column(narcoticsControlSubstances; "Narcotics Control Substances") { }
            column(uniqueLogNo; "Unique Log No.") { }
            column(syncStatus; "Sync Status") { }
            column(errorMessage; "Error Message") { }
            column(entryType; "Entry Type") { }
            column(lastModifiedDateTime; "Last Modified Date Time") { }
            column(itemGroup; "Item Group") { }
            column(toleranceExcess; "Tolerance excess") { }
            column(toleranceShortage; "Tolerance Shortage") { }
            column(marginFix; "Margin Fix") { }
            column(propertyListName; "Property List Name") { }
            column(skuName; SkuName) { }
            column(manualCode; "Manual Code") { }
            column(remarks; Remarks) { }
            column(purchQtyPerRate; "Purch. Qty. Per Rate") { }
            column(saleQtyPerRate; "Sale Qty. Per Rate") { }

            column(strengthCode; "Strength Code") { }
            column(itemGroupCode; "Item Group Code") { }
            column(itemMakeCode; "Item Make Code") { }
            column(compositionCode; "Composition Code") { }
            column(subCategoryCode; "Sub Category Code") { }
            column(categoryCode; "Category Code") { }
            column(manufacturerCode; "Manufacturer Code") { }
            column(marketingCompanyCode; "Marketing Company Code") { }
            column(materialTypeCode; "Material Type Code") { }
            column(materialCategoryCode; "Material Category Code") { }

            column(allowNegativeStock; "Allow Negative Stock") { }
            column(isIndentMandatory; "Is Indent Mandatory") { }
            column(isCommon; "Is Common") { }
            column(schemeOnQty; "Scheme On Qty") { }
            column(schemeFreeQty; "Scheme Free Qty") { }
            column(isLifeSaving; "Is Life Saving") { }
            column(isHighValue; "Is High Value") { }
            column(isFlowThrough; "Is Flow Through") { }
            column(isBilledItem; "Is Billed Item") { }
            column(itemSpecialityCode; "Item Speciality Code") { }
            column(divisionCode; "Division Code") { }
            column(divisionName; "Division Name") { }
            column(instruction; Instruction) { }
            column(regionalInstruction; "Regional Instruction") { }
            column(modelName; "Model Name") { }
            column(name; Name) { }
            column(medicineCompanyCode; "Medicine Company Code") { }
            column(medicineSubCategoryCode; "Medicine SubCategory Code") { }
            column(medicineManufacturerCode; "Medicine Manufacturer Code") { }
            column(resGroupCode; "Res. Group Code") { }
            column(propertyListCode; "Property List Code") { }
            column(itemTypeName2; "Item Type Name") { }
            column(salesUnitOfMeasureName; "Sales Unit of Measure Name") { }
            column(purchUnitOfMeasureName; "Purch. Unit of Measure Name") { }
            column(preparedBy; "Prepared By") { }
            column(hsnSACType; "HSN/SAC Type") { }
            column(mrp; MRP) { }
            column(saleRate; "Sale Rate") { }
            column(purchaseRate; "Purchase Rate") { }
            column(purchaseDiscount; "Purchase Discount %") { }
            column(saleDiscount; "Sale Discount %") { }
            column(marketingCompanyName; "Marketing Company Name") { }
            column(filterItemTypeCode; "Filter Item Type Code") { }
            column(baseUnitOfMeasureName; "Base Unit of Measure Name") { }
            column(isActive; IsActive) { }
            column(d365Status; D365_Status) { }
            column(psychotropicSubstanceFlag; "Psychotropic Substance Flag") { }
            column(scheduleH1Tagging; "Schedule H1 Tagging") { }
            column(formulary; Formulary) { }
            column(nonFormulary; "Non-Formulary") { }
            column(antiTB; "Anti TB") { }
            column(antibiotic; Antibiotic) { }
            column(capexOpexTagging; "Capex / Opex Tagging") { }
            column(poMandatory; "PO Mandatory") { }
            column(marginCode; "Margin Code") { }
            column(glen; GLEN) { }
            column(genProdPostingGroup; "Gen. Prod. Posting Group") { }
            column(commonItemNo; "Common Item No.") { }
            column(gstGroupCode; "GST Group Code") { }
            column(hsnSACCode; "HSN/SAC Code") { }
        }
    }

    trigger OnBeforeOpen()
    begin
    end;
}
