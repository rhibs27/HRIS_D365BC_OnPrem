query 50009 "Incoming Transfer Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'incomingTransferApproval';
    EntitySetName = 'incomingTransferApprovalEntity';
    QueryType = API;
    OrderBy = descending(no);

    elements
    {
        dataitem(EmployeeTransfer; "Employee/HR Transfer")
        {
            //general
            column(no; "No.") { }
            column(type; Type)
            {
            }
            column(employeeNo; "Employee No.")
            {
            }
            column(employeeName; "Employee Name") { }
            column(salaryLevel; "Salary Level Code") { }
            column(startDate; "Start Date") { }
            column(startDateBS; "Start Date (BS)") { }
            column(endDate; "End Date") { }
            column(endDateBS; "End Date (BS)") { }
            column(noOfdays; "No. of Days") { }
            column(requestedDate; "Requested Date") { }
            column(fiscalYear; "Fiscal Year") { }
            column(approvalStatus; "Approval Status") { }
            column(status; Status)
            {
            }
            column(isTransferDetailsAdded; "Is Transfer Details Added")
            {
            }
            column(transferProposeDate; "Transfer Propose Date")
            {
            }
            column(reasonCode; "Reason Code") { }
            column(reasonDescription; "Reason Description") { }
            column(reasonForTransfer; "Reason for Transfer") { }
            column(provinceCode; "Province Code") { }
            column(provinceName; "Province Name") { }
            column(unitCode; "Unit Code") { }
            column(approverRoleFrom; "Approver Role From") { }
            column(remarks; Remarks) { }
            column(screenerRemarks; "Screener Remarks") { }
            column(rejectionRemarks; "Rejection Remarks") { }
            column(transferType; "Transfer Type") { }
            //current
            column(department; Department) { }
            column(departmentName; "Department Name") { }
            column(branchCode; "From Branch") { }
            column(branchName; "Branch Name") { }
            column(functionalTitle; "Functional Title") { }
            column(functionalTitleDesc; "Functional Title Desc") { }
            column(extensionCounterName; "Extension Counter Name") { }
            column(unitName; "Unit Name") { }
            column(deputationOn; "Deputation On") { }
            column(extensionCounterCode; "Extension Counter Code") { }
            // propose
            column(shortcutDimension1CodeTo; "Shortcut Dimension 1 Code (To)") { }
            column(functionalTitleTo; "Functional Title (To)") { }
            column(functionalDescTo; "Functional Desc To") { }
            column(provinceCodeTo; "Province Code (To)") { }
            column(provinceNameTo; "Province Name To") { }
            column(unitTo; "Unit (To)") { }
            column(unitNameTo; "Unit Name To") { }
            column(departmentCodeTo; "Department Code (To)") { }
            column(departmentNameTo; "Department Name To") { }
            column(branchCodeTo; "To Branch") { }
            column(branchNameTo; "Branch Name To") { }
            column(extensionNameTo; "Extension Name To")
            {
            }
            column(extensionCounterTo; "Extension Counter (To)") { }
            column(deputationOnTo; "Deputation On (To)") { }
            column(approverRoleTo; "Approver Role To")
            {

            }
            column(proposedTransferDate; "Transfer Effective Date") { }
            column(incomingSupervisior; "Incoming Supervisior") { }
            column(incomingSupervisiorName; "Incoming Supervisior Name") { }
            column(outgoingBranchRepPerson; "Outgoing Branch Rep. Person")
            {
            }
            column(outgoingReportingPersonName; "Outgoing Reporting Person Name") { }

            // remark and approver
            // column(reviewer; Reviewer) { }
            // column(reviewerName; "Reviewer Name") { }
            column(dateofJoiningOfTransfer; "Date of Joining Of Transfer") { }
            // column(reviewerRemarks; "Reviewer Remarks") { }
            column(description; Description) { }

            column(transferRemarks; "Transfer Remarks") { }
            // column(transferClaimReviewer; "Transfer Claim Reviewer") { }
            // column(transferClaimRecommender; "Transfer Claim Recommender") { }
            // column(transferClaimReviewerName; "Transfer Claim Reviewer Name") { }
            column(relocationAllow; "Relocation Allow.") { }
            column(outstationDiscomfortAllow; "Outstation/Discomfort Allow.") { }
            column(BMAccomodationAllow; "BM Accomodation Allow.") { }
            column(remoteAreaAllow; "Remote Area Allow.") { }
            column(officiatingAllow; "Officiating Allow.") { }
            column(relocationDistance; "Relocation Distance") { }
            column(outstationDistance; "Outstation Distance") { }
            column(BMAFDistance; "BMAF Distance") { }
            column(transferClaim; "Transfer Claim")
            {
            }
            column(handover; Handover) { }
            column(takeover; Takeover) { }
            // column(transferAllowanceApproval; "Transfer Allowance Approval") { }
        }

    }

    trigger OnBeforeOpen()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(incomingSupervisior, HrMgt.GetEmployeeNo());
    end;
}