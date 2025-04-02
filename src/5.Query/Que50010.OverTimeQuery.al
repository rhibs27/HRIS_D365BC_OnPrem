query 50010 "OverTime Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'overTimeApproval';
    EntitySetName = 'overtimeApprovalEntity';
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
                    // column(salaryLevel; "Salary Level Code") { }
                    // column(department; Department) { }
                    // column(departmentName; "Department Name") { }
                    // column(branchCode; "Shortcut Dimension 1 Code") { }
                    // column(branchName; "Branch Name") { }
                    // column(functionalTitle; "Functional Title") { }
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(checkInTime; "Check In Time") { }
                    column(checkOutTime; "Check Out Time") { }
                    // column(endDate; "End Date") { }
                    // column(endDateBS; "End Date (BS)") { }
                    // column(noOfDays; "No. of Days") { }
                    column(requestedDate; "Requested Date") { }
                    // column(fiscalYear; "Fiscal Year") { }
                    column(approvalStatus; "Approval Status") { }
                    // column(cancelled; Cancelled) { }
                    column(reasonCode; "Reason Code") { }
                    column(reasonDescription; "Reason Description") { }
                    column(remarks; Remarks) { }
                    column(rejectionRemarks; "Rejection Remarks") { }
                    column(Status; status) { }
                    column(TimeDuration; "Time Duration") { }
                    column(ActualHours; "Actual OT Hours") { }
                    // column(EstimatedHours; "Estimated Hours") { }
                    column(EncashmentCode; "Encashment Code") { }
                    column(morningOThrs; "Morning OT Hours")
                    {
                    }
                    column(eveningOThrs; "Evening OT Hours")
                    {
                    }
                    column(OTAmount; "OT Amount") { }
                    column(OTDisbursed; "OT Disbursed") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HRMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HRMgt.GetEmployeeNo());
        CurrQuery.SetRange(type, type::Overtime);
    end;
}