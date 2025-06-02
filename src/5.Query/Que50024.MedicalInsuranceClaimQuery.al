query 50024 "Medical Insurance Claim Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'medialInsuranceClaimApproval';
    EntitySetName = 'medialInsuranceClaimApprovalEntity';
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
                dataitem(MedicalInsuranceClaim; "Medical Insurance Claim")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(type; Type) { }
                    column(employeeNo; "Employee No.") { }
                    column(employeeName; "Employee Name") { }
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(requestedDate; "Requested Date") { }
                    column(approvalStatus; "Approval Status") { }
                    column(remarks; Remarks) { }
                    column(rejectionRemarks; "Rejection Remarks") { }
                    column(status; status) { }
                    column(endDate; "End Date") { }
                    column(endDateBS; "End Date (BS)") { }
                    column(fiscalYear; "Fiscal Year") { }
                    column(cancelledNo; "Cancelled No.") { }
                    column(cancelledDocNo; "Cancelled Document No.") { }
                    column(insuranceClaim; "Insurance Claim") { }
                    column(fatherName; "Father Name") { }
                    column(motherName; "Mother Name") { }
                    column(spouseName; "Spouse Name") { }
                    column(childName; "Child Name") { }
                    column(totalInsuranceClaimAmount; "Total Insurance Claim Amount") { }
                    column(medicalPrescriptionDate; "Medical Prescription Date") { }
                    column(dischargeDate; "Discharge Date")
                    {
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
        CurrQuery.SetRange(type, type::"Medical Insurance Claim");
    end;
}