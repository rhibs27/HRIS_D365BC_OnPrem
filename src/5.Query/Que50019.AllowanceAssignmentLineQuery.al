query 50019 "Allowance Assign Line Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'allowanceLineApproval';
    EntitySetName = 'allowanceAssignLineEntity';
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
            dataitem(AllowanceAssignmentLine; "Allowance Assignment Line")
            {
                DataItemLink = "Employee Code" = employee."No.";
                column(no; "No.") { }
                column(lineNo; "Line No.")
                {
                }
                column(type; Type)
                {
                }
                column(code; Code)
                {
                }
                column(allowanceType; "Allowance Type")
                { }
                column(fromDate; "From Date")
                {
                }
                column(employeeCode; "Employee Code")
                {
                }
                column(employeeName; "Employee Name")
                {
                }
                column(toDate; "To Date")
                {
                }
                column(noOfDays; "No. of Days")
                {
                }
                column(isSubstitute; "Substitute Type")
                {
                }
                column(panel; Panel)
                {
                }
                column(allowanceAmount; "Allowance Amount")
                {
                }

                column(approvalStatus; "Approval Status")
                {
                }
            }
        }
    }
    trigger OnBeforeOpen()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HrMgt.GetEmployeeNo());
        CurrQuery.SetRange(approvalStatus, approvalStatus::Approved);
    end;
}