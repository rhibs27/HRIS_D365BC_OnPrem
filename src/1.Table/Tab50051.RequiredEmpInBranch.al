table 50051 "Required Emp In Branch"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = if ("Deputation On" = filter("Deputation Type"::Branch)) "Organization Structure List".Code where(Type = filter("Deputation Type"::Branch))
            else if ("Deputation On" = filter("Deputation Type"::Department)) "Organization Structure List".Code where(Type = filter("Deputation Type"::Department))
            else if ("Deputation On" = filter("Deputation Type"::"Extension Counter")) "Organization Structure List".Code where(Type = filter("Deputation Type"::"Extension Counter"))
            else if ("Deputation On" = filter("Deputation Type"::Province)) "Organization Structure List".Code where(Type = filter("Deputation Type"::Province))
            else if ("Deputation On" = filter("Deputation Type"::Unit)) "Organization Structure List".Code where(Type = filter("Deputation Type"::Unit));
        }
        field(2; Description; Text[50]) { }
        field(3; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";

            trigger OnValidate()
            begin
                if FunctionalTitle.Get("Functional Title") then
                    Validate("Functional Tilte Description", FunctionalTitle.Description)
                else
                    Clear("Functional Tilte Description");
            end;
        }
        field(4; "Functional Tilte Description"; Text[50]) { }
        field(5; "Required Employee"; Integer) { }
        field(6; "Salary Level Code"; Code[20])
        {
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
                if SalaryLevel.Get("Salary Level Code") then
                    "Salary Level" := SalaryLevel.Description
                else
                    "Salary Level" := '';
            end;
        }
        field(7; "Salary Level"; Text[50])
        {
            Editable = false;
        }
        // field(8; "Reporting Category"; Code[20])
        // {
        //     // TableRelation = "Reporting Category";
        // }
        field(9; "Deputation On"; Enum "Deputation Type") { }
        field(10; "Fiscal Year"; Text[10]) { }
    }

    keys
    {
        key(Key1; "Code", "Functional Title") { }
    }

    fieldgroups { }

    var
        FunctionalTitle: Record "Functional Title";
        SalaryLevel: Record "Salary Level";
}
