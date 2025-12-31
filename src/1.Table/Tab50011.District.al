table 50011 District
{
    LookupPageId = "District";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "District Code"; Code[20]) { }
        field(2; "District Name"; Text[50]) { }
        field(3; Province; Code[20])
        {
            TableRelation = Province;
            trigger OnValidate()
            var
                ProvinceVar: Record Province;
            begin
                if ProvinceVar.Get(Province) then
                    Validate("Province Name", ProvinceVar.Description)
                else
                    Clear("Province Name");
            end;
        }
        field(4; "Province Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Region; Enum Region)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "InsideOutside Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = ToBeClassified;
            ValuesAllowed = Inside, Outside;
        }
        field(7; "District Name(Nepali)"; Text[50])
        {
            Description = 'In Nepali';
        }
    }
    keys
    {
        key(Key1; "District Code") { }
        key(Key2; "District Name") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "District Code", "District Name") { }
    }
}
