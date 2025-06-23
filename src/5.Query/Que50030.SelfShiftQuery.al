query 50030 "Self Shift Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'shiftSelf';
    EntitySetName = 'shiftSelfEntity';
    QueryType = API;
    OrderBy = descending(no);
    elements
    {
        dataitem(employee; Employee)
        {
            column(empNo; "No.")
            {
            }
            column(navLoginID; "NAV Login ID")
            {
            }
            column(fullName; "Full Name")
            {
            }
            dataitem(ShiftLine; "Shift Line")
            {
                DataItemLink = "Employee No" = Employee."No.";
                column(no; "No.") { }
                column(lineNo; "Line No") { }
                column(employeeName; "Employee Name") { }
                column(rosterDate; "Roster Date") { }
                column(deputationType; "Deputation Type") { }
                column(employeeWorkShift; "Employee Work Shift") { }
                column(deputationCode; "Deputation Code") { }
                column(deputationName; "Deputation Name") { }
                column(approvalStatus; "Approval Status") { }
                column(remarks; Remarks) { }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HRMgt.GetEmployeeNo());
    end;
}