query 50011 "Resignation Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'resignationApproval';
    EntitySetName = 'resignationApprovalEntity';
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
                dataitem(Resignation; Resignation)
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(type; Type) { }
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name") { }
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(endDate; "End Date") { }
                    column(endDateBS; "End Date (BS)") { }

                    column(requestedDate; "Requested Date") { }
                    column(approvalStatus; "Approval Status") { }
                    column(Status; status) { }
                    column(cancelled; Cancelled) { }
                    column(reasonCode; "Reason Code") { }
                    column(reasonDescription; "Reason Description") { }
                    column(remarks; Remarks) { }
                    column(rejectionRemarks; "Rejection Remarks") { }

                    column(proposedDateOfResignation; "Proposed Date of Resignation") { }
                    // column(supervisorProposedDate; "Supervisor Proposed Date") { }
                    column(hRProposedDate; "HR Proposed Date") { }
                    column(waiverCase; "Waiver Case") { }
                    column(reasonForResignation; "Reason for Resignation") { }
                    column(applyForWaiver; "Apply for Waiver") { }
                }
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