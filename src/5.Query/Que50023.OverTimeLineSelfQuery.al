query 50023 "OverTimeLine Self Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overtimeBulkSelf';
    EntitySetName = 'overtimeSelfBulkEntity';
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
            dataitem(OverTimeLine; "OverTime Line")
            {
                DataItemLink = "Employee Code" = Employee."No.";
                column(no; "No.") { }
                column(lineNo; "Line No.") { }
                column(employeeName; "Employee Name") { }
                column(startDate; "Overtime Date") { }
                column(startDateBS; "Overtime Date (BS)") { }
                column(checkInTime; "Check In Time") { }
                column(checkOutTime; "Check Out Time") { }
                column(overtimeClaimType; "Overtime Claim Type") { }
                column(totalOTHours; "Total OT Hours") { }
                column(actualOTHours; "Actual OT Hours") { }
                column(oTAmount; "OT Amount") { }
                column(deputationType; "Deputation Type") { }
                column(employeeWorkShift; "Employee Work Shift") { }
                column(type; Type) { }
                column(deputationName; Name) { }
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