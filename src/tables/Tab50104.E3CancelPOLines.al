table 50104 "E3 Cancel PO Lines"
{
    Caption = 'E3 Cancel PO Lines';

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
            ToolTip = 'Specifies the type of document that you are about to create.';
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            ToolTip = 'Specifies the name of the vendor who delivered the items.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            ToolTip = 'Specifies the document number.';
            TableRelation = "Purchase Header"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line''s number.';
        }
        field(5; Type; Enum "Purchase Line Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the line type.';

        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
            ValidateTableRelation = false;
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(true)) "G/L Account"
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const(Item), "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) Item where(Blocked = const(false), "Purchasing Blocked" = const(false))
            else
            if (Type = const(Item), "Document Type" = filter("Credit Memo" | "Return Order")) Item where(Blocked = const(false))
            else
            if (Type = const("Allocation Account")) "Allocation Account"
            else
            if (Type = const(Resource)) Resource;

        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';


        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = if (Type = const(Item)) "Inventory Posting Group"
            else
            if (Type = const("Fixed Asset")) "FA Posting Group";
        }
        field(10; "Expected Receipt Date"; Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Expected Receipt Date';
            ToolTip = 'Specifies the date that you expect the items to be available in your warehouse.';

        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.';
            TableRelation = if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account".Name where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(true)) "G/L Account".Name
            else
            if (Type = const(Item), "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) Item.Description where(Blocked = const(false), "Purchasing Blocked" = const(false))
            else
            if (Type = const(Item), "Document Type" = filter("Credit Memo" | "Return Order")) Item.Description where(Blocked = const(false))
            else
            if (Type = const("Fixed Asset")) "Fixed Asset".Description
            else
            if (Type = const("Charge (Item)")) "Item Charge".Description
            else
            if (Type = const("Allocation Account")) "Allocation Account".Name
            else
            if (Type = const(Resource)) Resource.Name;
            ValidateTableRelation = false;


        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies information in addition to the description.';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            ToolTip = 'Specifies the unit of measure.';


        }
        field(15; Quantity; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the number of units of the item specified on the line.';

        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Outstanding Quantity';
            ToolTip = 'Specifies how many units on the order line have not yet been received.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(17; "Qty. to Invoice"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';

        }
        field(18; "Qty. to Receive"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            AutoFormatType = 0;
            Caption = 'Qty. to Receive';
            ToolTip = 'Specifies the quantity of items that remains to be received.';
            DecimalPlaces = 0 : 5;

        }
        field(22; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            ToolTip = 'Specifies the cost of one unit of the selected item or resource.';


        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';

        }
        field(25; "VAT %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Line Discount %';
            ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;


        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            ToolTip = 'Specifies the discount amount that is granted for the item on the line.';


        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
            Editable = false;


        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;


        }
        field(31; "Unit Price (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 2;
            Caption = 'Unit Price (LCY)';
            ToolTip = 'Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
            InitValue = true;


        }
        field(34; "Gross Weight"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Gross Weight';
            ToolTip = 'Specifies the gross weight of one unit of the item. In the purchase statistics window, the gross weight on the line is included in the total gross weight of all the lines for the particular purchase document.';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Net Weight';
            ToolTip = 'Specifies the net weight of one unit of the item. In the purchase statistics window, the net weight on the line is included in the total net weight of all the lines for the particular purchase document.';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Units per Parcel"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Units per Parcel';
            ToolTip = 'Specifies the number of units per parcel of the item. In the purchase statistics window, the number of units per parcel on the line helps to determine the total number of units for all the lines for the particular purchase document.';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Unit Volume"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Unit Volume';
            ToolTip = 'Specifies the volume of one unit of the item. In the purchase statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular purchase document.';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-to Item Entry';
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';


        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));


        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));


        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Project No.';
            ToolTip = 'Specifies the number of the related project. If you fill in this field and the Project Task No. field, then a project ledger entry will be posted together with the purchase line.';
            TableRelation = Job;


        }
        field(54; "Indirect Cost %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Indirect Cost %';
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;


        }
        field(56; "Recalculate Invoice Disc."; Boolean)
        {
            Caption = 'Recalculate Invoice Disc.';
            Editable = false;
        }
        field(57; "Outstanding Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Outstanding Amount';
            Editable = false;


        }
        field(58; "Qty. Rcd. Not Invoiced"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. Rcd. Not Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(59; "Amt. Rcd. Not Invoiced"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amt. Rcd. Not Invoiced';
            Editable = false;


        }
        field(60; "Quantity Received"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            AutoFormatType = 0;
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies how many units of the item on the line have been posted as received.';

        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Quantity Invoiced';
            ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(63; "Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
            Editable = false;
        }
        field(64; "Receipt Line No."; Integer)
        {
            Caption = 'Receipt Line No.';
            Editable = false;
        }
        field(65; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            ToolTip = 'Specifies the order number this line is associated with.';
        }
        field(66; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(67; "Profit %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(68; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(69; "Inv. Discount Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;
            ToolTip = 'Specifies the total calculated invoice discount amount for the line.';


        }
        field(70; "Vendor Item No."; Text[50])
        {
            Caption = 'Vendor Item No.';


        }
        field(71; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = if ("Drop Shipment" = const(true)) "Sales Header"."No." where("Document Type" = const(Order));


        }
        field(72; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;
            TableRelation = if ("Drop Shipment" = const(true)) "Sales Line"."Line No." where("Document Type" = const(Order),
                                                                                            "Document No." = field("Sales Order No."));


        }
        field(73; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
            ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
            Editable = false;


        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
            TableRelation = "Gen. Business Posting Group";


        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
            TableRelation = "Gen. Product Posting Group";


        }
        field(77; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }
        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            ToolTip = 'Specifies the line number to which this purchase line is attached.';
            Editable = false;
            TableRelation = "Purchase Line"."Line No." where("Document Type" = field("Document Type"),
                                                              "Document No." = field("Document No."));
        }
        field(81; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
            TableRelation = "Tax Area";


        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            ToolTip = 'Specifies if this vendor charges you sales tax for purchases.';


        }
        field(87; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
            TableRelation = "Tax Group";


        }
        field(88; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
            ToolTip = 'Specifies a U.S. sales tax that is paid on items purchased by a company that are used by the company, instead of being sold to a customer.';


        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            ToolTip = 'Specifies the vendor''s VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.';
            TableRelation = "VAT Business Posting Group";


        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
            TableRelation = "VAT Product Posting Group";


        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            ToolTip = 'Specifies the currency that is used on the entry.';
            Editable = false;
            TableRelation = Currency;
        }
        field(92; "Outstanding Amount (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Outstanding Amount (LCY)';
            ToolTip = 'Specifies the amount for the items on the order that have not yet been received in LCY.';
            Editable = false;
        }
        field(93; "Amt. Rcd. Not Invoiced (LCY)"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Amt. Rcd. Not Invoiced (LCY)';
            ToolTip = 'Specifies the sum, in LCY, for items that have been received but have not yet been invoiced. The value in the Amt. Rcd. Not Invoiced (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.';
            Editable = false;
        }
        field(95; "Reserved Quantity"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            AutoFormatType = 0;
            CalcFormula = sum("Reservation Entry".Quantity where("Source ID" = field("Document No."),
                                                                  "Source Ref. No." = field("Line No."),
                                                                  "Source Type" = const(39),
#pragma warning disable AL0603
                                                                  "Source Subtype" = field("Document Type"),
#pragma warning restore
                                                                  "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            ToolTip = 'Specifies how many item units on this line have been reserved.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(97; "Blanket Order No."; Code[20])
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Blanket Order No.';
            ToolTip = 'Specifies the number of the blanket order that the record originates from.';
            TableRelation = "Purchase Header"."No." where("Document Type" = const("Blanket Order"));




        }
        field(98; "Blanket Order Line No."; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Blanket Order Line No.';
            ToolTip = 'Specifies the number of the blanket order line that the record originates from.';
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const("Blanket Order"),
                                                              "Document No." = field("Blanket Order No."));

        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount';
            ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';

        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(105; "Inv. Disc. Amount to Invoice"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            ToolTip = 'Specifies the actual invoice discount amount that will be posted for the line on the invoice.';
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(107; "IC Partner Ref. Type"; Enum "IC Partner Reference Type")
        {
            AccessByPermission = TableData "IC G/L Account" = R;
            Caption = 'IC Partner Ref. Type';
            ToolTip = 'Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';

        }
        field(108; "IC Partner Reference"; Code[20])
        {
            AccessByPermission = TableData "IC G/L Account" = R;
            Caption = 'IC Partner Reference';
            ToolTip = 'Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner''s company that corresponds to the line.';


        }
        field(109; "Prepayment %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Prepayment %';
            ToolTip = 'Specifies the prepayment percentage to use to calculate the prepayment for purchases.';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;


        }
        field(110; "Prepmt. Line Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Line Amount';
            ToolTip = 'Specifies the prepayment amount of the line in the currency of the purchase document if a prepayment percentage is specified for the purchase line.';
            MinValue = 0;


        }
        field(111; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Inv.';
            ToolTip = 'Specifies the prepayment amount that has already been invoiced to the customer for this purchase line.';
            Editable = false;
        }
        field(112; "Prepmt. Amt. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            Editable = false;
        }
        field(113; "Prepayment Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Editable = false;
        }
        field(114; "Prepmt. VAT Base Amt."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            Editable = false;
        }
        field(115; "Prepayment VAT %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Prepayment VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(116; "Prepmt. VAT Calc. Type"; Enum "Tax Calculation Type")
        {
            Caption = 'Prepmt. VAT Calc. Type';
            Editable = false;
        }
        field(117; "Prepayment VAT Identifier"; Code[20])
        {
            Caption = 'Prepayment VAT Identifier';
            Editable = false;
        }
        field(118; "Prepayment Tax Area Code"; Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";


        }
        field(119; "Prepayment Tax Liable"; Boolean)
        {
            Caption = 'Prepayment Tax Liable';


        }
        field(120; "Prepayment Tax Group Code"; Code[20])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";


        }
        field(121; "Prepmt Amt to Deduct"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Amt to Deduct';
            ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this purchase order line.';
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text039, "Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

                if "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Direct Unit Cost" then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text039, "Qty. to Invoice" * "Direct Unit Cost"));
                if ("Prepmt. Amt. Inv." - "Prepmt Amt to Deduct" - "Prepmt Amt Deducted") >
                   (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"
                then
                    FieldError(
                      "Prepmt Amt to Deduct",
                      StrSubstNo(Text038,
                        "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
                        (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"));
            end;
        }
        field(122; "Prepmt Amt Deducted"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt Amt Deducted';
            ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this purchase order line.';
            Editable = false;
        }
        field(123; "Prepayment Line"; Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124; "Prepmt. Amount Inv. Incl. VAT"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. Incl. VAT';
            Editable = false;
        }
        field(129; "Prepmt. Amount Inv. (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Prepmt. Amount Inv. (LCY)';
            Editable = false;
        }
        field(130; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
            TableRelation = "IC Partner";

            trigger OnValidate()
            begin
                if "IC Partner Code" <> '' then begin
                    TestField(Type, Type::"G/L Account");
                    PurchHeader.TestField("Buy-from IC Partner Code", '');
                    PurchHeader.TestField("Pay-to IC Partner Code", '');
                    Validate("IC Partner Ref. Type", "IC Partner Ref. Type"::"G/L Account");
                end;
            end;
        }
        field(132; "Prepmt. VAT Amount Inv. (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Amount Inv. (LCY)';
            Editable = false;
        }
        field(135; "Prepayment VAT Difference"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment VAT Difference';
            Editable = false;
        }
        field(136; "Prepmt VAT Diff. to Deduct"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt VAT Diff. to Deduct';
            Editable = false;
        }
        field(137; "Prepmt VAT Diff. Deducted"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt VAT Diff. Deducted';
            Editable = false;
        }
        field(138; "IC Item Reference No."; Code[50])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'IC Item Reference No.';


        }
        field(140; "Outstanding Amt. Ex. VAT (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Outstanding Amt. Ex. VAT (LCY)';
        }
        field(141; "A. Rcd. Not Inv. Ex. VAT (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'A. Rcd. Not Inv. Ex. VAT (LCY)';
        }
        field(145; "Pmt. Discount Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Pmt. Discount Amount';


        }
        field(146; "Prepmt. Pmt. Discount Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Pmt. Discount Amount';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Project Task No.';
            ToolTip = 'Specifies the number of the related project task.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));


        }
        field(1002; "Job Line Type"; Enum "Job Line Type")
        {
            AccessByPermission = TableData Job = R;
            Caption = 'Project Line Type';
            ToolTip = 'Specifies a Project Planning Line together with the posting of a project ledger entry.';


        }
        field(1003; "Job Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            AutoFormatExpression = "Job Currency Code";
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Project Unit Price';
            ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';


        }
        field(1004; "Job Total Price"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Project Total Price';
            ToolTip = 'Specifies the gross amount of the line that the purchase line applies to.';
            Editable = false;
        }
        field(1005; "Job Line Amount"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Project Line Amount';
            ToolTip = 'Specifies the line amount of the project ledger entry that is related to the purchase line.';


        }
        field(1006; "Job Line Discount Amount"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Project Line Discount Amount';
            ToolTip = 'Specifies the line discount amount of the project ledger entry that is related to the purchase line.';


        }
        field(1007; "Job Line Discount %"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatType = 0;
            BlankZero = true;
            Caption = 'Project Line Discount %';
            ToolTip = 'Specifies the line discount percentage of the project ledger entry that is related to the purchase line.';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;


        }
        field(1008; "Job Unit Price (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = '';
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Project Unit Price (LCY)';
            Editable = false;


        }
        field(1009; "Job Total Price (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = '';
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Project Total Price (LCY)';
            Editable = false;
        }
        field(1010; "Job Line Amount (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = '';
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Project Line Amount (LCY)';
            Editable = false;


        }
        field(1011; "Job Line Disc. Amount (LCY)"; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatExpression = '';
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Project Line Disc. Amount (LCY)';
            Editable = false;


        }
        field(1012; "Job Currency Factor"; Decimal)
        {
            AutoFormatType = 0;
            BlankZero = true;
            Caption = 'Project Currency Factor';
        }
        field(1013; "Job Currency Code"; Code[20])
        {
            Caption = 'Project Currency Code';
        }
        field(1019; "Job Planning Line No."; Integer)
        {
            AccessByPermission = TableData Job = R;
            BlankZero = true;
            Caption = 'Project Planning Line No.';
            ToolTip = 'Specifies the project planning line number that the usage should be linked to when the project journal is posted. You can only link to project planning lines that have the Apply Usage Link option enabled.';




        }
        field(1030; "Job Remaining Qty."; Decimal)
        {
            AccessByPermission = TableData Job = R;
            AutoFormatType = 0;
            Caption = 'Project Remaining Qty.';
            ToolTip = 'Specifies the quantity that remains to complete a project.';
            DecimalPlaces = 0 : 5;


        }
        field(1031; "Job Remaining Qty. (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Project Remaining Qty. (Base)';
        }
        field(1700; "Deferral Code"; Code[10])
        {
            Caption = 'Deferral Code';
            ToolTip = 'Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
            TableRelation = "Deferral Template"."Deferral Code";


        }
        field(1702; "Returns Deferral Start Date"; Date)
        {
            Caption = 'Returns Deferral Start Date';
            ToolTip = 'Specifies the starting date of the returns deferral period.';


        }
        field(2675; "Selected Alloc. Account No."; Code[20])
        {
            Caption = 'Allocation Account No.';
            ToolTip = 'Specifies the allocation account number that will be used to distribute the amounts during the posting process.';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Account";
        }
        field(2677; "Alloc. Acc. Modified by User"; Boolean)
        {
            Caption = 'Allocation Account Distributions Modified';
            FieldClass = FlowField;
            CalcFormula = exist(Microsoft.Finance.AllocationAccount."Alloc. Acc. Manual Override" where("Parent System Id" = field(SystemId), "Parent Table Id" = const(Database::"Purchase Line")));
        }
        field(2678; "Allocation Account No."; Code[20])
        {
            Caption = 'Posting Allocation Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Account";
        }
        field(2679; "Alloc. Purch. Line SystemId"; Guid)
        {
            Caption = 'Allocation Purchase Line SystemId';
            DataClassification = SystemMetadata;
        }
        field(2700; "Invoicing From Line SystemId"; Guid)
        {
            Caption = 'Invoicing From Line SystemId';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2701; "Matched Order Lines"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Matched Order Line" where("Document Line SystemId" = field(SystemId), "Matched Rcpt./Shpt. Line SysId" = const('00000000-0000-0000-0000-000000000000')));
            Caption = 'Matched Order Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2702; "Matched Inv./Cr. Memo Lines"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Matched Order Line" where("Matched Order Line SystemId" = field(SystemId), "Matched Rcpt./Shpt. Line SysId" = const('00000000-0000-0000-0000-000000000000')));
            Caption = 'Matched Invoice/Cr. Memo Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            ToolTip = 'Specifies the variant of the item on the line.';
            TableRelation = if (Type = const(Item), "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) "Item Variant".Code where("Item No." = field("No."), Blocked = const(false), "Purchasing Blocked" = const(false))
            else
            if (Type = const(Item), "Document Type" = filter("Credit Memo" | "Return Order")) "Item Variant".Code where("Item No." = field("No."), Blocked = const(false));


        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            ToolTip = 'Specifies the bin where the items are picked or put away.';
            TableRelation = if ("Document Type" = filter(Order | Invoice),
                                Quantity = filter(< 0)) "Bin Content"."Bin Code" where("Location Code" = field("Location Code"),
                                                                                     "Item No." = field("No."),
                                                                                     "Variant Code" = field("Variant Code"))
            else
            if ("Document Type" = filter("Return Order" | "Credit Memo"),
                                                                                              Quantity = filter(>= 0)) "Bin Content"."Bin Code" where("Location Code" = field("Location Code"),
                                                                                                                                                    "Item No." = field("No."),
                                                                                                                                                    "Variant Code" = field("Variant Code"))
            else
            Bin.Code where("Location Code" = field("Location Code"));



        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; "Qty. Rounding Precision"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. Rounding Precision';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(5406; "Qty. Rounding Precision (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. Rounding Precision (Base)';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item),
                                "No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource), "No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            if (Type = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';


        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(5416; "Outstanding Qty. (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5417; "Qty. to Invoice (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. to Invoice (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(5418; "Qty. to Receive (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. to Receive (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(5458; "Qty. Rcd. Not Invoiced (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. Rcd. Not Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5460; "Qty. Received (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. Received (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5495; "Reserved Qty. (Base)"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Source Type" = const(39),
#pragma warning disable AL0603
                                                                           "Source Subtype" = field("Document Type"),
#pragma warning restore
                                                                           "Source ID" = field("Document No."),
                                                                           "Source Ref. No." = field("Line No."),
                                                                           "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            ToolTip = 'Specifies the value in the Reserved Quantity field, expressed in the base unit of measure.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5600; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
            ToolTip = 'Specifies the FA posting date if you have selected Fixed Asset in the Type field for this line.';
        }
        field(5601; "FA Posting Type"; Enum "Purchase FA Posting Type")
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Posting Type';
            ToolTip = 'Specifies the FA posting type if you have selected Fixed Asset in the Type field for this line.';

        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
            TableRelation = "Depreciation Book";


        }
        field(5603; "Salvage Value"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Salvage Value';
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'Depr. until FA Posting Date';
            ToolTip = 'Specifies if depreciation was calculated until the FA posting date of the line.';
        }
        field(5606; "Depr. Acquisition Cost"; Boolean)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'Depr. Acquisition Cost';
            ToolTip = 'Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
        }
        field(5609; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;
        }
        field(5610; "Insurance No."; Code[20])
        {
            Caption = 'Insurance No.';
            ToolTip = 'Specifies an insurance number if you have selected the Acquisition Cost option in the FA Posting Type field.';
            TableRelation = Insurance;
        }
        field(5611; "Budgeted FA No."; Code[20])
        {
            Caption = 'Budgeted FA No.';
            ToolTip = 'Specifies the number of a fixed asset with the Budgeted Asset check box selected. When you post the journal or document line, an additional entry is created for the budgeted fixed asset where the amount has the opposite sign.';
            TableRelation = "Fixed Asset";

            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                if "Budgeted FA No." <> '' then begin
                    FixedAsset.Get("Budgeted FA No.");
                    FixedAsset.TestField("Budgeted Asset", true);
                end;
            end;
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            begin
                "Use Duplication List" := false;
            end;
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'Use Duplication List';
            ToolTip = 'Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books.';

            trigger OnValidate()
            begin
                "Duplicate in Depreciation Book" := '';
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            AccessByPermission = TableData "Nonstock Item" = R;
            Caption = 'Catalog';
            ToolTip = 'Specifies that this item is a catalog item.';
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            Editable = false;
            TableRelation = Purchasing;
            ToolTip = 'Specifies the purchasing code associated with the purchase line.';

        }
        field(5713; "Special Order"; Boolean)
        {
            Caption = 'Special Order';


        }
        field(5714; "Special Order Sales No."; Code[20])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order Sales No.';
            TableRelation = if ("Special Order" = const(true)) "Sales Header"."No." where("Document Type" = const(Order));


        }
        field(5715; "Special Order Sales Line No."; Integer)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Special Order Sales Line No.';
            TableRelation = if ("Special Order" = const(true)) "Sales Line"."Line No." where("Document Type" = const(Order),
                                                                                            "Document No." = field("Special Order Sales No."));


        }
        field(5725; "Item Reference No."; Code[50])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'Item Reference No.';
            ToolTip = 'Specifies the referenced item number.';
            ExtendedDatatype = Barcode;


        }
        field(5726; "Item Reference Unit of Measure"; Code[10])
        {
            AccessByPermission = TableData "Item Reference" = R;
            Caption = 'Item Reference Unit of Measure';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5727; "Item Reference Type"; Enum "Item Reference Type")
        {
            Caption = 'Item Reference Type';
        }
        field(5728; "Item Reference Type No."; Code[30])
        {
            Caption = 'Item Reference Type No.';
        }
        field(5750; "Whse. Outstanding Qty. (Base)"; Decimal)
        {
            AccessByPermission = TableData Location = R;
            AutoFormatType = 0;
            BlankZero = true;
            CalcFormula = sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" where("Source Type" = const(39),
#pragma warning disable AL0603
                                                                                        "Source Subtype" = field("Document Type"),
#pragma warning restore
                                                                                        "Source No." = field("Document No."),
                                                                                        "Source Line No." = field("Line No.")));
            Caption = 'Whse. Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752; "Completely Received"; Boolean)
        {
            Caption = 'Completely Received';
            Editable = false;
        }
        field(5790; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
            ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.';


        }
        field(5791; "Promised Receipt Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Promised Receipt Date';
            ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';


        }
        field(5792; "Lead Time Calculation"; DateFormula)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Lead Time Calculation';
            ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';


        }
        field(5793; "Inbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Inbound Whse. Handling Time';
            ToolTip = 'Specifies the time it takes to make items part of available inventory, after the items have been posted as received.';


        }
        field(5794; "Planned Receipt Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Planned Receipt Date';
            ToolTip = 'Specifies the date when the item is planned to arrive in inventory. Forward calculation: planned receipt date = order date + vendor lead time (per the vendor calendar and rounded to the next working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: planned receipt date = order date + vendor lead time (per the location calendar). Backward calculation: order date = planned receipt date - vendor lead time (per the vendor calendar and rounded to the previous working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: order date = planned receipt date - vendor lead time (per the location calendar).';


        }
        field(5795; "Order Date"; Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Order Date';
            ToolTip = 'Specifies the date when the order was created.';


        }
        field(5800; "Allow Item Charge Assignment"; Boolean)
        {
            AccessByPermission = TableData "Item Charge" = R;
            Caption = 'Allow Item Charge Assignment';
            ToolTip = 'Specifies that you can assign item charges to this line.';
            InitValue = true;


        }
        field(5801; "Qty. to Assign"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = sum("Item Charge Assignment (Purch)"."Qty. to Assign" where("Document Type" = field("Document Type"),
                                                                                       "Document No." = field("Document No."),
                                                                                       "Document Line No." = field("Line No.")));
            Caption = 'Qty. to Assign';
            ToolTip = 'Specifies how many units of the item charge will be assigned to the line.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5802; "Qty. Assigned"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = sum("Item Charge Assignment (Purch)"."Qty. Assigned" where("Document Type" = field("Document Type"),
                                                                                      "Document No." = field("Document No."),
                                                                                      "Document Line No." = field("Line No.")));
            Caption = 'Qty. Assigned';
            ToolTip = 'Specifies how much of the item charge that has been assigned.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5803; "Return Qty. to Ship"; Decimal)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            AutoFormatType = 0;
            Caption = 'Return Qty. to Ship';
            ToolTip = 'Specifies the quantity of items that remains to be shipped.';
            DecimalPlaces = 0 : 5;


        }
        field(5804; "Return Qty. to Ship (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Return Qty. to Ship (Base)';
            DecimalPlaces = 0 : 5;


        }
        field(5805; "Return Qty. Shipped Not Invd."; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Return Qty. Shipped Not Invd.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5806; "Ret. Qty. Shpd Not Invd.(Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Ret. Qty. Shpd Not Invd.(Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5807; "Return Shpd. Not Invd."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Return Shpd. Not Invd.';
            Editable = false;


        }
        field(5808; "Return Shpd. Not Invd. (LCY)"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Return Shpd. Not Invd. (LCY)';
            Editable = false;
        }
        field(5809; "Return Qty. Shipped"; Decimal)
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            AutoFormatType = 0;
            Caption = 'Return Qty. Shipped';
            ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5810; "Return Qty. Shipped (Base)"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Return Qty. Shipped (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5812; "Item Charge Qty. to Handle"; Decimal)
        {
            AutoFormatType = 0;
            CalcFormula = sum("Item Charge Assignment (Purch)"."Qty. to Handle" where("Document Type" = field("Document Type"),
                                                                                       "Document No." = field("Document No."),
                                                                                       "Document Line No." = field("Line No.")));
            Caption = 'Item Charge Qty. to Handle';
            ToolTip = 'Specifies how many items the item charge will be assigned to on the line. It can be either equal to Qty. to Assign or to zero. If it is zero, the item charge will not be assigned to the line.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(6200; "Non-Deductible VAT %"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Non-Deductible VAT %';
            DecimalPlaces = 0 : 5;


        }
        field(6201; "Non-Deductible VAT Base"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Non-Deductible VAT Base';
            ToolTip = 'Specifies the amount of VAT that is not deducted due to the type of goods or services purchased.';
            Editable = false;
        }
        field(6202; "Non-Deductible VAT Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Non-Deductible VAT Amount';
            ToolTip = 'Specifies the amount of the transaction for which VAT is not applied, due to the type of goods or services purchased.';
            Editable = false;
        }
        field(6203; "Non-Deductible VAT Diff."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Non-Deductible VAT Difference';
            Editable = false;
        }
        field(6204; "Prepmt. Non-Deduct. VAT Base"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt.  Non-Deductible VAT Base';
            Editable = false;
        }
        field(6205; "Prepmt. Non-Deduct. VAT Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. on-Deductible VAT Amount';
            Editable = false;
        }
        field(6206; "Item Charge Has Non.Ded. VAT"; Boolean)
        {
            Caption = 'Item Charge Has Non-Deductible VAT';
            Editable = false;
        }
        field(6600; "Return Shipment No."; Code[20])
        {
            Caption = 'Return Shipment No.';
            Editable = false;
        }
        field(6601; "Return Shipment Line No."; Integer)
        {
            Caption = 'Return Shipment Line No.';
            Editable = false;
        }
        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            ToolTip = 'Specifies the code explaining why the item was returned.';
            TableRelation = "Return Reason";


        }
        field(6609; Subtype; Option)
        {
            Caption = 'Subtype';
            OptionCaption = ' ,Item - Inventory,Item - Service,Comment';
            OptionMembers = " ","Item - Inventory","Item - Service",Comment;
        }
        field(6610; "Copied From Posted Doc."; Boolean)
        {
            Caption = 'Copied From Posted Doc.';
        }
        field(7000; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
        }
        field(7010; "Attached Doc Count"; Integer)
        {
            BlankNumbers = DontBlank;
            CalcFormula = count("Document Attachment" where("Table ID" = const(39),
                                                             "No." = field("Document No."),
                                                             "Document Type" = field("Document Type"),
                                                             "Line No." = field("Line No.")));
            Caption = 'Attached Doc Count';
            ToolTip = 'Specifies the number of attachments.';
            FieldClass = FlowField;
            InitValue = 0;
        }
        field(7011; "Attached Lines Count"; Integer)
        {
            CalcFormula = count("Purchase Line" where("Document Type" = field("Document Type"),
                                                       "Document No." = field("Document No."),
                                                       "Attached to Line No." = field("Line No."),
                                                       Quantity = filter(<> 0)));
            Caption = 'Attached Lines Count';
            ToolTip = 'Specifies the number of non-inventory product lines attached to the purchase line.';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
        }
        field(8509; "Over-Receipt Quantity"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Over-Receipt Quantity';
            ToolTip = 'Specifies over-receipt quantity.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;


        }
        field(8510; "Over-Receipt Code"; Code[20])
        {
            Caption = 'Over-Receipt Code';
            ToolTip = 'Specifies over-receipt code.';
            TableRelation = "Over-Receipt Code";

            trigger OnValidate()
            begin
                if ((Rec."Over-Receipt Code" = '') and (xRec."Over-Receipt Code" <> '')) then
                    Validate("Over-Receipt Quantity", 0);
            end;
        }
        field(8511; "Over-Receipt Approval Status"; Enum "Over-Receipt Approval Status")
        {
            Caption = 'Over-Receipt Approval Status';
        }
        field(8512; "Buy-from Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
            Caption = 'Buy-from Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12100; "No. of Fixed Asset Cards"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Fixed Asset Cards';
            ToolTip = 'Specifies the number of fixed assets that is being purchased.';
            MinValue = 0;


        }
        field(99000755; "Overhead Rate"; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Validate("Indirect Cost %");
            end;
        }
        field(99000756; "MPS Order"; Boolean)
        {
            Caption = 'MPS Order';
        }
        field(99000757; "Planning Flexibility"; Enum "Reservation Planning Flexibility")
        {
            Caption = 'Planning Flexibility';
            ToolTip = 'Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.';


        }
        field(99000758; "Safety Lead Time"; DateFormula)
        {
            Caption = 'Safety Lead Time';

            trigger OnValidate()
            begin
                Validate("Inbound Whse. Handling Time");
            end;
        }
        field(50000; "E3 Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50003; "Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50004; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
        field(50005; "Item Make Code"; Code[20])
        {
            Caption = 'Item Make Code';
            DataClassification = CustomerContent;
            TableRelation = "E3 Item Make Master".Code;


        }
        field(50006; "Item Make Name"; Text[60])
        {
            Caption = 'Item Make Name';
            DataClassification = CustomerContent;
        }
        field(50007; Critical; Boolean)
        {
            Caption = 'Critical';
            DataClassification = CustomerContent;
        }
        field(50008; "Free Qty"; Decimal)
        {
            Caption = 'Free Qty';
            DataClassification = CustomerContent;
        }

        field(50009; "SNo."; Integer)
        {
            Caption = 'SNo.';
            DataClassification = CustomerContent;
        }
        field(50010; MRP; Decimal)
        {
            Caption = 'MRP';
            DataClassification = CustomerContent;
        }
        field(50011; Scheme; Text[30])
        {
            Caption = 'Scheme';
            DataClassification = CustomerContent;
        }
        field(50012; "Margin Fix"; Enum "E3 Margin Fix")
        {
            Caption = 'Margin Fix';
            DataClassification = CustomerContent;
        }
        field(50013; "Incl Free Qty in Sale Rate"; Boolean)
        {
            Caption = 'Include Free Qty in Sale Rate';
            DataClassification = CustomerContent;
        }
        field(50014; "Entry No."; Code[50])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Margin Code"; Code[20])
        {
            Caption = 'Margin Code';
            DataClassification = CustomerContent;
            tableRelation = "E3 Item Margin"."Margin Code";
        }
        field(50016; "Company Value"; Decimal)
        {
            Caption = 'Company Value';
            DataClassification = CustomerContent;
        }
        field(50017; "Patient Value"; Decimal)
        {
            Caption = 'Patient Value';
            DataClassification = CustomerContent;
        }
        field(50018; "Indent Line Remarks"; Text[200])
        {
            Caption = 'Indent Line Remarks';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50019; "Line Remarks"; Text[200])
        {
            Caption = 'Line Remarks';
            DataClassification = CustomerContent;
        }
        field(50020; "PO Qty"; Decimal)
        {
            Caption = 'PO Qty';
            DataClassification = CustomerContent;
        }
        field(50021; "Stock No"; Code[50])
        {
            Caption = 'Stock No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50022; "Stock Line No"; Integer)
        {
            Caption = 'Stock Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50023; "Manufacturing Date"; Date)
        {
            Caption = 'Manufacturing Date';
            DataClassification = CustomerContent;
        }
        field(50024; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50025; "Batch No."; Code[50])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(50028; "Challan No."; Code[35])
        {
            Caption = 'Challan No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Challan Date"; Date)
        {
            Caption = 'Challan Date';
            DataClassification = CustomerContent;
        }
        field(70001; "Purch Rcpt No."; Code[50])
        {
            Caption = 'Receipt No.';
            DataClassification = CustomerContent;
        }
        field(70002; "Purch Rcpt Line No."; Integer)
        {
            Caption = 'Purch Rcpt Line No.';
            DataClassification = CustomerContent;
        }
        field(70003; "Short Close Qty"; Decimal)
        {
            Caption = 'Short Close Qty';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if rec."Short Close Qty" > rec."Outstanding Quantity" then
                    Error('Short Close qty %1 can not exceed outstanding qty %2.', Rec."Short Close Qty", rec."Outstanding Quantity");

            end;
        }
        field(70004; "Short Close Reason"; Code[10])
        {
            Caption = 'Short Close Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }
        field(70005; "Cancel Reason"; Code[10])
        {
            Caption = 'Cancel Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }
        field(70006; "Short Closed"; Boolean)
        {
            Caption = 'Short Closed';
            DataClassification = CustomerContent;
            InitValue = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key3; "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date")
        {
            IncludedFields = "Outstanding Qty. (Base)";
        }
        key(Key4; "Document Type", "Pay-to Vendor No.", "Currency Code", "Document No.")
        {
#pragma warning disable AS0038
            IncludedFields = "Outstanding Amount", "Amt. Rcd. Not Invoiced", "Outstanding Amount (LCY)", "Amt. Rcd. Not Invoiced (LCY)", "Prepmt. Amount Inv. (LCY)", "Prepmt. VAT Amount Inv. (LCY)";
#pragma warning RESTORE AS0038
        }
        key(Key7; "Document Type", "Blanket Order No.", "Blanket Order Line No.")
        {
        }
        key(Key9; "Document Type", "Document No.", "Location Code")
        {
            IncludedFields = Amount, "Amount Including VAT", "VAT Base Amount";
        }
        key(Key10; "Document Type", "Receipt No.", "Receipt Line No.")
        {
            IncludedFields = Quantity;
        }
        key(Key11; Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type", "Expected Receipt Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key12; "Document Type", "Buy-from Vendor No.")
        {
        }
        key(Key13; "Document Type", "Job No.", "Job Task No.", "Document No.")
        {
            IncludedFields = "Outstanding Amt. Ex. VAT (LCY)", "A. Rcd. Not Inv. Ex. VAT (LCY)";
        }
        key(Key16; "Recalculate Invoice Disc.")
        {
        }
        key(Key18; "Location Code", "Quantity Invoiced")
        {
        }
        key(Key19; "Completely Received")
        {
            IncludedFields = Type, "Location Code";
        }
        key(Key20; "Document Type", "Document No.", "Drop Shipment")
        {
            IncludedFields = Quantity;
        }
        key(Key21; "Document Type", "Document No.", Type, "No.", "System-Created Entry")
        {
            IncludedFields = Quantity, "Outstanding Quantity", "Return Qty. Shipped", "Quantity Received", "Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount";
        }
        key(Key22; "Document Type", "Document No.", "VAT Identifier", "Line No.")
        {
            IncludedFields = "VAT %", "Tax Area Code", "Tax Group Code", "VAT Calculation Type", "Line Amount", "Inv. Discount Amount", Amount, "Amount Including VAT", "Quantity (Base)", "VAT Difference";
        }
        key(Key23; "Attached to Line No.")
        {
        }
        key(Key24; "No.", Type)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Line Amount", Quantity, "Unit of Measure Code")
        {
        }
    }






#if not CLEAN28
    [Obsolete('Not used for anything', '28.0')]
    procedure SetSkipEnsurePositiveLineNo(NewSkipEnsurePositiveLineNo: Boolean)
    begin
    end;
#endif    

    var
        PurchHeader: Record "Purchase Header";
        PurchLine2: Record "Purchase Line";
        GLAcc: Record "G/L Account";
        CurrExchRate: Record "Currency Exchange Rate";
        VATPostingSetup: Record "VAT Posting Setup";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        UnitOfMeasure: Record "Unit of Measure";
        ItemCharge: Record "Item Charge";
        SKU: Record "Stockkeeping Unit";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        GLSetup: Record "General Ledger Setup";
        CalChange: Record "Customized Calendar Change";
        TempJobJnlLine: Record "Job Journal Line" temporary;
        PurchSetup: Record "Purchases & Payables Setup";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        PurchasesWarehouseMgt: Codeunit "Purchases Warehouse Mgt.";
        UOMMgt: Codeunit "Unit of Measure Management";
        DimMgt: Codeunit DimensionManagement;
        ItemReferenceMgt: Codeunit "Item Reference Management";
        CatalogItemMgt: Codeunit "Catalog Item Management";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        CalendarMgmt: Codeunit "Calendar Management";
        CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
        DeferralUtilities: Codeunit "Deferral Utilities";
        PostingSetupMgt: Codeunit PostingSetupManagement;
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt.";
        NonDeductibleVAT: Codeunit "Non-Deductible VAT";
        FieldCausedPriceCalculation: Integer;
        GLSetupRead: Boolean;
        UnitCostCurrency: Decimal;
        UpdateFromVAT: Boolean;
        HasBeenShown: Boolean;
        PrePaymentLineAmountEntered: Boolean;
        PurchSetupRead: Boolean;
        SuppressPurchaseHeaderExistsVerification: Boolean;
#pragma warning disable AA0074
#pragma warning disable AA0470
        Text000: Label 'You cannot rename a %1.';
        Text001: Label 'You cannot change %1 because the order line is associated with sales order %2.';
        Text002: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        Text004: Label 'must not be less than %1';
#pragma warning restore AA0470
        Text006: Label 'You can''t invoice more than %1 units.', Comment = '%1 - the field value';
#pragma warning disable AA0470
        Text007: Label 'You cannot invoice more than %1 base units.';
        Text008: Label 'You cannot receive more than %1 units.';
        Text009: Label 'You cannot receive more than %1 base units.';
        Text010: Label 'You cannot change %1 when %2 is %3.';
        Text011: Label ' must be 0 when %1 is %2';
        Text016: Label '%1 is required for %2 = %3.';
        Text018: Label '%1 %2 is earlier than the work date %3.';
        Text020: Label 'You cannot return more than %1 units.';
        Text021: Label 'You cannot return more than %1 base units.';
        Text022: Label 'You cannot change %1, if item charge is already posted.';
        Text023: Label 'You cannot change the %1 when the %2 has been filled in.';
#pragma warning restore AA0470
        Text029: Label 'must be positive.';
        Text030: Label 'must be negative.';
#pragma warning disable AA0470
        Text032: Label '%1 must not be greater than the sum of %2 and %3.';
#pragma warning restore AA0470
        Text033: Label 'Warehouse ';
        Text034: Label 'Inventory ';
#pragma warning disable AA0470
        Text035: Label '%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.';
        Text037: Label 'cannot be %1.';
        Text038: Label 'cannot be less than %1.';
        Text039: Label 'cannot be more than %1.';
        Text042: Label 'You cannot return more than the %1 units that you have received for %2 %3.';
        Text043: Label 'must be positive when %1 is not 0.';
        Text046: Label '%3 will not update %1 when changing %2 because a prepayment invoice has been posted. Do you want to continue?', Comment = '%1 - product name';
        Text047: Label '%1 can only be set when %2 is set.';
        Text048: Label '%1 cannot be changed when %2 is set.';
        Text049: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
#pragma warning restore AA0470
        Text050: Label 'Cancelled.';
        Text051: Label 'must have the same sign as the receipt';
#pragma warning disable AA0470
        Text052: Label 'The quantity that you are trying to invoice is greater than the quantity in receipt %1.';
#pragma warning restore AA0470
        Text053: Label 'must have the same sign as the return shipment';
#pragma warning disable AA0470
        Text054: Label 'The quantity that you are trying to invoice is greater than the quantity in return shipment %1.';
        Text99000000: Label 'You cannot change %1 when the purchase order is associated to a production order.';
#pragma warning restore AA0470
#pragma warning restore AA0074
        MustNotBeSpecifiedErr: Label 'must not be specified when %1 = %2', Comment = '%1 - the field name, %2 - the field value';
        WhseRequirementMsg: Label '%1 is required for this line. The entered information may be disregarded by warehouse activities.', Comment = '%1=Document';
        QtyInvoiceNotValidTitleLbl: Label 'Qty. to Invoice isn''t valid';
        QtyInvoiceActionLbl: Label 'Set value to %1', Comment = '%1 - Qty. to Invoice';
        QtyInvoiceActionDescriptionLbl: Label 'Corrects %1 value to %2', Comment = '%1 - Qty. to Invoice field caption, %2 - Quantity';
        QtyReceiveNotValidTitleLbl: Label 'Qty. to Receive isn''t valid';
        QtyReceiveActionLbl: Label 'Set value to %1', comment = '%1=Qty. to Receive';
        QtyReceiveActionDescriptionLbl: Label 'Corrects %1 value to %2', Comment = '%1 - Qty. to Receive field caption, %2 - Quantity';
        ItemChargeAssignmentErr: Label 'You can only assign Item Charges for Line Types of Charge (Item).';
        CannotFindDescErr: Label 'Cannot find %1 with Description %2.\\Make sure to use the correct type.', Comment = '%1 = Type caption %2 = Description';
        CommentLbl: Label 'Comment';
        LineDiscountPctErr: Label 'The value in the Line Discount % field must be between 0 and 100.';
        PurchasingBlockedErr: Label 'You cannot purchase %1 %2 because the %3 check box is selected on the %1 card.', Comment = '%1 - Table Caption (Item), %2 - Item No., %3 - Field Caption';
        CannotChangePrepaidServiceChargeErr: Label 'You cannot change the line because it will affect service charges that are already invoiced as part of a prepayment.';
        LineInvoiceDiscountAmountResetTok: Label 'The value in the Inv. Discount Amount field in %1 has been cleared.', Comment = '%1 - Record ID';
        BlockedItemNotificationMsg: Label 'Item %1 is blocked, but it is allowed on this type of document.', Comment = '%1 is Item No.';
        BlockedItemVariantNotificationMsg: Label 'Item Variant %1 for Item %2 is blocked, but it is allowed on this type of document.', Comment = '%1 - Item Variant Code, %2 - Item No.';
        InvDiscForPrepmtExceededErr: Label 'You cannot enter an invoice discount for purchase document %1.\\You must cancel the prepayment invoice first and then you will be able to update the invoice discount.', Comment = '%1 - document number';
        CannotAllowInvDiscountErr: Label 'The value of the %1 field is not valid when the VAT Calculation Type field is set to "Full VAT".', Comment = '%1 is the name of not valid field';
        CannotChangeVATGroupWithPrepmInvErr: Label 'You cannot change the VAT product posting group because prepayment invoices have been posted.\\You need to post the prepayment credit memo to be able to change the VAT product posting group.';
        CannotChangePrepmtAmtDiffVAtPctErr: Label 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.';
        LineAmountInvalidErr: Label 'You have set the line amount to a value that results in a discount that is not valid. Consider increasing the unit cost instead.';
        ChangeExtendedTextErr: Label 'You cannot change %1 for Extended Text Line.', Comment = '%1= Field Caption';
        InvoiceOrOrderDocTypeErr: Label '%1 must be either %2 or %3.', Comment = '%1 - Document Type; %2, %3 - Purchase Document Type, Invoice or Order';
        CannotInsertPurchLineWithoutHeaderErr: Label 'You cannot insert a purchase line without a purchase header.';
        MustSpecifyErr: Label 'You must either specify %1 or %2.', Comment = '%1 = Field Caption; %2 = Field Caption';

    protected var
        Currency: Record Currency;
        HideValidationDialog: Boolean;
        StatusCheckSuspended: Boolean;
        SkipTaxCalculation: Boolean;
        TrackingBlocked: Boolean;

    /// <summary>
    /// Initializes outstanding quantities and amounts of the purchase line.
    /// </summary>

    /// <summary>
    /// Initializes the outstanding amounts of the purchase line.
    /// </summary>
}
