query 50016 "Cancel Document Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'cancelDocumentApproval';
    EntitySetName = 'cancelDocumentApprovalEntity';
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
                dataitem(CancelDocument; "Cancel Document")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(employeeNo; "Employee No.")
                    {
                        Caption = 'Employee No.';
                    }
                    column(employeeName; "Employee Name")
                    {
                        Caption = 'Employee Name';
                    }
                    column(employeeWorkShift; "Employee Work Shift")
                    {
                        Caption = 'Employee Work Shift';
                    }
                    column(cancelled; Cancelled)
                    {
                        Caption = 'Cancelled';
                    }
                    column(cancelledDocumentNo; "Cancelled Document No.")
                    {
                        Caption = 'Cancelled Document No.';
                    }
                    column(approvedDate; "Approved Date")
                    {
                        Caption = 'Approved Date';
                    }
                    column(approvalStatus; "Approval Status")
                    {
                        Caption = 'Approval Status';
                    }
                    column(endDate; "End Date")
                    {
                        Caption = 'End Date';
                    }
                    column(endDateBS; "End Date (BS)")
                    {
                        Caption = 'End Date (BS)';
                    }
                    column(fiscalYear; "Fiscal Year")
                    {
                        Caption = 'Fiscal Year';
                    }
                    column(functionalTitle; "Functional Title")
                    {
                        Caption = 'Functional Title';
                    }
                    column(leaveCode; "Leave Code")
                    {
                        Caption = 'Leave Code';
                    }
                    column(leaveDescription; "Leave Description")
                    {
                        Caption = 'Leave Description';
                    }
                    column(noOfDays; "No. of Days")
                    {
                        Caption = 'No. of Days';
                    }
                    column(rejectionRemarks; "Rejection Remarks")
                    {
                        Caption = 'Rejection Remarks';
                    }
                    column(remarks; Remarks)
                    {
                        Caption = 'Remarks';
                    }
                    column(requestedDate; "Requested Date")
                    {
                        Caption = 'Requested Date';
                    }
                    column(startDate; "Start Date")
                    {
                        Caption = 'Start Date';
                    }
                    column(startDateBS; "Start Date (BS)")
                    {
                        Caption = 'Start Date (BS)';
                    }
                    column(status; Status)
                    {
                        Caption = 'Status';
                    }
                    column("type"; "Type")
                    {
                        Caption = 'Type';
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HRMgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::"Leave Request");
    end;
}
