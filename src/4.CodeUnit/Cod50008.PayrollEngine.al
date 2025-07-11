codeunit 50008 "Payroll Engine"
{
    // version PRM19.01.01

    //
    // Pradhan
    //   //Calculation for TaxAtOnce payroll   3rd Jan 2020
    // //Min 4.22.2022 -- Subtract variable PropertyInsuranceTaxBenefit
    // //Min 5.4.2022 -- Added (PayrollLineVar."Salary Grade",PayrollLineVar."Salary Level") in get function instead from service history.
    // //Min 6.28.2022 -- For Life Insurance Premium route through "Loan Outstanding"
    // //Min 7.5.2022 -- Service event option Confirmation Added.
    // //Min 7.6.2022 -- Added PayrollLine."Remote Area Deduction" instead of RemoteAreaDeduction variable.
    // //Min 8.21.2022 -- Filter removed of "EmployeeActivity.Type::Overtime",no need to update in "Employee attendance & Activity".
    // //Min 10.17.2022 -- Commented for CheckIn,CheckOut time sync same of attendance line of Travel request, as per Santosh Paudel.
    // //Min 12.22.2022 -- Holiday Counter and Festive Counter Calculation on the basis Overtime Lines.

    Permissions = tabledata "Detailed Employee Ledger Entry" = rm,
                  tabledata "Posted Payroll Line" = rm;

    trigger OnRun()
    begin
    end;

    var
        PayrollHeader: Record "Payroll Header";
        PayrollLine: Record "Payroll Line";
        Employee: Record Employee;
        PGSetup: Record "Payroll General Setup";
        AttendanceSetup: Record "Attendance Setup";
        TaxSetupHeader: Record "Tax Setup Header";
        TaxSetupLine: Record "Tax Setup Line";
        PayrollAttributes: Record "Payroll Attributes";
        PayCycleTerm: Record "Pay Cycle Term";
        AttendanceSetupReady: Boolean;
        BasicSalaryAfterDeduction: Decimal;
        CurrentEarning: Decimal;
        CurrentDeduction: Decimal;
        CurrentNonTaxableBenefits: Decimal;
        CurrentNonPaymentBenefits: Decimal;
        ProjectedNonPaymentBenefit: Decimal;
        ProjectionEarning: Decimal;
        RemainingMonth: Decimal;
        TotalContributionToRetirementFund: Decimal;
        RetirementFundLimit1: Decimal;
        RetirementFundLimit2: Decimal;
        RetirementFundTaxBenefit: Decimal;
        CurrentDonation: Decimal;
        TotalDonation: Decimal;
        DonationLimit1: Decimal;
        DonationLimit2: Decimal;
        DonationTaxBenefit: Decimal;
        CurrentMedicalReimbursment: Decimal;
        TotalMedicalReimbursment: Decimal;
        MedicalReimbursmentLimit1: Decimal;
        MedicalReimbursmentLimit2: Decimal;
        MedicalReimbursmentTaxBenefit: Decimal;
        InsuranceAmount: Decimal;
        InsuranceLimit1: Decimal;
        InsuranceTaxBenefit: Decimal;
        EmployerContribution: Decimal;
        EmployeeContribution: Decimal;
        CITContribution: Decimal;
        TaxableAmount: Decimal;
        RemainingTaxableAmount: Decimal;
        AnnualTax: Decimal;
        MonthlyTax: Decimal;
        SocialSecurityTax: Decimal;
        TaxAttribute: Code[20];
        SocialSecurityTaxAttribute: Code[20];
        SocialSecurityTaxAmount: Decimal;
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        Text000: Label 'You must specify %1.';
        Text005: Label 'Default Journal';
        Text004: Label 'DEFAULT';
        PostedPayrollHeader: Record "Posted Payroll Header";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledger Entry";
        BankTotal: Decimal;
        BankTotal1: Decimal;
        TaxAtOnceCurrentEarning: Decimal;
        TaxAtOnceCurrentDeduction: Decimal;
        TaxAtOnceCurrentDonation: Decimal;
        TaxatOnceCurrentNonPayments: Decimal;
        TaxAtOnceProjectedNonPayments: Decimal;
        TaxAtOnceProjectionEarning: Decimal;
        TaxAtOnceTotalAnnualEarning: Decimal;
        TaxAtOnceTaxableAmt: Decimal;
        TaxAtOnceAnnualTax: Decimal;
        TaxAtOnceRemainingAmt: Decimal;
        RF: Decimal;
        LumpSumCIT: Decimal;
        FLRecovery: Decimal;
        InsuranceRecovery: Decimal;
        SettlementAmount: Decimal;
        LeaveTypeSetup: Record "Leave Type Setup";
        GLSetup: Record "General Ledger Setup";
        PreviousPayCyclePeriod: Record "Pay Cycle Period";
        HealthInsuranceTaxBenefit: Decimal;
        DisablePersonReduction: Decimal;
        TaxExempt: Decimal;
        HRSetup: Record "Human Resources Setup";
        SettlementStartDate: Date;
        HRMgt: Codeunit "HR Mgt.";
        EngNep: Record "English-Nepali Date";
        EmpPayOpen: Record "Employee Payroll Opening";
        SlabAmount: Decimal;
        SlabCount: Integer;
        RemoteAreaDeduction: Decimal;
        ServiceHistory: Record "Employee Service History";
        TotalTaxRemunPaid: Decimal;
        TotalSSTPaid: Decimal;
        TotalTaxWithoutSST: Decimal;
        EmployeeLumpsum: Decimal;
        PropertyInsuranceTaxBenefit: Decimal;
        LoanOutstanding: Record "Loan Outstanding from Finacle";
        HLInsAmt: Decimal;
        Text001: Label 'Over Time Employee Import Successfully.';
        Text002: Label 'Over Time Amount Updated Successfully.';

    local procedure GetAttendanceSetup()
    begin
        AttendanceSetup.Get;
        AttendanceSetupReady := true;
    end;

    procedure IsHourCalculation(): Boolean
    begin
        if not AttendanceSetupReady then
            GetAttendanceSetup;
        exit(AttendanceSetup."Calculation Method" = AttendanceSetup."Calculation Method"::Hour);
    end;

    procedure IsTimeSheetEnabled(): Boolean
    begin
        if not AttendanceSetupReady then
            GetAttendanceSetup;
        exit(AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::"Time Sheet");
    end;

    procedure InitPayrollLine(var _PayrollLine: Record "Payroll Line")
    var
        TotalAnnualEarning: Decimal;
    begin
        PGSetup.Get; //Get Setup
        PGSetup.TestField("Payroll Fiscal Year End Date");
        PGSetup.TestField("Payroll Fiscal Year Start Date");
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Deduction);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::"Tax on Remuneration & Benefits");
        PayrollAttributes.FindFirst;
        TaxAttribute := PayrollAttributes.Code;
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::"Social Security Tax");
        if PayrollAttributes.FindFirst then
            SocialSecurityTaxAttribute := PayrollAttributes.Code;
        //Check Document
        PayrollLine := _PayrollLine;
        PayrollLine.GetPayrollHeader;
        PayrollHeader.Get(PayrollLine."Document No.");
        PayrollHeader.TestField("Pay Cycle Code");
        PayrollHeader.TestField("Pay Cycle Term");
        PayrollHeader.TestField("Pay Cycle Period");
        if PayrollHeader."Previous Year Payroll" then begin //Min 7.18.2022
            PGSetup.TestField("Prev Fiscal Year End Date");
            PGSetup.TestField("Prev Fiscal Year Start Date");
        end;
        //checking for total days
        if not (PayrollHeader.Type = PayrollHeader.Type::Adjustment) then
            PayrollLine.TestTotalDays(PayrollHeader);
        EngNep.Reset;
        EngNep.SetRange("English Date", PayrollHeader."From Date");
        if EngNep.FindFirst then;
        Employee.Reset;
        Employee.SetRange("No.", PayrollLine."Employee No.");
        if PayrollHeader."Previous Year Payroll" then //Min 7.18.2022
            Employee.SetFilter("Date Filter", '%1..%2', PGSetup."Prev Fiscal Year Start Date", PGSetup."Prev Fiscal Year End Date")
        else
            Employee.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        Employee.SetRange("Document Type Filter", Employee."Document Type Filter"::Invoice);
        Employee.FindFirst;
        Employee.CalcFields("Total Earning", "Total Retirement Contribution", "Total Donation Contribution",
                         "Total Medical Re-Imbursement", "Social Security Tax", "Remuneration & Benefits Tax",
                         "PF Contribution", "PF Contribution (Office)", "RF Deposit", "Lump Sum CIT", "Non-Payment");
        //Check Employee Status
        Employee.TestField("Employment Date");
        if not (PayrollHeader.Type = PayrollHeader.Type::Settlement) then
            Employee.TestField(Status, Employee.Status::Active);
        Employee.TestField("Tax Code");
        TaxSetupHeader.Get(Employee."Tax Code");

        EmpPayOpen.Reset;
        EmpPayOpen.SetRange("Employee No.", PayrollLine."Employee No.");
        EmpPayOpen.SetRange("Fiscal Year", HRMgt.ReturnFiscalYear(PayrollHeader."From Date"));
        if EmpPayOpen.FindFirst then;

        //Read Payment Days
        PayCycleTerm.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term");
        PayCycleTerm.CalcFields("Periods Generated");
        if PayrollHeader.Type in [PayrollHeader.Type::Payroll, PayrollHeader.Type::Adjustment] then begin
            if Employee."Employment Type" <> Employee."Employment Type"::Contract then
                RemainingMonth := PayCycleTerm."Periods Generated" - GetLastPayPeriod
            else begin
                //Employee.TESTFIELD("Contract Expiry Date");
                if PayrollHeader."Previous Year Payroll" then
                    RemainingMonth := GetPayCyclePeriodPrevious(Employee."Contract Expiry Date") - GetLastPayPeriod //Min 7.18.2022
                else
                    RemainingMonth := GetPayCyclePeriod(Employee."Contract Expiry Date") - GetLastPayPeriod;
            end;
        end else
            RemainingMonth := GetSettlementPayCyclePeriod - GetLastPayPeriod;     //settlement

        if PayrollHeader.Type = PayrollHeader.Type::Adjustment then
            if RemainingMonth < 0 then
                RemainingMonth := 0;
        if (PayrollHeader.Type <> PayrollHeader.Type::Adjustment) or (PayrollHeader."Gross Payment") then
            CalcCurrentEarning;
        if not (PayrollHeader.Type = PayrollHeader.Type::Settlement) then begin
            CalcProjectionEarning();
            EmployeeLumpsum := Employee."Lumpsum CIT (Not Actual)" + Employee."Lumpsum RF (Not Actual)";
        end else
            RemainingMonth := 0;

        TotalAnnualEarning := CurrentEarning + ProjectionEarning + Employee."Total Earning" + EmpPayOpen."Total Benefit Opening" + Employee."Non-Payment" + CurrentNonPaymentBenefits + ProjectedNonPaymentBenefit;     // +  TaxOldEmployeeTotalEarning(Employee."No.")  //>>pradhan

        //Retirement
        if not (PayrollHeader.Type = PayrollHeader.Type::Settlement) then begin
            CalcProjectionRetirementFund; //SUMAN
        end;
        TotalContributionToRetirementFund := CITContribution + Abs(Employee."Total Retirement Contribution") + ProjectionEarning +
                                             EmployeeContribution + EmployerContribution + RF + LumpSumCIT + Abs(Employee."RF Deposit") + Abs(Employee."Lump Sum CIT") + EmpPayOpen."Total RF Opening" + EmployeeLumpsum;
        //RetirementFundLimit1 := TotalAnnualEarning * PGSetup."Tax Ex. Amt. (%) on Retirement" / 100;
        RetirementFundLimit1 := TotalAnnualEarning / PGSetup."Tax Ex. Amt Divsion";
        RetirementFundLimit2 := PGSetup."Tax Ex. Amt. not Exceeding";
        RetirementFundTaxBenefit := TotalContributionToRetirementFund;
        if RetirementFundLimit1 < RetirementFundTaxBenefit then
            RetirementFundTaxBenefit := RetirementFundLimit1;
        if RetirementFundLimit2 < RetirementFundTaxBenefit then
            RetirementFundTaxBenefit := RetirementFundLimit2;

        TaxableAmount := TotalAnnualEarning - RetirementFundTaxBenefit;
        //Donations
        TotalDonation := Employee."Total Donation Contribution" + CurrentDonation;
        DonationLimit1 := TaxAtOnceTaxableAmt * PGSetup."Tax Ex. Amt. (%) on Donation" / 100;
        DonationLimit2 := PGSetup."Tax Ex. Amt. not Exeed on Don.";
        DonationTaxBenefit := TotalDonation;
        if DonationLimit1 < DonationTaxBenefit then
            DonationTaxBenefit := DonationLimit1;
        if DonationLimit2 < DonationTaxBenefit then
            DonationTaxBenefit := DonationLimit2;
        //Life Insurance
        LoanOutstanding.Reset; //Min 6.28.2022
        LoanOutstanding.SetRange("Employee No.", Employee."No.");
        LoanOutstanding.SetRange("Loan Type", LoanOutstanding."Loan Type"::"Home Loan Insurance Tieup");
        LoanOutstanding.SetRange("Scheme Code", '');
        if LoanOutstanding.FindFirst then
            HLInsAmt := LoanOutstanding.EMI * 12;
        Employee.CalcFields("Premium of Life Insurance", "Premium of Health Insurance", "Premium Property Insurance");
        InsuranceAmount := Employee."Premium of Life Insurance" + HLInsAmt;
        InsuranceLimit1 := PGSetup."Tax Ex. Life Insurance Amt.";
        if InsuranceAmount > InsuranceLimit1 then
            InsuranceTaxBenefit := InsuranceLimit1
        else
            InsuranceTaxBenefit := InsuranceAmount;
        //Health Insurance Tax Benefit
        if Employee."Premium of Health Insurance" < PGSetup."Tax Ex. Health Insur. Amount" then
            HealthInsuranceTaxBenefit := Employee."Premium of Health Insurance"
        else
            HealthInsuranceTaxBenefit := PGSetup."Tax Ex. Health Insur. Amount";
        //Property Insurance Tax Benefit -- Min Added
        if Employee."Premium Property Insurance" < PGSetup."Tax Ex. Property Insurance Amt" then
            PropertyInsuranceTaxBenefit := Employee."Premium Property Insurance"
        else
            PropertyInsuranceTaxBenefit := PGSetup."Tax Ex. Property Insurance Amt";
        //CheckPremiumInsurance(PayrollLine."Employee No.");//Min Commented -- Calculated in above code.
        //Medical Tax Benefit
        TotalMedicalReimbursment := Employee."Total Medical Re-Imbursement" + CurrentMedicalReimbursment;   //>>pradhan    TaxOldEmployeeMedicalReinbursement(Employee."No.")
        MedicalReimbursmentLimit1 := TotalMedicalReimbursment * PGSetup."Tax Ex. Amt. (%) on Medical" / 100;
        MedicalReimbursmentLimit2 := PGSetup."Tax Ex. Amt. not Exeed on Med.";
        if MedicalReimbursmentLimit1 < MedicalReimbursmentLimit2 then
            MedicalReimbursmentTaxBenefit := MedicalReimbursmentLimit1
        else
            MedicalReimbursmentTaxBenefit := MedicalReimbursmentLimit2;
        //Calculation for TaxAtOnce attribute payroll  >>
        CalculateTaxAtOnce;
        //<<Calculation for TaxAtOnce attribute payroll
        if PayrollHeader."Gross Payment" then begin
            PopulateGlobalAmounts;
            PayrollLine."Net Pay" := TaxAtOnceCurrentEarning - AddTaxOnInterestAllowance(Employee."No.", PayrollHeader."No.") - TaxAtOnceCurrentDeduction;
            PayrollLine.Modify;
            exit;
        end;
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then
            TaxableAmount := TotalAnnualEarning - RetirementFundTaxBenefit - DonationTaxBenefit - InsuranceTaxBenefit - HealthInsuranceTaxBenefit - PropertyInsuranceTaxBenefit   //Min 4.22.2022
        else
            TaxableAmount := TotalAnnualEarning - RetirementFundTaxBenefit - DonationTaxBenefit - InsuranceTaxBenefit - HealthInsuranceTaxBenefit - PropertyInsuranceTaxBenefit - FLRecovery - InsuranceRecovery;     //settlement //Min 4.22.2022

        if Employee.Disabled then begin
            TaxSetupLine.Reset;
            TaxSetupLine.SetRange(Code, TaxSetupHeader.Code);
            TaxSetupLine.SetCurrentKey(Code, "Line No.");
            if TaxSetupLine.FindFirst then
                DisablePersonReduction := TaxSetupLine."End Amount" / 2;
            TaxableAmount := TaxableAmount - DisablePersonReduction;
        end;
        //GetRemoteAreaDeduction; //Min Commented -- Remote Do not calculate for Asar 2079 Payroll.
        TaxableAmount := TaxableAmount - PayrollLine."Remote Area Deduction"; //Min 7.6.2022
        RemainingTaxableAmount := TaxableAmount;

        AnnualTax := 0;
        SocialSecurityTax := 0;
        SocialSecurityTaxAmount := 0;
        TaxSetupLine.Reset;
        TaxSetupLine.SetRange(Code, TaxSetupHeader.Code);
        Clear(SlabCount);
        if TaxSetupLine.FindSet then
            repeat
                if RemainingTaxableAmount > 0 then begin
                    TaxSetupLine.TestField("Tax Rate");
                    SlabAmount := GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount");
                    AnnualTax += SlabAmount * TaxSetupLine."Tax Rate" / 100.0;
                    //GetSlabAmount();
                end;
            until (TaxSetupLine.Next = 0);

        CalculateTaxAtOnceTax;

        AnnualTax := AnnualTax - MedicalReimbursmentTaxBenefit;
        if TaxSetupHeader."Special Tax Exempt %" <> 0 then
            AnnualTax := (AnnualTax - (AnnualTax * TaxSetupHeader."Special Tax Exempt %") / 100);

        TotalTaxRemunPaid := EmpPayOpen."Total Tax Remuneration Opening" + Employee."Remuneration & Benefits Tax";
        TotalSSTPaid := EmpPayOpen."Total Social Security Opening" + Employee."Social Security Tax";
        //SocialSecTaxAmt:=TaxOldEmployeeSocialSecurity(Employee."No.");  //>> pradhan
        AnnualTax := AnnualTax - (TotalTaxRemunPaid + TotalSSTPaid);
        /*IF TaxSetupHeader."Special Tax Exempt %" <> 0  THEN BEGIN
          NonRegularTax :=(TaxSetupHeader."Special Tax Exempt %"*(TaxAtOnceAnnualTax - AnnualTax)/ (100-TaxSetupHeader."Special Tax Exempt %"));
         AnnualTax -= NonRegularTax;
        END;*/
        PayrollLine."Gratuity & leave Encash Tax" := Round(PGSetup."Settlement TAX Rate" * SettlementAmount / 100, 0.01, '=');
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then
            MonthlyTax := AnnualTax / (RemainingMonth + 1)
        else
            MonthlyTax := AnnualTax / (RemainingMonth + 1) + Round(PGSetup."Settlement TAX Rate" * SettlementAmount / 100, 0.01, '=');   //settlement

        if TaxAtOnceAnnualTax < 0 then
            MonthlyTax := TaxAtOnceAnnualTax + PayrollLine."Gratuity & leave Encash Tax"
        else begin
            if PayrollHeader.Type = PayrollHeader.Type::Adjustment then
                MonthlyTax := TaxAtOnceAnnualTax - AnnualTax
            else
                MonthlyTax := MonthlyTax + (TaxAtOnceAnnualTax - AnnualTax);
        end;
        PayrollLine.RoundAmount(MonthlyTax);

        TotalTaxWithoutSST := TaxAtOnceAnnualTax + TotalTaxRemunPaid + TotalSSTPaid - SocialSecurityTax + TaxExempt + PayrollLine."Gratuity & leave Encash Tax";
        if TotalTaxWithoutSST > 0 then begin
            if TotalTaxWithoutSST > TaxExempt then
                TotalTaxWithoutSST := TotalTaxWithoutSST - TaxExempt
            else begin
                SocialSecurityTax := SocialSecurityTax - (TaxExempt - TotalTaxWithoutSST);
                TotalTaxWithoutSST := 0;
            end;
        end else
            SocialSecurityTax := SocialSecurityTax - TaxExempt;

        if TotalSSTPaid <> SocialSecurityTax then begin     //>>pradhan     SocialSecTaxAmt
            if SocialSecurityTax - TotalSSTPaid < 0 then begin     //>>pradhan     SocialSecTaxAmt
                SocialSecurityTaxAmount := 0;
                MonthlyTax := -TotalTaxRemunPaid + PayrollLine."Gratuity & leave Encash Tax";
                //SocialSecurityTaxAmount := MonthlyTax + (SocialSecurityTax - Employee."Social Security Tax" -EmpPayOpen."Total Social Security Opening");//>>pradhan     SocialSecTaxAmt
            end else begin
                SocialSecurityTaxAmount := (SocialSecurityTax - TotalSSTPaid) / (RemainingMonth + 1);   //>>pradhan     SocialSecTaxAmt
                if (PayrollHeader.Type = PayrollHeader.Type::Adjustment) and (MonthlyTax > 0) then begin
                    if SocialSecurityTax = (TaxAtOnceAnnualTax + TotalSSTPaid + TotalTaxRemunPaid) then
                        SocialSecurityTaxAmount := MonthlyTax
                    else if (TaxAtOnceAnnualTax + TotalSSTPaid + TotalTaxRemunPaid - MonthlyTax) < SocialSecurityTax then
                        SocialSecurityTaxAmount := SocialSecurityTax - (TaxAtOnceAnnualTax + TotalSSTPaid + TotalTaxRemunPaid - MonthlyTax)
                    else
                        SocialSecurityTaxAmount := 0;
                end;
                if TotalTaxWithoutSST > 0 then begin
                    if (TotalTaxWithoutSST - TotalTaxRemunPaid) < 0 then
                        MonthlyTax := TotalTaxWithoutSST - TotalTaxRemunPaid + SocialSecurityTaxAmount;
                end else
                    MonthlyTax := -TotalTaxRemunPaid + SocialSecurityTaxAmount;
            end;
            /*IF MonthlyTax < 0 THEN BEGIN
              MonthlyTax := 0;
              SocialSecurityTaxAmount := 0;
              MonthlyTax :=0;
            END;*/
        end;
        PayrollLine.RoundAmount(SocialSecurityTaxAmount);
        PopulateGlobalAmounts;
        PayrollLine.Modify;
        if (SocialSecurityTaxAmount <> 0) and (SocialSecurityTaxAttribute <> '') then begin
            //IF (SocialSecurityTaxAmount >= MonthlyTax) AND (MonthlyTax > 0) THEN
            //SocialSecurityTaxAmount := MonthlyTax;
            PayrollLine.SaveValues(SocialSecurityTaxAmount, SocialSecurityTaxAttribute);
            PayrollLine.SaveValues(MonthlyTax - SocialSecurityTaxAmount, TaxAttribute);
        end else
            PayrollLine.SaveValues(MonthlyTax, TaxAttribute);
    end;

    local procedure CalcCurrentEarning()
    var
        FieldID: Integer;
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;

    begin
        CurrentEarning := 0;
        CurrentNonPaymentBenefits := 0;
        RecRef.Open(Database::"Payroll Line");
        for FieldID := 47 to 180 do begin
            if PayrollColumnConfiguration.Get(Database::"Payroll Line", FieldID) then begin
                PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                FieldRef := RecRef.Field(1);
                FieldRef.SetRange(PayrollHeader."No.");
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PayrollLine."Line No.");
                RecRef.FindFirst;
                FieldRef := RecRef.Field(FieldID);
                Evaluate(FieldValue, Format(FieldRef.Value));
                FieldValue := Round(FieldValue, 0.01, '=');
                PayrollAttributes.TestField(Status, PayrollAttributes.Status::Active);
                if not PayrollAttributes."Tax at once" then begin
                    if PayrollAttributes.Type = PayrollAttributes.Type::Benefits then begin
                        if PayrollAttributes."Non-Taxable" = false then begin
                            if FieldValue <> 0 then begin
                                if (PayrollHeader.Type = PayrollHeader.Type::Settlement) and
                                   ((PGSetup.Gratuity = PayrollAttributes.Code) or (PGSetup."Leave Encashment" = PayrollAttributes.Code)) then
                                    SettlementAmount += FieldValue
                                else
                                    CurrentEarning += FieldValue;
                                if PayrollAttributes.Subtype = PayrollAttributes.Subtype::Basic then
                                    BasicSalaryAfterDeduction := FieldValue
                                else if PayrollAttributes.Subtype = PayrollAttributes.Subtype::Medical then
                                    CurrentMedicalReimbursment := FieldValue;
                            end;
                        end
                        else begin
                            if FieldValue <> 0 then
                                CurrentNonTaxableBenefits += FieldValue;
                        end;
                    end
                    else if (PayrollAttributes.Type = PayrollAttributes.Type::Deduction) then begin
                        if (FieldValue <> 0) and (PayrollAttributes.Subtype <> PayrollAttributes.Subtype::"Tax on Remuneration & Benefits")
                          and (PayrollAttributes.Subtype <> PayrollAttributes.Subtype::"Social Security Tax") then begin
                            CurrentDeduction += FieldValue
                        end;
                    end
                    else if (PayrollAttributes.Type = PayrollAttributes.Type::"Non-Payment") then begin
                        if FieldValue <> 0 then begin
                            if PayrollAttributes.Subtype = PayrollAttributes.Subtype::Donation then
                                CurrentDonation += FieldValue;
                            CurrentNonPaymentBenefits += FieldValue;
                        end;
                    end;
                    if (PayrollAttributes.Type = PayrollAttributes.Type::Deduction) and
                      (PayrollAttributes.Code = PGSetup."LFA Recover") then
                        FLRecovery := FieldValue;
                    if (PayrollAttributes.Type = PayrollAttributes.Type::Deduction) and
                      (PayrollAttributes.Code = PGSetup."Insurance Recover") then
                        InsuranceRecovery := FieldValue;
                    if (PayrollAttributes.Type = PayrollAttributes.Type::Deduction) and
                      (PayrollAttributes.Subtype in [PayrollAttributes.Subtype::"Employee Contribution",
                                                     PayrollAttributes.Subtype::"Employer Contribution",
                                                     PayrollAttributes.Subtype::CIT, PayrollAttributes.Subtype::RF, PayrollAttributes.Subtype::"Lump Sum Contribution"]) then begin
                        if FieldValue <> 0 then begin
                            if PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Employer Contribution" then
                                EmployerContribution := FieldValue
                            else if PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Employee Contribution" then
                                EmployeeContribution := FieldValue
                            else if PayrollAttributes.Subtype = PayrollAttributes.Subtype::CIT then
                                CITContribution := FieldValue
                            else if PayrollAttributes.Subtype = PayrollAttributes.Subtype::RF then
                                RF := FieldValue
                            else if PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Lump Sum Contribution" then
                                LumpSumCIT += FieldValue;
                        end;
                    end;
                end;
            end;
        end;
        RecRef.Close;
    end;

    local procedure CalcProjectionEarning()
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        UsageAmount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
    begin
        ProjectionEarning := 0;
        ProjectedNonPaymentBenefit := 0;
        PayrollColumnConfiguration.Reset;
        PayrollColumnConfiguration.SetRange("Table No.", Database::"Level Wise Attributes");
        if PayrollColumnConfiguration.FindSet then begin
            RecRefs.Open(Database::"Level Wise Attributes");
            repeat
                if PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code") then begin
                    if not PayrollAttributesUsage.Get(PayrollAttributes.Code, Employee."No.") then begin
                        UsageAmount := 0;
                        if (PayrollAttributes.Status = PayrollAttributes.Status::Active) and
                            (PayrollAttributes."Non-Taxable" = false)
                           then begin
                            FieldRefs := RecRefs.Field(1);
                            FieldRefs.SetRange(Employee."Salary Grade");
                            FieldRefs := RecRefs.Field(2);
                            FieldRefs.SetRange(Employee."Salary Level");
                            RecRefs.FindFirst;
                            FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                            Evaluate(UsageAmount, Format(FieldRefs.Value));
                            UsageAmount := Round(UsageAmount, 0.01, '=');
                            if not PayrollAttributes."Tax at once" then begin
                                if PayrollAttributes."Apply Every Month" then
                                    ProjectionEarning += UsageAmount * RemainingMonth
                                else begin
                                    ProjectionEarning += UsageAmount * GetPayFrequency(PayrollAttributesUsage, PayrollAttributes);
                                end;
                            end;
                        end;
                    end;
                end;
            until PayrollColumnConfiguration.Next = 0;
        end;

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.SetFilter(Type, '%1|%2', PayrollAttributesUsage.Type::Benefits, PayrollAttributesUsage.Type::"Non-Payment");
        if PayrollAttributesUsage.FindFirst then
            repeat
                PayrollAttributesUsage.CalcFields("Formula Exists");
                UsageAmount := 0;
                if PayrollAttributes.Get(PayrollAttributesUsage.Code) then begin
                    if (PayrollAttributes.Status = PayrollAttributes.Status::Active) and
                        (PayrollAttributes."Non-Taxable" = false) and (not PayrollAttributes."Tax at once")
                       then begin
                        if PayrollAttributesUsage.Amount <> 0 then
                            UsageAmount := PayrollAttributesUsage.Amount
                        else if PayrollAttributesUsage."Formula Exists" then begin
                            UsageAmount := EvaluateAmount(PayrollAttributes.Formula, false);
                        end;
                        UsageAmount := Round(UsageAmount, 0.01, '=');
                        if PayrollAttributes.Type = PayrollAttributes.Type::"Benefits" then
                            if PayrollAttributes."Apply Every Month" then
                                ProjectionEarning += UsageAmount * RemainingMonth
                            else
                                ProjectionEarning += UsageAmount * GetPayFrequency(PayrollAttributesUsage, PayrollAttributes);

                        if PayrollAttributes.Type = PayrollAttributes.Type::"Non-Payment" then
                            if PayrollAttributes."Apply Every Month" then
                                ProjectedNonPaymentBenefit += UsageAmount * RemainingMonth
                            else
                                ProjectedNonPaymentBenefit += UsageAmount * GetPayFrequency(PayrollAttributesUsage, PayrollAttributes);
                    end;
                end;
            until PayrollAttributesUsage.Next = 0;
    end;

    local procedure CalcProjectionRetirementFund()
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        UsageAmount: Decimal;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
    begin
        ProjectionEarning := 0;
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.SetRange(Type, PayrollAttributesUsage.Type::Deduction);
        PayrollAttributesUsage.SetFilter(Subtype, '%1|%2|%3|%4|%5', PayrollAttributesUsage.Subtype::CIT,
                                                      PayrollAttributesUsage.Subtype::"Employee Contribution",
                                                      PayrollAttributesUsage.Subtype::"Employer Contribution", PayrollAttributesUsage.Subtype::RF, PayrollAttributesUsage.Subtype::"Lump Sum Contribution");
        if PayrollAttributesUsage.FindFirst then
            repeat
                PayrollAttributesUsage.CalcFields("Formula Exists");
                UsageAmount := 0;
                if PayrollAttributes.Get(PayrollAttributesUsage.Code) then begin
                    if (PayrollAttributes.Status = PayrollAttributes.Status::Active) and (not PayrollAttributes."Tax at once") then begin
                        if PayrollAttributesUsage.Amount <> 0 then
                            UsageAmount := PayrollAttributesUsage.Amount
                        else if PayrollAttributesUsage."Formula Exists" then
                            UsageAmount := EvaluateAmount(PayrollAttributes.Formula, false)
                        else if PayrollHeader.Type = PayrollHeader.Type::Adjustment then begin
                            PayrollColumnConfig.Reset;
                            PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                            PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributesUsage.Code);
                            if PayrollColumnConfig.FindFirst then begin
                                RecRefs.Open(Database::"Payroll Line");
                                FieldRefs := RecRefs.Field(1);
                                FieldRefs.SetRange(PayrollHeader."No.");
                                FieldRefs := RecRefs.Field(3);
                                FieldRefs.SetRange(Employee."No.");
                                RecRefs.FindFirst;
                                FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                                UsageAmount := FieldRefs.Value;

                                case PayrollAttributes.Subtype of
                                    PayrollAttributes.Subtype::CIT:
                                        CITContribution += UsageAmount;
                                    PayrollAttributes.Subtype::"Lump Sum Contribution":
                                        LumpSumCIT += UsageAmount;
                                    PayrollAttributes.Subtype::"Employee Contribution":
                                        EmployeeContribution += UsageAmount;
                                    PayrollAttributes.Subtype::"Employer Contribution":
                                        EmployerContribution += UsageAmount;
                                    PayrollAttributes.Subtype::RF:
                                        RF += UsageAmount;
                                end;

                                RecRefs.Close;
                            end;
                        end;

                        if PayrollAttributes."Apply Every Month" then
                            ProjectionEarning += UsageAmount * RemainingMonth
                        //ELSE
                        // ProjectionEarning += UsageAmount;
                    end;
                end;
            until PayrollAttributesUsage.Next = 0;
    end;

    procedure EvaluateAmount(Expression: Code[100]; BasicFromLine: Boolean): Decimal
    var
        OperatorStack: array[100] of Code[20];
        NumberStack: array[100] of Decimal;
        DecNumber: Decimal;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        Counter: Integer;
        Num1: Decimal;
        Num2: Decimal;
        operat: Code[20];
    begin
        ResolveColumn(Expression, BasicFromLine);
        Expression := DelChr(Expression, '=', ',');
        Counter := 0;
        ExNo := StrLen(Expression);
        OsNo := 0;
        NsNo := 0;
        repeat
            Counter += 1;
            if Expression[Counter] = '(' then begin
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else if Expression[Counter] = ')' then begin
                if OsNo <> 0 then
                    while (OperatorStack[OsNo] <> '(') and (OsNo <> 0) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValue(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                if (OsNo <> 0) then begin
                    OperatorStack[OsNo] := '';
                    OsNo -= 1;
                end;
            end
            else if Expression[Counter] in ['+', '-', '*', '/'] then begin
                if OsNo <> 0 then
                    while (OsNo <> 0) and (CheckPrecedence(OperatorStack[OsNo]) >= CheckPrecedence(Format(Expression[Counter]))) do begin
                        Num2 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        Num1 := NumberStack[NsNo];
                        NumberStack[NsNo] := 0;
                        NsNo -= 1;
                        operat := OperatorStack[OsNo];
                        OperatorStack[OsNo] := '';
                        OsNo -= 1;
                        NsNo += 1;
                        NumberStack[NsNo] := CalculateValue(Num1, Num2, operat);
                        if OsNo = 0 then
                            break;
                    end;
                OsNo += 1;
                OperatorStack[OsNo] := Format(Expression[Counter]);
            end else begin
                CurrExpr := '';
                repeat
                    ContiguousNumber := false;
                    if Expression[Counter] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] then
                        CurrExpr := CurrExpr + Format(Expression[Counter]);
                    if Counter < ExNo then begin
                        if Evaluate(DecNumber, Format(Expression[Counter + 1])) or (Expression[Counter + 1] = '.') then begin
                            ContiguousNumber := true;
                            Counter += 1;
                        end;
                    end;
                until not ContiguousNumber;
                Evaluate(DecNumber, CurrExpr);
                NsNo += 1;
                NumberStack[NsNo] := DecNumber;
            end;
        until Counter = ExNo;

        while (OsNo <> 0) do begin
            Num2 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            Num1 := NumberStack[NsNo];
            NumberStack[NsNo] := 0;
            NsNo -= 1;
            operat := OperatorStack[OsNo];
            OperatorStack[OsNo] := '';
            OsNo -= 1;
            NsNo += 1;
            NumberStack[NsNo] := CalculateValue(Num1, Num2, operat);
        end;
        exit(NumberStack[NsNo]);
    end;

    local procedure CalculateValue(Number1: Decimal; Number2: Decimal; Opt: Code[20]): Decimal
    begin
        case Opt of
            '*':
                exit(Number1 * Number2);
            '/':
                exit(Number1 / Number2);
            '+':
                exit(Number1 + Number2);
            '-':
                exit(Number1 - Number2);
        end;
    end;

    local procedure CheckPrecedence(Opt: Code[20]): Integer
    begin
        if (Opt = '*') or (Opt = '/') then
            exit(2);
        if (Opt = '+') or (Opt = '-') then
            exit(1);
        exit(0);
    end;

    procedure ResolveColumn(var Expression: Code[100]; BasicFromLine: Boolean)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        BasicAmount: Decimal;
    begin

        Expression := DelChr(Expression, '=');
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        PayrollAttributes.FindFirst;

        BasicAmount := PayrollLine."Basic Salary";
        //ResolveColumnCalc(Expression,PayrollAttributes,BasicFromLine,BasicAmount);
        /*
        Expression := DELCHR(Expression,'=');
        PayrollAttributes.RESET;
        PayrollAttributes.SETRANGE(Type,PayrollAttributes.Type::Benefits);
        PayrollAttributes.SETRANGE(Subtype,PayrollAttributes.Subtype::Grade);
        PayrollAttributes.FINDFIRST;
        BasicAmount := 0;
        ResolveColumnCalc(Expression,PayrollAttributes,BasicFromLine,BasicAmount);

        Expression := DELCHR(Expression,'=');
        PayrollAttributes.RESET;
        PayrollAttributes.SETRANGE(Type,PayrollAttributes.Type::Benefits);
        PayrollAttributes.SETRANGE(Subtype,PayrollAttributes.Subtype::"Add Salary");
        PayrollAttributes.FINDFIRST;

        BasicAmount := 0;
        ResolveColumnCalc(Expression,PayrollAttributes,BasicFromLine,BasicAmount);
        */

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        if PayrollAttributesUsage.FindFirst then begin
            PayrollAttributesUsage.TestField(Amount);
            BasicAmount := PayrollAttributesUsage.Amount;
        end;

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            if BasicFromLine then
                Expression := InsStr(Expression, Format(BasicSalaryAfterDeduction), StrPosition)
            else
                Expression := InsStr(Expression, Format(BasicAmount), StrPosition)
        end;
        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                      'Y', 'Z'] then begin
                PayrollAttributes.Reset;
                PayrollAttributes.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes.FindFirst then begin
                    StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                    Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));
                    //      Expression := INSSTR(Expression,FORMAT(PayrollAttributesUsage.Amount),StrPosition);

                    PayrollAttributesUsage.Reset;
                    PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
                    PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
                    if PayrollAttributesUsage.FindFirst then
                        //IF PayrollAttributesUsage.Amount <> 0 THEN           
                        Expression := InsStr(Expression, Format(PayrollAttributesUsage.Amount), StrPosition)
                    else
                        Expression := InsStr(Expression, Format(0), StrPosition);
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    local procedure GetLastPayPeriod(): Integer
    var
        EmployeeLedgerEntry: Record "Employee Ledger Entry PRM";
        LastPayCyclePeriod: Integer;
    begin
        EmployeeLedgerEntry.Reset;
        EmployeeLedgerEntry.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period");
        EmployeeLedgerEntry.SetRange("Employee No.", Employee."No.");
        EmployeeLedgerEntry.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
        EmployeeLedgerEntry.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
        if EmployeeLedgerEntry.FindLast then
            LastPayCyclePeriod := EmployeeLedgerEntry."Pay Cycle Period";
        if LastPayCyclePeriod > PayrollHeader."Pay Cycle Period" then
            exit(LastPayCyclePeriod)
        else
            exit(PayrollHeader."Pay Cycle Period");
    end;

    local procedure GetPayFrequency(PayrollAttributesUsage: Record "Payroll Attributes Usage"; PayrollAttributes: Record "Payroll Attributes"): Integer
    var
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledg. En PRM";
        PaidFrequencyCount: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
    begin
        if PayrollAttributes."Pay Frequency" = 0 then
            exit(0)
        else begin
            if PayrollAttributes."Pay Cycle Code" <> PayrollHeader."Pay Cycle Code" then
                exit(0);
            PaidFrequencyCount := 0;
            DetailedEmployeeLedgEntry.Reset;
            DetailedEmployeeLedgEntry.SetRange("Employee No.", Employee."No.");
            DetailedEmployeeLedgEntry.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
            DetailedEmployeeLedgEntry.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
            DetailedEmployeeLedgEntry.SetRange(Reversed, false);
            DetailedEmployeeLedgEntry.SetRange("Payroll Attribute Code", PayrollAttributes.Code);
            PaidFrequencyCount := DetailedEmployeeLedgEntry.Count;

            PayrollColumnConfiguration.Reset;
            PayrollColumnConfiguration.SetRange("Table No.", Database::"Payroll Line");
            PayrollColumnConfiguration.SetRange("Variable Field Code", PayrollAttributes.Code);
            if PayrollColumnConfiguration.FindFirst then begin
                RecRef.Open(Database::"Payroll Line");
                FieldRef := RecRef.Field(1);
                FieldRef.SetRange(PayrollHeader."No.");
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PayrollLine."Line No.");
                RecRef.FindFirst;
                FieldRef := RecRef.Field(PayrollColumnConfiguration."Field No.");
                Evaluate(FieldValue, Format(FieldRef.Value));
                if FieldValue <> 0 then
                    PaidFrequencyCount += 1;
            end;
            if PaidFrequencyCount > PayrollAttributes."Pay Frequency" then
                exit(0)
            else
                exit(PayrollAttributes."Pay Frequency" - PaidFrequencyCount)
        end;
    end;

    local procedure GetSettlementPayCyclePeriod(): Integer
    var
        PayCylePeriodVar: Record "Pay Cycle Period";
    begin
        Employee.TestField("Resignation Date");
        PayCylePeriodVar.Reset;
        PayCylePeriodVar.SetFilter("Start Date", '<=%1', Employee."Resignation Date");
        PayCylePeriodVar.SetFilter("End Date", '>=%1', Employee."Resignation Date");
        if PayCylePeriodVar.FindFirst then
            exit(PayCylePeriodVar.Period);
    end;

    local procedure IsContribution(PayrollAttributes: Record "Payroll Attributes"; PayrollAttributesUsage: Record "Payroll Attributes Usage"): Boolean
    begin
        exit((PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Employee Contribution") or
              (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Employer Contribution"))
    end;

    procedure PayrollCaptionClassTranslate(Language: Integer; CaptionRef: Text[80]): Text[30]
    var
        LanguageCode: Code[20];
        LanguageRec: Record Language;
        TableID: Integer;
        FieldNo: Integer;
    begin
        if CaptionRef = '' then
            exit('');
        if not Evaluate(TableID, SelectStr(1, CaptionRef)) then
            exit('');
        if not Evaluate(FieldNo, SelectStr(2, CaptionRef)) then
            exit('');


        LanguageRec.Reset;
        LanguageRec.SetCurrentKey("Windows Language ID");
        LanguageRec.SetRange("Windows Language ID", Language);
        if LanguageRec.Find('-') then
            LanguageCode := LanguageRec.Code;

        exit(GetPayrollCaption(TableID, FieldNo, LanguageCode));
    end;

    procedure GetPayrollCaption(TableNo: Integer; FieldNo: Integer; LanguageCode: Code[20]): Text[30]
    var
        PayColumnConfig: Record "Payroll Column Configuration";
        PayAttribute: Record "Payroll Attributes";
    begin
        if PayColumnConfig.Get(TableNo, FieldNo) then begin
            if PayAttribute.Get(PayColumnConfig."Variable Field Code") then begin
                exit(CopyStr(PayAttribute.Description, 1, 30));
            end;
        end;
        exit('');
    end;

    procedure ShowColumn(TableID: Integer; FieldID: Integer): Boolean
    var
        PayColumnConfig: Record "Payroll Column Configuration";
    begin
        PayColumnConfig.Reset;
        PayColumnConfig.SetRange("Table No.", TableID);
        PayColumnConfig.SetRange("Field No.", FieldID);
        if PayColumnConfig.IsEmpty then
            exit(false)
        else
            exit(true);
    end;

    local procedure "--Temporary>>"()
    begin
    end;

    local procedure DeleteAllDocuments()
    var
        PayrollHeader: Record "Payroll Header";
        PayrollLine: Record "Payroll Line";
        EmployeeLedgerEntry: Record "Employee Ledger Entry PRM";
        DetailedEmployeeLedgEntry: Record "Detailed Employee Ledg. En PRM";
        PostedPayrollHeader: Record "Posted Payroll Header";
        PostedPayrollLine: Record "Posted Payroll Line";
        AttendanceHeader: Record "Attendance Header";
        AttendanceLine: Record "Attendance Line";
        AttendanceSummary: Record "Attendance Summary";
    begin
        PayrollHeader.DeleteAll;
        PayrollLine.DeleteAll;
        EmployeeLedgerEntry.DeleteAll;
        DetailedEmployeeLedgEntry.DeleteAll;
        PostedPayrollHeader.DeleteAll;
        PostedPayrollLine.DeleteAll;
        AttendanceHeader.DeleteAll;
        AttendanceLine.DeleteAll;
        AttendanceSummary.DeleteAll;
        //EmployeeActivityDetails.DELETEALL;
    end;

    local procedure GetFiscalYearDates(var StartDate: Date; var EndDate: Date; PayCyclePeriod: Record "Pay Cycle Period")
    var
        PCP: Record "Pay Cycle Period";
    begin
        PCP.Reset;
        PCP.SetRange("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
        PCP.SetRange("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
        if PCP.FindFirst then
            StartDate := PCP."Start Date";
        if PCP.FindLast then
            EndDate := PCP."End Date";
    end;

    local procedure CreateDocuments()
    var
        PGSetup: Record "Payroll General Setup";
        PayCyclePeriod: Record "Pay Cycle Period";
        PayrollHeader: Record "Payroll Header";
        PayrollLine: Record "Payroll Line";
        PayrollJournalLine: Record "Payroll Journal Line";
        Employee: Record Employee;
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollEngine: Codeunit "Payroll Engine";
        LineNo: Integer;
    begin
        DeleteAllDocuments;
        exit;

        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Code", 'MONTHLY');
        //PayCyclePeriod.SETFILTER("Pay Cycle Term",'%1|%2|%3','2071MNTH','2072MNTH','2073MNTH');
        PayCyclePeriod.SetFilter("Pay Cycle Term", '2071MNTH');
        //PayCyclePeriod.SETRANGE(Period,1);
        if PayCyclePeriod.FindSet then
            repeat
                if PayCyclePeriod.Period = 1 then begin
                    PGSetup.Get;
                    GetFiscalYearDates(PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date", PayCyclePeriod);
                    PGSetup.Modify;
                end;
                Clear(PayrollHeader);
                PayrollHeader.Init;
                PayrollHeader.Insert(true);
                PayrollHeader.Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
                PayrollHeader.Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
                PayrollHeader.Validate("Pay Cycle Period", PayCyclePeriod.Period);
                PayrollHeader.Modify(true);
                if PayCyclePeriod.Period = 3 then begin
                    PayrollAttributesUsage.Init;
                    PayrollAttributesUsage.Code := 'MEDICAL';
                    PayrollAttributesUsage."Employee Code" := 'EMP-000003';
                    PayrollAttributesUsage.Amount := 1200;
                    PayrollAttributesUsage.Insert(true);
                end;
                if PayCyclePeriod.Period = 4 then begin
                    PayrollAttributesUsage.Reset;
                    PayrollAttributesUsage.SetRange(Code, 'MEDICAL');
                    PayrollAttributesUsage.SetRange("Employee Code", 'EMP-000003');
                    if PayrollAttributesUsage.FindFirst then
                        PayrollAttributesUsage.Delete;
                end;
                PayrollHeader.SetHideModificationDialog(true);
                PayrollHeader.ImportEmployee;
                PayrollLine.Reset;
                PayrollLine.SetRange("Document No.", PayrollHeader."No.");
                if PayrollLine.FindSet then
                    repeat
                        //PayrollLine.VALIDATE("Present Days",PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" - 5 -2);
                        //PayrollLine.VALIDATE("Absent Days",3);
                        PayrollLine.Validate("Present Days", PayCyclePeriod."End Date" - PayCyclePeriod."Start Date" - 5 + 1);
                        PayrollLine.Validate("Week off Days", 5);
                        PayrollLine.Modify(true);
                    until PayrollLine.Next = 0;

                PayrollHeader.Reset;
                PayrollHeader.SetRange("No.", PayrollLine."Document No.");
                PayrollHeader.FindFirst;
                PayrollHeader.GetDetails(PayrollHeader);
                Commit;

                PayrollHeader.Reset;
                PayrollHeader.SetRange("No.", PayrollLine."Document No.");
                PayrollHeader.FindFirst;
                PayrollHeader.SetHideModificationDialog(true);
                PayrollHeader.CalculatePayroll(PayrollHeader);
                Commit;

                PayrollHeader.Reset;
                PayrollHeader.SetRange("No.", PayrollLine."Document No.");
                PayrollHeader.FindFirst;
                Codeunit.Run(Codeunit::"Payroll-Post", PayrollHeader);
                Commit;
                if PayCyclePeriod.Period = 6 then begin
                    LineNo := 10000;
                    Employee.Reset;
                    if Employee.FindSet then
                        repeat
                            if PayrollEngine.IsValidEmployee(Employee, PayrollHeader."From Date", PayrollHeader."To Date") then begin
                                PayrollJournalLine.Init;
                                PayrollJournalLine."Journal Template Name" := '';
                                PayrollJournalLine."Journal Batch Name" := 'DEFAULT';
                                PayrollJournalLine."Line No." := LineNo;
                                PayrollJournalLine.Insert(true);
                                PayrollJournalLine."Document No." := Format(PayCyclePeriod."Pay Cycle Term") + 'INC01';
                                PayrollJournalLine.SetHideValidation(true);
                                PayrollJournalLine.SetUpNewLine(PayrollJournalLine, PayrollJournalLine."Balance (LCY)", true);
                                PayrollJournalLine.Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
                                PayrollJournalLine.Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
                                PayrollJournalLine.Validate("Pay Cycle Period", PayCyclePeriod.Period);
                                PayrollJournalLine.Validate("Employee No.", Employee."No.");
                                PayrollJournalLine.Validate("Document Date", Today);
                                PayrollJournalLine.Validate("Attribute Code", 'TECHNICAL ALLOWANCE');
                                PayrollJournalLine.Validate(Description, 'Technical Allowance');
                                PayrollJournalLine.Validate(Amount, 150000);
                                PayrollJournalLine.UpdateLineBalance;
                                PayrollJournalLine.Modify(true);
                                LineNo += 10000;
                                PayrollJournalLine.Init;
                                PayrollJournalLine."Journal Template Name" := '';
                                PayrollJournalLine."Journal Batch Name" := 'DEFAULT';
                                PayrollJournalLine."Line No." := LineNo;
                                PayrollJournalLine.Insert(true);
                                PayrollJournalLine."Document No." := Format(PayCyclePeriod."Pay Cycle Term") + 'INC01';
                                PayrollJournalLine.SetHideValidation(true);
                                PayrollJournalLine.SetUpNewLine(PayrollJournalLine, PayrollJournalLine."Balance (LCY)", true);
                                PayrollJournalLine.Validate("Pay Cycle Code", PayCyclePeriod."Pay Cycle Code");
                                PayrollJournalLine.Validate("Pay Cycle Term", PayCyclePeriod."Pay Cycle Term");
                                PayrollJournalLine.Validate("Pay Cycle Period", PayCyclePeriod.Period);
                                PayrollJournalLine.Validate("Employee No.", Employee."No.");
                                PayrollJournalLine.Validate("Document Type", PayrollJournalLine."Document Type"::Payment);
                                PayrollJournalLine.Validate("Account Type", PayrollJournalLine."Account Type"::"Bank Account");
                                PayrollJournalLine.Validate("Account No.", 'B-0001');
                                PayrollJournalLine.Validate("Document Date", Today);
                                PayrollJournalLine.Validate(Description, 'Technical Allowance Payment');
                                PayrollJournalLine.Validate(Amount, -150000);
                                PayrollJournalLine.UpdateLineBalance;
                                PayrollJournalLine.Modify(true);
                                LineNo += 10000;
                            end;
                        until Employee.Next = 0;
                    Codeunit.Run(Codeunit::"Payroll Jnl.-Post Line", PayrollJournalLine);
                    Commit;
                end;
            until PayCyclePeriod.Next = 0;
    end;

    local procedure GenerateTimeSheetPostingEntry(FromDate: Date; ToDate: Date)
    var
        ProgressWindow: Dialog;
    begin
        /* commented at UTS1.00
        TimeSheetPostingEntry.RESET;
        TimeSheetPostingEntry.DELETEALL;
        ProgressWindow.OPEN(Text000);
        AttendanceSetup.GET;
        Employee.RESET;
        ProgressWindow.UPDATE(2,Employee.COUNT);
        IF Employee.FINDSET THEN REPEAT
          TotalCount += 1;
          ProgressWindow.UPDATE(1,TotalCount);
          Date.RESET;
          Date.SETRANGE("Period Type",Date."Period Type"::Date);
          Date.SETFILTER("Period Start",'%1..%2',FromDate,ToDate);
          IF Date.FINDSET THEN REPEAT
            IF DATE2DMY(Date."Period Start",1) IN [5,10,15,20,25,30] THEN
              WorkingHour := RandomNumberGenerator.RandInt(7)
            ELSE
              WorkingHour := 8;
            IF WorkingHour IN [1,2,4,6,7] THEN
              WorkingHour := 0;
            IF (WorkingHour = 0) AND (RandomNumberGenerator.RandInt(7) IN [1,3,5]) THEN BEGIN
              IF NOT IsHoliday(AttendanceSetup."Base Calender",Date."Period Start",TempRemarks) THEN BEGIN
                CLEAR(TimeSheetPostingEntry);
                TimeSheetPostingEntry.INIT;
                TimeSheetPostingEntry."Time Sheet Date" := Date."Period Start";
                TimeSheetPostingEntry."Posting Date" := TODAY;
                TimeSheetPostingEntry."Day Type" := TimeSheetPostingEntry."Day Type"::Leave;
                TimeSheetPostingEntry.Chargeable := TRUE;
                TimeSheetPostingEntry.Reversed := FALSE;
                TimeSheetPostingEntry."Actual Hour" := 8;
                TimeSheetPostingEntry.Quantity := 8;
                TimeSheetPostingEntry."Standard Hour" := 8;
                TimeSheetPostingEntry."Employee No." := Employee."No.";
                TimeSheetPostingEntry.INSERT(TRUE);
              END;
            END;
            IF (WorkingHour = 8) AND (RandomNumberGenerator.RandInt(7) IN [1,3]) THEN BEGIN
                RecordedHour := 0;
                GeneratedHour := 0;
                WHILE RecordedHour < 2 DO BEGIN
                  CLEAR(TimeSheetPostingEntry);
                  TimeSheetPostingEntry.INIT;
                  TimeSheetPostingEntry."Time Sheet Date" := Date."Period Start";
                  TimeSheetPostingEntry."Posting Date" := TODAY;
                  TimeSheetPostingEntry."Day Type" := TimeSheetPostingEntry."Day Type"::Overtime;
                  TimeSheetPostingEntry.Chargeable := TRUE;
                  TimeSheetPostingEntry.Reversed := FALSE;
                  CLEAR(RandomNumberGenerator);
                  GeneratedHour := RandomNumberGenerator.RandInt(2 - RecordedHour);
                  TimeSheetPostingEntry."Actual Hour" := GeneratedHour;
                  TimeSheetPostingEntry.Quantity := GeneratedHour;
                  IF IsHoliday(AttendanceSetup."Base Calender",Date."Period Start",TempRemarks) THEN
                    TimeSheetPostingEntry."Standard Hour" := 0
                  ELSE
                    TimeSheetPostingEntry."Standard Hour" := 8;
                  TotalDonor := 11;
                  DimensionValue.RESET;
                  DimensionValue.SETRANGE("Dimension Value Type",DimensionValue."Dimension Value Type"::Standard);
                  DimensionValue.SETRANGE("Global Dimension No.",2);
                  IF DimensionValue.FINDFIRST THEN BEGIN
                    RANDOMIZE;
                    RandomNext := RANDOM(TotalDonor);
                    DimensionValue.NEXT(RandomNext);
                    TimeSheetPostingEntry."Job No." := DimensionValue.Code;
                  END;
                  TimeSheetPostingEntry."Employee No." := Employee."No.";
                  TimeSheetPostingEntry.INSERT(TRUE);
                  RecordedHour += GeneratedHour;
                END;
            END;

            IF WorkingHour > 0 THEN BEGIN
              IF NOT IsHoliday(AttendanceSetup."Base Calender",Date."Period Start",TempRemarks) THEN BEGIN
                RecordedHour := 0;
                GeneratedHour := 0;
                WHILE RecordedHour < WorkingHour DO BEGIN
                  CLEAR(TimeSheetPostingEntry);
                  TimeSheetPostingEntry.INIT;
                  TimeSheetPostingEntry."Time Sheet Date" := Date."Period Start";
                  TimeSheetPostingEntry."Posting Date" := TODAY;
                  TimeSheetPostingEntry."Day Type" := TimeSheetPostingEntry."Day Type"::Working;
                  TimeSheetPostingEntry.Chargeable := TRUE;
                  TimeSheetPostingEntry.Reversed := FALSE;
                  CLEAR(RandomNumberGenerator);
                  GeneratedHour := RandomNumberGenerator.RandInt(WorkingHour - RecordedHour);
                  TimeSheetPostingEntry."Actual Hour" := GeneratedHour;
                  TimeSheetPostingEntry.Quantity := GeneratedHour;
                  TimeSheetPostingEntry."Standard Hour" := 8;
                  TotalDonor := 11;
                  DimensionValue.RESET;
                  DimensionValue.SETRANGE("Dimension Value Type",DimensionValue."Dimension Value Type"::Standard);
                  DimensionValue.SETRANGE("Global Dimension No.",2);
                  IF DimensionValue.FINDFIRST THEN BEGIN
                    RANDOMIZE;
                    RandomNext := RANDOM(TotalDonor);
                    DimensionValue.NEXT(RandomNext);
                    TimeSheetPostingEntry."Job No." := DimensionValue.Code;
                  END;
                  TimeSheetPostingEntry."Employee No." := Employee."No.";
                  TimeSheetPostingEntry.INSERT(TRUE);
                  RecordedHour += GeneratedHour;
                END;
              END;
            END;
          UNTIL Date.NEXT = 0;
        UNTIL Employee.NEXT = 0;
        */
        ProgressWindow.Close;
    end;

    local procedure "--Temporary<<"()
    begin
    end;

    local procedure "--Journal"()
    begin
    end;

    procedure SetName(CurrentJnlBatchName: Code[20]; var PayrollJournalLine: Record "Payroll Journal Line")
    begin
        PayrollJournalLine.FilterGroup := 2;
        PayrollJournalLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        PayrollJournalLine.FilterGroup := 0;
        if PayrollJournalLine.Find('-') then;
    end;

    procedure CalcBalance(var PayrollJournalLine: Record "Payroll Journal Line"; LastPayrollJournalLine: Record "Payroll Journal Line"; var Balance: Decimal; var TotalBalance: Decimal; var ShowBalance: Boolean; var ShowTotalBalance: Boolean)
    var
        TempPayrollJournalLine: Record "Payroll Journal Line";
    begin
        TempPayrollJournalLine.CopyFilters(PayrollJournalLine);
        ShowTotalBalance := TempPayrollJournalLine.CalcSums("Balance (LCY)");
        if ShowTotalBalance then begin
            TotalBalance := TempPayrollJournalLine."Balance (LCY)";
            if PayrollJournalLine."Line No." = 0 then
                TotalBalance := TotalBalance + LastPayrollJournalLine."Balance (LCY)";
        end;

        if PayrollJournalLine."Line No." <> 0 then begin
            TempPayrollJournalLine.SetRange("Line No.", 0, PayrollJournalLine."Line No.");
            ShowBalance := TempPayrollJournalLine.CalcSums("Balance (LCY)");
            if ShowBalance then
                Balance := TempPayrollJournalLine."Balance (LCY)";
        end else begin
            TempPayrollJournalLine.SetRange("Line No.", 0, LastPayrollJournalLine."Line No.");
            ShowBalance := TempPayrollJournalLine.CalcSums("Balance (LCY)");
            if ShowBalance then begin
                Balance := TempPayrollJournalLine."Balance (LCY)";
                TempPayrollJournalLine.CopyFilters(PayrollJournalLine);
                TempPayrollJournalLine := LastPayrollJournalLine;
                if TempPayrollJournalLine.Next = 0 then
                    Balance := Balance + LastPayrollJournalLine."Balance (LCY)";
            end;
        end;
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[20]; var PayrollJournalLine: Record "Payroll Journal Line")
    begin
        CheckTemplateName(CurrentJnlBatchName);
        PayrollJournalLine.FilterGroup := 2;
        PayrollJournalLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        PayrollJournalLine.FilterGroup := 0;
    end;

    local procedure CheckTemplateName(var CurrentJnlBatchName: Code[20])
    var
        PayrollJournalBatch: Record "Payroll Journal Batch";
    begin
        if not PayrollJournalBatch.Get(CurrentJnlBatchName) then begin
            if not PayrollJournalBatch.FindFirst then begin
                PayrollJournalBatch.Init;
                PayrollJournalBatch.Code := Text004;
                PayrollJournalBatch.Description := Text005;
                PayrollJournalBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := PayrollJournalBatch.Code
        end;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[20]; var PayrollJournalLine: Record "Payroll Journal Line")
    var
        PayrollJournalBatch: Record "Payroll Journal Batch";
    begin
        PayrollJournalBatch.Get(CurrentJnlBatchName);
    end;

    procedure LookupName(var CurrentJnlBatchName: Code[20]; var PayrollJournalLine: Record "Payroll Journal Line")
    var
        PayrollJournalBatch: Record "Payroll Journal Batch";
    begin
        Commit;
        PayrollJournalBatch.Code := PayrollJournalLine.GetRangeMax("Journal Batch Name");
        if Page.RunModal(0, PayrollJournalBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := PayrollJournalBatch.Code;
            SetName(CurrentJnlBatchName, PayrollJournalLine);
        end;
    end;

    procedure OpenJnlBatch(var PayrollJournalBatch: Record "Payroll Journal Batch")
    begin
    end;

    procedure GetGenJnlDocumentNo(var PayrollJournalLine: Record "Payroll Journal Line"; PostingDate: Date; CreateError: Boolean): Code[20]
    var
        PayrollJournalBatch: Record "Payroll Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentNo: Code[20];
    begin
        PayrollJournalBatch.Get(PayrollJournalLine."Journal Batch Name");
        if (PayrollJournalBatch."No. Series" <> '') and not PayrollJournalLine.Find('=><') then
            DocumentNo := NoSeriesMgt.GetNextNo(PayrollJournalBatch."No. Series", PostingDate, false);
        if (DocumentNo = '') and CreateError then
            Error(Text000, PayrollJournalLine.FieldCaption("Document No."));
        exit(DocumentNo);
    end;

    procedure GetPayrollDateFilter(): Text
    begin
        if PGSetup.Get then begin
            if (PGSetup."Payroll Fiscal Year Start Date" <> 0D) and (PGSetup."Payroll Fiscal Year End Date" <> 0D) then
                exit(Format(PGSetup."Payroll Fiscal Year Start Date") + '..' + Format(PGSetup."Payroll Fiscal Year End Date"));
        end;
    end;

    local procedure "--EmployeeValidation"()
    begin
    end;

    procedure IsValidEmployee(Employee: Record Employee; ProcessingFrom: Date; ProcessingTo: Date): Boolean
    var
        PGSetup: Record "Payroll General Setup";
    begin
        PGSetup.Get;
        PGSetup.TestField("Payroll Fiscal Year Start Date");
        PGSetup.TestField("Payroll Fiscal Year End Date");

        if (ProcessingFrom <> 0D) and (ProcessingTo <> 0D) then
            if Employee."Employment Date" > ProcessingTo then
                exit(false);
        /*IF (Employee."Tax Code" <> '') AND
            (Employee."Salary Level" <> '') AND
            (Employee."Salary Grade" <> '') AND
            //(Employee."Employee Designation" <> '') AND
            (Employee."Employment Date" < PGSetup."Payroll Fiscal Year End Date") AND
            (Employee.Status = Employee.Status::Active) THEN*/     //tesing oman
                                                                   //HasEmployeeDimension(Employee."No.") THEN    UTS Commented
        exit(true);
    end;

    procedure HasEmployeeDimension(EmployeeCode: Code[20]): Boolean
    var
        DefaultDimension: Record "Default Dimension";
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.Get;
        DefaultDimension.Reset;
        DefaultDimension.SetRange("Table ID", Database::Employee);
        DefaultDimension.SetRange("No.", EmployeeCode);
        DefaultDimension.SetRange("Dimension Code", HRSetup."Employee Dimension");
        if DefaultDimension.FindFirst then
            exit(DefaultDimension."Dimension Value Code" <> '');
    end;

    local procedure "--Navigation"()
    begin
    end;

    procedure RetrieveEmployeeLedgers(var DocumentEntry: Record "Document Entry" temporary; DocNoFilter: Code[250]; PostingDateFilter: Text[250])
    begin
        if PostedPayrollHeader.ReadPermission then begin
            PostedPayrollHeader.Reset;
            PostedPayrollHeader.SetCurrentKey("No.");
            PostedPayrollHeader.SetFilter("No.", DocNoFilter);
            PostedPayrollHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(
              DocumentEntry, Database::"Posted Payroll Header", 0, PostedPayrollHeader.TableCaption, PostedPayrollHeader.Count);
        end;

        if EmployeeLedgerEntry.ReadPermission then begin
            EmployeeLedgerEntry.Reset;
            EmployeeLedgerEntry.SetCurrentKey("Document No.");
            EmployeeLedgerEntry.SetFilter("G/L Document No", DocNoFilter);
            EmployeeLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(
              DocumentEntry, Database::"Employee Ledger Entry PRM", 0, EmployeeLedgerEntry.TableCaption, EmployeeLedgerEntry.Count);
        end;

        if DetailedEmployeeLedgEntry.ReadPermission then begin
            DetailedEmployeeLedgEntry.Reset;
            DetailedEmployeeLedgEntry.SetCurrentKey("Document No.");
            DetailedEmployeeLedgEntry.SetFilter("G/L Document No", DocNoFilter);
            DetailedEmployeeLedgEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(
              DocumentEntry, Database::"Detailed Employee Ledg. En PRM", 0, DetailedEmployeeLedgEntry.TableCaption, DetailedEmployeeLedgEntry.Count);
        end;
    end;

    local procedure InsertIntoDocEntry(var DocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType: Option; DocTableName: Text[1024]; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;
        DocumentEntry.Init;
        DocumentEntry."Entry No." := DocumentEntry."Entry No." + 1;
        DocumentEntry."Table ID" := DocTableID;
        DocumentEntry."Document Type" := DocType;
        DocumentEntry."Table Name" := CopyStr(DocTableName, 1, MaxStrLen(DocumentEntry."Table Name"));
        DocumentEntry."No. of Records" := DocNoOfRecords;
        DocumentEntry.Insert;
    end;

    procedure ShowEmployeeLedgers(TableID: Integer)
    begin
        case TableID of
            Database::"Posted Payroll Header":
                Page.Run(Page::"Posted Payroll Plan", PostedPayrollHeader);
            Database::"Employee Ledger Entry PRM":
                Page.Run(0, EmployeeLedgerEntry);
            Database::"Detailed Employee Ledg. En PRM":
                Page.Run(0, DetailedEmployeeLedgEntry);
        end;
    end;

    local procedure "--Getting--Attendance"()
    begin
    end;

    procedure PrepareEmployeeDailyActivity(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date; PreparationBeforePosting: Boolean)
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        Leave: Record Leave;
        Travel: Record "Travel Request";
        OverTime: Record OverTime;
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        AttendanceLine: Record "Attendance Line";
        TrainingAttend: Record "Training Attendance";
        AllowanceAssignMgt: Codeunit "Allowance Assignment Mgt";
    begin
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
        EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
        EmployeeAttendanceActivity.DeleteAll;

        AttendanceLine.Reset;
        AttendanceLine.SetCurrentKey("Employee No.", "Attendance Date");
        AttendanceLine.SetRange("Employee No.", EmployeeCode);
        AttendanceLine.SetRange("Attendance Date", StartDate, EndDate);
        // IF PreparationBeforePosting THEN
        //     AttendanceLine.SETRANGE(Status, AttendanceLine.Status::Open)
        // ELSE
        //     AttendanceLine.SETRANGE(Status, AttendanceLine.Status::Released);
        if AttendanceLine.FindSet then
            repeat
                Clear(EmployeeAttendanceActivity);
                EmployeeAttendanceActivity.TransferFields(AttendanceLine);
                EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
                EmployeeAttendanceActivity.Insert;
            until AttendanceLine.Next = 0;

        // EmployeeActivity.Reset;
        // EmployeeActivity.SetCurrentKey("Employee No.", "Start Date", "End Date");
        // EmployeeActivity.SetFilter(Type, '%1|%2|%3', EmployeeActivity.Type::"Leave Request", EmployeeActivity.Type::"Travel Request",
        //                                             EmployeeActivity.Type::"Attendance Missed"); //Min 8.21.2022
        // EmployeeActivity.SetRange("Employee No.", EmployeeCode);
        // EmployeeActivity.SetFilter("Start Date", '<=%1', StartDate);
        // EmployeeActivity.SetFilter("End Date", '>=%1', StartDate);
        // EmployeeActivity.SetRange("Approval Status", EmployeeActivity."Approval Status"::Approved);
        // EmployeeActivity.SetFilter("Cancelled No.", '%1', '');
        // EmployeeActivity.SetRange(Cancelled, false);
        // if EmployeeActivity.FindSet then
        //     repeat
        //         CorrectAttendanceActivity(EmployeeActivity, StartDate);
        //     until EmployeeActivity.Next = 0;

        // for Approved leave Request
        Leave.Reset;
        Leave.SetCurrentKey("Employee No.", "Start Date", "End Date");
        Leave.SetRange(Type, Leave.Type::"Leave Request"); //Min 8.21.2022
        Leave.SetRange("Employee No.", EmployeeCode);
        Leave.SetFilter("Start Date", '<=%1', StartDate);
        Leave.SetFilter("End Date", '>=%1', StartDate);
        Leave.SetRange("Approval Status", Leave."Approval Status"::Approved);
        Leave.SetFilter("Cancelled No.", '%1', '');
        Leave.SetRange(Cancelled, false);
        if Leave.FindSet then
            repeat
                CorrectAttendanceActivity(Leave.Type, Leave."No.", StartDate, EmployeeCode);
            until Leave.Next = 0;

        // for Approved Travel Request
        Travel.Reset;
        Travel.SetCurrentKey("Employee No.", "Start Date", "End Date");
        Travel.SetRange(Type, Leave.Type::"Travel Request"); //Min 8.21.2022
        Travel.SetRange("Employee No.", EmployeeCode);
        Travel.SetFilter("Start Date", '<=%1', StartDate);
        Travel.SetFilter("End Date", '>=%1', StartDate);
        Travel.SetRange("Approval Status", Leave."Approval Status"::Approved);
        Travel.SetFilter("Cancelled No.", '%1', '');
        Travel.SetRange(Cancelled, false);
        if Travel.FindSet then
            repeat
                CorrectAttendanceActivity(Travel.Type, Travel."No.", StartDate, EmployeeCode);
            until Travel.Next = 0;

        // for Approved OverTime Request
        OverTime.Reset;
        OverTime.SetCurrentKey("Employee No.", "Start Date", "End Date");
        OverTime.SetRange(Type, OverTime.Type::Overtime); //Min 8.21.2022
        OverTime.SetRange("Employee No.", EmployeeCode);
        OverTime.SetFilter("Start Date", '<=%1', StartDate);
        OverTime.SetFilter("End Date", '>=%1', StartDate);
        OverTime.SetRange("Approval Status", OverTime."Approval Status"::Approved);
        OverTime.SetRange(Cancelled, false);
        if OverTime.FindSet then
            repeat
                CorrectAttendanceActivity(OverTime.Type, OverTime."No.", StartDate, EmployeeCode);
            until OverTime.Next = 0;
        // for Approved AllowanceAssignmentLine Request
        AllowanceAssignmentLine.Reset;
        AllowanceAssignmentLine.SetRange("Emp Act Type", AllowanceAssignmentLine."Emp Act Type"::"Allowance Assignment"); //Min 8.21.2022
        AllowanceAssignmentLine.SetRange("Employee Code", EmployeeCode);
        AllowanceAssignmentLine.SetFilter("From Date", '<=%1', StartDate);
        AllowanceAssignmentLine.SetFilter("To Date", '>=%1', StartDate);
        AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Approved);
        if AllowanceAssignmentLine.Findset then
            repeat
                AllowanceAssignMgt.InsertAllowanceAssignmentDayInAttendance(AllowanceAssignmentLine);
            until AllowanceAssignmentLine.Next = 0;

        TrainingAttend.Reset;
        TrainingAttend.SetRange("Employee No.", EmployeeCode);
        TrainingAttend.SetRange("Attended Date", StartDate);
        if TrainingAttend.FindFirst then begin
            EmployeeAttendanceActivity.Reset;
            EmployeeAttendanceActivity.SetRange("Employee No.", TrainingAttend."Employee No.");
            EmployeeAttendanceActivity.SetRange("Attendance Date", TrainingAttend."Attended Date");
            if EmployeeAttendanceActivity.FindFirst then begin
                EmployeeAttendanceActivity."Training Day" := 1;
                EmployeeAttendanceActivity.Validate("Present Day", 1);
                EmployeeAttendanceActivity."Employee Activity Found" := true;
                EmployeeAttendanceActivity."Source No." := TrainingAttend."Training No";
                EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
            end;
        end;
        CalculateLateDays(EmployeeCode, StartDate, EndDate);
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
        EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate);
        if EmployeeAttendanceActivity.FindFirst then begin
            if (EmployeeAttendanceActivity."Present Day" = 0) and (EmployeeAttendanceActivity."Leave Day" = 0) and (EmployeeAttendanceActivity."Week Off Day" = 0) then begin
                EmployeeAttendanceActivity.Validate("Absent Day", 1);
                EmployeeAttendanceActivity.Modify;
            end;
        end;
    end;

    local procedure CorrectAttendanceActivity(EmployeeActType: Enum "Employee Activity Type"; EmpActNo: Code[20]; AttendanceDate: Date; EmpNo: Code[20])
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        Leave: Record Leave;
        PRSetup: Record "Payroll General Setup";
    begin
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmpNo);
        EmployeeAttendanceActivity.SetRange("Attendance Date", AttendanceDate);
        if EmployeeAttendanceActivity.FindFirst then begin
            case EmployeeActType of
                EmployeeActType::"Leave Request":
                    begin
                        //EmployeeAttendanceActivity."Check In Time" := 0T;
                        //EmployeeAttendanceActivity."Check Out Time" := 0T;
                        Leave.Get(EmpActNo);
                        LeaveTypeSetup.Get(Leave."Leave Code");
                        if EmployeeAttendanceActivity."Day Type" = EmployeeAttendanceActivity."Day Type"::Holiday then
                            if not LeaveTypeSetup."Exclude Non Working Days" then begin
                                EmployeeAttendanceActivity."Day Type" := EmployeeAttendanceActivity."Day Type"::"Working Day";
                                EmployeeAttendanceActivity."Week Off Day" := 0;
                            end;
                        if LeaveTypeSetup."Pay Type" = LeaveTypeSetup."Pay Type"::Paid then begin
                            EmployeeAttendanceActivity."Pay Type" := EmployeeAttendanceActivity."Pay Type"::Paid;
                        end else begin
                            EmployeeAttendanceActivity."Pay Type" := EmployeeAttendanceActivity."Pay Type"::Unpaid;
                        end;
                        if leave."Leave Type" = Leave."Leave Type"::"Full Day" then begin
                            EmployeeAttendanceActivity."Leave Day" := 1;
                            EmployeeAttendanceActivity."Present Day" := 0;
                        end else begin
                            EmployeeAttendanceActivity."Leave Day" := 0.5;
                            EmployeeAttendanceActivity."Present Day" := 0.5;
                        end;
                        EmployeeAttendanceActivity."Tour Day" := 0;
                        EmployeeAttendanceActivity."Half Day" := 0;
                        EmployeeAttendanceActivity."OT Hrs" := 0;
                        EmployeeAttendanceActivity."OT Day" := 0;
                        EmployeeAttendanceActivity."Late Day" := 0;
                        EmployeeAttendanceActivity."Outdoor Duty Day" := 0;
                        EmployeeAttendanceActivity."Training Day" := 0;
                        EmployeeAttendanceActivity.Validate("Leave Description", Leave."Leave Description");
                    end;

                EmployeeActType::"Travel Request":
                    begin
                        EmployeeAttendanceActivity."Leave Day" := 0;
                        //EmployeeAttendanceActivity."Check In Time" := 0T; //Min 10.17.2022
                        //EmployeeAttendanceActivity."Check Out Time" := 0T; //Min 10.17.2022
                        EmployeeAttendanceActivity.Validate("Present Day", 1);
                        EmployeeAttendanceActivity."Absent Day" := 0;
                        EmployeeAttendanceActivity."Tour Day" := 1;
                        EmployeeAttendanceActivity."Half Day" := 0;
                        EmployeeAttendanceActivity."OT Hrs" := 0;
                        EmployeeAttendanceActivity."OT Day" := 0;
                        EmployeeAttendanceActivity."Late Day" := 0;
                        EmployeeAttendanceActivity."Outdoor Duty Day" := 0;
                        EmployeeAttendanceActivity."Training Day" := 0;
                    end;
            end;

            /*EmployeeActivity.Type::Overtime : BEGIN //Min 8.21.2022
              EmployeeAttendanceActivity."Check In Time" := EmployeeActivity."Start Time";
              EmployeeAttendanceActivity."Check Out Time" := EmployeeActivity."End Time";
              //EmployeeAttendanceActivity."OT Day" := 1;
            END;*/
        end;
        EmployeeAttendanceActivity."Employee Activity Found" := true;
        EmployeeAttendanceActivity."Source No." := EmpActNo;
        EmployeeAttendanceActivity."Created Datetime" := CurrentDateTime;
        CalcAttendance(EmployeeAttendanceActivity);
        EmployeeAttendanceActivity.Modify;
    end;

    local procedure CalcAttendance(var EmployeeAttendanceActivity: Record "Employee Attendance & Activity")
    var
        AttendanceSetup: Record "Attendance Setup";
        CheckInLateMinutes: Duration;
        CheckOutEarlyMinutes: Duration;
        CheckInEarlyMinutes: Duration;
        CheckOutLateMinutes: Duration;
        TempRemarks: Text[100];
    begin
        AttendanceSetup.Get;
        if IsHoliday(AttendanceSetup."Base Calender", EmployeeAttendanceActivity."Attendance Date", TempRemarks, Employee."Province Code", Employee.Gender, Employee."Inside/Outside Valley", Employee."Posting Region", Employee."Global Dimension 1 Code") then begin
            if AttendanceSetup."Min. minutes to be OT Eligible" <> 0 then begin
                EmployeeAttendanceActivity."OT Hrs" := Round((EmployeeAttendanceActivity."Actual Work Time" / (60 * 1000)) / AttendanceSetup."Min. minutes to be OT Eligible", 1, '<');
                if EmployeeAttendanceActivity."OT Hrs" > 0 then
                    EmployeeAttendanceActivity."OT Day" := 1;
            end;
        end else begin
            if (EmployeeAttendanceActivity."Shift Start Time" <> 0T) and (EmployeeAttendanceActivity."Check In Time" <> 0T) then
                EmployeeAttendanceActivity."Check In Difference" := EmployeeAttendanceActivity."Shift Start Time" - EmployeeAttendanceActivity."Check In Time";
            if (EmployeeAttendanceActivity."Check Out Time" <> 0T) and (EmployeeAttendanceActivity."Shift End Time" <> 0T) then
                EmployeeAttendanceActivity."Check Out Difference" := EmployeeAttendanceActivity."Check Out Time" - EmployeeAttendanceActivity."Shift End Time";
            if EmployeeAttendanceActivity."Check In Difference" < 0 then
                EmployeeAttendanceActivity."Late Check In Day" := 1;
            if EmployeeAttendanceActivity."Check Out Difference" < 0 then
                EmployeeAttendanceActivity."Early Check Out Day" := 1;

            if AttendanceSetup."Per Day Late Tolerance" <> 0 then begin
                if EmployeeAttendanceActivity."Check In Difference" < 0 then
                    CheckInLateMinutes := EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                if EmployeeAttendanceActivity."Check Out Difference" < 0 then
                    CheckOutEarlyMinutes := EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);
                if (Abs(CheckInLateMinutes) > AttendanceSetup."Per Day Late Tolerance") or
                    ((Abs(CheckOutEarlyMinutes) > AttendanceSetup."Per Day Late Tolerance")) then begin
                    if EmployeeAttendanceActivity."Leave Day" = 0 then begin
                        EmployeeAttendanceActivity."Present Day" := 0.5;
                        EmployeeAttendanceActivity."Absent Day" := 0.5;
                        EmployeeAttendanceActivity."Half Day" := 0.5;
                    end;
                end;
            end;

            if AttendanceSetup."Min. minutes to be OT Eligible" <> 0 then begin
                if EmployeeAttendanceActivity."Check In Difference" > 0 then
                    CheckInEarlyMinutes := EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                if EmployeeAttendanceActivity."Check Out Difference" > 0 then
                    CheckOutLateMinutes := EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);

                if CheckInEarlyMinutes > AttendanceSetup."Min. minutes to be OT Eligible" then
                    EmployeeAttendanceActivity."OT Hrs" := Round(CheckInEarlyMinutes / AttendanceSetup."Min. minutes to be OT Eligible", 1, '<');
                if CheckOutLateMinutes > AttendanceSetup."Min. minutes to be OT Eligible" then
                    EmployeeAttendanceActivity."OT Hrs" += Round(CheckOutLateMinutes / AttendanceSetup."Min. minutes to be OT Eligible", 1, '<');
                if EmployeeAttendanceActivity."OT Hrs" > 0 then
                    EmployeeAttendanceActivity."OT Day" := 1;
            end;
            if (EmployeeAttendanceActivity."Check In Time" <> 0T) and (EmployeeAttendanceActivity."Check Out Time" <> 0T) then
                EmployeeAttendanceActivity."Actual Work Time" := EmployeeAttendanceActivity."Check Out Time" - EmployeeAttendanceActivity."Check In Time";
            EmployeeAttendanceActivity."Work Time Difference" := EmployeeAttendanceActivity."Actual Work Time" - EmployeeAttendanceActivity."Standard Work Time";
        end;
    end;

    local procedure IsHoliday(BaseCalendar: Code[20]; Date: Date; Remarks: Text[100]; Provience: Text; Gender: Enum "Employee Gender"; InOutValley: Enum "Outside/Inside Valley"; PostingRegion: Option; Branch: Text): Boolean
    var
        HrMgmt: Codeunit "HR Mgt.";
    begin
        exit(HrMgmt.CheckDateStatus(BaseCalendar, Date, Remarks, Provience, Gender, InOutValley, PostingRegion, Branch));
    end;

    local procedure GetDailyFoodAllowance(var EmployeeAttendanceActivity: Record "Employee Attendance & Activity"; AttendanceSetup: Record "Attendance Setup"; CheckInLateMinutes: Duration; CheckOutEarlyMinutes: Duration): Decimal
    begin
        if ((EmployeeAttendanceActivity."Week Off Day" = 1) and (not AttendanceSetup."Daily Food Allow. on Holiday")) or
            (EmployeeAttendanceActivity."Leave Day" <> 0) or
            (EmployeeAttendanceActivity."Absent Day" <> 0) or
            (EmployeeAttendanceActivity."Tour Day" <> 0) or
            (EmployeeAttendanceActivity."Half Day" <> 0) or
            (EmployeeAttendanceActivity."Outdoor Duty Day" <> 0) or
            (EmployeeAttendanceActivity."Training Day" <> 0) or
            (Abs(CheckInLateMinutes) > AttendanceSetup."Per Day Late Tolerance") or
            (Abs(CheckOutEarlyMinutes) > AttendanceSetup."Per Day Late Tolerance") or
            (EmployeeAttendanceActivity."Check In Time" = 0T) or
            (EmployeeAttendanceActivity."Check Out Time" = 0T)
            then
            exit(0);
        exit(1);
    end;

    local procedure CalculateLateDays(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        AttendanceSetup: Record "Attendance Setup";
        LateCheckInMinutes: Decimal;
        EarlyCheckOutMinutes: Decimal;
    begin
        AttendanceSetup.Get;
        if AttendanceSetup."Per Month Late Tolerance" <> 0 then begin
            EmployeeAttendanceActivity.Reset;
            EmployeeAttendanceActivity.SetCurrentKey("Employee No.", "Check In Difference");
            EmployeeAttendanceActivity.Ascending(false);
            EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
            EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
            EmployeeAttendanceActivity.SetRange("Late Check In Day", 1);
            if EmployeeAttendanceActivity.FindSet then
                repeat
                    LateCheckInMinutes += EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                    if Abs(LateCheckInMinutes) > AttendanceSetup."Per Month Late Tolerance" then begin
                        EmployeeAttendanceActivity."Late Day" := 1;
                        EmployeeAttendanceActivity.Modify;
                    end;
                until EmployeeAttendanceActivity.Next = 0;

            EmployeeAttendanceActivity.Reset;
            EmployeeAttendanceActivity.SetCurrentKey("Employee No.", "Check Out Difference");
            EmployeeAttendanceActivity.Ascending(false);
            EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
            EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
            EmployeeAttendanceActivity.SetRange("Early Check Out Day", 1);
            if EmployeeAttendanceActivity.FindSet then
                repeat
                    EarlyCheckOutMinutes += EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);
                    if Abs(EarlyCheckOutMinutes) > AttendanceSetup."Per Month Late Tolerance" then begin
                        EmployeeAttendanceActivity."Late Day" := 1;
                        EmployeeAttendanceActivity.Modify;
                    end;
                until EmployeeAttendanceActivity.Next = 0;
        end;
    end;

    local procedure CalculateDailyFoodAllowance(EmployeeCode: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        AttendanceSetup: Record "Attendance Setup";
        CheckInLateMinutes: Duration;
        CheckOutEarlyMinutes: Duration;
    begin
        AttendanceSetup.Get;
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeCode);
        EmployeeAttendanceActivity.SetRange("Attendance Date", StartDate, EndDate);
        if EmployeeAttendanceActivity.FindSet then
            repeat
                CheckInLateMinutes := 0;
                CheckOutEarlyMinutes := 0;
                if AttendanceSetup."Per Day Late Tolerance" <> 0 then begin
                    if EmployeeAttendanceActivity."Check In Difference" < 0 then
                        CheckInLateMinutes := EmployeeAttendanceActivity."Check In Difference" / (60 * 1000);
                    if EmployeeAttendanceActivity."Check Out Difference" < 0 then
                        CheckOutEarlyMinutes := EmployeeAttendanceActivity."Check Out Difference" / (60 * 1000);
                end;
                EmployeeAttendanceActivity."Daily Food Allowance" := GetDailyFoodAllowance(EmployeeAttendanceActivity, AttendanceSetup, CheckInLateMinutes, CheckOutEarlyMinutes);
                EmployeeAttendanceActivity.Modify;
            until EmployeeAttendanceActivity.Next = 0;
    end;

    procedure GetAttendanceForPayroll(var PayrollLine: Record "Payroll Line"; PayrollHeader: Record "Payroll Header")
    var
        AttendanceSummary: Record "Attendance Summary";
        PayCyclePeriod: Record "Pay Cycle Period";
        LatterPresentDays: Integer;
        EmployeeAttendActivity: Record "Employee Attendance & Activity";
        AbsentDays: Decimal;
        LeaveDays: Decimal;
        LWPDays: Decimal;
        PriorLWPDays: Decimal;
        PriorPresentDays: Decimal;
        SickLeave: Decimal;
        AnnualLeave: Decimal;
        UsedLeave: Decimal;
        CarryForwardLeave: Decimal;
        CarryForwardSick: Decimal;
        CarryForwardAnnual: Decimal;
        UsedSick: Decimal;
        UsedAnnual: Decimal;
        ProrataLeave: Decimal;
        ProrataSick: Decimal;
        ProrataAnnual: Decimal;
        ResignAbsentDays: Decimal;
        DaysAfterResignationDate: Decimal;
    begin
        Clear(AbsentDays);
        Clear(LeaveDays);
        Clear(LatterPresentDays);
        Clear(LWPDays);
        Clear(PriorPresentDays);
        Clear(PriorLWPDays);
        Clear(SettlementStartDate);
        Clear(SickLeave);
        Clear(AnnualLeave);
        Clear(DaysAfterResignationDate);
        if PayrollHeader.Type = PayrollHeader.Type::Settlement then begin
            GetSettlementAttendance(PayrollLine, PayrollHeader);
            exit;
        end;
        PayrollHeader.TestField("Pay Cycle Code");
        PayrollHeader.TestField("Pay Cycle Period");
        PayrollHeader.TestField("Pay Cycle Term");
        PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period");//attendace of prior absent day santosh
        PayCyclePeriod.TestField("Pay Date");
        Employee.Get(PayrollLine."Employee No.");

        AttendanceSummary.Reset;
        AttendanceSummary.SetCurrentKey("Employee No.", "From Date", "To Date");
        AttendanceSummary.SetRange("Employee No.", PayrollLine."Employee No.");
        if PayrollHeader.Type in [PayrollHeader.Type::Payroll, PayrollHeader.Type::Resignation] then begin
            if PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::Permanent then
                AttendanceSummary.SetRange("Date Filter", PayrollHeader."From Date", PayCyclePeriod."Pay Date" - 1)
            else
                AttendanceSummary.SetRange("Date Filter", PayrollHeader."From Date", PayrollHeader."To Date");

            //if PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::" " then begin
            if Employee."Employment Date" > PayCyclePeriod."Pay Date" then
                LatterPresentDays := PayrollHeader."To Date" - Employee."Employment Date" + 1
            else
                LatterPresentDays := PayrollHeader."To Date" - PayCyclePeriod."Pay Date";
            //end;
        end else begin
            EmployeeLedgerEntry.Reset;
            EmployeeLedgerEntry.SetRange("Employee No.", PayrollLine."Employee No.");
            EmployeeLedgerEntry.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period");
            if EmployeeLedgerEntry.FindLast then
                SettlementStartDate := EmployeeLedgerEntry."Pay Period End Date" + 1
            else
                SettlementStartDate := Employee."Employment Date";
            AttendanceSummary.SetRange("Date Filter", SettlementStartDate, PayrollLine."Resignation Date");
        end;

        //Absent Days for LWP
        EmployeeAttendActivity.Reset;
        EmployeeAttendActivity.SetRange("Employee No.", PayrollLine."Employee No.");
        EmployeeAttendActivity.SetRange("Pay Type", EmployeeAttendActivity."Pay Type"::Unpaid);
        EmployeeAttendActivity.SetRange("Present Day", 0);
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            if PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::Permanent then
                EmployeeAttendActivity.SetRange("Attendance Date", PayrollHeader."From Date", PayCyclePeriod."Pay Date" - 1)
            else
                EmployeeAttendActivity.SetRange("Attendance Date", PayrollHeader."From Date", PayrollHeader."To Date");

        end else if PayrollHeader.Type = PayrollHeader.Type::Resignation then
                EmployeeAttendActivity.SetRange("Attendance Date", PayrollHeader."From Date", PayrollLine."Resignation Date")
        else
            EmployeeAttendActivity.SetRange("Attendance Date", SettlementStartDate, PayrollLine."Resignation Date");

        EmployeeAttendActivity.CalcSums("Absent Day");
        LWPDays := EmployeeAttendActivity."Absent Day";

        //CLEAR(PayCyclePeriod);
        Clear(EmployeeAttendActivity);
        //IF PayCyclePerioid.GET(PayrollHeader."Pay Cycle Code",PayrollHeader."Pay Cycle Term",PayrollHeader."Pay Cycle Period"-1) THEN;
        GetPreviousPayCycleCode(PayrollHeader);
        if PreviousPayCyclePeriod."Pay Date" <> 0D then begin
            EmployeeAttendActivity.Reset;
            EmployeeAttendActivity.SetRange("Employee No.", PayrollLine."Employee No.");
            if PayrollHeader.Type in [PayrollHeader.Type::Payroll, PayrollHeader.Type::Resignation] then
                EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date", PayrollHeader."From Date" - 1)
            else if EmployeeLedgerEntry."Pay Period End Date" <> 0D then
                EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date", EmployeeLedgerEntry."Pay Period End Date")
            else
                EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date");
            EmployeeAttendActivity.SetRange("Pay Type", EmployeeAttendActivity."Pay Type"::Unpaid);
            EmployeeAttendActivity.CalcSums("Absent Day");
            PriorLWPDays := EmployeeAttendActivity."Absent Day";

            if (PayrollHeader.Type in [PayrollHeader.Type::Payroll, PayrollHeader.Type::Resignation]) and (PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::Permanent) then begin
                if (Employee."Employment Date" >= PreviousPayCyclePeriod."Pay Date") and (Employee."Employment Date" <= PayrollHeader."From Date" - 1) then begin
                    EmployeeAttendActivity.Reset;
                    EmployeeAttendActivity.SetRange("Employee No.", PayrollLine."Employee No.");
                    EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date", PayrollHeader."From Date" - 1);
                    EmployeeAttendActivity.SetRange("Day Type", EmployeeAttendActivity."Day Type"::"Working Day");
                    EmployeeAttendActivity.CalcSums("Present Day");
                    PriorPresentDays := EmployeeAttendActivity."Present Day";

                    EmployeeAttendActivity.Reset;
                    EmployeeAttendActivity.SetRange("Employee No.", PayrollLine."Employee No.");
                    EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date", PayrollHeader."From Date" - 1);
                    EmployeeAttendActivity.SetRange("Day Type", EmployeeAttendActivity."Day Type"::Holiday);
                    EmployeeAttendActivity.CalcSums("Week Off Day");
                    PriorPresentDays += EmployeeAttendActivity."Week Off Day";
                end;
            end;

            EmployeeAttendActivity.Reset;
            EmployeeAttendActivity.SetRange("Employee No.", PayrollLine."Employee No.");
            if PayrollHeader.Type in [PayrollHeader.Type::Payroll, PayrollHeader.Type::Resignation] then
                EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date", PayrollHeader."From Date" - 1)
            else if EmployeeLedgerEntry."Pay Period End Date" <> 0D then
                EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date", EmployeeLedgerEntry."Pay Period End Date")
            else
                EmployeeAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Pay Date");
            EmployeeAttendActivity.SetFilter("Pay Type", '<>%1', EmployeeAttendActivity."Pay Type"::Unpaid);
            EmployeeAttendActivity.CalcSums("Absent Day");
        end;

        Employee.TestField("Employment Date");
        if (Employee."Employment Date" >= PayrollHeader."From Date") and (Employee."Employment Date" <= PayrollHeader."To Date") then
            AbsentDays := Employee."Employment Date" - PayrollHeader."From Date";

        Clear(LeaveTypeSetup);
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetRange("Employee No. Filter", PayrollLine."Employee No.");
        LeaveTypeSetup.SetRange("Check Balance for Payroll", true);
        if LeaveTypeSetup.Find('-') then
            repeat
                if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
                    LeaveTypeSetup.CalcFields("Remaining Days");
                    LeaveDays += LeaveTypeSetup."Remaining Days";
                end else begin
                    if GetProrataLeaveDays(LeaveTypeSetup.Code, PayrollLine."Employee No.", UsedLeave, CarryForwardLeave, ProrataLeave) > 0 then
                        LeaveDays += GetProrataLeaveDays(LeaveTypeSetup.Code, PayrollLine."Employee No.", UsedLeave, CarryForwardLeave, ProrataLeave);
                end;
            until LeaveTypeSetup.Next = 0;

        AttendanceSummary.SetRange(Status, AttendanceSummary.Status::Released);
        AttendanceSummary.SetAutoCalcFields("Present Day", "Week Off Day", "Leave Day", "Absent Day",
            "Total Days", "Tour Day", "OT Hrs", "OT Days", "Late Check In Day");
        if AttendanceSummary.FindLast then begin
            PayrollLine.Validate("Present Days", AttendanceSummary."Present Day");
            PayrollLine.Validate("Post Payroll Days", LatterPresentDays);
            PayrollLine.Validate("Late Days", AttendanceSummary."Late Check In Day");
            if LeaveDays > AttendanceSummary."Absent Day" then begin
                PayrollLine.Validate("Leave Days", AttendanceSummary."Leave Day" + AttendanceSummary."Absent Day");
                if PayrollHeader.Type = PayrollHeader.Type::Settlement then;
                PayrollLine.Validate("Total Adjusted Leave Days", AttendanceSummary."Absent Day");

                PayrollLine.Validate("Absent Days", AbsentDays + LWPDays);
                if PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::Permanent then begin
                    if EmployeeAttendActivity."Absent Day" > (LeaveDays - AttendanceSummary."Absent Day") then
                        PayrollLine.Validate("Prior Absent Days", EmployeeAttendActivity."Absent Day" - (LeaveDays - AttendanceSummary."Absent Day") + PriorLWPDays)
                    else
                        PayrollLine.Validate("Prior Absent Days", PriorLWPDays);
                end;
            end else begin
                PayrollLine.Validate("Absent Days", AttendanceSummary."Absent Day" - LeaveDays + AbsentDays);
                PayrollLine.Validate("Leave Days", AttendanceSummary."Leave Day" + LeaveDays);
                if PayrollHeader."Employee Type" = PayrollHeader."Employee Type"::Permanent then
                    PayrollLine.Validate("Prior Absent Days", PriorLWPDays);
                if PayrollHeader.Type = PayrollHeader.Type::Settlement then;
                PayrollLine.Validate("Total Adjusted Leave Days", LeaveDays);
            end;
            PayrollLine.Validate("Prior Present Days", PriorPresentDays);
            PayrollLine.Validate("Week off Days", AttendanceSummary."Week Off Day");
            PayrollLine.Validate("Tour Days", AttendanceSummary."Tour Day");
            PayrollLine.Validate("Half Days", AttendanceSummary."Half Day");
            PayrollLine.Validate("OT Hrs", AttendanceSummary."OT Hrs");
            PayrollLine.Validate("OT Days", AttendanceSummary."OT Days");
            if PayrollHeader.Type = PayrollHeader.Type::Resignation then
                PayrollLine.Validate("Post Resignation Days", PayrollHeader."To Date" - PayrollLine."Resignation Date");
            PayrollLine.Validate("LWP Days", LWPDays + PriorLWPDays + PayrollLine."Post Resignation Days");
            if PayrollHeader.Type = PayrollHeader.Type::Settlement then begin
                EmployeeAttendActivity.Reset();
                EmployeeAttendActivity.SetRange("Attendance Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
                EmployeeAttendActivity.SetRange("Absent Day", 1);
                EmployeeAttendActivity.SetRange("Leave Day", 0);
                EmployeeAttendActivity.SetRange("Employee No.", PayrollLine."Employee No.");
                EmployeeAttendActivity.CalcSums("Absent Day");
                ResignAbsentDays := EmployeeAttendActivity."Absent Day";
                GetLeaveDaysForSettlement(PayrollLine."Total Adjusted Leave Days", SickLeave, AnnualLeave, PayrollLine."Employee No.", false, CarryForwardSick, CarryForwardAnnual, UsedSick, UsedAnnual, ProrataSick, ProrataAnnual);
                if ResignAbsentDays > PayrollLine."Total Adjusted Leave Days" then
                    PayrollLine.Validate("Absent Days", ResignAbsentDays - PayrollLine."Total Adjusted Leave Days")
                else
                    PayrollLine.Validate("Absent Days", 0);
                PayrollLine.Validate("Sick Leave Days", SickLeave);
                PayrollLine.Validate("Prorata Annual", ProrataAnnual);
                PayrollLine.Validate("Annual Leave Days", AnnualLeave);
                PayrollLine.Validate("Carry Forwarded Sick", CarryForwardSick);
                PayrollLine.Validate("Carry Forward Annual", CarryForwardAnnual);
                PayrollLine.Validate("Used Leave Sick", UsedSick);
                PayrollLine.Validate("Used Leave Annual", UsedAnnual);
                PayrollLine.Validate("Prorata Sick", ProrataSick);
            end;
        end;

        //days for allowance assignment
        //PayCyclePeriod.GET(PayrollHeader."Pay Cycle Code",PayrollHeader."Pay Cycle Term",PayrollHeader."Pay Cycle Period");
        Clear(AttendanceSummary);
        AttendanceSummary.Reset;
        AttendanceSummary.SetCurrentKey("Employee No.", "From Date", "To Date");
        AttendanceSummary.SetRange("Employee No.", PayrollLine."Employee No.");
        AttendanceSummary.SetRange("Allowance Date Filter", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
        AttendanceSummary.SetRange(Status, AttendanceSummary.Status::Released);
        AttendanceSummary.SetAutoCalcFields("Vault Key Days", "Festival Counter Days", "Friday Counter Days",
                          "Evening Counter Days", "Holiday Counter Days", "Cash Risk Days", "Morning Counter Days");
        if AttendanceSummary.FindLast then begin
            PayrollLine.Validate("Evening Counter Days", AttendanceSummary."Evening Counter Days");
            PayrollLine.Validate("Vault Key Days", AttendanceSummary."Vault Key Days");
            PayrollLine.Validate("Festival Counter Days", AttendanceSummary."Festival Counter Days");
            PayrollLine.Validate("Cash Risk Days", AttendanceSummary."Cash Risk Days");
            PayrollLine.Validate("Morning Counter Days", AttendanceSummary."Morning Counter Days");
            PayrollLine.Validate("Holiday Counter Days", AttendanceSummary."Holiday Counter Days");
            PayrollLine.Validate("Friday Counter Days", AttendanceSummary."Friday Counter Days");
        end;
    end;

    procedure CalculateProRataLeaveSettlement(LeaveCode: Code[20]; JoiningDate: Date; ResignDate: Date): Decimal
    var
        LeaveTypeSetup: Record "Leave Type Setup";
    begin
        PGSetup.Get;
        LeaveTypeSetup.Get(LeaveCode);
        if JoiningDate > PGSetup."Payroll Fiscal Year Start Date" then begin
            //TotalRemainingMonth:=ROUND((PGSetup."Payroll Fiscal Year End Date"-JoiningDate)/30.5,0.01,'=');
            exit(Round((ResignDate - JoiningDate) / 365 * LeaveTypeSetup."Days Earned Per Year", 1, '<'));
        end else
            exit(Round((ResignDate - PGSetup."Payroll Fiscal Year Start Date") / 365 * LeaveTypeSetup."Days Earned Per Year", 1, '<'));
    end;

    procedure GetLeaveDaysForSettlement(AdjustedLeave: Decimal; var SickLeave: Decimal; var AnualLeave: Decimal; EmpNo: Code[20]; ToPost: Boolean; var CarryForwardSick: Decimal; var CarryForwardAnnual: Decimal; var UsedSick: Decimal; var UsedAnnual: Decimal; var ProrataSick: Decimal; var ProrataAnnual: Decimal)
    var
        LeaveEarn: Record "Leave Earn";
        VarLeaveDays: Decimal;
        UsedLeave: Decimal;
        CarryForwardLeave: Decimal;
        ProrataLeave: Decimal;
    begin
        LeaveTypeSetup.Reset;
        Employee.Get(EmpNo);
        LeaveTypeSetup.SetRange("Check Balance for Payroll", true);
        LeaveTypeSetup.SetRange("Employee No. Filter", EmpNo);
        LeaveTypeSetup.SetFilter("Adjustment Sequence", '<>%1', 0);
        LeaveTypeSetup.SetCurrentKey("Adjustment Sequence");
        LeaveTypeSetup.SetFilter("Leave For Employee Type", '%1|%2', LeaveTypeSetup."Leave For Employee Type"::" ", Employee."Employment Type");
        if LeaveTypeSetup.Find('-') then
            repeat
                Clear(VarLeaveDays);
                Clear(UsedLeave);
                Clear(CarryForwardLeave);
                //IF AdjustedLeave = 0 THEN
                //EXIT;
                VarLeaveDays := GetProrataLeaveDays(LeaveTypeSetup.Code, EmpNo, UsedLeave, CarryForwardLeave, ProrataLeave);
                if VarLeaveDays < AdjustedLeave then begin
                    AdjustedLeave -= VarLeaveDays;
                    AdjustedLeave := Abs(AdjustedLeave);
                    UsedLeave := Abs(UsedLeave);
                    if LeaveTypeSetup."Sick Leave" then begin
                        UsedSick := UsedLeave + VarLeaveDays;
                        CarryForwardSick := CarryForwardLeave;
                        ProrataSick := ProrataLeave;
                    end else if LeaveTypeSetup."Carry Forwardable" then begin
                        UsedAnnual := UsedLeave + VarLeaveDays;
                        CarryForwardAnnual := CarryForwardLeave;
                        ProrataAnnual := ProrataLeave;
                    end;
                end else begin
                    if LeaveTypeSetup."Sick Leave" then begin
                        SickLeave := VarLeaveDays - AdjustedLeave;
                        UsedSick := UsedLeave + AdjustedLeave;
                        CarryForwardSick := CarryForwardLeave;
                        ProrataSick := ProrataLeave;
                    end else if LeaveTypeSetup."Carry Forwardable" then begin
                        AnualLeave := VarLeaveDays - AdjustedLeave;
                        UsedAnnual := UsedLeave + AdjustedLeave;
                        CarryForwardAnnual := CarryForwardLeave;
                        ProrataAnnual := ProrataLeave;
                    end;
                    AdjustedLeave -= AdjustedLeave;
                    if (ToPost) and ((VarLeaveDays - AdjustedLeave) > 0) then begin
                        LeaveEarn.Init;
                        LeaveEarn.Validate(EmpNo, EmpNo);
                        LeaveEarn.Validate("Leave Code", LeaveTypeSetup.Code);
                        LeaveEarn.Validate(Type, LeaveEarn.Type::Used);
                        LeaveEarn.Validate("Fiscal year", EngNep."Fiscal Year");
                        LeaveEarn.Validate("Balancing Days", VarLeaveDays - AdjustedLeave);
                        LeaveEarn.Validate(Remarks, 'Leave Adusted.');
                        LeaveEarn.Insert(true);
                    end;
                end;
            until (LeaveTypeSetup.Next = 0);
    end;

    local procedure GetProrataLeaveDays(LeaveCode: Code[20]; EmpNo: Code[20]; var UsedDays: Decimal; var CarryForwardLeave: Decimal; var ProrataLeave: Decimal): Decimal
    var
        LocalLeaveTypeSetup: Record "Leave Type Setup";
        LeaveEarn: Record "Leave Earn";
        ResignDate: Date;
    begin
        EngNep.Reset;
        EngNep.SetRange("English Date", Today);

        if EngNep.FindFirst then;
        Employee.Get(EmpNo);
        if Employee."Resignation Date" = 0D then
            ResignDate := Employee."Contract Expiry Date"
        else
            ResignDate := Employee."Resignation Date";
        LocalLeaveTypeSetup.Reset;
        LocalLeaveTypeSetup.SetRange(Code, LeaveCode);
        LocalLeaveTypeSetup.SetRange("Employee No. Filter", EmpNo);
        if LocalLeaveTypeSetup.Find('-') then begin
            Clear(CarryForwardLeave);
            Clear(UsedDays);

            LocalLeaveTypeSetup.CalcFields("Remaining Days");
            LeaveEarn.Reset;
            LeaveEarn.SetRange(EmpNo, EmpNo);
            LeaveEarn.SetRange("Leave Code", LocalLeaveTypeSetup.Code);
            LeaveEarn.SetRange(Type, LeaveEarn.Type::Used);
            LeaveEarn.SetRange("Fiscal year", EngNep."Fiscal Year");
            LeaveEarn.CalcSums("Balancing Days");
            UsedDays := LeaveEarn."Balancing Days";

            if LocalLeaveTypeSetup."Remaining Days" > LocalLeaveTypeSetup."Days Earned Per Year" then
                CarryForwardLeave := LocalLeaveTypeSetup."Remaining Days" - LocalLeaveTypeSetup."Days Earned Per Year" + UsedDays;
            ProrataLeave := CalculateProRataLeaveSettlement(LocalLeaveTypeSetup.Code, Employee."Employment Date", ResignDate);
            if LocalLeaveTypeSetup."Remaining Days" > 0 then
                exit(ProrataLeave + UsedDays + CarryForwardLeave);
        end;
    end;

    local procedure "--Agile SRT--"()
    begin
    end;

    procedure PostPFContribution(PostedPayrollPlan: Record "Posted Payroll Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        PostedPayrollLine: Record "Posted Payroll Line";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollGenSetup: Record "Payroll General Setup";
        FieldID: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
        PayrollAttribCode: Code[20];
        DocumentNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if PostedPayrollPlan.Reversed then
            exit;

        if not Confirm('Do you want to post PF Payment for %1?', false, PostedPayrollPlan."No.") then
            exit;

        RecRef.Open(Database::"Posted Payroll Line");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange(PostedPayrollPlan."No.");

        PayrollGenSetup.Get;
        PayrollGenSetup.TestField("PF Payroll Attribute 1");
        PayrollGenSetup.TestField("PF Payroll Attribute 2");
        PayrollGenSetup.TestField("Payroll Journal Template");
        PayrollGenSetup.TestField("Payroll Journal Batch");

        /*GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
        GenJnlLine.DELETEALL;*/

        Clear(NoSeriesMgt);
        Clear(BankTotal);
        Clear(PayrollAttribCode);
        Clear(DocumentNo);

        GenJnlBatch.Get(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch");
        DocumentNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostedPayrollPlan."Posting Date", false);

        PostedPayrollLine.Reset;
        PostedPayrollLine.SetRange("Document No.", PostedPayrollPlan."No.");
        if PostedPayrollLine.FindFirst then
            repeat
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PostedPayrollLine."Line No.");
                RecRef.FindFirst;
                for FieldID := 48 to 101 do begin //Min 9.16.2022
                    FieldRef := RecRef.Field(FieldID);
                    Evaluate(FieldValue, Format(FieldRef.Value));
                    if FieldValue <> 0 then begin
                        PayrollColumnConfiguration.Get(Database::"Posted Payroll Line", FieldID);
                        PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                        if (PayrollGenSetup."PF Payroll Attribute 1" = PayrollAttributes.Code) and (not PostedPayrollLine."PF Posted 1") then begin
                            PayrollAttribCode := PayrollAttributes.Code;
                            InsertPayrollJournal(PostedPayrollPlan, PostedPayrollLine, PayrollAttributes, FieldValue, DocumentNo);
                            BankTotal += FieldValue; //pram
                            PostedPayrollLine."PF Posted 1" := true;
                            PostedPayrollLine.Modify;
                        end else if (PayrollGenSetup."PF Payroll Attribute 2" = PayrollAttributes.Code) and (not PostedPayrollLine."PF Posted 2") then begin
                            PayrollAttribCode := PayrollAttributes.Code;
                            InsertPayrollJournal(PostedPayrollPlan, PostedPayrollLine, PayrollAttributes, FieldValue, DocumentNo);
                            BankTotal += FieldValue; //pram
                            PostedPayrollLine."PF Posted 2" := true;
                            PostedPayrollLine.Modify;
                        end
                    end;
                end;
            until PostedPayrollLine.Next = 0;
        //to be executed setup wise (need to customize if required)  SRT
        /*IF BankTotal <> 0 THEN BEGIN
          PayrollAttributes.GET(PayrollAttribCode);
          InsertBalancingEntry(PostedPayrollPlan,PostedPayrollLine, -BankTotal,PayrollAttributes,DocumentNo); //pram
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
          GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
          GenJnlLine.SETRANGE("Document No.",DocumentNo);
          IF GenJnlLine.FINDSET THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJnlLine);
        END;*/
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Posted Payroll Plan No.", PostedPayrollPlan."No.");
        if GenJnlLine.FindSet then
            Message('PF Journal lines for Payroll Plan No. %1 has been created on \Journal Template Name: %2\Journal Template Batch: %3',
                     PostedPayrollPlan."No.", PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch");
    end;

    procedure PostIncomeTax(PostedPayrollPlan: Record "Posted Payroll Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        PostedPayrollLine: Record "Posted Payroll Line";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollGenSetup: Record "Payroll General Setup";
        FieldID: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
        IncomeTaxAttrib1: Code[20];
        IncomeTaxAttrib2: Code[20];
        DocumentNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlBatch: Record "Gen. Journal Batch";
        DocumentNo1: Code[20];
    begin
        if PostedPayrollPlan.Reversed then
            exit;

        if not Confirm('Do you want to post Income Tax for %1?', false, PostedPayrollPlan."No.") then
            exit;

        RecRef.Open(Database::"Posted Payroll Line");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange(PostedPayrollPlan."No.");

        PayrollGenSetup.Get;
        PayrollGenSetup.TestField("IC Payroll Attribute 1");
        PayrollGenSetup.TestField("IC Payroll Attribute 2");
        PayrollGenSetup.TestField("Payroll Journal Template");
        PayrollGenSetup.TestField("Payroll Journal Batch");

        /*GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
        GenJnlLine.DELETEALL;*/

        Clear(BankTotal);
        Clear(BankTotal1);
        Clear(IncomeTaxAttrib1);
        Clear(IncomeTaxAttrib2);
        Clear(DocumentNo);
        Clear(NoSeriesMgt);

        GenJnlBatch.Get(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch");
        DocumentNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostedPayrollPlan."Posting Date", false);
        DocumentNo1 := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostedPayrollPlan."Posting Date", false);

        PostedPayrollLine.Reset;
        PostedPayrollLine.SetRange("Document No.", PostedPayrollPlan."No.");
        if PostedPayrollLine.FindFirst then
            repeat
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PostedPayrollLine."Line No.");
                RecRef.FindFirst;
                for FieldID := 48 to 101 do begin //Min 9.16.2022
                    FieldRef := RecRef.Field(FieldID);
                    Evaluate(FieldValue, Format(FieldRef.Value));
                    if FieldValue <> 0 then begin
                        PayrollColumnConfiguration.Get(Database::"Posted Payroll Line", FieldID);
                        PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                        if (PayrollGenSetup."IC Payroll Attribute 1" = PayrollAttributes.Code) and (not PostedPayrollLine."IC Posted 1") then begin
                            IncomeTaxAttrib1 := PayrollAttributes.Code;
                            InsertPayrollJournal(PostedPayrollPlan, PostedPayrollLine, PayrollAttributes, FieldValue, DocumentNo);
                            PostedPayrollLine."IC Posted 1" := true;
                            PostedPayrollLine.Modify;
                            BankTotal += FieldValue;
                        end;
                        if (PayrollGenSetup."IC Payroll Attribute 2" = PayrollAttributes.Code) and (not PostedPayrollLine."IC Posted 2") then begin
                            IncomeTaxAttrib2 := PayrollAttributes.Code;
                            InsertPayrollJournal(PostedPayrollPlan, PostedPayrollLine, PayrollAttributes, FieldValue, DocumentNo1);
                            PostedPayrollLine."IC Posted 2" := true;
                            PostedPayrollLine.Modify;
                            BankTotal1 += FieldValue;
                        end;
                    end;
                end;
            until PostedPayrollLine.Next = 0;
        //to be executed setup wise (need to customize if required)  SRT
        /*//Balance Entry
        IF BankTotal <> 0 THEN BEGIN
          IF IncomeTaxAttrib1 = PayrollGenSetup."IC Payroll Attribute 1" THEN BEGIN
            PayrollAttributes.GET(IncomeTaxAttrib1);
            InsertBalancingEntry(PostedPayrollPlan,PostedPayrollLine, -BankTotal,PayrollAttributes,DocumentNo);
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
            GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
            GenJnlLine.SETRANGE("Payroll Attribute Code",IncomeTaxAttrib1);
            IF GenJnlLine.FINDSET THEN
              CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJnlLine);
          END;
          IF BankTotal1 <> 0 THEN BEGIN
              IF IncomeTaxAttrib2 = PayrollGenSetup."IC Payroll Attribute 2" THEN BEGIN
              PayrollAttributes.GET(IncomeTaxAttrib2);
              InsertBalancingEntry(PostedPayrollPlan,PostedPayrollLine, -BankTotal1,PayrollAttributes,DocumentNo1);
              GenJnlLine.RESET;
              GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
              GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
              GenJnlLine.SETRANGE("Payroll Attribute Code",IncomeTaxAttrib2);
              IF GenJnlLine.FINDSET THEN
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJnlLine);
            END;
          END;
        END;*/
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Posted Payroll Plan No.", PostedPayrollPlan."No.");
        if GenJnlLine.FindSet then
            Message('Tax Journal lines for Payroll Plan No. %1 has been created on \Journal Template Name: %2\Journal Template Batch: %3',
                     PostedPayrollPlan."No.", PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch");
    end;

    procedure PostCITPayment(PostedPayrollPlan: Record "Posted Payroll Header")
    var
        GenJnlLine: Record "Gen. Journal Line";
        PostedPayrollLine: Record "Posted Payroll Line";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollGenSetup: Record "Payroll General Setup";
        FieldID: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
        PayrollAttribCode: Code[20];
        DocumentNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        if PostedPayrollPlan.Reversed then
            exit;

        if not Confirm('Do you want to post CIT Payment for %1?', false, PostedPayrollPlan."No.") then
            exit;

        RecRef.Open(Database::"Posted Payroll Line");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange(PostedPayrollPlan."No.");

        PayrollGenSetup.Get;
        PayrollGenSetup.TestField("Payroll Journal Template");
        PayrollGenSetup.TestField("Payroll Journal Batch");
        PayrollGenSetup.TestField("CIT Payroll Attribute 1");
        PayrollGenSetup.TestField("CIT Payroll Attribute 2");

        /*GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
        GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
        GenJnlLine.DELETEALL;*/

        Clear(BankTotal);
        Clear(PayrollAttribCode);
        Clear(DocumentNo);
        Clear(NoSeriesMgt);

        GenJnlBatch.Get(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch");
        DocumentNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", PostedPayrollPlan."Posting Date", false);

        PostedPayrollLine.Reset;
        PostedPayrollLine.SetRange("Document No.", PostedPayrollPlan."No.");
        if PostedPayrollLine.FindFirst then
            repeat
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PostedPayrollLine."Line No.");
                RecRef.FindFirst;
                for FieldID := 48 to 101 do begin //Min 9.16.2022
                    FieldRef := RecRef.Field(FieldID);
                    Evaluate(FieldValue, Format(FieldRef.Value));
                    if FieldValue <> 0 then begin
                        PayrollColumnConfiguration.Get(Database::"Posted Payroll Line", FieldID);
                        PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                        if (PayrollGenSetup."CIT Payroll Attribute 1" = PayrollAttributes.Code) and (not PostedPayrollLine."CIT Posted 1") then begin
                            PayrollAttribCode := PayrollAttributes.Code;
                            InsertPayrollJournal(PostedPayrollPlan, PostedPayrollLine, PayrollAttributes, FieldValue, DocumentNo);
                            BankTotal += FieldValue; //pram
                            PostedPayrollLine."CIT Posted 1" := true;
                            PostedPayrollLine.Modify;
                        end else if (PayrollGenSetup."CIT Payroll Attribute 2" = PayrollAttributes.Code) and (not PostedPayrollLine."CIT Posted 2") then begin
                            PayrollAttribCode := PayrollAttributes.Code;
                            InsertPayrollJournal(PostedPayrollPlan, PostedPayrollLine, PayrollAttributes, FieldValue, DocumentNo);
                            BankTotal += FieldValue; //pram
                            PostedPayrollLine."CIT Posted 2" := true;
                            PostedPayrollLine.Modify;
                        end;
                    end;
                end;
            until PostedPayrollLine.Next = 0;

        //to be executed setup wise (need to customize if required)  SRT
        /*IF BankTotal <> 0 THEN BEGIN
          PayrollAttributes.GET(PayrollAttribCode);
          InsertBalancingEntry(PostedPayrollPlan,PostedPayrollLine, -BankTotal,PayrollAttributes,DocumentNo); //pram
          GenJnlLine.RESET;
          GenJnlLine.SETRANGE("Journal Template Name",PayrollGenSetup."Payroll Journal Template");
          GenJnlLine.SETRANGE("Journal Batch Name",PayrollGenSetup."Payroll Journal Batch");
          GenJnlLine.SETRANGE("Document No.",DocumentNo);
          IF GenJnlLine.FINDSET THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJnlLine);
        END;*/
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Posted Payroll Plan No.", PostedPayrollPlan."No.");
        if GenJnlLine.FindSet then
            Message('CIT Journal lines for Payroll Plan No. %1 has been created on \Journal Template Name: %2\Journal Template Batch: %3',
                     PostedPayrollPlan."No.", PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch");
    end;

    local procedure InsertPayrollJournal(PostedPayrollHdr: Record "Posted Payroll Header"; PostedPayrollLine: Record "Posted Payroll Line"; PayrollAttributes: Record "Payroll Attributes"; Amount: Decimal; DocumentNo: Code[20])
    var
        PayrollGenSetup: Record "Payroll General Setup";
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        PayrollGenSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", PayrollGenSetup."Payroll Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", PayrollGenSetup."Payroll Journal Batch");
        if not GenJnlLine.FindLast then
            LineNo := 1000
        else
            LineNo := GenJnlLine."Line No." + 1000;

        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := PayrollGenSetup."Payroll Journal Template";
        GenJnlLine."Journal Batch Name" := PayrollGenSetup."Payroll Journal Batch";
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No.", PayrollAttributes."G/L Account No.");
        GenJnlLine.Description := PostedPayrollLine."Employee Name";
        GenJnlLine."Posting Date" := Today;   //to be decided later
        GenJnlLine.Validate(Amount, Amount);
        GenJnlLine."Employee Code" := PostedPayrollLine."Employee No.";   //Employee Code
        GenJnlLine.Validate("Dimension Set ID", PostedPayrollLine."Dimension Set ID");
        GenJnlLine.Narration := PostedPayrollLine.Remarks;
        GenJnlLine."Posted Payroll Plan No." := PostedPayrollHdr."No.";
        GenJnlLine."Posted Payroll Plan Line No." := PostedPayrollLine."Line No.";
        GenJnlLine."Payroll Attribute Code" := PayrollAttributes.Code;
        GenJnlLine.Insert(true);
    end;

    local procedure InsertBalancingEntry(PostedPayrollHdr: Record "Posted Payroll Header"; PostedPayrollLine: Record "Posted Payroll Line"; Amount: Decimal; PayrollAttributes: Record "Payroll Attributes"; DocumentNo: Code[20])
    var
        PayrollGenSetup: Record "Payroll General Setup";
        GenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        PayrollGenSetup.Get;
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", PayrollGenSetup."Payroll Journal Template");
        GenJnlLine.SetRange("Journal Batch Name", PayrollGenSetup."Payroll Journal Batch");
        if not GenJnlLine.FindLast then
            LineNo := 1000
        else
            LineNo := GenJnlLine."Line No." + 1000;

        GenJnlLine.Init;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Journal Template Name" := PayrollGenSetup."Payroll Journal Template";
        GenJnlLine."Journal Batch Name" := PayrollGenSetup."Payroll Journal Batch";
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Validate("Account Type", PayrollGenSetup."Bal. Account Type");
        GenJnlLine.Validate("Account No.", PayrollGenSetup."Bal. Account No.");
        GenJnlLine."Posting Date" := Today;  //to be decided later
        GenJnlLine.Validate(Amount, Amount);
        GenJnlLine.Validate("Dimension Set ID", PostedPayrollLine."Dimension Set ID");
        GenJnlLine.Narration := PostedPayrollLine.Remarks;
        GenJnlLine."Dimension Set ID" := PostedPayrollLine."Dimension Set ID";
        GenJnlLine."Payroll Attribute Code" := PayrollAttributes.Code;
        GenJnlLine.Insert(true);
    end;

    procedure Reopen(PostedPayrollPlan: Record "Posted Payroll Header")
    var
        PostedPayrollLine: Record "Posted Payroll Line";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollGenSetup: Record "Payroll General Setup";
        FieldID: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
    begin

        if not Confirm('Do you want to Reset CIT,PF & Income Tax for %1 ?', false, PostedPayrollPlan."No.") then
            exit;

        PayrollGenSetup.Get;

        RecRef.Open(Database::"Posted Payroll Line");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange(PostedPayrollPlan."No.");

        PostedPayrollLine.Reset;
        PostedPayrollLine.SetRange("Document No.", PostedPayrollPlan."No.");
        if PostedPayrollLine.FindFirst then
            repeat
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PostedPayrollLine."Line No.");
                RecRef.FindFirst;
                for FieldID := 48 to 101 do begin //Min 9.16.2022
                    FieldRef := RecRef.Field(FieldID);
                    Evaluate(FieldValue, Format(FieldRef.Value));
                    if FieldValue <> 0 then begin
                        PayrollColumnConfiguration.Get(Database::"Payroll Line", FieldID);
                        PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                        if (PayrollGenSetup."CIT Payroll Attribute 1" = PayrollAttributes.Code) and (PostedPayrollLine."CIT Posted 1") then begin
                            if JournalLedgerExists(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch",
                                                    PostedPayrollLine, PayrollGenSetup."CIT Payroll Attribute 1") then
                                PostedPayrollLine."CIT Posted 1" := false;
                            PostedPayrollLine.Modify;
                        end else if (PayrollGenSetup."CIT Payroll Attribute 2" = PayrollAttributes.Code) and (PostedPayrollLine."CIT Posted 2") then begin
                            if JournalLedgerExists(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch",
                                                    PostedPayrollLine, PayrollGenSetup."CIT Payroll Attribute 2") then
                                PostedPayrollLine."CIT Posted 2" := false;
                            PostedPayrollLine.Modify;
                        end else if (PayrollGenSetup."PF Payroll Attribute 1" = PayrollAttributes.Code) and (PostedPayrollLine."PF Posted 1") then begin
                            if JournalLedgerExists(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch",
                                                   PostedPayrollLine, PayrollGenSetup."PF Payroll Attribute 1") then
                                PostedPayrollLine."PF Posted 1" := false;
                            PostedPayrollLine.Modify;
                        end else if (PayrollGenSetup."PF Payroll Attribute 2" = PayrollAttributes.Code) and (PostedPayrollLine."PF Posted 2") then begin
                            if JournalLedgerExists(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch",
                                                   PostedPayrollLine, PayrollGenSetup."PF Payroll Attribute 2") then
                                PostedPayrollLine."PF Posted 2" := false;
                            PostedPayrollLine.Modify;
                        end else if (PayrollGenSetup."IC Payroll Attribute 1" = PayrollAttributes.Code) and (PostedPayrollLine."IC Posted 1") then begin
                            if JournalLedgerExists(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch",
                                                  PostedPayrollLine, PayrollGenSetup."IC Payroll Attribute 1") then
                                PostedPayrollLine."IC Posted 1" := false;
                        end else if (PayrollGenSetup."IC Payroll Attribute 2" = PayrollAttributes.Code) and (PostedPayrollLine."IC Posted 2") then begin
                            if JournalLedgerExists(PayrollGenSetup."Payroll Journal Template", PayrollGenSetup."Payroll Journal Batch",
                                                   PostedPayrollLine, PayrollGenSetup."IC Payroll Attribute 2") then
                                PostedPayrollLine."IC Posted 2" := false;
                            PostedPayrollLine.Modify;
                        end;
                    end;
                end;
            until PostedPayrollLine.Next = 0;
    end;

    procedure JournalLedgerExists(JnlTemplate: Code[20]; JnlBatch: Code[20]; PostedPayrollLine: Record "Posted Payroll Line"; PayrollAttributeCode: Code[20]): Boolean
    var
        GLEntry: Record "G/L Entry";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GLEntry.Reset;
        GLEntry.SetCurrentKey("Posted Payroll Plan No.", "Posted Payroll Plan Line No.", "Payroll Attribute Code", "Employee Code");
        GLEntry.SetRange("Posted Payroll Plan No.", PostedPayrollLine."Document No.");
        GLEntry.SetRange("Posted Payroll Plan Line No.", PostedPayrollLine."Line No.");
        GLEntry.SetRange("Payroll Attribute Code", PayrollAttributeCode);
        GLEntry.SetRange("Employee Code", PostedPayrollLine."Employee No.");
        if not GLEntry.FindFirst then begin
            GenJnlLine.Reset;
            GenJnlLine.SetRange("Journal Template Name", JnlTemplate);
            GenJnlLine.SetRange("Journal Batch Name", JnlBatch);
            GenJnlLine.SetRange("Posted Payroll Plan No.", PostedPayrollLine."Document No.");
            GenJnlLine.SetRange("Posted Payroll Plan Line No.", PostedPayrollLine."Line No.");
            GenJnlLine.SetRange("Payroll Attribute Code", PayrollAttributeCode);
            GenJnlLine.SetRange("Employee Code", PostedPayrollLine."Employee No.");
            if GenJnlLine.FindSet then begin
                GenJnlLine.DeleteAll;
                exit(true);
            end else
                exit(false);
        end else begin
            Message('The entries have been already posted to ledger entries. The document cannot be reopened.');
            exit(false);
        end;

        // Bhuwan 8/22/2019
    end;

    procedure UploadDataToAttributeUsage()
    begin
        /*
        PayrollAttributeSubform.RESET;
        PayrollAttributeSubform.SETRANGE("Employee No.",PayrollAttributeSubform."Employee No.");
         IF PayrollAttributeSubform.FINDFIRST THEN BEGIN
           REPEAT
              PayrollAttributeSubGroup.SETRANGE("Group Code",PayrollAttributeSubform."Group Code");
              IF PayrollAttributeSubGroup.FINDFIRST THEN BEGIN
                REPEAT
                PayrollAttributeUsage.INIT;
                PayrollAttributeUsage.VALIDATE("Employee Code",PayrollAttributeSubform."Employee No.");
                PayrollAttributeUsage.VALIDATE(Code,PayrollAttributeSubGroup.Code);
                PayrollAttributeUsage.VALIDATE(Description,PayrollAttributeSubGroup.Description);
                PayrollAttributeUsage.INSERT;
                UNTIL PayrollAttributeSubGroup.NEXT=0;
                END;
           UNTIL PayrollAttributeSubform.NEXT=0;
        END;
        */
    end;

    procedure ResolveColumnCalc(var Expression: Code[100]; PayrollAttribute: Record "Payroll Attributes"; BasicFromLine: Boolean; BasicAmount: Decimal)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes2: Record "Payroll Attributes";
    begin
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange(Code, PayrollAttribute.Code);
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        if PayrollAttributesUsage.FindFirst then begin
            PayrollAttributesUsage.TestField(Amount);
            BasicAmount := PayrollAttributesUsage.Amount;
        end;

        StrPosition := StrPos(Expression, PayrollAttributes."Column Name");
        if StrPosition > 0 then begin
            Expression := DelStr(Expression, StrPosition, StrLen(PayrollAttributes."Column Name"));
            if BasicFromLine then
                Expression := InsStr(Expression, Format(BasicSalaryAfterDeduction), StrPosition)
            else
                Expression := InsStr(Expression, Format(BasicAmount), StrPosition)
        end;
        StrLength := StrLen(Expression);
        repeat
            if Expression[StrLength] in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                      'Y', 'Z'] then begin
                PayrollAttributes2.Reset;
                PayrollAttributes2.SetRange("Column Name", Format(Expression[StrLength]));
                if PayrollAttributes2.FindFirst then begin
                    if PayrollAttributes2.Subtype = PayrollAttribute.Subtype then begin
                        StrPosition := StrPos(Expression, Format(Expression[StrLength]));
                        Expression := DelStr(Expression, StrPosition, StrLen(Format(Expression[StrLength])));
                        Expression := InsStr(Expression, Format(PayrollAttributesUsage.Amount), StrPosition);
                    end;
                end;
            end;
            StrLength -= 1;
        until StrLength = 0;
    end;

    procedure PayrollAttCheck(PayrollCode: Code[20]; EmpCode: Code[20]): Boolean
    var
        PayrollAttUsage: Record "Payroll Attributes Usage";
        MutuallyEx: Record "Mutually Excl. Payroll Group";
        MutuallyEx2: Record "Mutually Excl. Payroll Group";
    begin
        PayrollAttributes.Get(PayrollCode);
        if not (PayrollAttributes."Payroll Type" = '') then begin
            PayrollAttUsage.SetRange("Payroll Type", PayrollAttributes."Payroll Type");
            PayrollAttUsage.SetRange("Employee Code", EmpCode);
            if PayrollAttUsage.FindFirst then begin
                MutuallyEx.Get(PayrollAttributes."Payroll Type", PayrollAttributes.Code);
                MutuallyEx2.Get(PayrollAttUsage."Payroll Type", PayrollAttUsage.Code);
                if MutuallyEx2.Priority < MutuallyEx.Priority then
                    exit(false)
                else begin
                    PayrollAttUsage.Delete;
                    exit(true)
                end;
            end else
                exit(true);
        end else
            exit(true);
    end;

    procedure TaxOldEmployeeTotalEarning(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeeTotalEarning(EmpVar."Old Employee No.");
            EmpVar.CalcFields("Total Earning");
            exit(TaxAmt + EmpVar."Total Earning");
        end;
    end;

    procedure AddTaxOnInterestAllowance("Code": Code[20]; PayrollCode: Code[20]): Decimal
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        Amount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        FieldsValue: Decimal;
    begin
        PayrollHeader.Get(PayrollCode);
        //IF PayrollHeader.Type = PayrollHeader.Type::Adjustment THEN BEGIN
        RecRefs.Open(Database::"Payroll Line");
        FieldRefs := RecRefs.Field(1);
        FieldRefs.SetRange(PayrollCode);
        FieldRefs := RecRefs.Field(3);
        FieldRefs.SetRange(Code);
        RecRefs.FindFirst;
        //END;
        Employee.Get(Code);
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.CalcFields(Subtype);
        PayrollAttributesUsage.SetRange(Subtype, PayrollAttributes.Subtype::"Tax on Interest"); // should be tax on interest
        if PayrollAttributesUsage.FindFirst then begin
            repeat
                //IF PayrollHeader.Type <>PayrollHeader.Type::Adjustment THEN
                // Amount+=PayrollAttributesUsage.Amount;
                //ELSE BEGIN
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributesUsage.Code);
                if PayrollColumnConfig.FindFirst then begin
                    FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                    Evaluate(FieldsValue, Format(FieldRefs.Value));
                    Amount += FieldsValue;
                end;
            //END;
            until PayrollAttributesUsage.Next = 0;
        end;
        //IF PayrollHeader.Type = PayrollHeader.Type::Adjustment THEN
        RecRefs.Close;
        exit(Round(Amount, 0.01, '='));
    end;

    procedure GetLumpsumpCIT(EmpCode: Code[20]; PayrollCode: Code[20]): Decimal
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        Amount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        FieldsValue: Decimal;
    begin
        PayrollHeader.Get(PayrollCode);
        if PayrollHeader.Type = PayrollHeader.Type::Adjustment then begin
            RecRefs.Open(Database::"Payroll Line");
            FieldRefs := RecRefs.Field(1);
            FieldRefs.SetRange(PayrollCode);
            FieldRefs := RecRefs.Field(3);
            FieldRefs.SetRange(EmpCode);
            RecRefs.FindFirst;
        end;
        Employee.Get(EmpCode);
        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.CalcFields(Subtype);
        PayrollAttributesUsage.SetRange(Subtype, PayrollAttributes.Subtype::"Lump Sum Contribution");
        if PayrollAttributesUsage.FindFirst then begin
            repeat
                if PayrollHeader.Type <> PayrollHeader.Type::Adjustment then
                    Amount += PayrollAttributesUsage.Amount
                else begin
                    PayrollColumnConfig.Reset;
                    PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                    PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
                    if PayrollColumnConfig.FindFirst then begin
                        FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                        Evaluate(FieldsValue, Format(FieldRefs.Value));
                        Amount += FieldsValue;
                    end;
                end;
            until PayrollAttributesUsage.Next = 0;
        end;
        if PayrollHeader.Type = PayrollHeader.Type::Adjustment then
            RecRefs.Close;
        exit(Round(Amount, 0.01, '='));
    end;

    procedure TaxOldEmployeeRetirement(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeeRetirement(EmpVar."Old Employee No.");
            EmpVar.CalcFields("Total Retirement Contribution");
            exit(TaxAmt + EmpVar."Total Retirement Contribution");
        end;
    end;

    procedure TaxOldEmployeeDonationAmt(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeeDonationAmt(EmpVar."Old Employee No.");
            EmpVar.CalcFields("Total Donation Contribution");
            exit(TaxAmt + EmpVar."Total Donation Contribution");
        end;
    end;

    procedure TaxOldEmployeeMedicalReinbursement(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeeMedicalReinbursement(EmpVar."Old Employee No.");
            EmpVar.CalcFields("Total Medical Re-Imbursement");
            exit(TaxAmt + EmpVar."Total Medical Re-Imbursement");
        end;
    end;

    procedure TaxOldEmployeeSocialSecurity(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeeSocialSecurity(EmpVar."Old Employee No.");
            EmpVar.CalcFields("Social Security Tax");
            exit(TaxAmt + EmpVar."Social Security Tax");
        end;
    end;

    procedure TaxOldEmployeeRemunerationBenefits(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeeRemunerationBenefits(EmpVar."Old Employee No.");
            EmpVar.CalcFields("Remuneration & Benefits Tax");
            exit(TaxAmt + EmpVar."Remuneration & Benefits Tax");
        end;
    end;

    procedure TaxOldEmployeePFEmployee(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeePFEmployee(EmpVar."Old Employee No.");
            EmpVar.CalcFields("PF Contribution");
            exit(TaxAmt + EmpVar."PF Contribution");
        end;
    end;

    procedure TaxOldEmployeePFOffice(Empcode: Code[20]): Decimal
    var
        EmpVar: Record Employee;
        TaxAmt: Decimal;
    begin
        TaxAmt := 0;
        EmpVar.Reset;
        EmpVar.SetRange("No.", Empcode);
        EmpVar.SetFilter("Date Filter", '%1..%2', PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        if EmpVar.FindFirst then begin
            if EmpVar."Old Employee No." <> '' then
                TaxAmt := TaxOldEmployeePFOffice(EmpVar."Old Employee No.");
            EmpVar.CalcFields("PF Contribution (Office)");
            exit(TaxAmt + EmpVar."PF Contribution (Office)");
        end;
    end;

    local procedure GetPayCyclePeriod(ExpiryDate: Date): Integer
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
        PayCyclePeriod.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
        if (ExpiryDate = 0D) or (ExpiryDate >= PGSetup."Payroll Fiscal Year End Date") then begin
            PayCyclePeriod.SetFilter("Start Date", '<=%1', PGSetup."Payroll Fiscal Year End Date");
            PayCyclePeriod.SetFilter("End Date", '>=%1', PGSetup."Payroll Fiscal Year End Date");
        end else begin
            PayCyclePeriod.SetFilter("Start Date", '<=%1', ExpiryDate);
            PayCyclePeriod.SetFilter("End Date", '>=%1', ExpiryDate);
        end;
        PayCyclePeriod.FindFirst;
        exit(PayCyclePeriod.Period);
    end;

    local procedure TaxAtOnceCalcCurrentEarning()
    var
        FieldID: Integer;
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        PayrollAttributes: Record "Payroll Attributes";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldValue: Decimal;
    begin
        TaxAtOnceCurrentEarning := 0;
        TaxatOnceCurrentNonPayments := 0;
        RecRef.Open(Database::"Payroll Line");
        for FieldID := 47 to 180 do begin
            if PayrollColumnConfiguration.Get(Database::"Payroll Line", FieldID) then begin
                PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code");
                FieldRef := RecRef.Field(1);
                FieldRef.SetRange(PayrollHeader."No.");
                FieldRef := RecRef.Field(2);
                FieldRef.SetRange(PayrollLine."Line No.");
                RecRef.FindFirst;
                FieldRef := RecRef.Field(FieldID);
                Evaluate(FieldValue, Format(FieldRef.Value));
                FieldValue := Round(FieldValue, 0.01, '=');
                PayrollAttributes.TestField(Status, PayrollAttributes.Status::Active);
                // Current Earning/Donation
                if PayrollAttributes.Type = PayrollAttributes.Type::Benefits then begin
                    if PayrollAttributes."Non-Taxable" = false then begin
                        if FieldValue <> 0 then begin
                            if not ((PayrollHeader.Type = PayrollHeader.Type::Settlement) and
                                 ((PGSetup.Gratuity = PayrollAttributes.Code) or (PGSetup."Leave Encashment" = PayrollAttributes.Code))) then
                                TaxAtOnceCurrentEarning += FieldValue;
                        end;
                    end
                end
                else if (PayrollAttributes.Type = PayrollAttributes.Type::Deduction) then begin
                    if (FieldValue <> 0) and (PayrollAttributes.Subtype <> PayrollAttributes.Subtype::"Tax on Remuneration & Benefits")
                      and (PayrollAttributes.Subtype <> PayrollAttributes.Subtype::"Social Security Tax") then begin
                        TaxAtOnceCurrentDeduction += FieldValue
                    end;
                end
                else if (PayrollAttributes.Type = PayrollAttributes.Type::"Non-Payment") then begin
                    if FieldValue <> 0 then begin
                        if PayrollAttributes.Subtype = PayrollAttributes.Subtype::Donation then
                            TaxAtOnceCurrentDonation += FieldValue;
                        TaxatOnceCurrentNonPayments += FieldValue;
                    end;
                end;
            end;
        end;
        RecRef.Close;
    end;

    local procedure TaxAtOnceCalcProjectionEarning()
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        PayrollColumnConfiguration: Record "Payroll Column Configuration";
        UsageAmount: Decimal;
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
    begin
        TaxAtOnceProjectionEarning := 0;
        TaxAtOnceProjectedNonPayments := 0;
        PayrollColumnConfiguration.Reset;
        PayrollColumnConfiguration.SetRange("Table No.", Database::"Level Wise Attributes");
        if PayrollColumnConfiguration.FindSet then begin
            RecRefs.Open(Database::"Level Wise Attributes");
            repeat
                if PayrollAttributes.Get(PayrollColumnConfiguration."Variable Field Code") then begin
                    if not PayrollAttributesUsage.Get(PayrollAttributes.Code, Employee."No.") then begin
                        UsageAmount := 0;
                        if (PayrollAttributes.Status = PayrollAttributes.Status::Active) and
                            (PayrollAttributes."Non-Taxable" = false)
                           then begin
                            FieldRefs := RecRefs.Field(1);
                            FieldRefs.SetRange(Employee."Salary Grade");
                            FieldRefs := RecRefs.Field(2);
                            FieldRefs.SetRange(Employee."Salary Level");
                            RecRefs.FindFirst;
                            FieldRefs := RecRefs.Field(PayrollColumnConfiguration."Field No.");
                            Evaluate(UsageAmount, Format(FieldRefs.Value));
                            UsageAmount := Round(UsageAmount, 0.01, '=');
                            if PayrollAttributes."Apply Every Month" then
                                TaxAtOnceProjectionEarning += UsageAmount * RemainingMonth
                            else begin
                                TaxAtOnceProjectionEarning += UsageAmount * GetPayFrequency(PayrollAttributesUsage, PayrollAttributes);
                            end;
                        end;
                    end;
                end;
            until PayrollColumnConfiguration.Next = 0;
        end;

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.SetRange(Type, PayrollAttributesUsage.Type::Benefits);
        if PayrollAttributesUsage.FindFirst then
            repeat
                PayrollAttributesUsage.CalcFields("Formula Exists");
                UsageAmount := 0;
                if PayrollAttributes.Get(PayrollAttributesUsage.Code) then begin
                    if (PayrollAttributes.Status = PayrollAttributes.Status::Active) and
                        (PayrollAttributes."Non-Taxable" = false)
                       then begin
                        if PayrollAttributesUsage.Amount <> 0 then
                            UsageAmount := PayrollAttributesUsage.Amount
                        else if PayrollAttributesUsage."Formula Exists" then begin
                            UsageAmount := EvaluateAmount(PayrollAttributes.Formula, false);
                        end;
                        UsageAmount := Round(UsageAmount, 0.01, '=');
                        if PayrollAttributes."Apply Every Month" then
                            TaxAtOnceProjectionEarning += UsageAmount * RemainingMonth
                        else begin
                            TaxAtOnceProjectionEarning += UsageAmount * GetPayFrequency(PayrollAttributesUsage, PayrollAttributes);
                        end;
                    end;
                end;
            until PayrollAttributesUsage.Next = 0;

        PayrollAttributesUsage.Reset;
        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
        PayrollAttributesUsage.SetRange(Type, PayrollAttributesUsage.Type::"Non-Payment");
        if PayrollAttributesUsage.FindFirst then
            repeat
                PayrollAttributesUsage.CalcFields("Formula Exists");
                UsageAmount := 0;
                if PayrollAttributes.Get(PayrollAttributesUsage.Code) then begin
                    if (PayrollAttributes.Status = PayrollAttributes.Status::Active) and
                        (PayrollAttributes."Non-Taxable" = false)
                       then begin
                        if PayrollAttributesUsage.Amount <> 0 then
                            UsageAmount := PayrollAttributesUsage.Amount
                        else if PayrollAttributesUsage."Formula Exists" then begin
                            UsageAmount := EvaluateAmount(PayrollAttributes.Formula, false);
                        end;
                        UsageAmount := Round(UsageAmount, 0.01, '=');
                        if PayrollAttributes."Apply Every Month" then
                            TaxAtOnceProjectedNonPayments += UsageAmount * RemainingMonth
                        else begin
                            TaxAtOnceProjectedNonPayments += UsageAmount * GetPayFrequency(PayrollAttributesUsage, PayrollAttributes);
                        end;
                    end;
                end;
            until PayrollAttributesUsage.Next = 0;
    end;

    procedure GetTax(StartAmount: Decimal; EndAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
    begin
        if (EndAmount - StartAmount) <= RemainingTaxableAmount then begin
            RemainingTaxableAmount := RemainingTaxableAmount - (EndAmount - StartAmount + 1);
            exit(EndAmount - StartAmount + 1)
        end
        else begin
            RemainingAmountCopy := RemainingTaxableAmount;
            RemainingTaxableAmount := 0;
            exit(RemainingAmountCopy);
        end;
    end;

    procedure TaxAtOnceGetTax(StartAmount: Decimal; EndAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
    begin
        if (EndAmount - StartAmount) <= TaxAtOnceRemainingAmt then begin
            TaxAtOnceRemainingAmt := TaxAtOnceRemainingAmt - (EndAmount - StartAmount + 1);
            exit(EndAmount - StartAmount + 1)
        end
        else begin
            RemainingAmountCopy := TaxAtOnceRemainingAmt;
            TaxAtOnceRemainingAmt := 0;
            exit(RemainingAmountCopy);
        end;
    end;

    local procedure CalculateTaxAtOnce()
    begin
        //Calculation for TaxAtOnce payroll
        TaxAtOnceCalcCurrentEarning;
        TaxAtOnceCalcProjectionEarning;

        TaxAtOnceTotalAnnualEarning := TaxAtOnceCurrentEarning + TaxAtOnceProjectionEarning + EmpPayOpen."Total Benefit Opening" + Employee."Non-Payment" + Employee."Total Earning" + TaxatOnceCurrentNonPayments + TaxAtOnceProjectedNonPayments;

        //RetirementFundLimit1 := TaxAtOnceTotalAnnualEarning * PGSetup."Tax Ex. Amt. (%) on Retirement" / 100;
        RetirementFundLimit1 := TaxAtOnceTotalAnnualEarning / PGSetup."Tax Ex. Amt Divsion";
        RetirementFundLimit2 := PGSetup."Tax Ex. Amt. not Exceeding";
        RetirementFundTaxBenefit := TotalContributionToRetirementFund;
        if RetirementFundLimit1 < RetirementFundTaxBenefit then
            RetirementFundTaxBenefit := RetirementFundLimit1;
        if RetirementFundLimit2 < RetirementFundTaxBenefit then
            RetirementFundTaxBenefit := RetirementFundLimit2;
        TaxAtOnceTaxableAmt := TaxAtOnceTotalAnnualEarning - RetirementFundTaxBenefit - DonationTaxBenefit - InsuranceTaxBenefit - HealthInsuranceTaxBenefit - PropertyInsuranceTaxBenefit; //Min 4.22.2022
    end;

    local procedure CalculateTaxAtOnceTax()
    begin
        //Calculation for TaxAtOnce payroll
        TaxAtOnceTaxableAmt := TaxAtOnceTaxableAmt - DisablePersonReduction - PayrollLine."Remote Area Deduction"; //Min 7.6.2022
        TaxAtOnceRemainingAmt := TaxAtOnceTaxableAmt;
        Clear(SlabCount);
        TaxAtOnceAnnualTax := 0;
        TaxSetupLine.Reset;
        TaxSetupLine.SetRange(Code, TaxSetupHeader.Code);
        if TaxSetupLine.FindFirst then
            repeat
                if TaxAtOnceRemainingAmt > 0 then begin
                    TaxSetupLine.TestField("Tax Rate");
                    SlabCount += 1;
                    SlabAmount := TaxAtOnceGetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount");
                    TaxAtOnceAnnualTax += SlabAmount * TaxSetupLine."Tax Rate" / 100.0;
                    GetSlabAmount();
                    if SocialSecurityTax = 0 then
                        SocialSecurityTax := TaxAtOnceAnnualTax;
                end;
            until TaxSetupLine.Next = 0;
        TaxAtOnceAnnualTax := TaxAtOnceAnnualTax - MedicalReimbursmentTaxBenefit;
        if TaxSetupHeader."Special Tax Exempt %" <> 0 then begin
            TaxExempt := (TaxAtOnceAnnualTax * TaxSetupHeader."Special Tax Exempt %") / 100;
            TaxAtOnceAnnualTax := (TaxAtOnceAnnualTax - (TaxAtOnceAnnualTax * TaxSetupHeader."Special Tax Exempt %") / 100);
        end;
        TaxAtOnceAnnualTax := TaxAtOnceAnnualTax - (Employee."Remuneration & Benefits Tax" + EmpPayOpen."Total Tax Remuneration Opening" + Employee."Social Security Tax" + EmpPayOpen."Total Social Security Opening");
    end;

    procedure ValidateAttributes(PayAttributeCode: Code[20]; PayrollLineVar: Record "Payroll Line"; PayCyclePeriod: Record "Pay Cycle Period"): Decimal
    var
        Employee: Record Employee;
        LevelWiseAttributes: Record "Level Wise Attributes";
        // Branches: Record "Dimension Value";
        RemoteAreaCategory: Record "Remote Area Category";
        GrossSalary: Decimal;
        FuntionalTitle: Record "Functional Title";
        PayrollHeader: Record "Payroll Header";
        Amount: Decimal;
        AllowanceAssignmentLine: Record "Allowance Assignment Line";
        PriorLevelwise: Record "Level Wise Attributes";
        PriorAmount: Decimal;
        PriorRemoteAll: Decimal;
        RemoteAll: Decimal;
        EmployeeTranfer: Record "Employee Transfer";
        PromotionHistory: Record "Promotion History";
        ServiceHistory: Record "Employee Service History";
        InitialDate: Date;
        BranchCode: Code[20];
        // EmpHie: Record "Employee Hierarchy Master";
        OrganizationStructureList: Record "Organization Structure List";
        FirstTime: Boolean;
        OutstationEligible: Boolean;
        SalaryAdvance: Record "Employee Loan/Advance";
        // OtEmployeeActivity: Record "Employee Activity";
        OverTime: Record OverTime;
        IsHandled: Boolean;
    begin
        GLSetup.Get;
        GrossSalary := 0;
        PGSetup.Get;
        Clear(Amount);
        Clear(PriorAmount);
        Employee.Get(PayrollLineVar."Employee No.");
        PayrollHeader.Get(PayrollLineVar."Document No.");
        LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");
        PayrollHeader.Get(PayrollLineVar."Document No.");

        if PriorLevelwise.Get(PromotionHistory."Previous Salary Grade", PromotionHistory."Previous Salary Level Code") then;
        case PayAttributeCode of

            PGSetup."Relocation Allowance":
                begin
                    //EXIT(TransferEmpActivity."Relocation Allow.");
                end;
            PGSetup."Outstn/Discomfort Allowance":
                begin
                    OnBeforeInsertOutstationAllowance(Employee."No.", PayCyclePeriod, IsHandled, Amount);
                    if IsHandled then
                        exit(Amount);
                    /*TransferEmpActivity.RESET;
                    TransferEmpActivity.SETRANGE("Employee No.",Employee."No.");
                    TransferEmpActivity.SETFILTER("Date of Joining Of Transfer",'<%1',PayCyclePeriod."Start Date");
                    TransferEmpActivity.SETRANGE("Approval Status",TransferEmpActivity."Approval Status"::Acknowledged);
                    TransferEmpActivity.SETRANGE("Transfer Category",TransferEmpActivity."Transfer Category"::General);
                    IF TransferEmpActivity.FINDLAST THEN
                      IF TransferEmpActivity."Transfer Allowance Approval" = TransferEmpActivity."Transfer Allowance Approval"::Approved THEN
                        OutstationEligible := TRUE;*/
                    ServiceHistory.Reset;
                    ServiceHistory.SetRange("Employee No.", Employee."No.");
                    ServiceHistory.SetFilter("Effective Date", '<%1', PayCyclePeriod."Start Date");
                    //ServiceHistory.SETRANGE("Transfer Category",TransferEmpActivity."Transfer Category"::General);
                    ServiceHistory.SetCurrentKey("Effective Date");
                    if ServiceHistory.FindLast then begin
                        if ServiceHistory."Outstation Eligible" then
                            OutstationEligible := true;
                        if LevelWiseAttributes.Get(PayrollLineVar."Salary Grade", PayrollLineVar."Salary Level") then; //Min 5.4.2022
                    end;
                    InitialDate := PayCyclePeriod."Start Date";
                    ServiceHistory.Reset;
                    ServiceHistory.SetRange("Employee No.", Employee."No.");
                    ServiceHistory.SetRange("Effective Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
                    ServiceHistory.SetFilter("Service Event", '%1|%2|%3|%4|%5', ServiceHistory."Service Event"::"Grade Increment",
                                              ServiceHistory."Service Event"::"Internal Appointment", ServiceHistory."Service Event"::Transfer, ServiceHistory."Service Event"::"Assignment in Job Function", ServiceHistory."Service Event"::Confirmation);
                    ServiceHistory.SetCurrentKey("Effective Date");
                    if ServiceHistory.Find('-') then
                        repeat
                            if LevelWiseAttributes.Get(PayrollLineVar."Salary Grade", PayrollLineVar."Salary Level") then; //Min 5.4.2022
                            GrossSalary := LevelWiseAttributes."Total Basic Salary" * 0.25 / PayrollHeader."Total Days" *
                                        (ServiceHistory."Effective Date" - InitialDate);
                            if ServiceHistory."Service Event" in [ServiceHistory."Service Event"::Transfer, ServiceHistory."Service Event"::"Assignment in Job Function", ServiceHistory."Service Event"::Confirmation] then begin //Min 7.5.2022
                                if OutstationEligible then
                                    Amount += GrossSalary;
                                OutstationEligible := ServiceHistory."Outstation Eligible";
                            end else begin
                                if OutstationEligible then
                                    Amount += GrossSalary;
                            end;
                            InitialDate := ServiceHistory."Effective Date";
                        until ServiceHistory.Next = 0;

                    ServiceHistory.Reset;
                    ServiceHistory.SetRange("Employee No.", Employee."No.");
                    ServiceHistory.SetRange("Effective Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
                    ServiceHistory.SetFilter("Service Event", '%1|%2|%3|%4', ServiceHistory."Service Event"::"Grade Increment",
                                            ServiceHistory."Service Event"::"Internal Appointment", ServiceHistory."Service Event"::Transfer, ServiceHistory."Service Event"::"Assignment in Job Function", ServiceHistory."Service Event"::Confirmation); //Min 7.5.2022
                    ServiceHistory.SetCurrentKey("Effective Date");
                    if ServiceHistory.FindLast then begin
                        if LevelWiseAttributes.Get(PayrollLineVar."Salary Grade", PayrollLineVar."Salary Level") then; //Min 5.4.2022
                        GrossSalary := LevelWiseAttributes."Total Basic Salary" * 0.25 / PayrollHeader."Total Days" *
                                      (PayCyclePeriod."End Date" - ServiceHistory."Effective Date" + 1);
                        if ServiceHistory."Service Event" in [ServiceHistory."Service Event"::Transfer, ServiceHistory."Service Event"::"Assignment in Job Function", ServiceHistory."Service Event"::Confirmation] then begin //Min 7.5.2022
                            if ServiceHistory."Outstation Eligible" then
                                Amount += GrossSalary;
                        end else begin
                            if OutstationEligible then
                                Amount += GrossSalary;
                        end;


                    end;
                    if OutstationEligible and (Amount = 0) then
                        Amount := LevelWiseAttributes."Total Basic Salary" * 0.25;
                    exit(Amount);
                end;
            //BM accomendation
            // PGSetup."BM Accomendation":
            //     begin
            //         EmployeeTranfer.Reset;
            //         EmployeeTranfer.SetRange("Employee No.", Employee."No.");
            //         EmployeeTranfer.SetRange("Date of Joining Of Transfer", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
            //         EmployeeTranfer.SetFilter(Type, '%1|%2', EmployeeTranfer.Type::"HR Transfer", EmployeeTranfer.Type::"Employee Transfer");
            //         EmployeeTranfer.SetRange("Transfer Category", EmployeeTranfer."Transfer Category"::General);
            //         EmployeeTranfer.SetRange("Approval Status", EmployeeTranfer."Approval Status"::Acknowledged);
            //         InitialDate := 0D;
            //         if EmployeeTranfer.FindLast then
            //             repeat
            //                 if EmployeeTranfer."BM Accomodation Allow." <> 0 then begin
            //                     Clear(BranchCode);
            //                     if EmployeeTranfer."Deputation On (To)" = EmployeeTranfer."Deputation On (To)"::Branch then
            //                         BranchCode := EmployeeTranfer."Shortcut Dimension 1 Code (To)"
            //                     else if EmployeeTranfer."Deputation On (To)" = EmployeeTranfer."Deputation On (To)"::"Extension Counter" then begin
            //                         OrganizationStructureList.Reset;
            //                         OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::"Extension Counter");
            //                         OrganizationStructureList.SetRange(Code, EmployeeTranfer."Extension Counter (To)");
            //                         if OrganizationStructureList.FindFirst then
            //                             BranchCode := OrganizationStructureList.code;
            //                     end;
            //                     if FuntionalTitle.Get(EmployeeTranfer."Functional Title (To)") then begin
            //                         if FuntionalTitle.Locationwise then begin
            //                             OrganizationStructureList.Reset();
            //                             OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, BranchCode);
            //                             // Branches.Get(GLSetup."Global Dimension 1 Code", BranchCode);
            //                             RemoteAreaCategory.Get(OrganizationStructureList."BM Category");
            //                             if InitialDate = 0D then begin
            //                                 Amount := RemoteAreaCategory."BM Accomodation Amount" / PayrollLineVar."Total Days" * (PayCyclePeriod."End Date" - TransferEmpActivity."Date of Joining Of Transfer" + 1);
            //                             end else begin
            //                                 Amount += RemoteAreaCategory."BM Accomodation Amount" / PayrollLineVar."Total Days" * (InitialDate - TransferEmpActivity."Date of Joining Of Transfer");
            //                             end;
            //                         end;
            //                     end;
            //                 end;
            //                 InitialDate := TransferEmpActivity."Date of Joining Of Transfer";
            //             until TransferEmpActivity.Next(-1) = 0;
            //         TransferEmpActivity.Reset;
            //         TransferEmpActivity.SetRange("Employee No.", Employee."No.");
            //         TransferEmpActivity.SetRange("Date of Joining Of Transfer", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
            //         TransferEmpActivity.SetFilter(Type, '%1|%2', TransferEmpActivity.Type::"HR Transfer", TransferEmpActivity.Type::"Employee Transfer");
            //         TransferEmpActivity.SetRange("Transfer Category", TransferEmpActivity."Transfer Category"::General);
            //         TransferEmpActivity.SetRange("Approval Status", TransferEmpActivity."Approval Status"::Acknowledged);
            //         if TransferEmpActivity.FindFirst then begin
            //             if TransferEmpActivity."BM Accomodation Allow." <> 0 then begin
            //                 Clear(BranchCode);
            //                 Clear(RemoteAreaCategory);
            //                 if TransferEmpActivity."Deputation On" = TransferEmpActivity."Deputation On"::Branch then
            //                     BranchCode := TransferEmpActivity."Shortcut Dimension 1 Code"
            //                 else if TransferEmpActivity."Deputation On" = TransferEmpActivity."Deputation On"::"Extension Counter" then begin
            //                     EmpHie.Reset;
            //                     EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
            //                     EmpHie.SetRange(Code, TransferEmpActivity."Extension Counter Code");
            //                     if EmpHie.FindFirst then
            //                         BranchCode := EmpHie."Shortcut Dimension 1 Code";
            //                 end;

            //                 FuntionalTitle.Get(TransferEmpActivity."Functional Title");
            //                 if FuntionalTitle.Locationwise then begin
            //                     Branches.Get(GLSetup."Global Dimension 1 Code", BranchCode);
            //                     if RemoteAreaCategory.Get(Branches."BM Category") then
            //                         PriorAmount := RemoteAreaCategory."BM Accomodation Amount" / PayrollLineVar."Total Days" * (TransferEmpActivity."Date of Joining Of Transfer" - PayCyclePeriod."Start Date");
            //                 end;
            //             end;
            //             exit(PriorAmount + Amount);
            //         end else begin
            //             TransferEmpActivity.Reset;
            //             TransferEmpActivity.SetRange("Employee No.", Employee."No.");
            //             TransferEmpActivity.SetRange("Date of Joining Of Transfer", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
            //             TransferEmpActivity.SetFilter(Type, '%1|%2', TransferEmpActivity.Type::"HR Transfer", TransferEmpActivity.Type::"Employee Transfer");
            //             TransferEmpActivity.SetRange("Transfer Category", TransferEmpActivity."Transfer Category"::General);
            //             TransferEmpActivity.SetRange("Approval Status", TransferEmpActivity."Approval Status"::Acknowledged);
            //             if TransferEmpActivity.FindLast then begin
            //                 if TransferEmpActivity."BM Accomodation Allow." <> 0 then begin
            //                     if Branches.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then;
            //                     if RemoteAreaCategory.Get(Branches."BM Category") then
            //                         exit(RemoteAreaCategory."BM Accomodation Amount");
            //                 end;
            //             end;
            //         end;
            //     end;

            PGSetup."Salary Advance":
                begin
                    SalaryAdvance.Reset;
                    SalaryAdvance.SetRange("Employee Code", Employee."No.");
                    SalaryAdvance.SetRange("Loan Type", SalaryAdvance."Loan Type"::"Salary Advance");
                    SalaryAdvance.SetRange("Approval Status", SalaryAdvance."Approval Status"::Approved);
                    SalaryAdvance.SetRange(Settled, false);
                    if SalaryAdvance.FindFirst then begin
                        SalaryAdvance.CalcFields("Salary Advance Paid");
                        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
                            if (SalaryAdvance."Applied Loan/Advance" - SalaryAdvance."Salary Advance Paid") > SalaryAdvance.EMI then
                                exit(SalaryAdvance.EMI)
                            else
                                exit(SalaryAdvance."Applied Loan/Advance" - SalaryAdvance."Salary Advance Paid");
                        end else
                            exit(SalaryAdvance."Applied Loan/Advance" - SalaryAdvance."Salary Advance Paid");
                    end;
                end;

            PGSetup."Comm. Reimbursement":
                begin
                    if PromotionHistory."Promoted Date" = 0D then
                        Amount := LevelWiseAttributes."Communication Reim. Allowence"
                    else begin
                        Amount := LevelWiseAttributes."Communication Reim. Allowence" / PayrollLineVar."Total Days" * (PayCyclePeriod."End Date" - PromotionHistory."Promoted Date" + 1);
                        Clear(LevelWiseAttributes);
                        if LevelWiseAttributes.Get(PromotionHistory."Previous Salary Grade", PromotionHistory."Previous Salary Level Code") then
                            PriorAmount := LevelWiseAttributes."Communication Reim. Allowence" / PayrollLineVar."Total Days" * (PromotionHistory."Promoted Date" - PayCyclePeriod."Start Date");
                    end;
                    if (PriorAmount + Amount) = 0 then begin
                        if FuntionalTitle.Get(Employee."Functional Title") then
                            if FuntionalTitle.Locationwise then
                                Amount := FuntionalTitle."Communication Rein.";
                    end;
                    exit(Amount + PriorAmount);
                end;

            // PGSetup."COPO/COSPO Allowance":
            //     begin
            //         if FuntionalTitle.Get(TransferEmpActivity."Functional Title") then
            //             if TransferEmpActivity."Date of Joining Of Transfer" <> 0D then
            //                 PriorAmount := FuntionalTitle."COPO/COSPO Allowance" / PayrollLineVar."Total Days" * (TransferEmpActivity."Date of Joining Of Transfer" - PayCyclePeriod."Start Date");

            //         if FuntionalTitle.Get(Employee."Functional Title") then begin
            //             if TransferEmpActivity."Date of Joining Of Transfer" <> 0D then
            //                 Amount := FuntionalTitle."COPO/COSPO Allowance" / PayrollLineVar."Total Days" * (PayCyclePeriod."End Date" - TransferEmpActivity."Date of Joining Of Transfer" + 1)
            //             else
            //                 Amount := FuntionalTitle."COPO/COSPO Allowance";
            //         end;
            //         exit(Amount + PriorAmount);
            //     end;
            //remote area allowance
            PGSetup."Remote Area Allowance":
                begin
                    //getting gross salary
                    InitialDate := 0D;
                    ServiceHistory.Reset;
                    ServiceHistory.SetRange("Employee No.", PayrollLineVar."Employee No.");
                    ServiceHistory.SetFilter("Service Event", '%1|%2|%3', ServiceHistory."Service Event"::Appointment, ServiceHistory."Service Event"::"Internal Appointment",
                                              ServiceHistory."Service Event"::Transfer);
                    ServiceHistory.SetRange("Effective Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
                    ServiceHistory.SetCurrentKey("Effective Date");
                    if ServiceHistory.Find('+') then begin
                        repeat
                            Clear(BranchCode);
                            Clear(RemoteAreaCategory);
                            if LevelWiseAttributes.Get(ServiceHistory."Salary Grade (To)", ServiceHistory."Salary Level (To)") then;
                            GrossSalary := (LevelWiseAttributes."Total Basic Salary" + LevelWiseAttributes.Allowance);
                            FirstTime := false;
                            OrganizationStructureList.Reset();
                            // if ServiceHistory."Deputation On (To)" = ServiceHistory."Deputation On (To)"::Branch then
                            //     BranchCode := ServiceHistory."Deputation Code (To)"
                            // else if ServiceHistory."Deputation On (To)" = ServiceHistory."Deputation On (To)"::"Extension Counter" then begin
                            //     OrganizationStructureList.Reset;
                            //     if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", ServiceHistory."Deputation Code (To)") then
                            //         BranchCode := OrganizationStructureList.Code;
                            // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                            // EmpHie.SetRange(Code, ServiceHistory."Deputation Code (To)");
                            // if EmpHie.FindFirst then
                            //     BranchCode := EmpHie."Shortcut Dimension 1 Code";
                            // end;
                            if OrganizationStructureList.Get(OrganizationStructureList.type::Branch, ServiceHistory."Deputation Code (To)") then begin
                                if RemoteAreaCategory.Get(OrganizationStructureList."Remote Area Category") then;
                                if InitialDate = 0D then begin
                                    Amount += (RemoteAreaCategory."Remote allowance Percentage" / 100 * GrossSalary) / PayrollLineVar."Total Days" * (PayCyclePeriod."End Date" - ServiceHistory."Effective Date" + 1);
                                    RemoteAll += RemoteAreaCategory."Remote Allowance Amount" / PayrollLineVar."Total Days" * (PayCyclePeriod."End Date" - ServiceHistory."Effective Date" + 1);
                                    InitialDate := ServiceHistory."Effective Date";
                                end else begin
                                    Amount += (RemoteAreaCategory."Remote allowance Percentage" / 100 * GrossSalary) / PayrollLineVar."Total Days" * (InitialDate - ServiceHistory."Effective Date");
                                    RemoteAll += RemoteAreaCategory."Remote Allowance Amount" / PayrollLineVar."Total Days" * (InitialDate - ServiceHistory."Effective Date");
                                    InitialDate := ServiceHistory."Effective Date";
                                end;
                            end;
                        until ServiceHistory.Next(-1) = 0;

                        ServiceHistory.Reset;
                        ServiceHistory.SetRange("Employee No.", PayrollLineVar."Employee No.");
                        ServiceHistory.SetFilter("Service Event", '%1|%2', ServiceHistory."Service Event"::Appointment, ServiceHistory."Service Event"::Transfer);
                        ServiceHistory.SetRange("Effective Date", PayCyclePeriod."Start Date", PayCyclePeriod."End Date");
                        ServiceHistory.SetCurrentKey("Effective Date");
                        if ServiceHistory.FindFirst then begin
                            Clear(BranchCode);
                            Clear(RemoteAreaCategory);
                            if LevelWiseAttributes.Get(ServiceHistory."Salary Grade (From)", ServiceHistory."Salary Level (From)") then;
                            GrossSalary := (LevelWiseAttributes."Total Basic Salary" + LevelWiseAttributes.Allowance);
                            OrganizationStructureList.Reset();
                            if ServiceHistory."Service Event" = ServiceHistory."Service Event"::Transfer then begin
                                // if ServiceHistory."Deputation On (To)" = ServiceHistory."Deputation On (To)"::Branch then
                                //     BranchCode := ServiceHistory."Deputation Code (To)"
                                // else if ServiceHistory."Deputation On (To)" = ServiceHistory."Deputation On (To)"::"Extension Counter" then begin
                                //     EmpHie.Reset;
                                //     EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                                //     EmpHie.SetRange(Code, ServiceHistory."Deputation Code (To)");
                                //     if EmpHie.FindFirst then
                                //         BranchCode := EmpHie."Shortcut Dimension 1 Code";
                                // end;
                                if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, ServiceHistory."Deputation Code (From)") then begin
                                    if RemoteAreaCategory.Get(OrganizationStructureList."Remote Area Category") then;
                                    PriorAmount := (RemoteAreaCategory."Remote allowance Percentage" / 100 * GrossSalary) / PayrollLineVar."Total Days" * (ServiceHistory."Effective Date" - PayCyclePeriod."Start Date");
                                    PriorRemoteAll := RemoteAreaCategory."Remote Allowance Amount" / PayrollLineVar."Total Days" * (ServiceHistory."Effective Date" - PayCyclePeriod."Start Date");
                                end;
                            end;
                        end;
                        if (Amount + PriorAmount) >= (PriorRemoteAll + RemoteAll) then
                            exit(PriorRemoteAll + RemoteAll)
                        else
                            exit(Amount + PriorAmount);
                    end else begin
                        if OrganizationStructureList.Get(OrganizationStructureList.type::Branch, Employee."Global Dimension 1 Code") then begin
                            if LevelWiseAttributes.Get(ServiceHistory."Salary Grade (To)", ServiceHistory."Salary Level (To)") then;
                            GrossSalary := (LevelWiseAttributes."Total Basic Salary" + LevelWiseAttributes.Allowance);
                            if RemoteAreaCategory.Get(OrganizationStructureList."Remote Area Category") then begin
                                if GrossSalary >= RemoteAreaCategory."Remote Allowance Amount" then
                                    exit(RemoteAreaCategory."Remote Allowance Amount")
                                else begin
                                    if InitialDate = 0D then
                                        exit(0);
                                    exit((RemoteAreaCategory."Remote allowance Percentage" / 100 * GrossSalary) / PayrollLineVar."Total Days" * (InitialDate - PayCyclePeriod."Start Date"));
                                end;
                            end;
                        end;
                    end;
                end;
            /* PGSetup."Faciliator Allowance": BEGIN
               SalaryLevel.GET(Employee."Salary Level");
               VALIDATE(Amount,(SalaryLevel."Net Learning"*(PayrollLine."Faciliating Hours" DIV PGSetup."Base Teaching Hours")*(LevelWiseAttributes."Total Basic Salary"+LevelWiseAttributes.Allowance)));
               MODIFY;
             END;*/
            PGSetup."Friday Counter":
                begin
                    AllowanceAssignmentLine.Reset;
                    AllowanceAssignmentLine.SetRange("Employee Code", PayrollLineVar."Employee No.");
                    AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SetRange("Allowance Type", PGSetup."Friday Counter");
                    AllowanceAssignmentLine.CalcSums("Allowance Amount");
                    if not (AllowanceAssignmentLine."Allowance Amount" = 0) then
                        exit(AllowanceAssignmentLine."Allowance Amount");
                end;
            PGSetup."Staff Vehicle Allowance":
                begin
                    if Employee."Vehicle Type" = Employee."Vehicle Type"::"Four Wheeler" then begin
                        if PromotionHistory."Promoted Date" <> 0D then
                            exit((LevelWiseAttributes."Staff Vehicle Allowance" / PayrollLineVar."Total Days" * (PayCyclePeriod."End Date" - PromotionHistory."Promoted Date")) +
                                  (PriorLevelwise."Staff Vehicle Allowance" / PayrollLineVar."Total Days" * (PromotionHistory."Promoted Date" - PayCyclePeriod."Start Date")));
                        exit(LevelWiseAttributes."Staff Vehicle Allowance");//oman
                    end;
                end;
            /*PGSetup."Dashain Renumeration" : BEGIN
              //EXIT(LevelWiseAttributes."Dashain Remuneration");
              EXIT(0);
            END;*/
            PGSetup."Officiating Allowance Code":
                begin
                    //EXIT(PGSetup."Officiating Allowance");
                    exit(0);
                end;

            PGSetup."Bulk Cash Allowance":
                begin
                    exit(PGSetup."bulk Cash Amt" * PayrollLineVar."Bulk Cash Transfer Days");
                end;
            PGSetup."Evening Counter":
                begin
                    AllowanceAssignmentLine.Reset;
                    AllowanceAssignmentLine.SetRange("Employee Code", PayrollLineVar."Employee No.");
                    AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SetRange("Allowance Type", PGSetup."Evening Counter");
                    AllowanceAssignmentLine.CalcSums("Allowance Amount");
                    if not (AllowanceAssignmentLine."Allowance Amount" = 0) then
                        exit(AllowanceAssignmentLine."Allowance Amount");
                end;

            PGSetup."Holiday Counter":
                begin
                    OverTime.Reset; //Min 12.22.2022
                    OverTime.SetRange("Employee No.", PayrollLineVar."Employee No.");
                    OverTime.SetRange(Type, OverTime.Type::Overtime);
                    OverTime.SetRange("Approval Status", OverTime."Approval Status"::Approved);
                    if PayrollHeader."Previous Year Payroll" then
                        OverTime.SetRange("Start Date", PGSetup."Prev Fiscal Year Start Date", PGSetup."Prev Fiscal Year End Date")
                    else
                        OverTime.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
                    OverTime.SetRange("OT Disbursed", false);
                    OverTime.SetRange("Encashment Code", PGSetup."Holiday Counter");
                    if OverTime.FindSet then
                        repeat
                            OverTime."Updated Payroll Line" := true;
                            OverTime.Modify;
                        until OverTime.Next = 0;
                    OverTime.CalcSums("OT Amount");
                    if not (OverTime."OT Amount" = 0) then
                        exit(OverTime."OT Amount");
                    /*AllowanceAssignmentLine.RESET;
                    AllowanceAssignmentLine.SETRANGE("Employee Code","Employee No.");
                    AllowanceAssignmentLine.SETRANGE("Approval Status",AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SETRANGE("From Date",PayCyclePeriod."Allowance Start Date",PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SETRANGE("Allowance Type",PGSetup."Holiday Counter");
                    AllowanceAssignmentLine.CALCSUMS("Allowance Amount");
                    IF NOT (AllowanceAssignmentLine."Allowance Amount" =0) THEN
                    EXIT(AllowanceAssignmentLine."Allowance Amount");*/
                end;

            PGSetup."Festival Counter":
                begin
                    OverTime.Reset; //Min 12.22.2022
                    OverTime.SetRange("Employee No.", PayrollLineVar."Employee No.");
                    OverTime.SetRange(Type, OverTime.Type::Overtime);
                    OverTime.SetRange("Approval Status", OverTime."Approval Status"::Approved);
                    if PayrollHeader."Previous Year Payroll" then
                        OverTime.SetRange("Start Date", PGSetup."Prev Fiscal Year Start Date", PGSetup."Prev Fiscal Year End Date")
                    else
                        OverTime.SetRange("Start Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
                    OverTime.SetRange("OT Disbursed", false);
                    OverTime.SetRange("Encashment Code", PGSetup."Festival Counter");
                    if OverTime.FindSet then
                        repeat
                            OverTime."Updated Payroll Line" := true;
                            OverTime.Modify;
                        until OverTime.Next = 0;
                    OverTime.CalcSums("OT Amount");
                    if not (OverTime."OT Amount" = 0) then
                        exit(OverTime."OT Amount");
                    /*AllowanceAssignmentLine.RESET;
                    AllowanceAssignmentLine.SETRANGE("Employee Code","Employee No.");
                    AllowanceAssignmentLine.SETRANGE("Approval Status",AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SETRANGE("From Date",PayCyclePeriod."Allowance Start Date",PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SETRANGE("Allowance Type",PGSetup."Festival Counter");
                    AllowanceAssignmentLine.CALCSUMS("Allowance Amount");
                    IF NOT (AllowanceAssignmentLine."Allowance Amount" =0) THEN
                    EXIT(AllowanceAssignmentLine."Allowance Amount");*/
                end;

            PGSetup."Vault Key":
                begin
                    AllowanceAssignmentLine.Reset;
                    AllowanceAssignmentLine.SetRange("Employee Code", PayrollLineVar."Employee No.");
                    AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SetRange("Allowance Type", PGSetup."Vault Key");
                    AllowanceAssignmentLine.CalcSums("Allowance Amount");
                    if not (AllowanceAssignmentLine."Allowance Amount" = 0) then
                        exit(Round(AllowanceAssignmentLine."Allowance Amount", 1, '='));
                end;

            PGSetup."Morning Counter":
                begin
                    AllowanceAssignmentLine.Reset;
                    AllowanceAssignmentLine.SetRange("Employee Code", PayrollLineVar."Employee No.");
                    AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SetRange("Allowance Type", PGSetup."Morning Counter");
                    AllowanceAssignmentLine.CalcSums("Allowance Amount");
                    if not (AllowanceAssignmentLine."Allowance Amount" = 0) then
                        exit(AllowanceAssignmentLine."Allowance Amount");
                end;

            PGSetup."Risk Allowance":
                begin
                    AllowanceAssignmentLine.Reset;
                    AllowanceAssignmentLine.SetRange("Employee Code", PayrollLineVar."Employee No.");
                    AllowanceAssignmentLine.SetRange("Approval Status", AllowanceAssignmentLine."Approval Status"::Screened);
                    AllowanceAssignmentLine.SetRange("From Date", PayCyclePeriod."Allowance Start Date", PayCyclePeriod."Allowance End Date");
                    AllowanceAssignmentLine.SetRange("Allowance Type", PGSetup."Risk Allowance");
                    AllowanceAssignmentLine.CalcSums("Allowance Amount");
                    if not (AllowanceAssignmentLine."Allowance Amount" = 0) then
                        exit(AllowanceAssignmentLine."Allowance Amount");
                end;
            /*
            PGSetup."OT Benefit Component" : BEGIN
              EXIT((LevelWiseAttributes."Total Basic Salary" / PayrollHeader."Total Days")*"OT Hrs");
              END;

            PGSetup."LFA Alowance": BEGIN
              EXIT(LevelWiseAttributes."Total Basic Salary");
              END;*/
            PGSetup."Contract Basic":
                begin
                    exit(Employee."Contract Salary Amount");
                end;

            PGSetup."Leave Encashment":
                begin
                    if PayrollHeader.Type = PayrollHeader.Type::Settlement then //settlement
                        exit(Round((LevelWiseAttributes."Total Basic Salary" + LevelWiseAttributes.Allowance) / HRMgt.GetNoDaysInMonth * PayrollLineVar."Annual Leave Days"
                                     + LevelWiseAttributes."Total Basic Salary" / HRMgt.GetNoDaysInMonth * PayrollLineVar."Sick Leave Days", 0.01, '='));
                end;

            PGSetup.Gratuity:
                begin
                    if PayrollHeader.Type = PayrollHeader.Type::Payroll then
                        exit;
                    HRSetup.Get;
                    if PayrollLineVar."Gratuity Years" < HRSetup."Gratuity Level 1" then
                        exit(HRSetup."Gratuity Rate for Level 1" * (LevelWiseAttributes."Total Basic Salary") * PayrollLineVar."Gratuity Years")
                    else if (PayrollLineVar."Gratuity Years" > HRSetup."Gratuity Level 1") and (PayrollLineVar."Gratuity Years" <= HRSetup."Gratuity Level 2") then
                        exit(HRSetup."Gratuity Rate for Level 2" * (LevelWiseAttributes."Total Basic Salary") * PayrollLineVar."Gratuity Years")
                    else if (PayrollLineVar."Gratuity Years" > HRSetup."Gratuity Level 2") and (PayrollLineVar."Gratuity Years" <= HRSetup."Gratuity Level 3") then
                        exit(HRSetup."Gratuity Rate for Level 3" * (LevelWiseAttributes."Total Basic Salary") * PayrollLineVar."Gratuity Years")
                    else if (PayrollLineVar."Gratuity Years" > HRSetup."Gratuity Level 3") and (PayrollLineVar."Gratuity Years" <= HRSetup."Gratuity Level 4") then
                        exit(HRSetup."Gratuity Rate for Level 4" * (LevelWiseAttributes."Total Basic Salary") * PayrollLineVar."Gratuity Years")
                    else if (PayrollLineVar."Gratuity Years" > HRSetup."Gratuity Level 4") then
                        exit(HRSetup."Gratuity Rate for Level 4" * (LevelWiseAttributes."Total Basic Salary") * PayrollLineVar."Gratuity Years");
                end;

            PGSetup."LFA Recover":
                begin
                    if PayrollHeader.Type = PayrollHeader.Type::Payroll then
                        exit;
                    LeaveTypeSetup.Reset;
                    LeaveTypeSetup.SetRange("AML Eligible", true);
                    if LeaveTypeSetup.FindFirst then
                        exit(LevelWiseAttributes."Total Basic Salary" / LeaveTypeSetup."Days Earned Per Year" * PayrollLineVar.LFA)
                end;
        //<<settlement
        end;
    end;

    procedure InsertPayrollAttributes()
    var
        EmployeePageBuilder: FilterPageBuilder;
        TempEmployee: Record Employee;
    begin
        EmployeePageBuilder.AddRecord('Employee Payroll Attributes Usage', TempEmployee);
        EmployeePageBuilder.AddField('Employee Payroll Attributes Usage', TempEmployee."No.");
        if EmployeePageBuilder.RunModal then begin
            TempEmployee.SetView(EmployeePageBuilder.GetView('Employee Payroll Attributes Usage'));
            InsertPayrollAttributesUsage(TempEmployee.GetFilter("No."));
            Message('Payroll Attributes Usage Updated.');
        end;
    end;

    procedure InsertPayrollAttributesUsage(EmpCode: Code[20])
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
    begin
        Employee.Reset;
        Employee.SetFilter("No.", EmpCode);
        //Employee.SETRANGE(Status,Employee.Status::Active);
        Employee.SetFilter("Employment Type", '<>%1', Employee."Employment Type"::" ");
        if Employee.Find('-') then
            repeat
                Clear(PayrollAttributesUsage);
                /*PayrollAttributesUsage.SETRANGE("Employee Code",Employee."No.");
                PayrollAttributesUsage.DELETEALL;*/
                PayrollAttributes.Reset;
                // if Employee."Employment Type" = Employee."Employment Type"::Contract then
                //     PayrollAttributes.SetFilter("Employee Type", '%1|%2', PayrollAttributes."Employee Type"::All, PayrollAttributes."Employee Type"::Contract)
                // else if Employee."Employment Type" = Employee."Employment Type"::Probation then
                //     PayrollAttributes.SetFilter("Employee Type", '%1|%2', PayrollAttributes."Employee Type"::All, PayrollAttributes."Employee Type"::"Except Contract")
                // else
                //     PayrollAttributes.SetFilter("Employee Type", '%1|%2|%3', PayrollAttributes."Employee Type"::All, PayrollAttributes."Employee Type"::Permanent, PayrollAttributes."Employee Type"::"Except Contract");
                PayrollAttributes.SetFilter("Employee Type", '%1|%2', PayrollAttributes."Employee Type"::" ", Employee."Employment Type");
                if PayrollAttributes.Find('-') then
                    repeat
                        Clear(PayrollAttributesUsage);
                        PayrollAttributesUsage.Reset;
                        PayrollAttributesUsage.SetRange("Employee Code", Employee."No.");
                        PayrollAttributesUsage.SetRange(Code, PayrollAttributes.Code);
                        if not PayrollAttributesUsage.FindFirst then begin
                            PayrollAttributesUsage.Init;
                            PayrollAttributesUsage.Validate(Code, PayrollAttributes.Code);
                            PayrollAttributesUsage.Validate("Employee Code", Employee."No.");
                            PayrollAttributesUsage.Insert(true);
                        end;
                    until PayrollAttributes.Next = 0;
            until Employee.Next = 0;
    end;

    local procedure GetPreviousPayCycleCode(PayrollHeader: Record "Payroll Header")
    begin
        if PayrollHeader.Type = PayrollHeader.Type::Payroll then begin
            PreviousPayCyclePeriod.Reset;
            PreviousPayCyclePeriod.SetFilter("Start Date", '<=%1', PayrollHeader."From Date" - 2);
            PreviousPayCyclePeriod.SetFilter("End Date", '>=%1', PayrollHeader."From Date" - 2);
            if PreviousPayCyclePeriod.FindFirst then;
        end else begin
            PreviousPayCyclePeriod.Reset;
            PreviousPayCyclePeriod.SetFilter("Start Date", '<=%1', PayrollHeader."From Date" - 2);
            PreviousPayCyclePeriod.SetFilter("End Date", '>=%1', PayrollHeader."From Date" - 2);
            // PreviousPayCyclePeriod.SETFILTER("Start Date",'<=%1',EmployeeLedgerEntry."Pay Period Start Date" - 2);
            //PreviousPayCyclePeriod.SETFILTER("End Date",'>=%1',EmployeeLedgerEntry."Pay Period Start Date" - 2);
            if PreviousPayCyclePeriod.FindFirst then;
        end;
    end;

    procedure GetPreviousPayCycleCodeDays(PayrollHeader: Record "Payroll Header"): Decimal
    var
        TotalDaysInPeviousMonth: Decimal;
    begin
        GetPreviousPayCycleCode(PayrollHeader);
        if PGSetup."Total Days From" = PGSetup."Total Days From"::Year then
            TotalDaysInPeviousMonth := PGSetup."Total Days" / 12
        else
            TotalDaysInPeviousMonth := (PreviousPayCyclePeriod."End Date" - PreviousPayCyclePeriod."Start Date" + 1);
        exit(TotalDaysInPeviousMonth);
    end;

    local procedure GetSlabAmount()
    begin
        case SlabCount of
            1:
                PayrollLine."1% Slab" := (SlabAmount * TaxSetupLine."Tax Rate" / 100.0);//    /(12 -FirstPayCyclePeriod +1);
            2:
                PayrollLine."10% Slab" := (SlabAmount * TaxSetupLine."Tax Rate" / 100.0);//   /(12-FirstPayCyclePeriod +1);
            3:
                PayrollLine."20% Slab" := (SlabAmount * TaxSetupLine."Tax Rate" / 100.0);//   /(12-FirstPayCyclePeriod +1);
            4:
                PayrollLine."30% Slab" := (SlabAmount * TaxSetupLine."Tax Rate" / 100.0);//   /(12-FirstPayCyclePeriod +1);
            5:
                PayrollLine."36% Slab" := (SlabAmount * TaxSetupLine."Tax Rate" / 100.0);//   /(12-FirstPayCyclePeriod +1);
            6:
                PayrollLine."39% Slab" := (SlabAmount * TaxSetupLine."Tax Rate" / 100.0);//   /(12-FirstPayCyclePeriod +1);
        end;
    end;

    local procedure PopulateGlobalAmounts()
    begin
        PayrollLine."Projection Month" := RemainingMonth;
        PayrollLine."Tax for Period" := MonthlyTax;
        PayrollLine."Projected Benefit" := TaxAtOnceProjectionEarning;
        PayrollLine."Projected Non-Payments" := TaxAtOnceProjectedNonPayments;
        PayrollLine."Past Benefit" := Employee."Total Earning" + EmpPayOpen."Total Benefit Opening";
        PayrollLine."Past Non-Payments" := Employee."Non-Payment";
        PayrollLine."Assessable Income" := TaxAtOnceProjectionEarning + Employee."Total Earning" + Employee."Non-Payment" + EmpPayOpen."Total Benefit Opening" + TaxAtOnceCurrentEarning + TaxAtOnceProjectedNonPayments + TaxatOnceCurrentNonPayments;
        PayrollLine."Past Retirement Fund" := Abs(Employee."RF Deposit") + Abs(Employee."Total Retirement Contribution") + EmpPayOpen."Total RF Opening" + Abs(Employee."Lump Sum CIT");
        PayrollLine."Projected Retirement Fund" := ProjectionEarning;
        PayrollLine."Actual RF Contribution" := TotalContributionToRetirementFund;
        PayrollLine."1/3 of Assessable Income" := RetirementFundLimit1;
        PayrollLine."Eligible RF Deduction" := RetirementFundTaxBenefit;
        PayrollLine."Total Employer Contribution" := EmployerContribution;
        PayrollLine."Balance Taxable Income" := TaxAtOnceTaxableAmt;
        PayrollLine."Taxable Income" := TaxAtOnceTotalAnnualEarning - RetirementFundTaxBenefit;
        PayrollLine."Life Insurance Premium" := InsuranceTaxBenefit;
        PayrollLine."Health Insurance Premium" := HealthInsuranceTaxBenefit;
        PayrollLine."Property Insurance Premium" := PropertyInsuranceTaxBenefit; //Min -- assigned PropertyInsuranceTaxBenefit
        PayrollLine."Disable Person Reduction" := DisablePersonReduction;
        PayrollLine."Total Tax Liability" := TaxAtOnceAnnualTax + TaxExempt + TotalSSTPaid + TotalTaxRemunPaid;
        //Wrong Expression
        PayrollLine."Payable Tax Liability" := TaxAtOnceAnnualTax + TotalSSTPaid + TotalTaxRemunPaid;
        PayrollLine."Social Security Tax(Annual)" := SocialSecurityTax;
        if (TaxAtOnceAnnualTax - SocialSecurityTax + TotalTaxRemunPaid + TotalSSTPaid) < 0 then
            PayrollLine."Tax on Remuneration(Annual)" := 0
        else
            PayrollLine."Tax on Remuneration(Annual)" := TaxAtOnceAnnualTax - SocialSecurityTax + TotalTaxRemunPaid + TotalSSTPaid;
        PayrollLine."Female Tax Credit" := TaxExempt;
        PayrollLine."Net Tax Liability" := TaxAtOnceAnnualTax;
        PayrollLine."Total Tax Paid" := Employee."Remuneration & Benefits Tax" + EmpPayOpen."Total Tax Remuneration Opening" + Employee."Social Security Tax" + EmpPayOpen."Total Social Security Opening";
        PayrollLine."Total SST Paid" := Employee."Social Security Tax" + EmpPayOpen."Total Social Security Opening";
        PayrollLine."Total Tax Remuneration Paid" := Employee."Remuneration & Benefits Tax" + EmpPayOpen."Total Tax Remuneration Opening";
        PayrollLine."Current Benefit" := TaxAtOnceCurrentEarning + CurrentNonTaxableBenefits;
        PayrollLine."Current Non-Payments" := CurrentNonPaymentBenefits;
        PayrollLine."Current Deduction" := TaxAtOnceCurrentDeduction;

        PayrollLine."Net Pay" := Round(TaxAtOnceCurrentEarning - TaxAtOnceCurrentDeduction + LumpSumCIT - MonthlyTax + CurrentNonTaxableBenefits - AddTaxOnInterestAllowance(PayrollLine."Employee No.", PayrollLine."Document No.") + SettlementAmount, 0.01, '=');
        //Wrong Expression
    end;

    local procedure GetRemoteAreaDeduction()
    var
        InitalDate: Date;
        FirstTime: Boolean;
        BranchCode: Code[20];
        // EmpHie: Record "Employee Hierarchy Master";
        OrganationStructureList: Record "Organization Structure List";
        RemoteArea: Record "Remote Area Category";
        DimValue: Record "Dimension Value";
        FinalDate: Date;
    begin
        GLSetup.Get;
        FirstTime := true;
        if Employee."Employment Date" < PGSetup."Payroll Fiscal Year Start Date" then
            InitalDate := PGSetup."Payroll Fiscal Year Start Date"
        else
            InitalDate := Employee."Employment Date";
        ServiceHistory.Reset;
        ServiceHistory.SetRange("Employee No.", Employee."No.");
        ServiceHistory.SetRange("Effective Date", InitalDate, PGSetup."Payroll Fiscal Year End Date");
        ServiceHistory.SetFilter("Service Event", '%1|%2|%3|%4', ServiceHistory."Service Event"::"Assignment in Job Function", ServiceHistory."Service Event"::Appointment, ServiceHistory."Service Event"::"Internal Appointment",
                                        ServiceHistory."Service Event"::Transfer);

        ServiceHistory.SetCurrentKey("Effective Date");
        if ServiceHistory.Find('+') then begin
            repeat
                Clear(BranchCode);
                // if ServiceHistory."Deputation On (To)" = ServiceHistory."Deputation On (To)"::Branch then
                //     BranchCode := ServiceHistory."Deputation Code (To)"
                // else if ServiceHistory."Deputation On (To)" = ServiceHistory."Deputation On (To)"::"Extension Counter" then begin
                //     EmpHie.Reset;
                //     EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                //     EmpHie.SetRange(Code, ServiceHistory."Deputation Code (To)");
                //     if EmpHie.FindFirst then
                //         BranchCode := EmpHie."Shortcut Dimension 1 Code";
                // end;
                if OrganationStructureList.Get(OrganationStructureList.Type::Branch, ServiceHistory."Deputation Code (To)") then;
                if RemoteArea.Get(OrganationStructureList."Remote Area Reduction") then begin
                    if FirstTime then begin
                        RemoteAreaDeduction := RemoteArea."Remote Area Deduction" / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1)
                                              * (PGSetup."Payroll Fiscal Year End Date" - ServiceHistory."Effective Date" + 1);
                        FirstTime := false;
                        FinalDate := ServiceHistory."Effective Date";
                    end else begin
                        RemoteAreaDeduction += RemoteArea."Remote Area Deduction" / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1)
                                            * (FinalDate - ServiceHistory."Effective Date");
                        FinalDate := ServiceHistory."Effective Date";
                    end;
                end;
            until ServiceHistory.Next(-1) = 0;

            //** to calculate the remote area deduction if employment date is in previous fiscal year...
            if Employee."Employment Date" < PGSetup."Payroll Fiscal Year Start Date" then begin
                ServiceHistory.Reset;
                ServiceHistory.SetRange("Employee No.", Employee."No.");
                ServiceHistory.SetRange("Effective Date", InitalDate, FinalDate);
                ServiceHistory.SetFilter("Service Event", '%1', ServiceHistory."Service Event"::Transfer);
                ServiceHistory.SetCurrentKey("Effective Date");
                if ServiceHistory.FindFirst then begin
                    Clear(BranchCode);
                    // if ServiceHistory."Deputation On(From)" = ServiceHistory."Deputation On(From)"::Branch then
                    //     BranchCode := ServiceHistory."Deputation Code (From)"
                    // else if ServiceHistory."Deputation On(From)" = ServiceHistory."Deputation On(From)"::"Extension Counter" then begin
                    //     EmpHie.Reset;
                    //     EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    //     EmpHie.SetRange(Code, ServiceHistory."Deputation Code (From)");
                    //     if EmpHie.FindFirst then
                    //         BranchCode := EmpHie."Shortcut Dimension 1 Code";
                    // end;
                    // if DimValue.Get(GLSetup."Global Dimension 1 Code", BranchCode) then;
                    If OrganationStructureList.Get(OrganationStructureList.Type::Branch, ServiceHistory."Deputation Code (From)") then;
                    if RemoteArea.Get(OrganationStructureList."Remote Area Reduction") then begin
                        RemoteAreaDeduction += RemoteArea."Remote Area Deduction" / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1)
                                               * (ServiceHistory."Effective Date" - InitalDate);
                    end;
                end;
            end;
        end else begin
            OrganationStructureList.Get();
            if OrganationStructureList.Get(OrganationStructureList.Type::Branch, Employee."Global Dimension 1 Code") then
                if RemoteArea.Get(OrganationStructureList."Remote Area Reduction") then
                    RemoteAreaDeduction := RemoteArea."Remote Area Deduction" / (PGSetup."Payroll Fiscal Year End Date" - PGSetup."Payroll Fiscal Year Start Date" + 1)
                                            * (PGSetup."Payroll Fiscal Year End Date" - InitalDate + 1);
        end;
        PayrollLine."Remote Area Deduction" := RemoteAreaDeduction;
        //MESSAGE(FORMAT(RemoteAreaDeduction));
    end;

    procedure LoadDashainBonus(EmployeeType: enum "Employee Type"; PayrollDocNo: Code[20])
    var
        Employee: Record Employee;
        EmployeePayrollAdjustment: Record "Employee Payroll Adjustment";
        LevelWiseAttributes: Record "Level Wise Attributes";
        CheckDate: Date;
    begin
        PGSetup.Get;
        PGSetup.TestField("Dashain Renumeration");
        PGSetup.TestField("Dashain Start Date");

        if PGSetup."Dashain Start Date" < PGSetup."Payroll Fiscal Year Start Date" then
            Error('Please update Dashain Start Date for current fiscal year.');

        case EmployeeType of
            EmployeeType::Permanent:
                begin
                    Employee.Reset;
                    Employee.SetFilter("Employment Type", '%1|%2', Employee."Employment Type"::Probation, Employee."Employment Type"::Permanent);
                    Employee.SetRange(Status, Employee.Status::Active);
                    if Employee.FindSet then
                        repeat
                            Employee.TestField("Employment Date");

                            LevelWiseAttributes.Get(Employee."Salary Grade", Employee."Salary Level");

                            CheckDate := GetCheckDateforDashain(PGSetup."Dashain Start Date", Employee."Employment Date");

                            if CheckDate <> 0D then begin
                                EmployeePayrollAdjustment.Init;
                                EmployeePayrollAdjustment."Payroll Document No." := PayrollDocNo;
                                EmployeePayrollAdjustment.Validate("Employee No.", Employee."No.");
                                EmployeePayrollAdjustment.Validate("Attribute Code", PGSetup."Dashain Renumeration");
                                EmployeePayrollAdjustment.Validate(Amount, GetDashainBonusAmt(LevelWiseAttributes."Total Basic Salary" + LevelWiseAttributes.Allowance, CheckDate));
                                if EmployeePayrollAdjustment.Amount <> 0 then
                                    EmployeePayrollAdjustment.Insert(true);
                            end;
                        until Employee.Next = 0;
                end;
            EmployeeType::Contract:
                begin
                    Employee.Reset;
                    Employee.SetRange("Employment Type", Employee."Employment Type"::Contract);
                    Employee.SetRange(Status, Employee.Status::Active);
                    if Employee.FindSet then
                        repeat
                            Employee.TestField("Contract Expiry Date");
                            Employee.TestField("Contract Salary Amount");
                            Employee.TestField("Employment Date");

                            CheckDate := GetCheckDateforDashain(PGSetup."Dashain Start Date", Employee."Employment Date");

                            if CheckDate <> 0D then begin
                                if (Employee."Contract Expiry Date" - Employee."Employment Date" + 1) >= 183 then begin
                                    EmployeePayrollAdjustment.Init;
                                    EmployeePayrollAdjustment."Payroll Document No." := PayrollDocNo;
                                    EmployeePayrollAdjustment.Validate("Employee No.", Employee."No.");
                                    EmployeePayrollAdjustment.Validate("Attribute Code", PGSetup."Dashain Renumeration");
                                    EmployeePayrollAdjustment.Validate(Amount, GetDashainBonusAmt(Employee."Contract Salary Amount", CheckDate));
                                    if EmployeePayrollAdjustment.Amount <> 0 then
                                        EmployeePayrollAdjustment.Insert(true);
                                end;
                            end;
                        until Employee.Next = 0;
                end;
        end;
    end;

    procedure GetCheckDateforDashain(DashainStartDate: Date; EmploymentDate: Date): Date
    begin
        if EmploymentDate < DashainStartDate then
            exit(EmploymentDate)
        else
            exit(DashainStartDate);
    end;

    local procedure GetDashainBonusAmt(TotalGrossSalary: Decimal; CheckDate: Date): Decimal
    var
        DashainDays: Integer;
    begin
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            if (Employee."Contract Expiry Date" - Employee."Employment Date" + 1) < 183 then
                exit(0);

        DashainDays := PGSetup."Dashain Start Date" - CheckDate;

        if DashainDays <= 0 then
            exit(0);

        if (DashainDays + 1) >= 183 then
            exit(TotalGrossSalary)
        else
            exit((DashainDays + 1) / 183 * TotalGrossSalary);
    end;



    procedure LoadLeaveFareAllowance(EmpType: Enum "Employee Type"; PayrollDocumentNo: Code[20])
    var
        Employee: Record Employee;
        LeaveEarn: Record "Leave Earn";
        TotalAnnualLeaveByEmployee: Dictionary of [Code[20], Decimal];
        TempLeaveCode: Code[20];
        EmployeePayrollAdjustment: Record "Employee Payroll Adjustment";
        EmployeeNo: Code[20];
        LeaveDays: Decimal;
    begin
        LeaveTypeSetup.Reset();
        LeaveTypeSetup.SetRange("AML Eligible", true);
        LeaveTypeSetup.SetRange("Leave For Employee Type", EmpType);
        if not LeaveTypeSetup.FindFirst() then
            exit;
        TempLeaveCode := LeaveTypeSetup.Code;
        PGSetup.Get();
        LeaveEarn.Reset();
        LeaveEarn.SetRange("Posted Date", PGSetup."Payroll Fiscal Year Start Date", PGSetup."Payroll Fiscal Year End Date");
        LeaveEarn.SetRange(Type, LeaveEarn.Type::Used);
        LeaveEarn.SetRange("Payroll Posted", false);
        LeaveEarn.SetRange("Leave Code", TempLeaveCode);
        if LeaveEarn.FindSet() then
            repeat
                EmployeeNo := LeaveEarn.EmpNo;
                LeaveDays := LeaveEarn."Balancing Days";
                if TotalAnnualLeaveByEmployee.Get(EmployeeNo, LeaveDays) then
                    TotalAnnualLeaveByEmployee.Set(EmployeeNo, LeaveDays + LeaveEarn."Balancing Days")
                else
                    TotalAnnualLeaveByEmployee.Add(EmployeeNo, LeaveDays);
            until LeaveEarn.Next() = 0;
        foreach EmployeeNo in TotalAnnualLeaveByEmployee.Keys do begin
            LeaveTypeSetup.get(TempLeaveCode);
            if LeaveDays = LeaveTypeSetup."Days Earned Per Year" then begin
                EmployeePayrollAdjustment.Init();
                EmployeePayrollAdjustment."Payroll Document No." := PayrollDocumentNo;
                EmployeePayrollAdjustment.Validate("Employee No.", EmployeeNo);
                EmployeePayrollAdjustment.Validate("Attribute Code", PGSetup."Leave Fare Allowance");
                EmployeePayrollAdjustment.Validate(Amount, GetLFAAmount(EmployeeNo, PayrollDocumentNo));
                OnBeforeInsertEmployeePayrollAdjustment(EmployeePayrollAdjustment);
                if EmployeePayrollAdjustment.Amount <> 0 then
                    EmployeePayrollAdjustment.Insert(true);

            end
        end;
    end;

    local procedure GetLFAAmount(EmpNo: Code[20]; PayrollDocNo: Code[20]): Decimal
    var
        PayrollAttributesUsage: Record "Payroll Attributes Usage";
        SalaryLevel: Record "Salary Level";
    begin
        PGSetup.Get();
        if PGSetup."LFA Source" = PGSetup."LFA Source"::"as per Basic Salary" then begin
            PayrollAttributesUsage.Reset();
            PayrollAttributesUsage.SetRange("Employee Code", EmpNo);
            PayrollAttributesUsage.SetRange(Subtype, PayrollAttributesUsage.Subtype::Basic);
            if PayrollAttributesUsage.FindFirst() then
                exit(Round(PayrollAttributesUsage.Amount, 0.01, '='))
        end
        else if PGSetup."LFA Source" = PGSetup."LFA Source"::"as per Salary Level" then begin
            Employee.Reset();
            Employee.SetRange("No.", EmpNo);
            if Employee.FindFirst() then begin
                SalaryLevel.Get(Employee."Salary Level");
                exit(Round(SalaryLevel."Leave Fare Allowance", 0.01, '='))
            end;

        end;

    end;

    local procedure GetSettlementAttendance(var SettlementLine: Record "Payroll Line"; var SettlementHeader: Record "Payroll Header")
    var
        AttendanceSummary: Record "Attendance Summary";
        PayCyclePeriod: Record "Pay Cycle Period";
        LeaveDays: Decimal;
        AbsentDays: Decimal;
        PresentDays: Decimal;
        EmpAttendActivity: Record "Employee Attendance & Activity";
        PriorAbsentDays: Decimal;
        PriorLeaveDays: Decimal;
        PriorPresentDays: Decimal;
        RemainingDays: Decimal;
        UsedLeave: Decimal;
        CarryForwardLeave: Decimal;
        ProrataLeave: Decimal;
        SettlementDate: Date;
        AdjustedLeave: Decimal;
        SickLeave: Decimal;
        AnnualLeave: Decimal;
        CarryForwardSick: Decimal;
        CarryForwardAnnual: Decimal;
        UsedSick: Decimal;
        UsedAnnual: Decimal;
        ProrataSick: Decimal;
        ProrataAnnual: Decimal;
        WeekoffDay: Decimal;
    begin
        Employee.Get(SettlementLine."Employee No.");

        if Employee."Employment Type" in [Employee."Employment Type"::Permanent, Employee."Employment Type"::Probation] then begin
            SettlementLine."Resignation Date" := Employee."Resignation Date";
            SettlementLine.TestField("Resignation Date");
            SettlementDate := SettlementLine."Resignation Date";
        end else begin
            if SettlementLine."Resignation Date" <> 0D then
                SettlementDate := SettlementLine."Resignation Date"
            else
                SettlementDate := Employee."Contract Expiry Date";
        end;
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetFilter("Start Date", '<=%1', SettlementDate);
        PayCyclePeriod.SetFilter("End Date", '>=%1', SettlementDate);
        if PayCyclePeriod.FindFirst then;

        //GetPreviousPayCycleCode(SettlementHeader);
        PreviousPayCyclePeriod.Reset;
        PreviousPayCyclePeriod.SetFilter("Start Date", '<=%1', PayCyclePeriod."Start Date" - 2);
        PreviousPayCyclePeriod.SetFilter("End Date", '>=%1', PayCyclePeriod."Start Date" - 2);
        // PreviousPayCyclePeriod.SETFILTER("Start Date",'<=%1',EmployeeLedgerEntry."Pay Period Start Date" - 2);
        //PreviousPayCyclePeriod.SETFILTER("End Date",'>=%1',EmployeeLedgerEntry."Pay Period Start Date" - 2);
        if PreviousPayCyclePeriod.FindFirst then;
        AttendanceSummary.Reset;
        AttendanceSummary.SetCurrentKey("Employee No.", "From Date", "To Date");
        AttendanceSummary.SetRange("Employee No.", SettlementLine."Employee No.");
        AttendanceSummary.SetRange("Date Filter", PayCyclePeriod."Start Date", SettlementDate);
        AttendanceSummary.SetAutoCalcFields("Present Day", "Absent Day", "Leave Day", "Week Off Day");
        if AttendanceSummary.FindLast then;
        LeaveDays := AttendanceSummary."Leave Day";
        AbsentDays := AttendanceSummary."Absent Day";
        PresentDays := AttendanceSummary."Present Day";
        WeekoffDay := AttendanceSummary."Week Off Day";
        Clear(LeaveTypeSetup);
        LeaveTypeSetup.Reset;
        LeaveTypeSetup.SetRange("Employee No. Filter", PayrollLine."Employee No.");
        LeaveTypeSetup.SetRange("Check Balance for Payroll", true);
        if LeaveTypeSetup.Find('-') then
            repeat
                if GetProrataLeaveDays(LeaveTypeSetup.Code, SettlementLine."Employee No.", UsedLeave, CarryForwardLeave, ProrataLeave) > 0 then
                    RemainingDays += GetProrataLeaveDays(LeaveTypeSetup.Code, SettlementLine."Employee No.", UsedLeave, CarryForwardLeave, ProrataLeave);
            until LeaveTypeSetup.Next = 0;
        EmployeeLedgerEntry.Reset;
        EmployeeLedgerEntry.SetRange("Employee No.", SettlementLine."Employee No.");
        EmployeeLedgerEntry.SetCurrentKey("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period");
        if EmployeeLedgerEntry.FindLast then begin
            if EmployeeLedgerEntry."Pay Period End Date" < PreviousPayCyclePeriod."End Date" then begin
                EmpAttendActivity.Reset();
                EmpAttendActivity.SetRange("Employee No.", SettlementLine."Employee No.");
                EmpAttendActivity.SetRange("Attendance Date", PreviousPayCyclePeriod."Start Date", PreviousPayCyclePeriod."End Date");
                EmpAttendActivity.CalcSums("Present Day", "Absent Day", "Leave Day", "Week Off Day");
                PriorAbsentDays := EmpAttendActivity."Absent Day";
                //    PriorLeaveDays := EmpAttendActivity."Leave Day";
                if (PriorAbsentDays + EmpAttendActivity."Present Day" + EmpAttendActivity."Week Off Day") > (PreviousPayCyclePeriod."End Date" - PreviousPayCyclePeriod."Start Date" + 1) then
                    PriorPresentDays := EmpAttendActivity."Present Day" + EmpAttendActivity."Week Off Day" - 1
                else
                    PriorPresentDays := EmpAttendActivity."Present Day" + EmpAttendActivity."Week Off Day";
            end;
        end else begin
            EmpAttendActivity.Reset();
            EmpAttendActivity.SetRange("Employee No.", SettlementLine."Employee No.");
            EmpAttendActivity.SetRange("Attendance Date", Employee."Employment Date", PreviousPayCyclePeriod."End Date");
            EmpAttendActivity.CalcSums("Present Day", "Absent Day", "Leave Day", "Week Off Day");
            if Employee."Employment Date" > PreviousPayCyclePeriod."Start Date" then
                PriorAbsentDays := EmpAttendActivity."Absent Day" + (Employee."Employment Date" - PreviousPayCyclePeriod."Start Date")
            else
                PriorAbsentDays := EmpAttendActivity."Absent Day";
            //    PriorLeaveDays := EmpAttendActivity."Leave Day";
            if (PriorAbsentDays + EmpAttendActivity."Present Day" + EmpAttendActivity."Week Off Day") > (PreviousPayCyclePeriod."End Date" - PreviousPayCyclePeriod."Start Date" + 1) then
                PriorPresentDays := EmpAttendActivity."Present Day" + EmpAttendActivity."Week Off Day" - 1
            else
                PriorPresentDays := EmpAttendActivity."Present Day" + EmpAttendActivity."Week Off Day";
        end;

        if RemainingDays <> 0 then begin
            if RemainingDays > PriorAbsentDays then begin
                PriorLeaveDays += PriorAbsentDays;
                RemainingDays -= PriorAbsentDays;
                AdjustedLeave += PriorAbsentDays;
                PriorAbsentDays := 0;
            end else begin
                PriorLeaveDays += RemainingDays;
                PriorAbsentDays -= RemainingDays;
                AdjustedLeave += RemainingDays;
                RemainingDays := 0;
            end;
        end;

        if RemainingDays <> 0 then begin
            if RemainingDays > AbsentDays then begin
                LeaveDays += AbsentDays;
                RemainingDays -= AbsentDays;
                AdjustedLeave += AbsentDays;
                AbsentDays := 0;
            end else begin
                LeaveDays += RemainingDays;
                AbsentDays -= RemainingDays;
                AdjustedLeave += RemainingDays;
                RemainingDays := 0;
            end;
        end;
        AttendanceSummary.Reset;
        AttendanceSummary.SetCurrentKey("Employee No.", "From Date", "To Date");

        AbsentDays += PayCyclePeriod."End Date" - SettlementDate;
        SettlementLine.Validate("Total Adjusted Leave Days", AdjustedLeave);
        GetLeaveDaysForSettlement(SettlementLine."Total Adjusted Leave Days", SickLeave, AnnualLeave, SettlementLine."Employee No.", false, CarryForwardSick, CarryForwardAnnual, UsedSick, UsedAnnual, ProrataSick, ProrataAnnual);
        SettlementLine.Validate("Absent Days", AbsentDays);
        SettlementLine.Validate("Sick Leave Days", SickLeave);
        SettlementLine.Validate("Prorata Annual", ProrataAnnual);
        SettlementLine.Validate("Annual Leave Days", AnnualLeave);
        SettlementLine.Validate("Carry Forwarded Sick", CarryForwardSick);
        SettlementLine.Validate("Carry Forward Annual", CarryForwardAnnual);
        SettlementLine.Validate("Used Leave Sick", UsedSick);
        SettlementLine.Validate("Used Leave Annual", UsedAnnual);
        SettlementLine.Validate("Prorata Sick", ProrataSick);
        SettlementLine.Validate("Leave Days", LeaveDays);
        SettlementLine.Validate("Prior Absent Days", PriorAbsentDays);
        SettlementLine.Validate("Prior Present Days", PriorPresentDays);
        SettlementLine.Validate("Prior Leave Days", PriorLeaveDays);
        SettlementLine.Validate("Week off Days", WeekoffDay);
        SettlementLine.Validate("Present Days", PresentDays);
        SettlementLine.Validate("Leave Days", LeaveDays);
    end;

    local procedure CheckPremiumInsurance(EmployeeNo: Code[20])
    var
        EmpLoanAdvance: Record "Employee Loan/Advance";
        EmployeeInsurance: Record "Employee Insurance Information";
        HLInsAmt: Decimal;
        LifeInsuranceAmt: Decimal;
        PayrollGeneralSetup: Record "Payroll General Setup";
        EmpInsHealth: Record "Employee Insurance Information";
        HealthInsAmt: Decimal;
        EmpInsProperty: Record "Employee Insurance Information";
        PropertyInsAmt: Decimal;
    begin
        PayrollGeneralSetup.Get;
        EmpLoanAdvance.Reset;
        EmpLoanAdvance.SetRange("Employee Code", EmployeeNo);
        EmpLoanAdvance.SetRange("Repayment Mode", EmpLoanAdvance."Repayment Mode"::"Insurance Tieup");
        EmpLoanAdvance.SetRange("Approval Status", EmpLoanAdvance."Approval Status"::Approved);
        EmpLoanAdvance.SetRange(Settled, false);
        EmpLoanAdvance.CalcSums(EMI);
        HLInsAmt := EmpLoanAdvance.EMI * 12;

        EmployeeInsurance.Reset;
        EmployeeInsurance.SetRange("Employee No.", EmployeeNo);
        EmployeeInsurance.SetRange("Insurance Type", EmployeeInsurance."Insurance Type"::"Life Insurance");
        EmployeeInsurance.SetRange("Approval Status", EmployeeInsurance."Approval Status"::Approved);
        EmployeeInsurance.CalcSums("Annual Premium Amount");

        LifeInsuranceAmt := HLInsAmt + EmployeeInsurance."Annual Premium Amount";

        if LifeInsuranceAmt > PayrollGeneralSetup."Tax Ex. Life Insurance Amt." then
            InsuranceTaxBenefit := PayrollGeneralSetup."Tax Ex. Life Insurance Amt."
        else
            InsuranceTaxBenefit := LifeInsuranceAmt;

        EmpInsHealth.Reset;
        EmpInsHealth.SetRange("Employee No.", EmployeeNo);
        EmpInsHealth.SetRange("Insurance Type", EmpInsHealth."Insurance Type"::"Medical Insurance");
        EmpInsHealth.SetRange("Approval Status", EmployeeInsurance."Approval Status"::Approved);
        EmpInsHealth.CalcSums("Annual Premium Amount");
        HealthInsAmt := EmpInsHealth."Annual Premium Amount";
        if HealthInsAmt > PayrollGeneralSetup."Tax Ex. Health Insur. Amount" then
            HealthInsuranceTaxBenefit := PayrollGeneralSetup."Tax Ex. Health Insur. Amount"
        else
            HealthInsuranceTaxBenefit := HealthInsAmt;

        EmpInsProperty.Reset;
        EmpInsProperty.SetRange("Employee No.", EmployeeNo);
        EmpInsProperty.SetRange("Insurance Type", EmpInsProperty."Insurance Type"::"Property Insurance");
        EmpInsProperty.SetRange("Approval Status", EmpInsProperty."Approval Status"::Approved);
        EmpInsProperty.CalcSums("Annual Premium Amount");
        PropertyInsAmt := EmpInsProperty."Annual Premium Amount";
        if PropertyInsAmt > PayrollGeneralSetup."Tax Ex. Property Insurance Amt" then
            PropertyInsuranceTaxBenefit := PayrollGeneralSetup."Tax Ex. Property Insurance Amt"
        else
            PropertyInsuranceTaxBenefit := PropertyInsAmt;
    end;

    local procedure GetPayCyclePeriodPrevious(ExpiryDate: Date): Integer
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Term", PayrollHeader."Pay Cycle Term");
        PayCyclePeriod.SetRange("Pay Cycle Code", PayrollHeader."Pay Cycle Code");
        if (ExpiryDate = 0D) or (ExpiryDate >= PGSetup."Prev Fiscal Year End Date") then begin
            PayCyclePeriod.SetFilter("Start Date", '<=%1', PGSetup."Prev Fiscal Year End Date");
            PayCyclePeriod.SetFilter("End Date", '>=%1', PGSetup."Prev Fiscal Year End Date");
        end else begin
            PayCyclePeriod.SetFilter("Start Date", '<=%1', ExpiryDate);
            PayCyclePeriod.SetFilter("End Date", '>=%1', ExpiryDate);
        end;
        PayCyclePeriod.FindFirst;
        exit(PayCyclePeriod.Period);
    end;

    procedure IsActiveEmployee(No: Code[20]): Boolean
    var
        EmpRec: Record Employee;
    begin
        if EmpRec.Get(No) then
            if Employee.Status = Employee.Status::Active then
                exit(true)
            else
                exit(false);
    end;

    procedure IsValidEmployeeOT(Employee: Record Employee; OTFrom: Date; OTTo: Date; EncashmentCode: Code[20]): Boolean
    var
        EmpActivity: Record "Employee Activity";
    begin
        EmpActivity.Reset;
        EmpActivity.SetRange("Employee No.", Employee."No.");
        EmpActivity.SetRange(Type, EmpActivity.Type::Overtime);
        EmpActivity.SetRange("Approval Status", EmpActivity."Approval Status"::Approved);
        EmpActivity.SetRange("Encashment Code", EncashmentCode);
        EmpActivity.SetRange("OT Disbursed", false);
        EmpActivity.SetRange("Start Date", OTFrom, OTTo);
        if EmpActivity.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    procedure ImportOTEmployeeEncashCode(PayrollHdr: Record "Payroll Header")
    var
        Employee: Record Employee;
        PayrollAdj: Record "Employee Payroll Adjustment";
        EncashmentSetup: Record "OT Encashment Setup";
    begin
        PayrollAdj.Reset;
        PayrollAdj.SetRange("Payroll Document No.", PayrollHdr."No.");
        PayrollAdj.DeleteAll;
        Employee.Reset;
        Employee.SetCurrentKey(Status);
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetRange(Settled, false);
        if Employee.FindSet then
            repeat
                if IsValidEmployeeOT(Employee, PayrollHdr."OverTime From", PayrollHdr."OverTime To", PayrollHdr."Encashment Code") then begin
                    PayrollAdj.Init;
                    PayrollAdj."Payroll Document No." := PayrollHdr."No.";
                    PayrollAdj.Validate("Employee No.", Employee."No.");
                    EncashmentSetup.Get(PayrollHdr."Encashment Code");
                    PayrollAdj.Validate("Attribute Code", EncashmentSetup."Attribute Code");
                    PayrollAdj.Insert(true);
                end;
            until Employee.Next = 0;
        Message(Text001);
    end;

    procedure ImportOTEmployeeEncashPeriod(PayrollHdr: Record "Payroll Header")
    var
        Employee: Record Employee;
        PayrollAdj: Record "Employee Payroll Adjustment";
        EncashmentSetup: Record "OT Encashment Setup";
    begin
        PayrollAdj.Reset;
        PayrollAdj.SetRange("Payroll Document No.", PayrollHdr."No.");
        PayrollAdj.DeleteAll;
        EncashmentSetup.Reset;
        EncashmentSetup.SetRange(Period, PayrollHdr."Encashment Period");
        if EncashmentSetup.FindFirst then
            repeat
                Employee.Reset;
                Employee.SetCurrentKey(Status);
                Employee.SetRange(Status, Employee.Status::Active);
                Employee.SetRange(Settled, false);
                if Employee.FindSet then
                    repeat
                        if IsValidEmployeeOT(Employee, PayrollHdr."OverTime From", PayrollHdr."OverTime To", EncashmentSetup."Encashment Code") then begin
                            PayrollAdj.Init;
                            PayrollAdj."Payroll Document No." := PayrollHdr."No.";
                            PayrollAdj.Validate("Employee No.", Employee."No.");
                            EncashmentSetup.Get(EncashmentSetup."Encashment Code");
                            PayrollAdj.Validate("Attribute Code", EncashmentSetup."Attribute Code");
                            PayrollAdj.Insert(true);
                        end;
                    until Employee.Next = 0;
            until EncashmentSetup.Next = 0;
        Message(Text001);
    end;

    procedure UpdateOTAmountEncashCode(PayrollHeader: Record "Payroll Header")
    var
        PayrollAdjustment: Record "Employee Payroll Adjustment";
        EmployeeActivity: Record "Employee Activity";
    begin
        Clear(PayrollAdjustment);
        PayrollAdjustment.Reset;
        PayrollAdjustment.SetRange("Payroll Document No.", PayrollHeader."No.");
        if PayrollAdjustment.FindSet then
            repeat
                EmployeeActivity.Reset;
                EmployeeActivity.SetRange("Employee No.", PayrollAdjustment."Employee No.");
                EmployeeActivity.SetRange(EmployeeActivity.Type, EmployeeActivity.Type::Overtime);
                EmployeeActivity.SetRange(EmployeeActivity."Approval Status", EmployeeActivity."Approval Status"::Approved);
                EmployeeActivity.SetRange("OT Disbursed", false);
                EmployeeActivity.SetRange("Start Date", PayrollHeader."OverTime From", PayrollHeader."OverTime To");
                EmployeeActivity.SetRange("Encashment Code", PayrollHeader."Encashment Code");
                EmployeeActivity.CalcSums("OT Amount");
                PayrollAdjustment.Validate(Amount, EmployeeActivity."OT Amount");
                PayrollAdjustment.Modify;
                if EmployeeActivity.FindSet then
                    repeat
                        EmployeeActivity."Updated Payroll Line" := true;
                        EmployeeActivity.Modify;
                    until EmployeeActivity.Next = 0;
            until PayrollAdjustment.Next = 0;
        Message(Text002);
    end;

    procedure UpdateOTAmountEncashPeriod(PayrollHeader: Record "Payroll Header")
    var
        PayrollAdjustment: Record "Employee Payroll Adjustment";
        EmployeeActivity: Record "Employee Activity";
        EncashmentSetup: Record "OT Encashment Setup";
    begin
        EncashmentSetup.Reset;
        EncashmentSetup.SetRange(Period, PayrollHeader."Encashment Period");
        if EncashmentSetup.FindSet then
            repeat
                Clear(PayrollAdjustment);
                PayrollAdjustment.Reset;
                PayrollAdjustment.SetRange("Payroll Document No.", PayrollHeader."No.");
                PayrollAdjustment.SetRange("Attribute Code", EncashmentSetup."Attribute Code");
                if PayrollAdjustment.FindSet then
                    repeat
                        EmployeeActivity.Reset;
                        EmployeeActivity.SetRange("Employee No.", PayrollAdjustment."Employee No.");
                        EmployeeActivity.SetRange(EmployeeActivity.Type, EmployeeActivity.Type::Overtime);
                        EmployeeActivity.SetRange(EmployeeActivity."Approval Status", EmployeeActivity."Approval Status"::Approved);
                        EmployeeActivity.SetRange("OT Disbursed", false);
                        EmployeeActivity.SetRange("Start Date", PayrollHeader."OverTime From", PayrollHeader."OverTime To");
                        EmployeeActivity.SetRange("Encashment Code", EncashmentSetup."Encashment Code");
                        EmployeeActivity.CalcSums("OT Amount");
                        PayrollAdjustment.Validate(Amount, EmployeeActivity."OT Amount");
                        PayrollAdjustment.Modify;
                        if EmployeeActivity.FindSet then
                            repeat
                                EmployeeActivity."Updated Payroll Line" := true;
                                EmployeeActivity.Modify;
                            until EmployeeActivity.Next = 0;
                    until PayrollAdjustment.Next = 0;
            until EncashmentSetup.Next = 0;
        Message(Text002);
    end;

    procedure UpdateOTDisbursedEncashCode(PayrollHeaderRec: Record "Payroll Header"; PayrollNo: Code[20])
    var
        PayrollLineRec: Record "Payroll Line";
        EmployeeActivity: Record "Employee Activity";
    begin
        PayrollLineRec.Reset;
        PayrollLineRec.SetRange("Document No.", PayrollHeaderRec."No.");
        if PayrollLineRec.FindSet then
            repeat
                EmployeeActivity.Reset;
                EmployeeActivity.SetRange("Employee No.", PayrollLineRec."Employee No.");
                EmployeeActivity.SetRange(EmployeeActivity.Type, EmployeeActivity.Type::Overtime);
                EmployeeActivity.SetRange(EmployeeActivity."Approval Status", EmployeeActivity."Approval Status"::Approved);
                EmployeeActivity.SetRange("OT Disbursed", false);
                EmployeeActivity.SetRange("Updated Payroll Line", true);
                EmployeeActivity.SetRange("Start Date", PayrollHeaderRec."OverTime From", PayrollHeaderRec."OverTime To");
                EmployeeActivity.SetRange("Encashment Code", PayrollHeaderRec."Encashment Code");
                if EmployeeActivity.FindSet then
                    repeat
                        EmployeeActivity.Validate("OT Disbursed", true);
                        EmployeeActivity.Validate("Payroll No.", PayrollNo);
                        EmployeeActivity.Modify;
                    until EmployeeActivity.Next = 0;
            until PayrollLineRec.Next = 0;
    end;

    procedure UpdateOTDisbursedEncashPeriod(PayrollHeaderRec: Record "Payroll Header"; PayrollNo: Code[20])
    var
        PayrollLineRec: Record "Payroll Line";
        EmployeeActivity: Record "Employee Activity";
        EncashmentSetup: Record "OT Encashment Setup";
    begin
        EncashmentSetup.Reset;
        EncashmentSetup.SetRange(Period, PayrollHeaderRec."Encashment Period");
        if EncashmentSetup.FindFirst then
            repeat
                PayrollLineRec.Reset;
                PayrollLineRec.SetRange("Document No.", PayrollHeaderRec."No.");
                if PayrollLineRec.FindSet then
                    repeat
                        EmployeeActivity.Reset;
                        EmployeeActivity.SetRange("Employee No.", PayrollLineRec."Employee No.");
                        EmployeeActivity.SetRange(EmployeeActivity.Type, EmployeeActivity.Type::Overtime);
                        EmployeeActivity.SetRange(EmployeeActivity."Approval Status", EmployeeActivity."Approval Status"::Approved);
                        EmployeeActivity.SetRange("OT Disbursed", false);
                        EmployeeActivity.SetRange("Updated Payroll Line", true);
                        EmployeeActivity.SetRange("Start Date", PayrollHeaderRec."OverTime From", PayrollHeaderRec."OverTime To");
                        EmployeeActivity.SetRange("Encashment Code", EncashmentSetup."Encashment Code");
                        if EmployeeActivity.FindSet then
                            repeat
                                EmployeeActivity.Validate("OT Disbursed", true);
                                EmployeeActivity.Validate("Payroll No.", PayrollNo);
                                EmployeeActivity.Modify;
                            until EmployeeActivity.Next = 0;
                    until PayrollLineRec.Next = 0;
            until EncashmentSetup.Next = 0;
    end;

    procedure UpdateOTDisbursedAllowances(PayrollHeaderRec: Record "Payroll Header"; PayrollNo: Code[20])
    var
        PayrollLineRec: Record "Payroll Line";
        EmployeeActivity: Record "Employee Activity";
        PayrollGenSetup: Record "Payroll General Setup";
    begin
        PayrollGenSetup.Get;
        PayrollLineRec.Reset;
        PayrollLineRec.SetRange("Document No.", PayrollHeaderRec."No.");
        if PayrollLineRec.FindSet then
            repeat
                EmployeeActivity.Reset;
                EmployeeActivity.SetRange("Employee No.", PayrollLineRec."Employee No.");
                EmployeeActivity.SetRange(EmployeeActivity.Type, EmployeeActivity.Type::Overtime);
                EmployeeActivity.SetRange(EmployeeActivity."Approval Status", EmployeeActivity."Approval Status"::Approved);
                EmployeeActivity.SetRange("OT Disbursed", false);
                EmployeeActivity.SetRange("Updated Payroll Line", true);
                if PayrollHeaderRec."Previous Year Payroll" then
                    EmployeeActivity.SetRange("Start Date", PayrollGenSetup."Prev Fiscal Year Start Date", PayrollGenSetup."Prev Fiscal Year End Date")
                else
                    EmployeeActivity.SetRange("Start Date", PayrollGenSetup."Payroll Fiscal Year Start Date", PayrollGenSetup."Payroll Fiscal Year End Date");
                EmployeeActivity.SetFilter("Encashment Code", '%1|%2', PayrollGenSetup."Holiday Counter", PayrollGenSetup."Festival Counter");
                if EmployeeActivity.FindSet then
                    repeat
                        EmployeeActivity.Validate("OT Disbursed", true);
                        EmployeeActivity.Validate("Payroll No.", PayrollNo);
                        EmployeeActivity.Modify;
                    until EmployeeActivity.Next = 0;
            until PayrollLineRec.Next = 0;
    end;

    procedure PayrollCaptionClassTranslate(CaptionRef: Text[80]): Text[30]
    var
        LanguageCode: Code[20];
        LanguageRec: Record Language;
        TableID: Integer;
        FieldNo: Integer;
    begin
        if CaptionRef = '' then
            exit('');
        if not Evaluate(TableID, SelectStr(1, CaptionRef)) then
            exit('');
        if not Evaluate(FieldNo, SelectStr(2, CaptionRef)) then
            exit('');

        exit(GetCaption(TableID, FieldNo));
    end;

    procedure GetCaption(TableNo: Integer; FieldNo: Integer): Text[30]
    var
        PayColumnConfig: Record "Payroll Column Configuration";
        PayAttribute: Record "Payroll Attributes";
    begin
        if PayColumnConfig.Get(TableNo, FieldNo) then begin
            if PayAttribute.Get(PayColumnConfig."Variable Field Code") then begin
                exit(CopyStr(PayAttribute.Description, 1, 30));
            end;
        end;
        exit('');
    end;

    procedure ImportPayrollAttributes(EmpCode: Code[20])
    var
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        EmpVar: Record Employee;
        PayrollAttrUsage1: Record "Payroll Attributes Usage";
        PayrollAttr: Record "Payroll Attributes";
    begin
        PayrollAttr.Reset();
        PayrollAttr.SetRange(Status, PayrollAttr.Status::Active);
        // PayrollAttr.SetRange("Manual Import", false);
        // if IrregularOnly then
        //     PayrollAttr.SetRange("For Irr. Payroll", true);
        if PayrollAttr.FindSet() then
            repeat
                EmpVar.Reset();

                // EmpVar.SetLoadFields("No.", "Tax Code", "Employment Type", "Global Dimension 1 Code", "Service Group", "Salary Level");
                if EmpCode <> '' then
                    EmpVar.SetRange("No.", EmpCode);
                // EmpVar.SetRange(Nominee, false);
                EmpVar.SetRange(Status, EmpVar.Status::Active);
                EmpVar.SetFilter("Tax Code", '<>%1', '');
                // if PayrollAttr."Pension Specific" <> PayrollAttr."Pension Specific"::" " then
                //     EmpVar.SetRange("Pension Applicable", true)
                // else
                //     EmpVar.SetRange("Pension Applicable", false);
                if PayrollAttr."Employee Type" <> PayrollAttr."Employee Type"::" " then
                    EmpVar.SetRange("Employment Type", PayrollAttr."Employee Type");
                if PayrollAttr."Branch Filter" <> '' then
                    EmpVar.SetFilter("Global Dimension 1 Code", PayrollAttr."Branch Filter");
                // if PayrollAttr."Service Group Filter" <> '' then
                //     EmpVar.SetFilter("Service Group", PayrollAttr."Service Group Filter");
                // if PayrollAttr."Salary Level Filter" <> '' then
                //     EmpVar.SetFilter("Salary Level", PayrollAttr."Salary Level Filter");
                if EmpVar.FindSet() then
                    repeat

                        if not PayrollAttrUsage1.Get(PayrollAttr.Code, EmpVar."No.") then begin
                            Clear(PayrollAttrUsage);
                            PayrollAttrUsage.Init();
                            PayrollAttrUsage.Validate("Employee Code", EmpVar."No.");
                            PayrollAttrUsage.Validate(Code, PayrollAttr.Code);
                            // if PayrollAttr.Subtype = PayrollAttr.Subtype::CIT then begin
                            // if (EmpVar."CIT No." <> '') then
                            if PayrollAttrUsage.Insert() then;
                            // end
                            // else

                            //     if PayrollAttrUsage.Insert() then;
                        end;
                    until EmpVar.Next() = 0;
            until PayrollAttr.Next = 0;
    end;

    //no in use
    procedure ProcessRetirementFundsDoc(var RetirementFund: Record "Retirement Fund")
    var
        PayrollAttributesUses: Record "Payroll Attributes Usage";
        PayrollAttributes: Record "Payroll Attributes";
        Employee: Record Employee;
    begin

        Employee.Get(RetirementFund."Employee No.");
        PayrollAttributes.SetFilter(Subtype, '%1|%2', PayrollAttributesUses.Subtype::CIT, PayrollAttributesUses.Subtype::RF);
        if PayrollAttributes.FindSet() then
            repeat
                if not PayrollAttributesUses.Get(PayrollAttributes.Code, RetirementFund."Employee No.") then begin
                    Clear(PayrollAttributesUses);
                    PayrollAttributesUses.Init();
                    PayrollAttributesUses.Validate("Employee Code", RetirementFund."Employee No.");
                    PayrollAttributesUses.Validate(Code, PayrollAttributes.Code);
                    PayrollAttributesUses.Validate(Subtype, PayrollAttributes.Subtype);
                    if PayrollAttributes.Subtype = PayrollAttributes.Subtype::CIT then
                        PayrollAttributesUses.Validate(Amount, RetirementFund."CIT Amount (Month)");
                    if PayrollAttributes.Subtype = PayrollAttributes.Subtype::RF then
                        PayrollAttributesUses.Validate(Amount, RetirementFund."RTF Amount (Month)");
                    PayrollAttributesUses.Insert(true);
                end
                else begin
                    if PayrollAttributes.Subtype = PayrollAttributes.Subtype::CIT then
                        PayrollAttributesUses.Validate(Amount, RetirementFund."CIT Amount (Month)");
                    if PayrollAttributes.Subtype = PayrollAttributes.Subtype::RF then
                        PayrollAttributesUses.Validate(Amount, RetirementFund."RTF Amount (Month)");
                    PayrollAttributesUses.Modify(true);
                end;
            until PayrollAttributes.Next() = 0;

        if RetirementFund."Lumpsum Committed Contribution" <> 0 then begin
            //
        end;
    end;

    procedure RFGetTotalAnnualEarning(var Employee: Record Employee; var RFTotalEarning: Decimal; RFprojectMonth: Integer)
    var
        EmployeePayrollOpening: Record "Employee Payroll Opening";
        PayrollgeneralSetup: Record "Payroll General Setup";
        paycycleperiod: Record "Pay Cycle Period";
        PayrollAttrUses: Record "Payroll Attributes Usage";
        PayAttribute: Record "Payroll Attributes";
    begin
        PayrollgeneralSetup.Get();
        paycycleperiod.SetRange("Start Date", PayrollgeneralSetup."Payroll Fiscal Year Start Date", PayrollgeneralSetup."Payroll Fiscal Year End Date");
        paycycleperiod.FindFirst();
        EmployeePayrollOpening.SetRange("Fiscal Year", paycycleperiod."Pay Cycle Term");
        if EmployeePayrollOpening.FindFirst() then
            RFTotalEarning += EmployeePayrollOpening."Total Benefit Opening";

        PayrollAttrUses.SetRange("Employee Code", Employee."No.");
        PayrollAttrUses.SetRange(Type, PayrollAttrUses.Type::Benefits);
        if PayrollAttrUses.FindSet() then
            repeat
                PayAttribute.get(PayrollAttrUses.code);
            // if PayAttribute."Apply Every Month" then

            until PayrollAttrUses.Next() = 0;


    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeInsertEmployeePayrollAdjustment(var EmployeePayrollAdjustment: Record "Employee Payroll Adjustment")
    begin
        // This event can be used to modify EmployeePayrollAdjustment before it is inserted.
        // You can add custom logic here if needed.
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertOutstationAllowance(EmployeeNo: Code[20]; PayCyclePeriod: Record "Pay Cycle Period"; var IsHandled: Boolean; var Amount: Decimal)
    begin
        //This event can be used to perform get the outstation allowance for the employee before exiting the process.
        //You can add custom logic here if needed.
    end;


}
