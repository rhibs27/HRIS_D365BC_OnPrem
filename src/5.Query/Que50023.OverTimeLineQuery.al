query 50023 "OverTimeLine Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overtimeBulkApproval';
    EntitySetName = 'overtimeBulkApprovalEntity';
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
            dataitem(ApprovalHRMS; "Approval HRMS")
            {
                DataItemLink = "Approver No" = employee."No.";
                column(no; "Document No.")
                {

                }
                column(approverCode; "Approver No")
                {

                }
                column(approverName; "Approver Name")
                {

                }
                column(approvalStatusLine; "Approval Status")
                {

                }
                column(approvalSequence; "Approval Sequence")
                {

                }
                dataitem(OverTime; OverTime)
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(type; Type) { }
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name") { }
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(checkInTime; "Check In Time") { }
                    column(checkOutTime; "Check Out Time") { }
                    column(overtimeClaimType; "Overtime Claim Type") { }
                    column(requestedDate; "Requested Date") { }
                    column(approvalStatus; "Approval Status") { }
                    column(remarks; Remarks) { }
                    column(rejectionRemarks; "Rejection Remarks") { }
                    column(status; status) { }
                    dataitem(OverTimeLine; "OverTime Line")
                    {
                        DataItemLink = "No." = OverTime."No.";
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
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(employeeNameLine, HRMgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::"Overtime Bulk");
    end;
}