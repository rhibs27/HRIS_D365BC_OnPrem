report 50144 "Yearly Payroll Projection"
{
    ApplicationArea = All;
    Caption = 'Yearly Payroll Projection';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\6.Report\Rep50144.YearlyPayrollProjection.rdl';
    PreviewMode = PrintLayout;

    dataset
    {
        // This is the main data item that loops through all payroll attributes (earnings, deductions, taxes)
        dataitem(PayrollAttributes; "Payroll Attributes")
        {
            DataItemTableView = sorting(Code);

            // Company information columns that appear on the report header
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(PANNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }

            // Payroll attribute details
            column(Code; Code) { }
            column(Description; PayrollAttributes.Description) { }
            column(Type; Type) { }

            // Employee information columns
            column(EmpFullName; EmpVar."Full Name") { }
            column(PANNo_Employee; EmpVar."Pan No.") { }
            column(BankName; EmpVar."Bank Name") { }
            column(BankAccountNo; EmpVar."Bank Account No.") { }
            column(EmployeeSalaryLevel; EmpVar."Salary Level") { }
            column(ReportName; ReportName) { }
            column(SortinNo; SortingNo) { }
            column(EmpDesignation; EmpVar."Job Title") { }
            column(SSFNo; EmpVar."Social Security No.") { }
            column(EmployeeNo; EmpVar."No.") { }

            // Financial calculation columns - these show the main payroll calculations
            column(RetirementAmount; Round(TotalRetirement, GlSetup."Amount Rounding Precision")) { }
            column(TaxableIncome; Round(TaxableAmount, GlSetup."Amount Rounding Precision")) { }
            column(ThisMonthTDS; Round(PayrollAmts[5], GlSetup."Amount Rounding Precision")) { }
            column(RemainingTDS; Round(PayrollAmts[6], GlSetup."Amount Rounding Precision")) { }
            column(TotalTaxPaid; Round(TotalTaxPaid, GlSetup."Amount Rounding Precision")) { }
            column(TDSCalcMonth; TDSCalcMonth) { }
            column(InsurranceAmount; Round(LifeInsuranceAmount, GlSetup."Amount Rounding Precision")) { }

            // Tax calculation columns - shows tax breakdown by slabs
            column(FirstSlabRate; Round(TaxAmts[1], GlSetup."Amount Rounding Precision")) { }
            column(SecondSlabRate; Round(TaxAmts[2], GlSetup."Amount Rounding Precision")) { }
            column(ThirdSlabRate; Round(TaxAmts[3], GlSetup."Amount Rounding Precision")) { }
            column(FourthSlabeRate; Round(TaxAmts[4], GlSetup."Amount Rounding Precision")) { }
            column(FifthSlabRate; Round(TaxAmts[5], GlSetup."Amount Rounding Precision")) { }
            column(SixthSlabRate; Round(TaxAmts[6], GlSetup."Amount Rounding Precision")) { }

            column(FirstSlab; Round(TaxAmtsSlabs[1], GlSetup."Amount Rounding Precision")) { }
            column(SecondSlab; Round(TaxAmtsSlabs[2], GlSetup."Amount Rounding Precision")) { }
            column(ThirdSlab; Round(TaxAmtsSlabs[3], GlSetup."Amount Rounding Precision")) { }
            column(FourthSlab; Round(TaxAmtsSlabs[4], GlSetup."Amount Rounding Precision")) { }
            column(FifthSlab; Round(TaxAmtsSlabs[5], GlSetup."Amount Rounding Precision")) { }
            column(SixthSlab; Round(TaxAmtsSlabs[6], GlSetup."Amount Rounding Precision")) { }

            // Tax benefits and deductions
            column(TaxRebate; Round(TaxRebate, GlSetup."Amount Rounding Precision")) { }
            column(Minvaluededuction; Round(Minvaluededuction, GlSetup."Amount Rounding Precision")) { }
            column(TotalTax; Round(TotalTax, GlSetup."Amount Rounding Precision")) { }
            column(NonTaxable; Round(NonTaxable, GlSetup."Amount Rounding Precision")) { }
            column(TotalNonPayment; Round(TotalNonPayment, GlSetup."Amount Rounding Precision")) { }
            column(TotalDonation; Round(TotalDonation, GlSetup."Amount Rounding Precision")) { }
            column(TaxExemptionLimit; Round(TaxExemptionLimit, GlSetup."Amount Rounding Precision")) { }

            // Previous year carry-forward amounts
            column(PastBenefit; Round(PastBenefit, GlSetup."Amount Rounding Precision")) { }
            column(PastRetirementFund; Round(PastRetirementFund, GlSetup."Amount Rounding Precision")) { }
            column(PastSSTPaid; Round(PastSSTPaid, GlSetup."Amount Rounding Precision")) { }
            column(PastTaxPaid; Round(PastTaxPaid, GlSetup."Amount Rounding Precision")) { }

            // Tax rates for each slab (1%, 10%, 20%, etc.)
            column(TaxRate1_; Round(TaxRates[1], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate2_; Round(TaxRates[2], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate3_; Round(TaxRates[3], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate4_; Round(TaxRates[4], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate5_; Round(TaxRates[5], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate6_; Round(TaxRates[6], GlSetup."Amount Rounding Precision")) { }

            // Additional financial information
            column(OneThird; Round(OneThird, GlSetup."Amount Rounding Precision")) { }
            column(TotalAnualEarning; Round(TotalAnnualEarning, GlSetup."Amount Rounding Precision")) { }
            column(MedicalInsuranceAmount; Round(MedicalInsuranceAmount, GlSetup."Amount Rounding Precision")) { }
            column(HouseInsuranceAmount; Round(HouseInsuranceAmount, GlSetup."Amount Rounding Precision")) { }
            column(TaxCode; EmpVar."Tax Code") { }

            // This data item shows the monthly breakdown for each payroll attribute
            dataitem("Pay Cycle Period"; "Pay Cycle Period")
            {
                DataItemTableView = sorting("Pay Cycle Code", "Pay Cycle Term", Period);

                // Monthly period information
                column(PayCycleTerm_PayCyclePeriod; "Pay Cycle Period"."Pay Cycle Term") { }
                column(Period; "Pay Cycle Period".Period) { }
                column(Amount; Round(Amount, GlSetup."Amount Rounding Precision")) { }
                column(BenefitAmount; BenefitAmount) { }
                column(DeductionAmount; DeductionAmount) { }
                column(NepaliMonth_PayCyclePeriod; "Pay Cycle Period"."Nepali Month") { }

                trigger OnPreDataItem()
                var
                    Employee: Record Employee;
                    PayCyclePeriod2: Record "Pay Cycle Period";
                    StartDate: Date;
                begin
                    // Filter to only show periods for the selected pay cycle term
                    SetRange("Pay Cycle Term", PayCycleTerm);

                    // If employee started after the fiscal year began, only show periods after their start date
                    if Employee.Get(EmployeeFilter) then
                        if GetFirstPayCyclePeriod("Pay Cycle Term") < Employee."Employment Date" then begin
                            PayCyclePeriod2.SetFilter("Start Date", '<%1', Employee."Employment Date");
                            if PayCyclePeriod2.FindLast() then begin
                                StartDate := PayCyclePeriod2."Start Date";
                                SetFilter("Start Date", '>%1', StartDate);
                            end;
                        end;
                end;

                trigger OnAfterGetRecord()
                begin
                    // Calculate the total amount for this payroll attribute in this period
                    Clear(Amount);
                    TempDetailedEmpLedgerEntry.Reset;
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Period", Period);
                    TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", PayrollAttributes.Code);

                    // Sum up all ledger entries for this attribute in this period
                    if TempDetailedEmpLedgerEntry.FindFirst then
                        repeat
                            if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                                Amount := Amount + Abs(TempDetailedEmpLedgerEntry.Amount) // Deductions are stored as negative, so we take absolute value
                            else
                                Amount := Amount + TempDetailedEmpLedgerEntry.Amount; // Earnings are positive
                        until TempDetailedEmpLedgerEntry.Next = 0;

                    // Skip if no amount or if period is zero (invalid period)
                    if (Amount = 0) or ("Pay Cycle Period".Period = 0) then
                        CurrReport.Skip();

                    // For tax amounts, ensure they are not negative
                    if (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Social Security Tax") or
                       (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Tax on Remuneration & Benefits") then
                        if Amount < 0 then
                            Amount := 0;

                    // Separate benefit amounts from deduction amounts for reporting
                    BenefitAmount := 0;
                    DeductionAmount := 0;
                    if PayrollAttributes.Type = PayrollAttributes.Type::Benefits then
                        BenefitAmount := Amount
                    else if PayrollAttributes.Type = PayrollAttributes.Type::Deduction then
                        DeductionAmount := Amount;
                end;
            }

            trigger OnPreDataItem()
            begin
                // This runs before processing each payroll attribute
                // Get opening balances and calculate total tax paid so far
                GetEmployeePayrollOpeningValues(EmployeeFilter);
                CalculateTotalTaxPaid(EmployeeFilter);
                ClearVariables; // Reset all calculation variables
                InsertColumn; // This is the main procedure that does all calculations
            end;

            trigger OnAfterGetRecord()
            begin
                // This runs for each payroll attribute after it's loaded
                // Skip if employee not found
                if not EmpVar.Get(EmployeeFilter) then
                    CurrReport.Skip();

                // Get the sorting order for this attribute from payroll configuration
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
                if PayrollColumnConfig.FindFirst then
                    SortingNo := PayrollColumnConfig."Field No.";

                // Skip attributes that don't have a sorting number (not meant to be displayed)
                if SortingNo = 0 then
                    CurrReport.Skip();
            end;
        }
    }

    // This defines the page where user selects which employee and pay cycle to report on
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Pay Cycle Term"; PayCycleTerm)
                    {
                        ApplicationArea = All;
                        TableRelation = "Pay Cycle Term".Term;
                        ToolTip = 'Select the fiscal year for the payroll projection';
                    }
                    field("Employee No"; EmployeeFilter)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee."No.";
                        ToolTip = 'Select the employee for the yearly projection';
                    }
                }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }

    // This runs when the report is first opened
    trigger OnInitReport()
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        // Auto-select the current pay cycle term based on today's date
        if GuiAllowed then begin
            PayCyclePeriod.Reset();
            PayCyclePeriod.SetFilter("End Date", '>=%1', Today);
            PayCyclePeriod.SetFilter("Start Date", '<=%1', Today);
            if PayCyclePeriod.FindFirst() then
                PayCycleTerm := PayCyclePeriod."Pay Cycle Term";
        end;
    end;

    // This runs before the report starts processing
    trigger OnPreReport()
    var
        PayPeriod: Record "Pay Cycle Period";
    begin
        // Basic setup and validation
        GlSetup.Get; // Get general ledger settings
        CompanyInfo.Get; // Get company information
        CompanyInfo.CalcFields(Picture); // Load company logo

        // Validate that user selected a pay cycle term
        if PayCycleTerm = '' then
            Error('Please specify a pay cycle term');

        PgSetup.Get(); // Get payroll general settings

        // Validate that the selected term is for the current fiscal year
        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Term", PayCycleTerm);
        if PayPeriod.FindFirst() then
            if PayPeriod."Start Date" < PgSetup."Payroll Fiscal Year Start Date" then
                Error('Yearly projection report is for current year only');

        // Clear temporary data from previous runs
        TempDetailedEmpLedgerEntry.Reset;
        TempDetailedEmpLedgerEntry.DeleteAll;
    end;

    // This runs after the report finishes
    trigger OnPostReport()
    begin
        // Clean up temporary data
        TempDetailedEmpLedgerEntry.Reset;
        TempDetailedEmpLedgerEntry.DeleteAll;
    end;

    // Global variables used throughout the report
    var
        PgSetup: Record "Payroll General Setup"; // Payroll settings
        GlSetup: Record "General Ledger Setup"; // General ledger settings
        Amount: Decimal; // Temporary amount storage
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry"; // Actual payroll transactions
        PayCycleTerm: Code[10]; // Selected fiscal year (e.g., "2023-2024")
        EmployeeFilter: Code[20]; // Selected employee number
        EmpVar: Record Employee; // Employee information
        CompanyInfo: Record "Company Information"; // Company details
        BenefitAmount: Decimal; // Total benefits amount
        DeductionAmount: Decimal; // Total deductions amount
        ReportName: Text; // Report title
        PayrollColumnConfig: Record "Payroll Column Configuration"; // How to display payroll attributes
        SortingNo: Integer; // Display order for each attribute
        PayrollAmts: array[10] of Decimal; // Array for various payroll amounts
        TDSCalcMonth: Enum "Nepali Month"; // Month for TDS calculation
        TaxAmts: array[10] of Decimal; // Tax amount for each slab
        TaxAmtsSlabs: array[10] of Decimal; // Taxable amount for each slab
        TaxRates: array[10] of Decimal; // Tax rate for each slab
        TaxRebate: Decimal; // Total tax rebate/deduction
        TotalRetirement: Decimal; // Total retirement fund contribution
        TotalTax: Decimal; // Total annual tax liability
        TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry" temporary; // Temporary storage for calculations
        TotalAnnualEarning: Decimal; // Total annual earnings
        TotalTaxPaid: Decimal; // Total tax paid so far this year
        MonthlySST: Decimal; // Monthly social security tax
        PayrollReportMgt: Codeunit "Payroll Report Mgt."; // Payroll calculation functions
        EmployeePayrollOpen: Record "Employee Payroll Opening"; // Opening balances
        TaxableAmount: Decimal; // Total taxable income
        PayrollAttrUsage: Record "Payroll Attributes Usage"; // Employee-specific payroll settings
        Minvaluededuction: Decimal; // Minimum value deduction for tax calculation
        LifeInsuranceAmount: Decimal; // Life insurance premium amount
        TotalNonPayment: Decimal; // Total non-payment amounts
        NonTaxable: Decimal; // Total non-taxable income
        TaxExemptionLimit: Decimal; // Maximum tax exemption limit
        OneThird: Decimal; // One-third of total earning (for tax calculation)
        MedicalInsuranceAmount: Decimal; // Medical insurance premium amount
        HouseInsuranceAmount: Decimal; // House insurance premium amount
        EmployeeInsuranceInfo: Record "Employee Insurance Information"; // Employee insurance details
        TotalDonation: Decimal; // Total donation amount
        PastBenefit: Decimal; // Benefits brought forward from previous year
        PastRetirementFund: Decimal; // Retirement fund brought forward from previous year
        PastSSTPaid: Decimal; // Social security tax paid in previous year
        PastTaxPaid: Decimal; // Income tax paid in previous year
        TaxSetupHdr: Record "Tax Setup Header"; // Tax rates and rules
        RemainingTaxableAmount: Decimal; // Remaining taxable amount during slab calculation

    // Main procedure that sets up all data for the report
    local procedure InsertColumn()
    var
        LastEntryNo: Integer; // Counter for temporary entries
        RemainingMonth: Integer; // Months remaining in fiscal year
    begin
        // Safety check - exit if employee not found
        if not EmpVar.Get(EmployeeFilter) then
            exit;

        LastEntryNo := 90000000; // Starting number for temporary entries

        // Get employee's opening balances for the year
        EmployeePayrollOpen.Reset;
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeFilter);
        if EmployeePayrollOpen.FindLast then
            if not TaxSetupHdr.Get(EmpVar."Tax Code") then
                TaxSetupHdr.Init(); // Initialize tax settings if not found

        // Find the last payroll period processed for this employee
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetFilter("Employee No.", EmployeeFilter);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindLast then begin
            // Create projections for remaining months starting from next period
            CreateTempDetailedLedgerFromPAttrUsage(DetailedEmpLedgerEntry."Pay Cycle Period" + 1, LastEntryNo);
            RemainingMonth := GetLastPayCycle(EmployeeFilter) - DetailedEmpLedgerEntry."Pay Cycle Period"
        end else begin
            // No transactions yet, project for entire year
            CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
            RemainingMonth := GetLastPayCycle(EmployeeFilter);
        end;

        // Copy all actual payroll transactions to temporary table for calculations
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeFilter);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindFirst then
            repeat
                TempDetailedEmpLedgerEntry.Init;
                TempDetailedEmpLedgerEntry := DetailedEmpLedgerEntry;
                // Convert deduction amounts to positive for calculations
                if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                    TempDetailedEmpLedgerEntry.Amount := Abs(DetailedEmpLedgerEntry.Amount);
                TempDetailedEmpLedgerEntry.Insert;
            until DetailedEmpLedgerEntry.Next = 0;

        // Perform all tax and financial calculations
        CalculateTaxComponents(RemainingMonth);
    end;

    // Calculates all the main financial components for tax calculation
    local procedure CalculateTaxComponents(RemainingMonth: Integer)
    var
        Employee: Record Employee;
    begin
        // Initialize all variables to zero
        TotalAnnualEarning := 0;
        TotalRetirement := 0;
        Minvaluededuction := 0;
        TotalNonPayment := 0;
        NonTaxable := 0;
        OneThird := 0;
        MedicalInsuranceAmount := 0;
        HouseInsuranceAmount := 0;

        PgSetup.Get(); // Get payroll settings

        // Get employee data with date filter for current fiscal year
        Employee.Reset;
        Employee.SetRange("No.", EmployeeFilter);
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        if Employee.FindFirst then begin
            // Calculate various employee totals
            Employee.CalcFields("Total Earning", "Total Retirement Contribution", "Total Donation Contribution",
                    "Total Medical Re-Imbursement", "Social Security Tax", "Remuneration & Benefits Tax", "PF Contribution");

            // Calculate Total Annual Earning from temporary ledger entries
            TempDetailedEmpLedgerEntry.Reset();
            TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2',
                TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning",
                TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
            TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
            TempDetailedEmpLedgerEntry.CalcSums(Amount);
            TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total Benefit Opening";

            // Calculate Total Retirement Contributions
            TempDetailedEmpLedgerEntry.Reset();
            TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::Deduction);
            TempDetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2|%3|%4|%5',
                TempDetailedEmpLedgerEntry."Attribute Sub Type"::CIT,
                TempDetailedEmpLedgerEntry."Attribute Sub Type"::RF,
                TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Lump Sum Contribution",
                TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employee Contribution",
                TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employer Contribution");
            TempDetailedEmpLedgerEntry.CalcSums(Amount);
            TotalRetirement := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total RF Opening";

            // Calculate tax exemption components
            OneThird := TotalAnnualEarning / PgSetup."Tax Ex. Amt Divsion"; // 1/3 of gross income
            TaxExemptionLimit := PgSetup."Tax Ex. Amt. not Exceeding"; // Government tax exemption limit

            // Determine the minimum value deduction (whichever is lowest)
            MinValueDeduction := TotalRetirement;
            if OneThird < MinValueDeduction then
                MinValueDeduction := OneThird;
            if TaxExemptionLimit < MinValueDeduction then
                MinValueDeduction := TaxExemptionLimit;

            // Get insurance premium amounts
            LifeInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Life Insurance");
            if LifeInsuranceAmount > PgSetup."Tax Ex. Life Insurance Amt." then
                LifeInsuranceAmount := PgSetup."Tax Ex. Life Insurance Amt."; // Cap at maximum allowed

            MedicalInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Medical Insurance");
            HouseInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Property Insurance");

            // Get total donations
            TotalDonation := GetDonationAmount(EmployeeFilter);

            // Calculate Total Non-Payment amounts (loans, advances, etc.)
            TempDetailedEmpLedgerEntry.Reset();
            TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::"Non-Payment");
            TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
            TempDetailedEmpLedgerEntry.CalcSums(Amount);
            TotalNonPayment := TempDetailedEmpLedgerEntry.Amount;

            // Calculate Non-Taxable amounts (allowances, reimbursements)
            TempDetailedEmpLedgerEntry.Reset();
            TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", true);
            TempDetailedEmpLedgerEntry.CalcSums(Amount);
            NonTaxable := TempDetailedEmpLedgerEntry.Amount;

            // Calculate final taxable amount after all deductions
            TaxableAmount := TotalAnnualEarning + TotalNonPayment - Minvaluededuction -
                            LifeInsuranceAmount - MedicalInsuranceAmount - HouseInsuranceAmount - TotalDonation;

            RemainingTaxableAmount := TaxableAmount; // This will be used for slab calculations
            CalculateTaxSlabs(); // Now calculate tax based on slabs
        end;
    end;

    // Calculates income tax based on Nepal's progressive tax slabs
    local procedure CalculateTaxSlabs()
    var
        TaxSetupLine: Record "Tax Setup Line";
        j: Integer; // Counter for tax slabs
        TempTax: Decimal; // Temporary tax calculation
    begin
        // Reset all tax arrays
        Clear(TaxAmts);
        Clear(TaxAmtsSlabs);
        Clear(TaxRates);
        TotalTax := 0;

        j := 1; // Start with first tax slab
        TaxSetupLine.Reset;
        TaxSetupLine.SetRange(Code, EmpVar."Tax Code"); // Get tax rates for this employee
        if TaxSetupLine.FindSet then
            repeat
                // Calculate tax for each slab until taxable amount is exhausted
                if RemainingTaxableAmount > 0 then begin
                    if TaxSetupLine."Tax Rate" = 0 then
                        TempTax := 0 // No tax for this slab
                    else
                        TempTax := GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount") * TaxSetupLine."Tax Rate" / 100.0;

                    TotalTax += TempTax; // Add to total tax
                    TaxAmts[j] := TempTax; // Store tax amount for this slab
                    TaxAmtsSlabs[j] := GetTaxableAmountInSlab(TaxSetupLine."Start Amount", TaxSetupLine."End Amount"); // Store taxable amount for this slab
                    TaxRates[j] := TaxSetupLine."Tax Rate"; // Store tax rate for this slab
                    j += 1; // Move to next slab
                end;
            until (TaxSetupLine.Next = 0) or (j > ArrayLen(TaxAmts)); // Stop when no more slabs or array full

        // Calculate any special tax rebates (e.g., for women, disabled, etc.)
        TaxRebate := 0;
        if TaxSetupHdr.Get(EmpVar."Tax Code") then
            if TaxSetupHdr."Special Tax Exempt %" > 0 then
                TaxRebate := Round((TaxSetupHdr."Special Tax Exempt %" / 100) * TotalTax, 0.01, '=');
    end;

    // Calculates how much taxable amount falls into a specific tax slab
    local procedure GetTax(StartAmount: Decimal; endAmount: Decimal): Decimal
    var
        TaxableAmountInSlab: Decimal;
    begin
        // If the slab range is less than remaining amount, use entire slab
        if (endAmount - StartAmount) <= RemainingTaxableAmount then begin
            TaxableAmountInSlab := endAmount - StartAmount + 1;
            RemainingTaxableAmount -= TaxableAmountInSlab; // Reduce remaining amount
            exit(TaxableAmountInSlab);
        end else begin
            // If remaining amount is less than slab range, use remaining amount
            TaxableAmountInSlab := RemainingTaxableAmount;
            RemainingTaxableAmount := 0; // No more taxable amount left
            exit(TaxableAmountInSlab);
        end;
    end;

    // Helper function to get taxable amount in a slab
    local procedure GetTaxableAmountInSlab(StartAmount: Decimal; endAmount: Decimal): Decimal
    begin
        // Return either the full slab amount or remaining amount, whichever is smaller
        if RemainingTaxableAmount > (endAmount - StartAmount + 1) then
            exit(endAmount - StartAmount + 1)
        else
            exit(RemainingTaxableAmount);
    end;

    // Counts how many times a payroll attribute has been paid
    local procedure getPaidFrequency(attrCode: Code[20]): Integer
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", attrCode);
        exit(TempDetailedEmpLedgerEntry.Count);
    end;

    // Determines how many pay periods remain in the fiscal year
    local procedure GetLastPayCycle(empCode: Code[20]): Integer
    var
        PGSetup: Record "Payroll General Setup";
        EmpRec: Record Employee;
        PayrollRepMgt: Codeunit "Payroll Report Mgt.";
        RemainingMonth: Integer;
    begin
        RemainingMonth := 12; // Default to 12 months
        if not EmpRec.Get(empCode) then
            exit(RemainingMonth);

        PGSetup.Get();

        // Adjust for terminated employees
        if EmpRec.Status = EmpRec.Status::Terminated then
            if EmpRec."Termination Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Termination Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Termination Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForTermination(EmpRec, 'MONTHLY', PayCycleTerm);

        // Adjust for contract employees
        if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then
            if EmpRec."Contract Expiry Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Contract Expiry Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Contract Expiry Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForContractExp(EmpRec, 'MONTHLY', PayCycleTerm);

        exit(RemainingMonth);
    end;

    // Procedure to set parameters when called from portal
    procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[20])
    begin
        EmployeeFilter := empCode;
        PayCycleTerm := FiscalYear;
    end;

    // Gets insurance premium amount for a specific insurance type
    local procedure GetInsuranceAmount(EmployeeNo: Code[20]; InsuranceType: Enum "Employee Insurance Type"): Decimal
    begin
        EmployeeInsuranceInfo.Reset();
        EmployeeInsuranceInfo.SetRange("Employee No.", EmployeeNo);
        EmployeeInsuranceInfo.SetRange(Type, EmployeeInsuranceInfo.Type::Insurance);
        EmployeeInsuranceInfo.SetRange("Approval Status", EmployeeInsuranceInfo."Approval Status"::Approved);
        EmployeeInsuranceInfo.SetRange(Expired, false);
        EmployeeInsuranceInfo.SetRange("Insurance Type", InsuranceType);
        if EmployeeInsuranceInfo.FindSet() then begin
            EmployeeInsuranceInfo.CalcSums("Annual Premium Amount");
            exit(EmployeeInsuranceInfo."Annual Premium Amount");
        end;
        exit(0); // Return 0 if no insurance found
    end;

    // Gets total donation amount for the year
    local procedure GetDonationAmount(EmployeeNo: Code[20]): Decimal
    var
        Emp: Record Employee;
    begin
        if not Emp.Get(EmployeeNo) then
            exit(0);

        Emp.SetRange("Date Filter", PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        Emp.CalcFields("Total Donation Contribution");
        exit(Emp."Total Donation Contribution");
    end;

    // Gets opening balances from previous year
    local procedure GetEmployeePayrollOpeningValues(EmployeeNo: Code[20])
    begin
        EmployeePayrollOpen.Reset();
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeNo);
        EmployeePayrollOpen.SetRange("Fiscal Year", PayCycleTerm);
        if EmployeePayrollOpen.FindLast() then begin
            PastBenefit := EmployeePayrollOpen."Total Benefit Opening";
            PastRetirementFund := EmployeePayrollOpen."Total RF Opening";
            PastSSTPaid := EmployeePayrollOpen."Total Social Security Opening";
            PastTaxPaid := EmployeePayrollOpen."Total Tax Remuneration Opening";
        end else begin
            // Set to zero if no opening balances found
            PastBenefit := 0;
            PastRetirementFund := 0;
            PastSSTPaid := 0;
            PastTaxPaid := 0;
        end;
    end;

    // Calculates total tax paid so far this year
    local procedure CalculateTotalTaxPaid(EmployeeNo: Code[20])
    begin
        // Start with opening balances from previous year
        TotalTaxPaid := PastSSTPaid + PastTaxPaid;

        // Add tax payments made this year
        DetailedEmpLedgerEntry.Reset();
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeNo);
        DetailedEmpLedgerEntry.setrange("Fiscal Year", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Document Type", DetailedEmpLedgerEntry."Document Type"::Invoice);
        DetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2',
            DetailedEmpLedgerEntry."Attribute Sub Type"::"Social Security Tax",
            DetailedEmpLedgerEntry."Attribute Sub Type"::"Tax on Remuneration & Benefits");
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindSet() then
            repeat
                TotalTaxPaid += Abs(DetailedEmpLedgerEntry.Amount); // Add tax payments
            until DetailedEmpLedgerEntry.Next() = 0;
    end;

    // Checks if a payroll attribute should be projected for future months
    local procedure CheckIfProjectable(AttrCode: Code[20]): Boolean
    var
        PayrollAtr: Record "Payroll Attributes";
    begin
        if not PayrollAtr.Get(AttrCode) then
            exit(false);

        // Irregular non-payments should be projected
        if PayrollAtr.Irregular then
            if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
                exit(true)
            else
                exit(false);

        // Non-taxable items should not be projected
        if PayrollAtr."Non-Taxable" then
            exit(false);

        // Non-payments should be projected
        if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
            exit(true);

        // Items that apply every month should be projected
        if PayrollAtr."Apply Every Month" then
            exit(true);

        // Check pay frequency - project if not yet paid enough times
        if PayrollAtr."Pay Frequency" <> 0 then
            if getPaidFrequency(PayrollAtr.Code) < PayrollAtr."Pay Frequency" then
                exit(true);

        // Tax deductions should be projected
        if (PayrollAtr.Type = PayrollAtr.Type::Deduction) then begin
            if PayrollAtr.Subtype in [PayrollAtr.Subtype::"Social Security Tax", PayrollAtr.Subtype::"Tax on Remuneration & Benefits"] then
                exit(true);
            exit(false);
        end;

        exit(false); // Default to not project
    end;

    // Checks if a date falls within a specified range
    local procedure IsDateInRange(CheckDate: Date; StartDate: Date; EndDate: Date): Boolean
    begin
        // If both dates are blank, always include
        if (StartDate = 0D) and (EndDate = 0D) then
            exit(true);

        // If only start date is specified, check if after start
        if (StartDate <> 0D) and (EndDate = 0D) then
            exit(CheckDate >= StartDate);

        // If only end date is specified, check if before end
        if (StartDate = 0D) and (EndDate <> 0D) then
            exit(CheckDate <= EndDate);

        // If both dates are specified, check if within range
        if (StartDate <> 0D) and (EndDate <> 0D) then
            exit((CheckDate >= StartDate) and (CheckDate <= EndDate));

        exit(false); // Default to not in range
    end;

    // Calculates pro-rata amount for partial month coverage
    local procedure CalculateProRataAmount(BaseAmount: Decimal; PayCyclePeriod: Integer; StartDate: Date; EndDate: Date): Decimal
    var
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        TotalDaysInPeriod: Integer;
        EffectiveDays: Integer;
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
    begin
        // Get the start and end date of the pay cycle period (assuming monthly)
        PeriodStartDate := DMY2Date(1, PayCyclePeriod, Date2DMY(WorkDate(), 3));
        PeriodEndDate := CalcDate('<+1M-1D>', PeriodStartDate);
        TotalDaysInPeriod := PeriodEndDate - PeriodStartDate + 1;

        // Determine effective start date (later of period start or specified start)
        if (StartDate = 0D) or (PeriodStartDate > StartDate) then
            EffectiveStartDate := PeriodStartDate
        else
            EffectiveStartDate := StartDate;

        // Determine effective end date (earlier of period end or specified end)
        if EndDate = 0D then
            EffectiveEndDate := PeriodEndDate
        else
            if PeriodEndDate < EndDate then
                EffectiveEndDate := PeriodEndDate
            else
                EffectiveEndDate := EndDate;

        // Calculate effective days
        if EffectiveStartDate > EffectiveEndDate then
            exit(0); // No overlap

        EffectiveDays := EffectiveEndDate - EffectiveStartDate + 1;

        // Return pro-rata amount based on days
        if TotalDaysInPeriod > 0 then
            exit(Round(BaseAmount * EffectiveDays / TotalDaysInPeriod, 0.01))
        else
            exit(0);
    end;

    // Creates temporary ledger entries for future month projections
    local procedure CreateTempDetailedLedgerFromPAttrUsage(StartPeriod: Integer; var TempEntryNo: Integer)
    var
        i: Integer;
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        PayAttr: Record "Payroll Attributes";
        InsertData: Boolean;
        CurrentPeriodDate: Date;
        CalculatedAmount: Decimal;
    begin
        PgSetup.Get();
        if not EmpVar.Get(EmployeeFilter) then
            exit;

        // Loop through all remaining months in fiscal year
        for i := StartPeriod to GetLastPayCycle(EmployeeFilter) do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmployeeFilter);
            if PayrollAttrUsage.FindSet() then
                repeat
                    // Check if this attribute should be projected
                    InsertData := CheckIfProjectable(PayrollAttrUsage.Code);

                    if InsertData then begin
                        CurrentPeriodDate := DMY2Date(1, i, Date2DMY(WorkDate(), 3));
                        // Check if within date range
                        if not IsDateInRange(CurrentPeriodDate, PayrollAttrUsage."Start Date", PayrollAttrUsage."End Date") then
                            InsertData := false;
                    end;

                    if InsertData and PayAttr.Get(PayrollAttrUsage.Code) then begin
                        // Check pay cycle period restriction
                        if (PayAttr."Pay Cycle Period" <> 0) and (PayAttr."Pay Cycle Period" <> i) then
                            InsertData := false;

                        // Check pay frequency restriction
                        if (PayAttr."Pay Frequency" <> 0) and (getPaidFrequency(PayAttr.Code) >= PayAttr."Pay Frequency") then
                            InsertData := false;
                    end;

                    // Insert projected entry if all checks pass
                    if InsertData then begin
                        TempDetailedEmpLedgerEntry.Init();
                        TempDetailedEmpLedgerEntry."Entry No." := TempEntryNo;
                        TempDetailedEmpLedgerEntry."Employee No." := EmployeeFilter;
                        TempDetailedEmpLedgerEntry.Validate("Payroll Attribute Code", PayrollAttrUsage.Code);

                        // Set attribute type based on category
                        if PayAttr.Type = PayAttr.Type::Benefits then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings";
                        if PayAttr.Type = PayAttr.Type::Deduction then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::Deduction;

                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;

                        // Calculate amount - use formula if available, otherwise use fixed amount
                        if PayrollAttrUsage."Formula Exists" then begin
                            PayrollReportMgt.SetEmployeeCode(EmployeeFilter);
                            CalculatedAmount := PayrollReportMgt.getAttributeAmount(EmployeeFilter, PayrollAttrUsage.Code);
                        end else
                            CalculatedAmount := PayrollAttrUsage.Amount;

                        // Apply pro-rata calculation for partial month coverage
                        if (PayrollAttrUsage."Start Date" <> 0D) or (PayrollAttrUsage."End Date" <> 0D) then
                            TempDetailedEmpLedgerEntry.Amount := CalculateProRataAmount(CalculatedAmount, i, PayrollAttrUsage."Start Date", PayrollAttrUsage."End Date")
                        else
                            TempDetailedEmpLedgerEntry.Amount := CalculatedAmount;

                        TempDetailedEmpLedgerEntry.Insert();
                        TempEntryNo += 1; // Increment entry number
                    end;
                until PayrollAttrUsage.Next() = 0;
        end;
    end;

    // Resets all calculation variables to zero
    local procedure ClearVariables()
    begin
        Clear(PayrollAmts);
        Clear(TaxAmts);
        Clear(TaxAmtsSlabs);
        Clear(TaxRates);
        TotalTax := 0;
        TaxRebate := 0;
        RemainingTaxableAmount := 0;
    end;

    // Gets the start date of the first period in a pay cycle term
    local procedure GetFirstPayCyclePeriod(PayCycleTermCode: Code[10]): Date
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTermCode);
        if PayCyclePeriod.FindFirst() then
            exit(PayCyclePeriod."Start Date");
        exit(0D); // Return blank date if not found
    end;
}