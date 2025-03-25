// Approver API list
query 50013 "Resignation Clearance Approver"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'resignationClearanceApproval';
    EntitySetName = 'resignationClearanceApprovalEntity';
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
            dataitem(DocumentApprover; "Document Approver")
            {
                DataItemLink = "Employee No." = employee."No.";
                column(no; "Document No.")
                {

                }
                column(approvalStatusLine; "Approval Status")
                {

                }
                dataitem(Resignation; Resignation)
                {
                    DataItemLink = "No." = DocumentApprover."Document No.";
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