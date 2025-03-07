query 50004 "Home Loan Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'homeLoanApproval';
    EntitySetName = 'homeLoanApprovalEntity';
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
                dataitem(EmployeeLoanAdvance; "Employee Loan/Advance")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(employeeCode; "Employee Code") { }
                    column(employeeName; "Employee Name") { }
                    column(jobTitle; "Job Title") { }
                    column(jobType; "Job Type") { }
                    column(gender; Gender) { }
                    column(confirmationServicePeriod; "Confirmation Service Period") { }
                    column(vehicleLoanType; "Vehicle Loan Type") { }
                    column(loanType; "Loan Type")
                    {
                    }
                    column(status; Status) { }
                    column(frequency; Frequency) { }
                    column(unitName; "Unit Name") { }
                    column(departmentName; "Department Name") { }
                    column(branchName; "Branch Name") { }
                    column(approvalStatus; "Approval Status") { }
                    column(grossSalary; "Gross Salary") { }
                    column(totalLoanAmount; "Total Loan Amount")
                    {
                    }
                    column(eligibleLoanAdvance; "Eligible Loan/Advance") { }
                    column(appliedLoanAdvance; "Applied Loan/Advance") { }
                    column(interestRate; "Interest Rate") { }
                    column(paybackMonths; "Payback Months") { }
                    column(requestedLoanDate; "Requested Loan Date") { }
                    column(loanEnhancement; "Loan Enhancement") { }
                    column(accountNo; "Account No.") { }
                    column(disbursed; Disbursed) { }
                    column(disbursementDate; "Disbursement Date") { }
                    column(screenerRemarks; "Screener Remarks") { }
                    column(purposeofLoan; "Purpose of Loan")
                    {
                    }
                    column(rejectionRemark; "Rejection Remark") { }
                    column(settlementDate; "Settlement Date") { }
                    column(propertyinthenameof; "Property in the name of") { }
                    column(nameofSpouse; "Name of Spouse") { }
                    column(nameofOwner; "Name of Owner") { }
                    column(addressofOwner; "Address of Owner") { }
                    column(purposeofAdvanceSalary; "Purpose of Advance Salary") { }
                    column(areaFormat; "Area Format") { }
                    column(areaofPlot; "Area of Plot") { }
                    column(age; Age) { }
                    column(repaymentPeriod; "Repayment Period") { }
                    column(insuranceTieup; "Insurance Tieup")
                    {
                    }
                    column(purposeofHousingLoan; "Purpose of Housing Loan") { }
                    column(approvedByLoan; "Approved By Board") { }
                    column(nameofSupplier; "Name of Supplier") { }
                    column(costofVehicle; "Cost of Vehicle") { }
                    column(addressofSupplier; "Address of Supplier") { }
                    column(repaymentMode; "Repayment Mode") { }
                    column(commercialValueofProperty; "Commercial Value of Property") { }
                    column(estimatedCostofConstruction; "Estimated Cost of Construction") { }
                    column(appliedLoan; "Applied Loan/Advance") { }
                    column(settled; Settled) { }
                    column(empCitizenshipNo; "Employee Citizenship No.") { }
                    column(citizenshipIssueDate; "Citizenship Issue Date") { }
                    column(empNameNepali; "Employee Name in Nepali") { }
                    column(fatherNameNepali; "Father's Name In Nepali") { }
                    column(grandfatherNameNepali; "Grandfather's Name In Nepali") { }
                    column(vehicleMolel; "Vehicle Model") { }
                    column(transportationManagement; "Transportation Management off.") { }
                    column(vehicleEngineNo; "Vehicle Engine No.") { }
                    column(completeAddressofProperty; "Complete Address of Property") { }
                    column(vehicleChasisNo; "Vehicle Chasis No.") { }
                    column(vehicleRegistration; "Vehicle Registration No.") { }
                    column(disbursedAmount; "Disbursed Amount") { }
                    column(outstandingAmount; "Outstanding Amount") { }
                    column(settlerUserID; "Settler User ID") { }
                    column(vehiclePurchaseType; "Vehicle Purchase Type") { }
                    column(plotNoofProperty; "Plot No. of Property") { }
                    column(recommendationRemarks; "Recommendation Remarks") { }
                    column(offerLetterIssueDate; "Offer Letter Issued Date") { }
                    column(screener; Screener) { }
                    column(offerLetterDateNepali; "Offer Letter Date(Nepali)") { }
                    column(amountInWordNepali; "Amount In Words (Nepali)") { }
                    column(remainingServicePeriod; "Remaining Service Period") { }
                    column(remarks; Remarks) { }
                    column(prevLoanAmt; "Previous Loan Amount")
                    {
                    }
                    column(amountInWords; "Amount In Words (Nepali)") { }
                    column(proposedOwnerNepali; "Proposed Owner (Nepali)") { }
                    column(addressOfPropertyNepali; "Address of Property (Nepali)") { }
                    column(loanExpiryDate; "Loan Expiry Date") { }
                    column(loanExpiryDateNepali; "Loan Expiry Date( Nepali)") { }
                    column(equityFinancingDeclaration; "Equity Financing Declaration") { }
                    column(returnedLoan; "Returned Loan") { }
                    column(reinstateDate; "Reinstate Date") { }
                    column(ageHomeLoan; "Age Home Loan") { }
                    column(DBRRatio; "DBR Ratio")
                    {
                    }
                    column(EMI; EMI)
                    {
                    }
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

