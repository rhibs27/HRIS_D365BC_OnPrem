report 50072 "Export Posted Payroll Value"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019873.ExportPostedPayrollValue.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Posted Payroll Line"; "Posted Payroll Line")
        {
            RequestFilterFields = "Document No.", "Employee No.";
            column(Title; StrSubstNo(Title, "Document No.")) { }
            column(DocumentNo_; "Document No.") { }
            column(EmployeeNo_; "Employee No.") { }
            column(EmployeeName_; "Employee Name") { }
            column(FunctionalTitle_; "Functional Title") { }
            column(SalaryLevel_; "Salary Level") { }
            column(SalaryGrade_; "Salary Grade") { }
            column(EmployeeType_; "Employee Type") { }
            column(PresentDays_; Format("Present Days")) { }
            column(AbsentDays_; Format("Absent Days")) { }
            column(WeekoffDays_; Format("Week off Days")) { }
            column(LeaveDays_; Format("Leave Days")) { }
            column(TotalDays_; Format("Total Days")) { }
            column(BankAccountNo_; "Bank Account No.") { }
            column(Number_; Number) { }
            column(PriorAbsentDays_; Format("Prior Absent Days")) { }
            column(PriorPresentDays_; Format("Prior Present Days")) { }
            column(ProjectedBenefit_; "Projected Benefit") { }
            column(TaxForPeriod_; "Tax for Period") { }
            column(PastBenefit_; "Past Benefit") { }
            column(CurrentBenefit_; "Current Benefit") { }
            column(AssessableIncome_; "Assessable Income") { }
            column(PastRetirementFund_; "Past Retirement Fund") { }
            column(ProjectedRetirementFund_; "Projected Retirement Fund") { }
            column(ActualRFContribution_; "Actual RF Contribution") { }
            column(V13ofAssessableIncome_; "1/3 of Assessable Income") { }
            column(EligibleRFDeduction_; "Eligible RF Deduction") { }
            column(LifeInsurancePremium_; "Life Insurance Premium") { }
            column(HealthInsurancePremium_; "Health Insurance Premium") { }
            column(TaxableIncome_; "Taxable Income") { }
            column(DisablePersonReduction_; "Disable Person Reduction") { }
            column(BalanceTaxableIncome_; "Balance Taxable Income") { }
            column(FemaleTaxCredit_; "Female Tax Credit") { }
            column(TotalTaxLiability_; "Total Tax Liability") { }
            column(PayableTaxLiability_; "Payable Tax Liability") { }
            column(NetTaxLiability_; "Net Tax Liability") { }
            column(SocialSecurityTaxAnnual_; "Social Security Tax(Annual)") { }
            column(TaxonRemunerationAnnual_; "Tax on Remuneration(Annual)") { }
            column(TotalTaxPaid_; "Total Tax Paid") { }
            column(ProjectionMonth_; "Projection Month") { }
            column(CurrentDeduction; "Current Deduction") { }
            column(NetPay; "Net Pay") { }
            column(TotalTaxForPeriod; TotalTaxForPeriod) { }
            column(TotalCurrentBenefit; TotalCurrentBenefit) { }
            column(TotalProjectedBenefit; TotalProjectedBenefit) { }
            column(TotalPastBenefit; TotalPastBenefit) { }
            column(TotalAssesibleIncome; TotalAssesibleIncome) { }
            column(TotalPastRetirementFund; TotalPastRetirementFund) { }
            column(TotalActualRFCont; TotalActualRFCont) { }
            column(TotalOneByThreeAssesibleIncome; "Total1/3AssesibleIncome") { }
            column(TotalProjectedRetireFund; TotalProjectedRetireFund) { }
            column(TotalEligibleDeduction; TotalEligibleDeduction) { }
            column(TotalTaxableIncome; TotalTaxableIncome) { }
            column(TotalDisablePersonRed; TotalDisablePersonRed) { }
            column(TotalLifeInsurancePremium; TotalLifeInsurancePremium) { }
            column(TotalHealthInsurancePremium; TotalHealthInsurancePremium) { }
            column(TotalBalTaxableIncome; TotalBalTaxableIncome) { }
            column(TotalSocialSecTax; TotalSocialSecTax) { }
            column(TotalTaxonRemun; TotalTaxonRemun) { }
            column(TotalTaxLiability; TotalTaxLiability) { }
            column(TotalFemaleTax; TotalFemaleTax) { }
            column(TotalPayableTax; TotalPayableTax) { }
            column(TotalTaxPaid; TotalTaxPaid) { }
            column(TotalNetTax; TotalNetTax) { }
            column(TotalDeduction; TotalDeduction) { }
            column(TotalNetPay; TotalNetPay) { }
            dataitem("Payroll Attributes Usage"; "Payroll Attributes Usage")
            {
                DataItemLink = "Employee Code" = field("Employee No.");
                column(Amt; Amt) { }
                column(Description_; PayrollAtt.Description) { }
                column(PayrollCode_; Code) { }
                column(sortby; PayrollAtt."Column Id") { }

                trigger OnAfterGetRecord()
                begin
                    Clear(Amt);
                    PayrollAtt.Get(Code);
                    PayrollColumnConfig.Reset;
                    PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                    PayrollColumnConfig.SetRange("Variable Field Code", "Payroll Attributes Usage".Code);
                    if PayrollColumnConfig.FindFirst then begin
                        RecRefs.Open(Database::"Posted Payroll Line");
                        FieldRefs := RecRefs.Field(1);
                        FieldRefs.SetRange("Posted Payroll Line"."Document No.");
                        FieldRefs := RecRefs.Field(3);
                        FieldRefs.SetRange("Posted Payroll Line"."Employee No.");
                        RecRefs.FindFirst;
                        FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                        Evaluate(Amt, Format(FieldRefs.Value));
                        Amt := Round(Amt, 0.01, '=');
                        RecRefs.Close;
                    end;

                    ClearValue;
                    if Counter = 0 then
                        TotalTaxForPeriod := "Posted Payroll Line"."Tax for Period";
                    if Counter = 0 then
                        TotalCurrentBenefit := "Posted Payroll Line"."Current Benefit";
                    if Counter = 0 then
                        TotalProjectedBenefit := "Posted Payroll Line"."Projected Benefit";
                    if Counter = 0 then
                        TotalPastBenefit := "Posted Payroll Line"."Past Benefit";
                    if Counter = 0 then
                        TotalAssesibleIncome := "Posted Payroll Line"."Assessable Income";
                    if Counter = 0 then
                        TotalPastRetirementFund := "Posted Payroll Line"."Past Retirement Fund";
                    if Counter = 0 then
                        TotalProjectedRetireFund := "Posted Payroll Line"."Projected Retirement Fund";
                    if Counter = 0 then
                        TotalActualRFCont := "Posted Payroll Line"."Actual RF Contribution";
                    if Counter = 0 then
                        "Total1/3AssesibleIncome" := "Posted Payroll Line"."1/3 of Assessable Income";
                    if Counter = 0 then
                        TotalEligibleDeduction := "Posted Payroll Line"."Eligible RF Deduction";
                    if Counter = 0 then
                        TotalTaxableIncome := "Posted Payroll Line"."Taxable Income";
                    if Counter = 0 then
                        TotalDisablePersonRed := "Posted Payroll Line"."Disable Person Reduction";
                    if Counter = 0 then
                        TotalLifeInsurancePremium := "Posted Payroll Line"."Life Insurance Premium";
                    if Counter = 0 then
                        TotalHealthInsurancePremium := "Posted Payroll Line"."Health Insurance Premium";
                    if Counter = 0 then
                        TotalBalTaxableIncome := "Posted Payroll Line"."Balance Taxable Income";
                    if Counter = 0 then
                        TotalSocialSecTax := "Posted Payroll Line"."Social Security Tax(Annual)";
                    if Counter = 0 then
                        TotalTaxonRemun := "Posted Payroll Line"."Tax on Remuneration(Annual)";
                    if Counter = 0 then
                        TotalTaxLiability := "Posted Payroll Line"."Total Tax Liability";
                    if Counter = 0 then
                        TotalFemaleTax := "Posted Payroll Line"."Female Tax Credit";
                    if Counter = 0 then
                        TotalPayableTax := "Posted Payroll Line"."Payable Tax Liability";
                    if Counter = 0 then
                        TotalTaxPaid := "Posted Payroll Line"."Total Tax Paid";
                    if Counter = 0 then
                        TotalNetTax := "Posted Payroll Line"."Net Tax Liability";
                    if Counter = 0 then
                        TotalDeduction := "Posted Payroll Line"."Current Deduction";
                    if Counter = 0 then
                        TotalNetPay := "Posted Payroll Line"."Net Pay";

                    Counter += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Counter);
            end;
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
        if "Posted Payroll Line".GetFilter("Document No.") = '' then
            Error('Please select a document no. in payroll line');
    end;

    var
        PayrollColumnConfig: Record "Payroll Column Configuration";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        Amt: Decimal;
        Title: Label 'Payroll Plan %1';
        PayrollAtt: Record "Payroll Attributes";
        TotalTaxForPeriod: Decimal;
        TotalCurrentBenefit: Decimal;
        TotalProjectedBenefit: Decimal;
        TotalPastBenefit: Decimal;
        TotalAssesibleIncome: Decimal;
        TotalPastRetirementFund: Decimal;
        TotalProjectedRetireFund: Decimal;
        TotalActualRFCont: Decimal;
        "Total1/3AssesibleIncome": Decimal;
        TotalEligibleDeduction: Decimal;
        TotalTaxableIncome: Decimal;
        TotalDisablePersonRed: Decimal;
        TotalLifeInsurancePremium: Decimal;
        TotalHealthInsurancePremium: Decimal;
        TotalBalTaxableIncome: Decimal;
        TotalSocialSecTax: Decimal;
        TotalTaxonRemun: Decimal;
        TotalTaxLiability: Decimal;
        TotalFemaleTax: Decimal;
        TotalPayableTax: Decimal;
        TotalTaxPaid: Decimal;
        TotalNetTax: Decimal;
        TotalDeduction: Decimal;
        TotalNetPay: Decimal;
        Counter: Integer;

    local procedure ClearValue()
    begin

        Clear(TotalTaxForPeriod);
        Clear(TotalCurrentBenefit);
        Clear(TotalProjectedBenefit);
        Clear(TotalPastBenefit);
        Clear(TotalAssesibleIncome);
        Clear(TotalPastRetirementFund);
        Clear(TotalProjectedRetireFund);
        Clear(TotalActualRFCont);
        Clear("Total1/3AssesibleIncome");
        Clear(TotalEligibleDeduction);
        Clear(TotalTaxableIncome);
        Clear(TotalDisablePersonRed);
        Clear(TotalLifeInsurancePremium);
        Clear(TotalHealthInsurancePremium);
        Clear(TotalBalTaxableIncome);
        Clear(TotalSocialSecTax);
        Clear(TotalTaxonRemun);
        Clear(TotalTaxLiability);
        Clear(TotalFemaleTax);
        Clear(TotalPayableTax);
        Clear(TotalTaxPaid);
        Clear(TotalNetTax);
        Clear(TotalDeduction);
        Clear(TotalNetPay);
    end;
}
