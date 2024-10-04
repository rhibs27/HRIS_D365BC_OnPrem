table 50006 "Employee Payroll Opening"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then
                    Validate("Employee Name", EmpVar."Full Name")
                else
                    Clear("Employee Name");

                EmpPayOpen.Reset;
                EmpPayOpen.SetRange("Employee No.", "Employee No.");
                EmpPayOpen.SetRange("Fiscal Year", "Fiscal Year");
                if EmpPayOpen.FindFirst then
                    Error('Employee Payroll opening already exist for this fiscal year.');
            end;
        }
        field(2; "Line No."; Integer) { }
        field(3; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Fiscal Year"; Code[10]) { }
        field(5; "Total Benefit Opening"; Decimal) { }
        field(6; "Total RF Opening"; Decimal) { }
        field(7; "Total Social Security Opening"; Decimal) { }
        field(8; "Total Tax Remuneration Opening"; Decimal) { }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.") { }
    }

    fieldgroups { }

    var
        EmpVar: Record Employee;
        EmpPayOpen: Record "Employee Payroll Opening";
}
