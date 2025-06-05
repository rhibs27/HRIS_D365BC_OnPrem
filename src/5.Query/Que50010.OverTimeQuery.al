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
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(checkInTime; "Check In Time") { }
                    column(checkOutTime; "Check Out Time") { }
                    column(overTimeClaimType; "Overtime Claim Type") { }
                    // column(endDate; "End Date") { }
                    // column(endDateBS; "End Date (BS)") { }
                    // column(noOfDays; "No. of Days") { }
                    column(requestedDate; "Requested Date") { }
                    column(approvalStatus; "Approval Status") { }
                    column(remarks; Remarks) { }
                    column(rejectionRemarks; "Rejection Remarks") { }
                    column(status; status) { }
                    column(timeDuration; "Time Duration") { }
                    column(actualHours; "Actual OT Hours") { }
                    column(encashmentCode; "Encashment Code") { }
                    column(morningOThrs; "Morning OT Hours")
                    {
                    }
                    column(eveningOThrs; "Evening OT Hours")
                    {
                    }
                    column(compensatoryDays; "Compensatory Days") { }
                    column(employeeWorkShift; "Employee Work Shift") { }
                    column(totalOTHours; "Total OT Hours") { }
                    column(oTAmount; "OT Amount") { }
                    column(oTDisbursed; "OT Disbursed") { }
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