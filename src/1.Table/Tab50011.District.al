table 50011 District
{
    LookupPageId = "District List Page";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "District Code"; Code[10]) { }
        field(2; "District Name"; Text[30]) { }
        field(3; Province; Code[10])
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
        field(5; "Sub-Province Code"; Code[20])
        {
            TableRelation = "Sub Province" where("Province Code" = field(Province));

            trigger OnValidate()
            var
                SubProvinceVar: Record "Sub Province";
            begin
                SubProvinceVar.Reset;
                SubProvinceVar.SetRange(Code, "Sub-Province Code");
                if SubProvinceVar.FindFirst then
                    Validate("Sub-Province Name", SubProvinceVar.City)
                else
                    Clear("Sub-Province Name");
            end;
        }
        field(6; "Sub-Province Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "District Name(Nepali)"; Text[30])
        {
            Description = 'In Nepali';
        }
    }

    keys
    {
        key(Key1; "District Code") { }
        key(Key2; "District Name", "District Code") { }
    }

    fieldgroups { }
}
