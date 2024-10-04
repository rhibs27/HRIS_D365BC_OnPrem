table 50051 "Required Emp In Branch"
{
    DataClassification = CustomerContent;
    // version NIC Asia 1.0,Recruitement (Matrix)

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = if ("Deputation On" = const(Branch)) "Dimension Value".Code where("Global Dimension No." = const(1))
            else if ("Deputation On" = const(Department)) Department
            else if ("Deputation On" = const("Extension Counter")) "Employee Hierarchy Master".Code where(Type = const("Extension Counter"))
            else if ("Deputation On" = const(Province)) Province.Code
            else if ("Deputation On" = const("Sub Province")) "Sub Province".Code
            else if ("Deputation On" = const(Unit)) "Employee Hierarchy Master".Code where(Type = const(Unit));
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
        field(8; "Reporting Category"; Code[20])
        {
            TableRelation = "Reporting Category";
        }
        field(9; "Deputation On"; Enum "Deputation Type")
        {

        }
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
