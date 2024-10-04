report 50051 "Loan/Salary Advance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019852.LoanSalaryAdvanceReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Loan/Advance"; "Employee Loan/Advance")
        {
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(TotalLoanAmount_; "Employee Loan/Advance"."Total Loan Amount") { }
            column(BranchName_; "Employee Loan/Advance"."Branch Name") { }
            column(DepartmentName_; "Employee Loan/Advance"."Department Name") { }
            column(UnitName_; "Employee Loan/Advance"."Unit Name") { }
            column(VehiclePurchaseType_; "Employee Loan/Advance"."Vehicle Purchase Type") { }
            column(EmployeeCitizenshipNo_; "Employee Loan/Advance"."Employee Citizenship No.") { }
            column(CitizenshipIssueDate_; "Employee Loan/Advance"."Citizenship Issue Date") { }
            column(Remarks_; "Employee Loan/Advance".Remarks) { }
            column(EligibleLoanAdvance_; "Employee Loan/Advance"."Eligible Loan/Advance") { }
            column(AppliedLoanAdvance_; "Employee Loan/Advance"."Applied Loan/Advance") { }
            column(PaybackMonths_; "Employee Loan/Advance"."Payback Months") { }
            column(DBRRatio_; "Employee Loan/Advance"."DBR Ratio") { }
            column(RequestedLoanDate_; "Employee Loan/Advance"."Requested Loan Date") { }
            column(ApprovalStatus_; "Employee Loan/Advance"."Approval Status") { }
            column(LoanType_; "Employee Loan/Advance"."Loan Type") { }
            column(VehicleLoanType_; "Employee Loan/Advance"."Vehicle Loan Type") { }
            column(RepaymentPeriod_; "Employee Loan/Advance"."Repayment Period") { }
            column(NameofSupplier_; "Employee Loan/Advance"."Name of Supplier") { }
            column(CostofVehicle_; "Employee Loan/Advance"."Cost of Vehicle") { }
            column(AddressofSupplier_; "Employee Loan/Advance"."Address of Supplier") { }
            column(MaxLoanAmount_; "Employee Loan/Advance"."Max. Loan Amount") { }
            column(PurposeofLoan_; "Employee Loan/Advance"."Purpose of Loan") { }
            column(InterestRate_; "Employee Loan/Advance"."Interest Rate") { }
            column(EMI_; "Employee Loan/Advance".EMI) { }
            column(IncomingDocumentEntryNo_; "Employee Loan/Advance"."Incoming Document Entry No.") { }
            column(Description_; "Employee Loan/Advance".Description) { }
            column(PurposeofHousingLoan_; "Employee Loan/Advance"."Purpose of Housing Loan") { }
            column(RepaymentMode_; "Employee Loan/Advance"."Repayment Mode") { }
            column(CommercialValueofProperty_; "Employee Loan/Advance"."Commercial Value of Property") { }
            column(InsuranceTieup_; "Employee Loan/Advance"."Insurance Tieup") { }
            column(Propertyinthenameof_; "Employee Loan/Advance"."Property in the name of") { }
            column(NameofSpouse_; "Employee Loan/Advance"."Name of Spouse") { }
            column(NameofOwner_; "Employee Loan/Advance"."Name of Owner") { }
            column(AddressofOwner_; "Employee Loan/Advance"."Address of Owner") { }
            column(AreaofPlot_; "Employee Loan/Advance"."Area of Plot") { }
            column(EstimatedCostofConstruction_; "Employee Loan/Advance"."Estimated Cost of Construction") { }
            column(Recommender_; "Employee Loan/Advance".Recommender) { }
            column(Approver_; "Employee Loan/Advance".Approver) { }
            column(RecommenderName_; "Employee Loan/Advance"."Recommender Name") { }
            column(ApproverName_; "Employee Loan/Advance"."Approver Name") { }
            column(ApprovedDate_; "Employee Loan/Advance"."Approved Date") { }
            column(RejectionRemark_; "Employee Loan/Advance"."Rejection Remark") { }
            column(Disbursed_; "Employee Loan/Advance".Disbursed) { }
            column(DisbursementDate_; "Employee Loan/Advance"."Disbursement Date") { }
            column(Settled_; "Employee Loan/Advance".Settled) { }
            column(SettlementDate_; "Employee Loan/Advance"."Settlement Date") { }
            column(LoanEnhancement_; Format("Employee Loan/Advance"."Loan Enhancement")) { }
            column(AccountNo_; "Employee Loan/Advance"."Account No.") { }
            column(AreaFormat_; "Employee Loan/Advance"."Area Format") { }
            column(PurposeofAdvanceSalary_; "Employee Loan/Advance"."Purpose of Advance Salary") { }
            column(SettlerUserID_; "Employee Loan/Advance"."Settler User ID") { }
            column(ScreenerRemarks_; "Employee Loan/Advance"."Screener Remarks") { }
            column(EmployeeNameinNepali_; "Employee Loan/Advance"."Employee Name in Nepali") { }
            column(FathersNameInNepali_; "Employee Loan/Advance"."Father's Name In Nepali") { }
            column(GrandfathersNameInNepali_; "Employee Loan/Advance"."Grandfather's Name In Nepali") { }
            column(VehicleModel_; "Employee Loan/Advance"."Vehicle Model") { }
            column(TransportationManagementoff_; "Employee Loan/Advance"."Transportation Management off.") { }
            column(VehicleEngineNo_; "Employee Loan/Advance"."Vehicle Engine No.") { }
            column(VehicleChasisNo_; "Employee Loan/Advance"."Vehicle Chasis No.") { }
            column(VehicleRegistrationNo_; "Employee Loan/Advance"."Vehicle Registration No.") { }
            column(DisbursedAmount_; "Employee Loan/Advance"."Disbursed Amount") { }
            column(OutstandingAmount_; "Employee Loan/Advance"."Outstanding Amount") { }
            column(Screener_; "Employee Loan/Advance".Screener) { }
            column(CompleteAddressofProperty_; "Employee Loan/Advance"."Complete Address of Property") { }
            column(PlotNoofProperty_; "Employee Loan/Advance"."Plot No. of Property") { }
            column(RecommendationRemarks_; "Employee Loan/Advance"."Recommendation Remarks") { }
            column(OfferLetterIssuedDate_; "Employee Loan/Advance"."Offer Letter Issued Date") { }
            column(AmountInWordsNepali_; "Employee Loan/Advance"."Amount In Words (Nepali)") { }
            column(ProposedOwnerNepali_; "Employee Loan/Advance"."Proposed Owner (Nepali)") { }
            column(AddressofPropertyNepali_; "Employee Loan/Advance"."Address of Property (Nepali)") { }
            column(OfferLetterDateNepali_; "Employee Loan/Advance"."Offer Letter Date(Nepali)") { }
            column(LoanExpiryDate_; "Employee Loan/Advance"."Loan Expiry Date") { }
            column(LoanExpiryDateNepali_; "Employee Loan/Advance"."Loan Expiry Date( Nepali)") { }
            column(VehicleTypeNepali_; "Employee Loan/Advance"."Vehicle Type (Nepali)") { }
            column(ApprovedByBoard_; Format("Employee Loan/Advance"."Approved By Board")) { }
            column(PreviousLoanAmount_; "Employee Loan/Advance"."Previous Loan Amount") { }
            column(SalaryLevel_; "Employee Loan/Advance"."Salary Level") { }
            column(DateofJoining_; "Employee Loan/Advance"."Date of Joining") { }
            column(Frequency_; "Employee Loan/Advance".Frequency) { }
            column(GrossSalary_; "Employee Loan/Advance"."Gross Salary") { }
            column(FY_; "Employee Loan/Advance".FY) { }
            column(Department_; "Employee Loan/Advance".Department) { }
            column(DateofBirth_; "Employee Loan/Advance"."Date of Birth") { }
            column(Age_; "Employee Loan/Advance".Age) { }
            column(Branch_; "Employee Loan/Advance".Branch) { }
            column(RemainingServicePeriod_; "Employee Loan/Advance"."Remaining Service Period") { }
            column(EmployeeCode_; "Employee Loan/Advance"."Employee Code") { }
            column(EmployeeName_; "Employee Loan/Advance"."Employee Name") { }
            column(JobTitle_; "Employee Loan/Advance"."Job Title") { }
            column(JobType_; "Employee Loan/Advance"."Job Type") { }
            column(Gender_; "Employee Loan/Advance".Gender) { }
            column(ConfirmationServicePeriod_; "Employee Loan/Advance"."Confirmation Service Period") { }
            column(Title; StrSubstNo(Title, "Employee Loan/Advance"."Loan Type")) { }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Title: Label '%1 Processing Report';
}
