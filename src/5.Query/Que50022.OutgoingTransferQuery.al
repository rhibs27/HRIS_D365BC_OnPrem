query 50022 "Outgoing Transfer Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'outgoingTransferApproval';
    EntitySetName = 'outgoingTransferApprovalEntity';
    QueryType = API;
    OrderBy = descending(no);

    elements
    {
        dataitem(EmployeeTransfer; "Employee/HR Transfer")
        {
            //general
            column(no; "No.") { }
            column(type; Type) { }
            column(employeeNo; "Employee No.") { }
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
            column(status; Status) { }
            column(isTransferDetailsAdded; "Is Transfer Details Added") { }
            column(transferProposeDate; "Transfer Propose Date") { }
            column(reasonCode; "Reason Code") { }
            column(reasonDescription; "Reason Description") { }
            column(reasonForTransfer; "Reason for Transfer") { }
            column(provinceCode; "Province Code") { }
            column(unitCode; "Unit Code") { }
            column(remarks; Remarks) { }
            column(screenerRemarks; "Screener Remarks") { }
            column(rejectionRemarks; "Rejection Remarks") { }
            column(transferType; "Transfer Type") { }
            //current
            column(department; Department) { }
            column(departmentName; "Department Name") { }
            column(branchCode; "Shortcut Dimension 1 Code") { }
            column(branchName; "Branch Name") { }
            column(functionalTitle; "Functional Title") { }
            column(functionalTitleDesc; "Functional Title Desc") { }
            column(deputationOn; "Deputation On") { }
            column(extensionCounterCode; "Extension Counter Code") { }
            column(unitName; "Unit Name") { }
            column(extensionCounterName; "Extension Counter Name") { }

            column(requestedPRovince; "Requested Province") { }
            column(requestedProvinceName; "Requested Province Name") { }
            // propose
            // column(shortcutDimension1CodeTo; "Shortcut Dimension 1 Code (To)") { }
            column(toBranch; "To Branch") { }
            column(functionalTitleTo; "Functional Title (To)") { }
            column(functionalDescTo; "Functional Desc To") { }
            column(provinceCodeTo; "Province Code (To)") { }
            column(unitTo; "Unit (To)") { }
            column(unitNameTo; "Unit Name To") { }
            column(departmentCodeTo; "Department Code (To)") { }
            column(departmentNameTo; "Department Name To") { }
            column(branchNameTo; "Branch Name To") { }
            column(extensionCounterTo; "Extension Counter (To)") { }
            column(extensionNameTo; "Extension Name To") { }
            column(deputationOnTo; "Deputation On (To)") { }
            column(transferEffectiveDate; "Transfer Effective Date") { }
            column(incomingSupervisior; "Incoming Supervisior") { }
            column(incomingSupervisiorName; "Incoming Supervisior Name") { }
            column(outgoingBranchRepPerson; "Outgoing Branch Rep. Person") { }
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
            column(transferClaim; "Transfer Claim") { }
            column(handover; Handover) { }
            column(takeover; Takeover) { }
        }
    }

    trigger OnBeforeOpen()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(outgoingBranchRepPerson, HrMgt.GetEmployeeNo());
    end;
}