table 33019883 "Vacancy Line"
{
    DataClassification = CustomerContent;
    // version HRM1.00

    fields
    {
        field(1; "Vacancy No."; Code[20]) { }
        field(2; "Banking Experince"; Decimal) { }
        field(3; "Non Banking Experince"; Decimal) { }
        field(4; "Minimum Age"; Integer) { }
        field(5; "No. of People"; Integer)
        {
            trigger OnValidate()
            begin
                if SalaryLevel.Get("Salary Level") then begin
                    Employee.Reset;
                    Employee.SetRange("Salary Level", "Salary Level");
                    if SalaryLevel.Darbandi < (Employee.Count + "No. of People") then
                        Error('Darbandi allcoated is %1 which is less than employee count %2 and no. of people %3 for salary level %4.', SalaryLevel.Darbandi, Employee.Count, "No. of People", SalaryLevel.Description);
                end;
            end;
        }
        field(6; "Salary Level"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(7; "Qualification Code"; Code[20])
        {
            TableRelation = Qualification.Code where(Type = const(Education));

            trigger OnValidate()
            begin
                if Qualification.Get("Qualification Code") then
                    Validate(Rank, Qualification.Rank)
                else
                    Clear(Rank);
            end;
        }
        field(8; Rank; Integer)
        {
            Editable = false;
        }
        field(9; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(10; "Maximum Age"; Decimal) { }
    }

    keys
    {
        key(Key1; "Vacancy No.", "Salary Level", "Functional Title") { }
    }

    fieldgroups { }

    var
        Qualification: Record Qualification;
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
}
