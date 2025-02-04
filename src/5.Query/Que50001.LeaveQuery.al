query 50001 "Leave Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'leaveApproval';
    EntitySetName = 'leaveApprovalEntity';
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
                column(approvalStatus; "Approval Status")
                {

                }
                column(approverName; "Approver Name")
                {

                }
                column(approvalSequence; "Approval Sequence")
                {

                }
                dataitem(Leave; Leave)
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
                    column(noOfDays; "No. of Days")
                    {

                    }
                    column(requestedDate; "Requested Date")
                    {

                    }
                    column(approverType; "Approver Type")
                    {

                    }
                    column(leaveCode; "Leave Code")
                    {

                    }
                    column(leaveDescription; "Leave Description")
                    {

                    }
                    column(leaveType; "Leave Type")
                    {

                    }
                    column(compensatoryDate; "Compensatory Date")
                    {

                    }
                    column(childGender; "Child's Gender")
                    {

                    }
                    column(forDeathOf; "For Death Of")
                    {

                    }
                    column(contactNo; "Contact No.")
                    {

                    }
                    column(remarks; Remarks)
                    {

                    }
                    column(rejectionRemarks; "Rejection Remarks")
                    {

                    }
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
