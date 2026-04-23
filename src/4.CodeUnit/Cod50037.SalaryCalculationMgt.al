codeunit 50038 "Salary Calculation Mgt"
{
    trigger OnRun()
    begin
    end;

    var
        DeductionExceedsLimitMsg: Label 'Total deductions (%1) exceed the permissible 66.67%% limit of gross salary (Max Allowed: %2). Surplus/Deficit: %3.';
        NegativeTakeHomeErr: Label 'Take-home salary is negative (%1). Total deductions exceed gross salary. Loan cannot be processed.';
    procedure CalculateGrossMonthly(Basic: Decimal; Grade: Decimal; RegularAllowance: Decimal; OtherAllowance: Decimal; DeemedIncome: Decimal): Decimal
    begin
        exit(Basic + Grade + RegularAllowance + OtherAllowance + DeemedIncome);
    end;

    procedure CalculateAnnualTaxableIncome(GrossMonthly: Decimal): Decimal
    begin
        exit(GrossMonthly * 12);
    end;

    // Step 3 — Monthly Tax (Nepal slab, optional female rebate 10%)
    procedure CalculateMonthlyTax(AnnualTaxable: Decimal; IsFemale: Boolean): Decimal
    var
        AnnualTax: Decimal;
    begin
        AnnualTax := 0;
        if AnnualTaxable <= 0 then
            exit(0);

        // Slab 1 – 1% on first 500,000
        if AnnualTaxable <= 500000 then
            AnnualTax := AnnualTaxable * 0.01
        else begin
            AnnualTax := 500000 * 0.01;               // 5,000

            // Slab 2 – 10% on 500,001 to 600,000
            if AnnualTaxable <= 600000 then
                AnnualTax += (AnnualTaxable - 500000) * 0.10
            else
                AnnualTax += 100000 * 0.10;            // 10,000

            // Additional slabs can be inserted here for higher income bands
        end;

        // 10% rebate for female employees
        if IsFemale then
            AnnualTax := AnnualTax * 0.90;

        exit(Round(AnnualTax / 12, 1, '='));
    end;

    procedure CalculatePF(Basic: Decimal; Grade: Decimal): Decimal
    begin
        exit(Round((Basic + Grade) * 0.10, 1, '='));
    end;

    procedure CalculateTotalDeductions(PF: Decimal; HomeLoanInsuranceEMI: Decimal; VehicleLoanEMI: Decimal; SocialLoanEMI: Decimal; IncomeTax: Decimal): Decimal
    begin
        exit(PF + HomeLoanInsuranceEMI + VehicleLoanEMI + SocialLoanEMI + IncomeTax);
    end;

    procedure CheckPermissibleLimit(GrossMonthly: Decimal; TotalDeductions: Decimal)
    var
        MaxAllowed: Decimal;
        SurplusDeficit: Decimal;
    begin
        MaxAllowed := Round(GrossMonthly * (2 / 3), 1, '=');
        if TotalDeductions > MaxAllowed then begin
            SurplusDeficit := MaxAllowed - TotalDeductions;
            if GuiAllowed then
                Message(DeductionExceedsLimitMsg, TotalDeductions, MaxAllowed, SurplusDeficit);
        end;
    end;

    procedure CalculateTakeHome(GrossMonthly: Decimal; TotalDeductions: Decimal): Decimal
    var
        TakeHome: Decimal;
    begin
        TakeHome := GrossMonthly - TotalDeductions;
        if TakeHome < 0 then
            Error(NegativeTakeHomeErr, TakeHome);
        exit(TakeHome);
    end;

    procedure CalculateAndStoreTakeHome(var EmpLoan: Record "Employee Loan/Advance")
    var
        Employee: Record Employee;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        LoanOutstanding: Record "Loan Outstanding from Finacle";
        OtherEmpLoan: Record "Employee Loan/Advance";
        Basic: Decimal;
        GradeAmt: Decimal;
        RegularAllowance: Decimal;
        OtherAllowance: Decimal;
        DeemedIncome: Decimal;
        GrossMonthly: Decimal;
        AnnualTaxable: Decimal;
        MonthlyTax: Decimal;
        PF: Decimal;
        HomeLoanInsuranceEMI: Decimal;
        VehicleLoanEMI: Decimal;
        SocialLoanEMI: Decimal;
        TotalDeductions: Decimal;
        TakeHome: Decimal;
        IsFemale: Boolean;
        IsHandled: Boolean;
        HrMgt: Codeunit "HR Mgt.";
    begin
        if not Employee.Get(EmpLoan."Employee No.") then
            exit;
        if not SalaryLevel.Get(Employee."Salary Level") then
            exit;
        if not SalaryGrade.Get(Employee."Salary Grade") then
            exit;

        // ── Earnings components ──────────────────────────────────────────────
        // Basic := SalaryLevel."Basic Salary";
        // GradeAmt := Round(SalaryGrade."Grade Percentage" / 100 * Basic, 1, '=');
        // RegularAllowance := SalaryLevel.Allowance;
        // OtherAllowance := 0;
        // DeemedIncome := 0;
        // Allow company-specific overrides via integration event
        // OnBeforeCalculateEarningsComponents(EmpLoan, Basic, GradeAmt, RegularAllowance, OtherAllowance, DeemedIncome, IsHandled);

        // ── Steps 1-3: Gross, Annual Taxable, Monthly Tax ────────────────────
        // GrossMonthly := CalculateGrossMonthly(Basic, GradeAmt, RegularAllowance, OtherAllowance, DeemedIncome);
        GrossMonthly := CalculateGS(EmpLoan);
        AnnualTaxable := CalculateAnnualTaxableIncome(GrossMonthly);
        IsFemale := Employee.Gender = Employee.Gender::Female;
        MonthlyTax := CalculateMonthlyTax(AnnualTaxable, IsFemale);

        PF := HrMgt.CalculateProvidentFundProjected(EmpLoan."Employee No.", 1);

        // Sum EMI from Loan Outstanding (Home Loan + Insurance Tieup variants)
        LoanOutstanding.Reset();
        LoanOutstanding.SetRange("Employee No.", EmpLoan."Employee No.");
        LoanOutstanding.SetFilter("Loan Type", '%1|%2',
            LoanOutstanding."Loan Type"::"Home Loan",
            LoanOutstanding."Loan Type"::"Home Loan Insurance Tieup");
        LoanOutstanding.CalcSums(EMI);
        HomeLoanInsuranceEMI := LoanOutstanding.EMI;
        // Include the current loan's EMI if it is itself a Home Loan
        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Home Loan" then
            HomeLoanInsuranceEMI += EmpLoan.EMI;

        VehicleLoanEMI := 0;
        // Loan Outstanding vehicle EMIs (applies when no vehicle loan limit set)
        if SalaryLevel."Vehicle Loan Limit" = 0 then begin
            LoanOutstanding.Reset();
            LoanOutstanding.SetRange("Employee No.", EmpLoan."Employee No.");
            LoanOutstanding.SetRange("Loan Type", LoanOutstanding."Loan Type"::"Vehicle Loan");
            LoanOutstanding.CalcSums(EMI);
            VehicleLoanEMI += LoanOutstanding.EMI;
        end;
        OtherEmpLoan.Reset();
        OtherEmpLoan.SetRange("Employee No.", EmpLoan."Employee No.");
        OtherEmpLoan.SetFilter("Approval Status", '%1|%2',
            EmpLoan."Approval Status"::Pending,
            EmpLoan."Approval Status"::Approved);
        OtherEmpLoan.SetFilter("No.", '<>%1', EmpLoan."No.");
        OtherEmpLoan.SetRange(Settled, false);
        OtherEmpLoan.SetRange("Loan Type", OtherEmpLoan."Loan Type"::"Vehicle Loan");
        OtherEmpLoan.CalcSums(EMI);
        VehicleLoanEMI += OtherEmpLoan.EMI;
        // Include current loan's EMI if it is a Vehicle Loan
        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Vehicle Loan" then
            VehicleLoanEMI += EmpLoan.EMI;

        SocialLoanEMI := 0;
        OtherEmpLoan.Reset();
        OtherEmpLoan.SetRange("Employee No.", EmpLoan."Employee No.");
        OtherEmpLoan.SetFilter("Approval Status", '%1|%2',
            EmpLoan."Approval Status"::Pending,
            EmpLoan."Approval Status"::Approved);
        OtherEmpLoan.SetFilter("No.", '<>%1', EmpLoan."No.");
        OtherEmpLoan.SetRange(Settled, false);
        OtherEmpLoan.SetRange("Loan Type", OtherEmpLoan."Loan Type"::"Staff Social Loan");
        OtherEmpLoan.CalcSums(EMI);
        SocialLoanEMI := OtherEmpLoan.EMI;
        // Include current loan's EMI if it is a Staff Social Loan
        if EmpLoan."Loan Type" = EmpLoan."Loan Type"::"Staff Social Loan" then
            SocialLoanEMI += EmpLoan.EMI;

        TotalDeductions := CalculateTotalDeductions(PF, HomeLoanInsuranceEMI, VehicleLoanEMI, SocialLoanEMI, MonthlyTax);
        CheckPermissibleLimit(GrossMonthly, TotalDeductions);
        TakeHome := CalculateTakeHome(GrossMonthly, TotalDeductions);

        EmpLoan."Take-Home Salary" := TakeHome;
    end;


    procedure CalculateGS(var EmpLoan: Record "Employee Loan/Advance"): Decimal
    var
        PayrollAttributeUsage: Record "Payroll Attributes Usage";
        PayrollAttribute: Record "Payroll Attributes";
        GrossAmount: Decimal;
    begin
        case EmpLoan."Loan Type" of
            "Loan Type"::"Home Loan":
                begin
                    PayrollAttribute.SetRange("Use Attr. for Home loan GS", true);
                    if PayrollAttribute.FindSet() then begin
                        repeat
                            if PayrollAttributeUsage.Get(PayrollAttribute.Code, EmpLoan."Employee No.") then
                                GrossAmount += PayrollAttributeUsage.Amount;
                        until PayrollAttribute.Next() = 0;
                    end;
                end;
            "Loan Type"::"Vehicle Loan":
                begin
                    PayrollAttribute.SetRange("Use Attr. for Vehicle loan GS", true);
                    if PayrollAttribute.FindSet() then begin
                        repeat
                            if PayrollAttributeUsage.Get(PayrollAttribute.Code, EmpLoan."Employee No.") then
                                GrossAmount += PayrollAttributeUsage.Amount;
                        until PayrollAttribute.Next() = 0;
                    end;
                end;
            "loan Type"::"Personal Loan":
                begin
                    PayrollAttribute.SetRange("Use Attr. for Personal Loan GS", true);
                    if PayrollAttribute.FindSet() then begin
                        repeat
                            if PayrollAttributeUsage.Get(PayrollAttribute.Code, EmpLoan."Employee No.") then
                                GrossAmount += PayrollAttributeUsage.Amount;
                        until PayrollAttribute.Next() = 0;
                    end;
                end;
            "loan Type"::"Salary Advance":
                begin
                    PayrollAttribute.SetRange("Use Attr. for Salary Adv. GS", true);
                    if PayrollAttribute.FindSet() then begin
                        repeat
                            if PayrollAttributeUsage.Get(PayrollAttribute.Code, EmpLoan."Employee No.") then
                                GrossAmount += PayrollAttributeUsage.Amount;
                        until PayrollAttribute.Next() = 0;
                    end;
                end;
            "loan Type"::"Staff Social Loan":
                begin
                    PayrollAttribute.SetRange("Use Attr. staff Social Loan GS", true);
                    if PayrollAttribute.FindSet() then begin
                        repeat
                            if PayrollAttributeUsage.Get(PayrollAttribute.Code, EmpLoan."Employee No.") then
                                GrossAmount += PayrollAttributeUsage.Amount;
                        until PayrollAttribute.Next() = 0;
                    end;
                end;
        end;

        if GrossAmount = 0 then
            Error('No Payroll Attributes found for Employee %1 for Loan Type %2',
                  EmpLoan."Employee No.", EmpLoan."Loan Type");
        exit(GrossAmount);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateEarningsComponents(EmpLoan: Record "Employee Loan/Advance"; var Basic: Decimal; var Grade: Decimal; var RegularAllowance: Decimal; var OtherAllowance: Decimal; var DeemedIncome: Decimal; var IsHandled: Boolean)
    begin

    end;
}
