table 50129 "KPI Target Raw"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            var
                EmployeeRec: Record Employee;
            begin
                EmployeeRec.Get("Employee Code");
                "Functional Title" := EmployeeRec."Functional Title";
            end;
        }
        field(3; "KPI Code"; Code[20])
        {
            TableRelation = "KPI Master";

            trigger OnValidate()
            begin
                KPIMaster.Get("KPI Code");
                "KPI Description" := KPIMaster.Description;
            end;
        }
        field(4; "KPI Description"; Text[250]) { }
        field(5; "Target Score"; Decimal) { }
        field(6; "Start Date"; Date) { }
        field(7; "End Date"; Date) { }
        field(8; Department; Code[20])
        {
            TableRelation = Department;

            trigger OnValidate()
            begin
                if DepartmentRec.Get(Department) then
                    "Department Name" := DepartmentRec.Name;
            end;
        }
        field(9; "Department Name"; Text[50]) { }
        field(10; Type; Enum EmployeeDepartment)
        {
        }
        field(11; "Assigned By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(12; "Expire Target"; Boolean) { }
        field(13; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
    }

    keys
    {
        key(Key1; "Line No.") { }
    }

    fieldgroups { }

    var
        KPIMaster: Record "KPI Master";
        DepartmentRec: Record Department;
}
