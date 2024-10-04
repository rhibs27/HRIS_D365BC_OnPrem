page 33019976 "Employee Loan/Advance API"
{
    // version NIC Asia1.00,Loan/Advance,APINICASIA1.00

    DelayedInsert = true;
    EntityName = 'employeeLoanAdvEntity';
    EntitySetName = 'employeeLoanAdvEntities';
    PageType = API;
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee Loan/Advance";
    SourceTableView = sorting("No.")
                      order(descending);

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field(employeeCode; Rec."Employee Code") { }
                field(employeeName; Rec."Employee Name") { }
                field(jobTitle; Rec."Job Title") { }
                field(jobType; Rec."Job Type") { }
                field(gender; Rec.Gender) { }
                field(confirmationServicePeriod; Rec."Confirmation Service Period") { }
                field(vehicleLoanType; Rec."Vehicle Loan Type") { }
                field(loanType; Rec."Loan Type")
                {
                    Editable = true;
                }
                field(frequency; Rec.Frequency) { }
                field(unitName; Rec."Unit Name") { }
                field(departmentName; Rec."Department Name") { }
                field(branchName; Rec."Branch Name") { }
                field(EMI; EMIVar)
                {
                    trigger OnValidate()
                    begin
                        Rec.Validate(EMI, EMIVar);
                    end;
                }
                field(approvalStatus; Rec."Approval Status") { }
                field(grossSalary; Rec."Gross Salary") { }
                field(totalLoanAmount; Rec."Total Loan Amount")
                {
                    Editable = true;
                }
                field(eligibleLoanAdvance; Rec."Eligible Loan/Advance") { }
                field(appliedLoanAdvance; Rec."Applied Loan/Advance") { }
                field(interestRate; Rec."Interest Rate") { }
                field(paybackMonths; Rec."Payback Months") { }
                field(DBRRatio; DBRVar)
                {
                    trigger OnValidate()
                    begin
                        Rec.Validate("DBR Ratio", DBRVar);
                    end;
                }
                field(requestedLoanDate; Rec."Requested Loan Date") { }
                field(loanEnhancement; Rec."Loan Enhancement") { }
                field(accountNo; Rec."Account No.") { }
                field(disbursed; Rec.Disbursed) { }
                field(disbursementDate; Rec."Disbursement Date") { }
                field(screenerRemarks; Rec."Screener Remarks") { }
                field(purposeofLoan; Rec."Purpose of Loan")
                {
                    MultiLine = true;
                }
                field(rejectionRemark; Rec."Rejection Remark") { }
                field(settlementDate; Rec."Settlement Date") { }
                field(propertyinthenameof; Rec."Property in the name of") { }
                field(nameofSpouse; Rec."Name of Spouse") { }
                field(nameofOwner; Rec."Name of Owner") { }
                field(addressofOwner; Rec."Address of Owner") { }
                field(purposeofAdvanceSalary; Rec."Purpose of Advance Salary") { }
                field(areaFormat; Rec."Area Format") { }
                field(areaofPlot; Rec."Area of Plot") { }
                field(age; Rec.Age) { }
                field(repaymentPeriod; Rec."Repayment Period") { }
                field(insuranceTieup; Rec."Insurance Tieup")
                {
                    trigger OnValidate()
                    begin
                        if Rec."Insurance Tieup" = Rec."Insurance Tieup"::"NEPAL Life Insurance" then
                            Error(Error1);
                    end;
                }
                field(purposeofHousingLoan; Rec."Purpose of Housing Loan") { }
                field(approvedByLoan; Rec."Approved By Board") { }
                field(nameofSupplier; Rec."Name of Supplier") { }
                field(costofVehicle; Rec."Cost of Vehicle") { }
                field(addressofSupplier; Rec."Address of Supplier") { }
                field(repaymentMode; Rec."Repayment Mode") { }
                field(commercialValueofProperty; Rec."Commercial Value of Property") { }
                field(estimatedCostofConstruction; Rec."Estimated Cost of Construction") { }
                field(appliedLoan; Rec."Applied Loan/Advance") { }
                field(settled; Rec.Settled) { }
                field(empCitizenshipNo; Rec."Employee Citizenship No.") { }
                field(citizenshipIssueDate; Rec."Citizenship Issue Date") { }
                field(empNameNepali; Rec."Employee Name in Nepali") { }
                field(fatherNameNepali; Rec."Father's Name In Nepali") { }
                field(grandfatherNameNepali; Rec."Grandfather's Name In Nepali") { }
                field(vehicleMolel; Rec."Vehicle Model") { }
                field(transportationManagement; Rec."Transportation Management off.") { }
                field(vehicleEngineNo; Rec."Vehicle Engine No.") { }
                field(CompleteAddressofProperty; Rec."Complete Address of Property") { }
                field(vehicleChasisNo; Rec."Vehicle Chasis No.") { }
                field(vehicleRegistration; Rec."Vehicle Registration No.") { }
                field(disbursedAmount; Rec."Disbursed Amount") { }
                field(outstandingAmount; Rec."Outstanding Amount") { }
                field(settlerUserID; Rec."Settler User ID") { }
                field(vehiclePurchaseType; Rec."Vehicle Purchase Type") { }
                field(plotNoofProperty; Rec."Plot No. of Property") { }
                field(recommendationRemarks; Rec."Recommendation Remarks") { }
                field(offerLetterIssueDate; Rec."Offer Letter Issued Date") { }
                field(screener; Rec.Screener) { }
                field(offerLetterDateNepali; Rec."Offer Letter Date(Nepali)") { }
                field(amountInWordNepali; Rec."Amount In Words (Nepali)") { }
                field(remainingServicePeriod; Rec."Remaining Service Period") { }
                field(remarks; Rec.Remarks) { }
                field(prevLoanAmt; Rec."Previous Loan Amount")
                {
                    Editable = true;
                }
                field(amountInWords; Rec."Amount In Words (Nepali)") { }
                field(proposedOwnerNepali; Rec."Proposed Owner (Nepali)") { }
                field(addressOfPropertyNepali; Rec."Address of Property (Nepali)") { }
                field(approvedByBoard; approvedByBoard)
                {
                    trigger OnValidate()
                    begin
                        Rec.Validate("Approved By Board", approvedByBoard);
                    end;
                }
                field(loanExpiryDate; Rec."Loan Expiry Date") { }
                field(loanExpiryDateNepali; Rec."Loan Expiry Date( Nepali)") { }
                field(equityFinancingDeclaration; Rec."Equity Financing Declaration") { }
                field(returnedLoan; Rec."Returned Loan") { }
                field(reinstateDate; Rec."Reinstate Date") { }
                field(ageHomeLoan; Rec."Age Home Loan") { }
                part(attachment; "Attachment Subform")
                {
                    EntityName = 'attachmentEntity';
                    EntitySetName = 'attachmentEntities';
                    SubPageLink = "No." = field("No.");
                }
                field(recommender; Rec.Recommender) { }
                field(recommenderName; Rec."Recommender Name") { }
                field(approver; Rec.Approver)
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        if Rec."Loan Type" = Rec."Loan Type"::"Salary Advance" then begin
                            Rec.Insert(true);
                            LoanMgt.SendApprovaLoan(Rec, true);
                        end;
                    end;
                }
                field(approverName; Rec."Approver Name") { }
                field(sendforApproval; sendforApproval)
                {
                    trigger OnValidate()
                    begin
                        if sendforApproval then begin
                            if Rec."Loan Type" = Rec."Loan Type"::"Salary Advance" then
                                if Rec."No." = '' then
                                    Rec.Insert(true);
                            Rec.Modify(true);
                            Commit;
                            LoanMgt.SendApprovaLoan(Rec, true);
                        end;
                    end;
                }
            }
        }
    }

    var
        sendforApproval: Boolean;
        approvedByBoard: Boolean;
        EMIVar: Decimal;
        DBRVar: Decimal;
        Error1: Label 'Insurance with Nepal Life Insurance is not tied up with Home Loan.';
        LoanMgt: Codeunit "Loan Mgt.";

    trigger OnAfterGetRecord()
    begin
        approvedByBoard := Rec."Approved By Board";
        EMIVar := Round(Rec.EMI, 0.000001, '=');
        DBRVar := Round(Rec."DBR Ratio", 0.000001, '=');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;
}
