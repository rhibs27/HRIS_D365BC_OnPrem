table 50103 "Employee Code Mapping"
{
    // version AMS6.1.0

    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Employee Mapping Code"; Code[20]) { }
        field(3; "Employee Name"; Text[80])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Employee Mapping Code") { }
    }

    fieldgroups { }
}
