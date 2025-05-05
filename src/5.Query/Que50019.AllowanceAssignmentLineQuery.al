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
                dataitem(AllowanceAssignmentLine; "Allowance Assignment Line")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
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
                    column(approvalStatus; "Approval Status")
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