table 50005 "E3 Integration API Setup"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Integration Enabled"; Boolean)
        {
            Caption = 'Integration Enabled';
            DataClassification = CustomerContent;
        }

        field(3; Username; Text[50])
        {
            Caption = 'Username';
            DataClassification = CustomerContent;
        }
        field(4; Password; Text[50])
        {
            Caption = 'Password';
            DataClassification = CustomerContent;
        }
        field(5; Host; Text[100])
        {
            Caption = 'Host';
            DataClassification = CustomerContent;
        }
        field(6; "Item Type API"; Text[100])
        {
            Caption = 'Item Type API';
            DataClassification = CustomerContent;
        }
        field(7; "Item Type API Enabled"; Boolean)
        {
            Caption = 'Item Type API';
            DataClassification = CustomerContent;
        }
        field(8; "Item Model API"; Text[100])
        {
            Caption = 'Item Model API';
            DataClassification = CustomerContent;
        }
        field(9; "Item Model API Enabled"; Boolean)
        {
            Caption = 'Item Model API Enabled';
            DataClassification = CustomerContent;
        }
        field(10; "Item Strength API"; Text[100])
        {
            Caption = 'Item Strength API';
            DataClassification = CustomerContent;
        }
        field(11; "Item Strength API Enabled"; Boolean)
        {
            Caption = 'Item Strength API Enabled';
            DataClassification = CustomerContent;
        }
        field(12; "Item Property API"; Text[100])
        {
            Caption = 'Item Property API';
            DataClassification = CustomerContent;
        }
        field(13; "Item Property API Enabled"; Boolean)
        {
            Caption = 'Item Property API Enabled';
            DataClassification = CustomerContent;
        }
        field(14; "Medicine SubCat API"; Text[100])
        {
            Caption = 'Medicine SubCategory API';
            DataClassification = CustomerContent;
        }
        field(15; "Medicine SubCat API Enabled"; Boolean)
        {
            Caption = 'Medicine SubCategory API Enabled';
            DataClassification = CustomerContent;
        }
        field(16; "Sub Group Nature API"; Text[100])
        {
            Caption = 'Sub Group Nature API';
            DataClassification = CustomerContent;
        }
        field(17; "Sub Group Nature API Enabled"; Boolean)
        {
            Caption = 'Sub Group Nature API Enabled';
            DataClassification = CustomerContent;
        }
        field(18; "Item Category API"; Text[100])
        {
            Caption = 'Item Category API';
            DataClassification = CustomerContent;
        }
        field(19; "Item Category API Enabled"; Boolean)
        {
            Caption = 'Item Category API Enabled';
            DataClassification = CustomerContent;
        }
        field(20; "Item Make API"; Text[100])
        {
            Caption = 'Item Make API';
            DataClassification = CustomerContent;
        }
        field(21; "Item Make API Enabled"; Boolean)
        {
            Caption = 'Item Make API Enabled';
            DataClassification = CustomerContent;
        }
        field(22; "Medicine Component API"; Text[100])
        {
            Caption = 'Medicine Component API';
            DataClassification = CustomerContent;
        }
        field(23; "Medicine Component API Enabled"; Boolean)
        {
            Caption = 'Medicine Component API Enabled';
            DataClassification = CustomerContent;
        }
        field(24; "Item Speciality API"; Text[100])
        {
            Caption = 'Item Speciality API';
            DataClassification = CustomerContent;
        }
        field(25; "Item Speciality API Enabled"; Boolean)
        {
            Caption = 'Item Speciality API Enabled';
            DataClassification = CustomerContent;
        }
        field(26; "Material Category API"; Text[100])
        {
            Caption = 'Material Category API';
            DataClassification = CustomerContent;
        }
        field(27; "Material Category API Enabled"; Boolean)
        {
            Caption = 'Material Category API Enabled';
            DataClassification = CustomerContent;
        }
        field(28; "Material Type API"; Text[100])
        {
            Caption = 'Material Type API';
            DataClassification = CustomerContent;
        }
        field(29; "Material Type API Enabled"; Boolean)
        {
            Caption = 'Material Type API Enabled';
            DataClassification = CustomerContent;
        }
        field(30; "Restricted Group API"; Text[100])
        {
            Caption = 'Restricted Group API';
            DataClassification = CustomerContent;
        }
        field(31; "Restricted Group API Enabled"; Boolean)
        {
            Caption = 'Restricted Group API Enabled';
            DataClassification = CustomerContent;
        }
        field(32; "Medicine Composition API"; Text[100])
        {
            Caption = 'Medicine Composition API';
            DataClassification = CustomerContent;
        }
        field(33; "Medi Composition API Enabled"; Boolean)
        {
            Caption = 'Medi Composition API Enabled';
            DataClassification = CustomerContent;
        }
        field(34; "Sub Group Site API"; Text[100])
        {
            Caption = 'Sub Group Site API';
            DataClassification = CustomerContent;
        }
        field(35; "Sub Group Site API Enabled"; Boolean)
        {
            Caption = 'Sub Group Site API Enabled';
            DataClassification = CustomerContent;
        }
        field(36; "Vendor Master API"; Text[100])
        {
            Caption = 'Vendor Master API';
            DataClassification = CustomerContent;
        }
        field(37; "Vendor Master API Enabled"; Boolean)
        {
            Caption = 'Vendor Master API Enabled';
            DataClassification = CustomerContent;

            // trigger OnValidate()
            // begin
            //     EnqueueJobEntry('FAILOVERSUPPLIER')
            // end;
        }
        field(38; "Item Master API"; Text[100])
        {
            Caption = 'Item Master API';
            DataClassification = CustomerContent;
        }
        field(39; "Item Master API Enabled"; Boolean)
        {
            Caption = 'Item Master API Enabled';
            DataClassification = CustomerContent;
        }
        field(40; "State Master API"; Text[100])
        {
            Caption = 'State Master API';
            DataClassification = CustomerContent;
        }
        field(41; "State Master API Enabled"; Boolean)
        {
            Caption = 'State Master API Enabled';
            DataClassification = CustomerContent;
        }
        field(42; "HSN/SAC API"; Text[100])
        {
            Caption = 'HSN/SAC API';
            DataClassification = CustomerContent;
        }
        field(44; "HSN/SAC API Enabled"; Boolean)
        {
            Caption = 'HSN/SAC API Enabled';
            DataClassification = CustomerContent;
        }
        field(45; "Department API"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Department API';
        }
        field(46; "Department API Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Department API Enabled';
        }
        field(47; "UOM API"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'UOM API';
        }
        field(48; "UOM API Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'UOM API Enabled';
        }
        field(49; "GRN Work Sheet API"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'GRN Work Sheet API';
        }
        field(50; "GRN Work Sheet API Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'GRN Work Sheet API Enabled';
        }


    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}