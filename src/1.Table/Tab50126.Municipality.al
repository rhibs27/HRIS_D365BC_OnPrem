table 50126 Municipality
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Municipality Name"; Text[50]) { }
        field(3; "District Code"; Code[20])
        {
            Caption = 'District Code';
            TableRelation = District;
            trigger OnValidate()
            var
                District: Record District;
            begin
                if District.Get("District Code") then
                    Validate("District Name", District."District Name")
                else
                    Error('The specified district code does not exist in the District table.');
            end;
        }
        field(4; "District Name (In Nepali)"; Text[50])
        {
            Caption = 'District Name (In Nepali) ';
        }
        field(5; "No of ward"; Integer)
        {
            Caption = 'No of ward';
        }
        field(6; Type; Enum "Municipality Type")
        {
            Caption = 'Municipality Type';
        }
        field(7; "District Name"; Text[50])
        {
            Caption = 'District Name';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Municipality Name")
        {
        }
    }
}
