table 50091 "Branchwise/Extension Allowance"
{
    DataCaptionFields = "Code", "Allowance Type";
    DrillDownPageId = "Branchwise/Extension Counter";
    LookupPageId = "Branchwise/Extension Counter";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = if (Type = filter("Branchwise/Extension Type"::Branch)) "Organization Structure List".Code where(Type = Filter("Deputation Type"::Branch), Blocked = filter(false))
            else if (Type = filter("Branchwise/Extension Type"::"Extension Counter")) "Organization Structure List".Code where(Type = Filter("Deputation Type"::"Extension Counter"), Blocked = filter(false));

            trigger OnValidate()
            begin
                Clear(Name);
                if Type = Type::Branch then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, Code) then
                        Name := OrganizationStructureList.Name;
                end else if Type = Type::"Extension Counter" then begin
                    if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", Code) then
                        Name := OrganizationStructureList.Name;
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Editable = false;
        }
        field(3; "Allowance Type"; Code[20])
        {
            TableRelation = "Payroll Attributes";
        }
        field(4; "Max. No. of Staffs"; Integer)
        {
            MinValue = 0;
        }
        field(5; Type; Enum "Branchwise/Extension Type")
        {

        }
        field(6; Disabled; Boolean) { }
    }

    keys
    {
        key(Key1; Type, "Code", "Allowance Type") { }
    }

    fieldgroups { }

    var
        OrganizationStructureList: Record "Organization Structure List";
}
