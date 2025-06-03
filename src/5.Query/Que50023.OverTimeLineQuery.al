query 50023 "OverTimeLine Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overtimeBulk';
    EntitySetName = 'overtimeBulkEntity';
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
                column(empNoLine; "Employee Code")
                {
                }
                column(employeeNameLine; "Employee Name") { }
                column(startDateLine; "Overtime Date") { }
                column(startDateBSLine; "Overtime Date (BS)") { }
                column(checkInTimeLine; "Check In Time") { }
                column(checkOutTimeLine; "Check Out Time") { }
                column(overtimeClaimTypeLine; "Overtime Claim Type") { }
                column(totalOTHoursLine; "Total OT Hours") { }
                column(actualHoursLine; "Actual OT Hours") { }
                column(oTAmountLine; "OT Amount") { }
                column(approvalStatusLineOvertime; "Approval Status") { }
                column(remarksLine; Remarks) { }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNoLine, HRMgt.GetEmployeeNo());
    end;
}