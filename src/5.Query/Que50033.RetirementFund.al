query 50033 "Retirement Fund"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'retirementFundApproval';
    EntitySetName = 'retirementFundApprovalEntity';
    QueryType = API;

    elements
    {
        dataitem(employee; Employee)
        {
            column(empNo; "No.") { }
            column(navLoginID; "NAV Login ID") { }
            column(fullName; "Full Name") { }

            dataitem(approvalHRMS; "Approval HRMS")
            {
                DataItemLink = "Approver No" = employee."No.";

                column(documentNo; "Document No.") { }
                column(approverCode; "Approver No") { }
                column(approverName; "Approver Name") { }
                column(approvalStatusLine; "Approval Status") { }
                column(approvalSequence; "Approval Sequence") { }

                dataitem(retirementFund; "Retirement Fund")
                {
                    DataItemLink = "No." = approvalHRMS."Document No.";

                    column(no; "No.") { }
                    column(employeeNo; "Employee No.") { }
                    column(employeeName; "Employee Name") { }
                    column(fiscalYear; "Fiscal Year") { }
                    column(payrollMonth; "Payroll Month") { }
                    column(annualAccessibleIncome; "Annual Assessable Income") { }
                    column(rfContributionEligibleAmt; "RF Contribution Eligible Amt") { }
                    column(providentFundDeposited; "Provident Fund Deposited") { }
                    column(rfContributionDeposited; "RF Contribution Deposited") { }
                    column(providentFundProjected; "Provident Fund Projected") { }
                    column(actualProjectedContribution; "Actual/Projected Contribution") { }
                    column(additionalSpaceForRFCont; "Additional Space for RF Cont.") { }
                    column(projectionMonth; "Projection Month") { }
                    column(rtfAmountMonth; "RTF Amount (Month)") { }
                    column(citAmountMonth; "CIT Amount (Month)") { }
                    column(rtfAmountLumpsum; "RTF Amount (Lumpsum)") { }
                    column(citAmountLumpsum; "CIT Amount( Lumpsum)") { }
                    column(totalCommittedContribution; "Total Committed Contribution") { }
                    column(totalDeduction; "Total Deduction") { }
                    column(difference; Difference) { }
                    column(approvalStatus; "Approval Status") { }
                    column(createdDate; "Created Date") { }
                    column(requestedDate; "Requested Date") { }
                    column(screenedDate; "Screened Date") { }
                    column(screenedBy; "Screened By") { }
                    column(remarks; Remarks) { }
                    column(citContributionDeposited; "CIT Contribution Deposited") { }
                    column(actualLumpsumpCIT; "Actual Lumpsump CIT") { }
                    column(actualLumpsumpRTF; "Actual Lumpsump RTF") { }
                    column(lumpsumCommittedContribution; "Lumpsum Committed Contribution") { }
                    column(lumpsumSpaceMaxBenefit; "Lumpsum Space Max Benefit") { }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HrMgt.GetEmployeeNo());
    end;
}
