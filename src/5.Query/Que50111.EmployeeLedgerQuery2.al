query 50111 "Employee Ledger Query 2"
{
    Caption = 'Employee Ledger Query';
    QueryType = Normal;
    DataAccessIntent = ReadOnly;
    elements
    {
        dataitem(DetailedEmployeeLedgerEntry; "Detailed Employee Ledger Entry")
        {
            DataItemTableFilter = "Non-Taxable" = const(true), Reversed = const(false);
            filter("Employee_No"; "Employee No.") { }
            filter("Posting_Date"; "Posting Date") { }
            column("Amount"; Amount)
            {
                Method = Sum;
            }
        }
    }

    procedure SetEmpDetailFilter(employeeNo: Code[20]; postingDateFrom: Date; postingDateTo: Date)
    begin
        SetRange(Employee_No, employeeNo);
        SetRange(Posting_Date, postingDateFrom, postingDateTo);
    end;
}
