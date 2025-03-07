query 50008 "Transfer Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'transferApproval';
    EntitySetName = 'transferApprovalEntity';
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
                dataitem(EmployeeTransfer; "Employee/HR Transfer")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(number; "No.") { }
                    column(type; Type)
                    {
                    }
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name") { }
                    column(salaryLevel; "Salary Level Code") { }
                    column(department; Department) { }
                    column(departmentName; "Department Name") { }
                    column(branchCode; "Shortcut Dimension 1 Code") { }
                    column(branchName; "Branch Name") { }
                    column(functionalTitle; "Functional Title") { }
                    column(startDate; "Start Date") { }
                    column(startDateBS; "Start Date (BS)") { }
                    column(endDate; "End Date") { }
                    column(endDateBS; "End Date (BS)") { }
                    column(noOfdays; "No. of Days") { }
                    column(requestedDate; "Requested Date") { }
                    column(fiscalYear; "Fiscal Year") { }
                    column(approvalStatus; "Approval Status") { }
                    column(status; Status) { }
                    column(isTransferDetailsAdded; "Is Transfer Details Added") { }
                    column(transferProposeDate; "Transfer Propose Date") { }
                    column(reasonCode; "Reason Code") { }
                    column(reasonDescription; "Reason Description") { }
                    column(reasonForTransfer; "Reason for Transfer") { }
                    column(subProvinceCode; "Sub Province Code") { }
                    column(provinceCode; "Province Code") { }
                    column(unitCode; "Unit Code") { }
                    column(remarks; Remarks) { }
                    column(screenerRemarks; "Screener Remarks") { }
                    column(rejectionRemarks; "Rejection Remarks") { }

                    column(transferType; "Transfer Type") { }
                    column(deputationOn; "Deputation On") { }
                    column(extensionCounterCode; "Extension Counter Code") { }
                    column(shortcutDimension1CodeTo; "Shortcut Dimension 1 Code (To)") { }
                    column(subProvinceCodeTo; "Sub Province Code (To)") { }
                    column(functionalTitleTo; "Functional Title (To)") { }
                    column(provinceCodeTo; "Province Code (To)") { }
                    column(unitTo; "Unit (To)") { }
                    column(departmentCodeTo; "Department Code (To)") { }
                    column(reportingLine1To; "Reporting Line 1 (To)") { }
                    column(reportingLine2To; "Reporting Line 2 (To)") { }
                    column(officeCode; "Office Code") { }
                    column(ecoSystemTo; "Eco-System (To)") { }
                    column(officeTo; "Office (To)") { }
                    column(extensionCounterTo; "Extension Counter (To)") { }
                    column(deputationOnTo; "Deputation On (To)") { }
                    column(proposedTransferDate; "Transfer Effective Date") { }
                    column(incomingSupervisior; "Incoming Supervisior") { }
                    column(incomingSupervisiorName; "Incoming Supervisior Name") { }
                    column(outgoingBranchRepPerson; "Outgoing Branch Rep. Person")
                    {
                    }
                    column(outgoingReportingPersonName; "Outgoing Reporting Person Name") { }
                    column(dateofJoiningOfTransfer; "Date of Joining Of Transfer") { }
                    column(description; Description) { }

                    column(transferRemarks; "Transfer Remarks") { }
                    column(relocationAllow; "Relocation Allow.") { }
                    column(outstationDiscomfortAllow; "Outstation/Discomfort Allow.") { }
                    column(BMAccomodationAllow; "BM Accomodation Allow.") { }
                    column(remoteAreaAllow; "Remote Area Allow.") { }
                    column(officiatingAllow; "Officiating Allow.") { }
                    column(relocationDistance; "Relocation Distance") { }
                    column(outstationDistance; "Outstation Distance") { }
                    column(BMAFDistance; "BMAF Distance") { }
                    column(transferAllowanceApproval; "Transfer Allowance Approval") { }
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
