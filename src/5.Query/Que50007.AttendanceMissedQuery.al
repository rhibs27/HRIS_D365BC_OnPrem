query 50007 "Attendance Missed Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'attendanceMissedApproval';
    EntitySetName = 'attendanceMissedApprovalEntity';
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
                dataitem(AttendanceMissed; "Attendance Missed")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name")
                    {
                    }
                    column(startDate; "Start Date")
                    {
                    }

                    column(endDate; "End Date")
                    {
                    }
                    column(startDateBS; "Start Date (BS)")
                    {
                    }
                    column(endDateBS; "End Date (BS)")
                    {
                    }
                    column(type; Type)
                    {
                    }
                    column(requestedDate; "Requested Date")
                    {
                    }

                    column(remarks; Remarks)
                    {
                    }
                    column(approvalStatus; "Approval Status")
                    {
                    }
                    column(status; Status)
                    {
                    }
                    column(rejectionRemarks; "Rejection Remarks")
                    {
                    }
                    column(reasonCode; "Reason Code")
                    {
                    }
                    column(reasonDescription; "Reason Description")
                    {
                    }
                    // column(noOfDays; "No. of Days")
                    // {
                    // }
                }
            }

        }
    }
    trigger OnBeforeOpen()
    var
        Hrmgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, Hrmgt.GetEmployeeNo());
    end;
}
