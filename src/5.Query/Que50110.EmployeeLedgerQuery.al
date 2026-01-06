query 50110 "Employee Ledger Query"
{
    Caption = 'Employee Ledger Query';
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(DetailedEmployeeLedgerEntry; "Detailed Employee Ledger Entry")
        {
            filter("Employee_No"; "Employee No.") { }
            filter("Payroll_Attribute_Code"; "Payroll Attribute Code") { }
            filter("Posting_Date"; "Posting Date") { }
            filter("Attribute_Type"; "Attribute Type") { }
            column("Amount"; Amount)
            {
                Method = Sum;
            }
        }
    }

    procedure SetEmpDetailFilter(employeeNo: Code[20]; payrollAttrCode: Code[20]; postingDateFrom: Date; postingDateTo: Date; attributeType: Integer)
    begin
        SetRange(Employee_No, employeeNo);
        SetRange(Payroll_Attribute_Code, payrollAttrCode);
        SetRange(Posting_Date, postingDateFrom, postingDateTo);
        SetRange(Attribute_Type, attributeType);
    end;
}
