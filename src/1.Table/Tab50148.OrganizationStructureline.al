table 50148 "Organization Structure line"
{
    Caption = 'Organization Structure line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "Deputation Type")
        {
            Caption = 'Type';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; "Reporting Type"; Enum "Deputation Type")
        {
            Caption = 'Reporting Type';
        }
        field(4; "Reporting Code"; Code[20])
        {
            Caption = 'Reporting Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Reporting Type"));
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if OrganizationStructureList.Get("Reporting Type", "Reporting Code") then
                    Validate("Reporting Name", OrganizationStructureList.Name);
            end;
        }
        field(5; "Reporting Name"; Text[100])
        {
            Caption = 'Reporting Name ';
            Editable = false;

        }
    }
    keys
    {
        key(PK; "Type", Code, "Reporting Type", "Reporting Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Reporting Code", "Reporting Name")
        {
        }
    }
}
