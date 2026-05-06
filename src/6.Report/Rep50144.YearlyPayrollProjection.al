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
        dataitem(PayrollAttributes; "Payroll Attributes")
        {
            DataItemTableView = sorting(Code);
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(PANNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyAddress; companyInfo.Address) { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(Code; Code) { }
            column(Description; PayrollAttributes.Description) { }
            column(Type; Type) { }
            column(ReportName; ReportName) { }
            column(SortinNo; SortingNo) { }
            column(FiscalYear; PayCycleTerm) { }
            column(EmpFullName; EmpVar."Full Name") { }
            column(PANNo_Employee; EmpVar."PAN No.") { }
            column(BankName; EmpVar."Bank Name") { }
            column(BankAccountNo; EmpVar."Bank Account No.") { }
            column(EmployeeSalaryLevel; EmpVar."Salary Level") { }
            column(EmpDesignation; EmpVar."Salary Level Description") { }
            column(SSFNo; EmpVar."Social Security No.") { }
            column(EmployeeNo; EmpVar."No.") { }
            column(TaxCode; EmpVar."Tax Code") { }
            column(Office; Empvar."Branch Name") { }
            column(Grade; Empvar."Salary Grade") { }
            column(RetirementAmount; Round(TotalRetirement, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TaxableIncome; Round(TaxableAmount, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(ThisMonthTDS; Round(PayrollAmts[5], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(RemainingTDS; Round(PayrollAmts[6], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TotalTaxPaid; Round(TotalTaxPaid, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TDSCalcMonth; TDSCalcMonth)
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TotalTax; Round(TotalTax, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(InsurranceAmount; Round(LifeInsuranceAmount, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(MedicalInsuranceAmount; Round(MedicalInsuranceAmount, GlSetup."Amount Rounding Precision")) { }
            column(HouseInsuranceAmount; Round(HouseInsuranceAmount, GlSetup."Amount Rounding Precision")) { }
            column(Minvaluededuction; Round(Minvaluededuction, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TotalDonation; Round(TotalDonation, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(DisabilityDiscount; Round(DisabilityDiscount, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(RemoteAreaDeductionAmount; Round(RemoteAreaDeductionAmount, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            // Tax Slab Rates (1-6)
            column(FirstSlabRate; Round(TaxAmts[1], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(SecondSlabRate; Round(TaxAmts[2], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(ThirdSlabRate; Round(TaxAmts[3], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(FourthSlabeRate; Round(TaxAmts[4], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(FifthSlabRate; Round(TaxAmts[5], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(SixthSlabRate; Round(TaxAmts[6], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            // Tax Slab Amounts (1-6)
            column(FirstSlab; Round(TaxAmtsSlabs[1], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(SecondSlab; Round(TaxAmtsSlabs[2], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(ThirdSlab; Round(TaxAmtsSlabs[3], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(FourthSlab; Round(TaxAmtsSlabs[4], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(FifthSlab; Round(TaxAmtsSlabs[5], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(SixthSlab; Round(TaxAmtsSlabs[6], GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            // Tax Rates (1-6)
            column(TaxRate1_; Round(TaxRates[1], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate2_; Round(TaxRates[2], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate3_; Round(TaxRates[3], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate4_; Round(TaxRates[4], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate5_; Round(TaxRates[5], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate6_; Round(TaxRates[6], GlSetup."Amount Rounding Precision")) { }
            column(TaxRebate; Round(TaxRebate, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(NonTaxable; Round(NonTaxable, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TotalNonPayment; Round(TotalNonPayment, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TaxExemptionLimit; Round(TaxExemptionLimit, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(OneThird; Round(OneThird, GlSetup."Amount Rounding Precision")) { }
            column(TotalAnualEarning; Round(TotalAnnualEarning + TotalNonPayment, GlSetup."Amount Rounding Precision")) { }
            column(PastBenefit; Round(PastBenefit, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(PastRetirementFund; Round(PastRetirementFund, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(PastSSTPaid; Round(PastSSTPaid, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(PastTaxPaid; Round(PastTaxPaid, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            dataitem("Pay Cycle Period"; "Pay Cycle Period")
            {
                DataItemTableView = sorting("Pay Cycle Code", "Pay Cycle Term", Period);
                column(PayCycleTerm_PayCyclePeriod; "Pay Cycle Period"."Pay Cycle Term") { }
                column(Period; "Pay Cycle Period".Period) { }
                column(NepaliMonth_PayCyclePeriod; "Pay Cycle Period"."Nepali Month") { }
                column(Amount; Round(Amount, GlSetup."Amount Rounding Precision")) { }
                column(BenefitAmount; BenefitAmount)
                {
                    AutoFormatExpression = 'NPR';
                    AutoFormatType = 1;
                }
                column(DeductionAmount; DeductionAmount)
                {
                    AutoFormatExpression = 'NPR';
                    AutoFormatType = 1;
                }
                trigger OnPreDataItem()
                var
                    Employee: Record Employee;
                    PayCyclePeriod1, PayCyclePeriod2 : Record "Pay Cycle Period";
                    StartDate: Date;
                begin
                    SetRange("Pay Cycle Term", PayCycleTerm);
                    // Get the first pay cycle period for the term
                    PayCyclePeriod1.SetRange("Pay Cycle Term", PayCycleTerm);
                    if PayCyclePeriod1.FindFirst() then;
                    // Adjust start date based on employee employment date
                    if Employee.Get(EmployeeFilter) then
                        if PayCyclePeriod1."Start Date" < Employee."Employment Date" then begin
                            PayCyclePeriod2.SetFilter("Start Date", '<%1', Employee."Employment Date");
                            if PayCyclePeriod2.FindLast() then begin
                                StartDate := PayCyclePeriod2."Start Date";
                                SetFilter("Start Date", '>%1', StartDate);
                            end;
                        end;
                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(Amount);
                    // Calculate total amount for this payroll attribute in this period
                    TempDetailedEmpLedgerEntry.Reset();
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Period", Period);
                    TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", PayrollAttributes.Code);
                    if TempDetailedEmpLedgerEntry.FindSet(false) then
                        repeat
                            // Handle deductions (make positive for display)
                            if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                                Amount := Amount + Abs(TempDetailedEmpLedgerEntry.Amount)
                            else
                                Amount := Amount + TempDetailedEmpLedgerEntry.Amount;
                        until TempDetailedEmpLedgerEntry.Next() = 0;
                    if Amount = 0 then
                        CurrReport.Skip();
                    if "Pay Cycle Period".Period = 0 then
                        CurrReport.Skip();
                    // Special handling for tax attributes - ensure non-negative
                    if (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Social Security Tax") or
                       (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Tax on Remuneration & Benefits") then
                        if Amount < 0 then
                            Amount := 0;
                    // Categorize amounts as benefits or deductions
                    BenefitAmount := 0;
                    DeductionAmount := 0;
                    if PayrollAttributes.Type = PayrollAttributes.Type::Benefits then
                        BenefitAmount := Amount
                    else
                        if PayrollAttributes.Type = PayrollAttributes.Type::Deduction then
                            DeductionAmount := Amount;
                end;
            }
            trigger OnPreDataItem()
            begin
                ValidateParameters();
                InitializeEmployeeData();
                InsertColumn();
            end;

            trigger OnAfterGetRecord()
            begin
                // Initialize sorting number
                SortingNo := GetAttributeSortingNumber(PayrollAttributes.Code);
                if SortingNo = 0 then
                    CurrReport.Skip();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Parameters)
                {
                    Caption = 'Parameters';
                    field("Pay Cycle Term"; PayCycleTerm)
                    {
                        ApplicationArea = All;
                        TableRelation = "Pay Cycle Term".Term;
                        ToolTip = 'Specifies the pay cycle term for the projection.';
                        trigger OnValidate()
                        begin
                            ValidatePayCycleTerm();
                        end;
                    }
                    field("Employee No"; EmployeeFilter)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee."No.";
                        ToolTip = 'Specifies the employee for the projection.';
                        trigger OnValidate()
                        begin
                            ValidateEmployee();
                        end;
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        // Initialize with current pay cycle term if running in GUI mode
        if GuiAllowed then begin
            PayCyclePeriod.Reset();
            PayCyclePeriod.SetFilter("End Date", '>=%1', Today);
            PayCyclePeriod.SetFilter("Start Date", '<=%1', Today);
            if PayCyclePeriod.FindFirst() then
                PayCycleTerm := PayCyclePeriod."Pay Cycle Term";
        end;
    end;

    trigger OnPreReport()
    begin
        InitializeSetupRecords();
        ValidateParameters();
        InitializeTempTables();
    end;

    trigger OnPostReport()
    begin
        // Clean up temporary data
        CleanupTempTables();
    end;

    protected var
        PayCycleTerm: Code[10];
        EmployeeFilter: Code[20];
        OptimumDeduction: Boolean;

    var
        PgSetup: Record "Payroll General Setup";
        GlSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry" temporary;
        EmpVar: Record Employee;
        EmployeePayrollOpen: Record "Employee Payroll Opening";
        PayrollColumnConfig: Record "Payroll Column Configuration";
        EmployeeInsuranceInfo: Record "Employee Insurance Information";
        Amount: Decimal;
        BenefitAmount: Decimal;
        DeductionAmount: Decimal;
        TotalAnnualEarning: Decimal;
        TotalRetirement: Decimal;
        TotalTax: Decimal;
        TotalTaxPaid: Decimal;
        TaxableAmount: Decimal;
        RemainingTaxableAmount: Decimal;
        MonthlyProjectedTax: Decimal;
        MonthlySST: Decimal;
        PayrollAmts: array[10] of Decimal;
        TaxAmts: array[10] of Decimal;
        TaxAmtsSlabs: array[10] of Decimal;
        TaxRates: array[10] of Decimal;
        TaxRebate: Decimal;
        Minvaluededuction: Decimal;
        LifeInsuranceAmount: Decimal;
        MedicalInsuranceAmount: Decimal;
        HouseInsuranceAmount: Decimal;
        TotalNonPayment: Decimal;
        NonTaxable: Decimal;
        TaxExemptionLimit: Decimal;
        OneThird: Decimal;
        TotalDonation: Decimal;
        DisabilityDiscount: Decimal;
        RemoteAreaDeductionAmount: Decimal;
        PastBenefit: Decimal;
        PastRetirementFund: Decimal;
        PastSSTPaid: Decimal;
        PastTaxPaid: Decimal;
        ReportName: Text;
        SortingNo: Integer;
        TDSCalcMonth: Enum "Nepali Month";
        TEMP_ENTRY_NO_START: Integer;
        MONTHS_PER_YEAR: Integer;
        PayrollReportMgt: Codeunit "Payroll Report Mgt.";
        PayCycleTermMissingErr: Label 'Please specify a pay cycle term.';
        EmployeeNotFoundErr: Label 'Employee %1 not found.';
        FiscalYearMismatchErr: Label 'Yearly projection report is for current year only.';
        PayrollSetupLine: Record "Payroll Setup Lines";
    //External procedure to set parameters for portal integration
    procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[20])
    begin
        EmployeeFilter := empCode;
        PayCycleTerm := FiscalYear;
    end;
    // Initialize constants used throughout the report
    local procedure InitializeConstants()
    begin
        TEMP_ENTRY_NO_START := 90000000;
        MONTHS_PER_YEAR := 12;
    end;
    /// Initialize setup records with error handling
    local procedure InitializeSetupRecords()
    begin
        if not GlSetup.Get() then
            Error('General Ledger Setup not found.');
        if not CompanyInfo.Get() then
            Error('Company Information not found.');
        CompanyInfo.CalcFields(Picture);
        if not PgSetup.Get() then
            Error('Payroll General Setup not found.');
    end;
    // Validate all required parameters
    local procedure ValidateParameters()
    begin
        if PayCycleTerm = '' then
            Error(PayCycleTermMissingErr);
        if EmployeeFilter = '' then
            Error('Please specify an employee.');
        ValidatePayCycleTerm();
        ValidateEmployee();
    end;
    // Validate pay cycle term
    local procedure ValidatePayCycleTerm()
    var
        PayPeriod: Record "Pay Cycle Period";
    begin
        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Term", PayCycleTerm);
        if PayPeriod.FindFirst() then
            if PayPeriod."Start Date" < PgSetup."Payroll Fiscal Year Start Date" then
                Error(FiscalYearMismatchErr);
    end;
    // Validate employee exists and is active
    local procedure ValidateEmployee()
    begin
        if not EmpVar.Get(EmployeeFilter) then
            Error(EmployeeNotFoundErr, EmployeeFilter);
    end;

    local procedure InitializeTempTables()
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.DeleteAll();
    end;

    local procedure CleanupTempTables()
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.DeleteAll();
    end;
    // Initialize employee data and calculations
    local procedure InitializeEmployeeData()
    begin
        InitializeConstants();
        GetEmployeePayrollOpeningValues(EmployeeFilter);
        CalculateTotalTaxPaid(EmployeeFilter);
        ClearVariables();
    end;
    // Get sorting number for payroll attribute
    local procedure GetAttributeSortingNumber(AttributeCode: Code[20]): Integer
    begin
        EmployeePayrollOpen.Reset();
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeFilter);
        if EmployeePayrollOpen.FindLast() then;
        PayrollColumnConfig.Reset();
        PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
        PayrollColumnConfig.SetRange("Variable Field Code", AttributeCode);
        if PayrollColumnConfig.FindFirst() then
            exit(PayrollColumnConfig."Field No.");
        exit(0);
    end;
    // Main procedure that plan the tax and payroll projection calculations
    local procedure InsertColumn()
    var
        LastEntryNo: Integer;
        TempTax: Decimal;
        AnnualTax: Decimal;
        SocialSecurityTax: Decimal;
        TaxSetupHdr: Record "Tax Setup Header";
        RemainingMonth: Integer;
        j: Integer;
    begin
        // Get employee and tax setup information
        if not EmpVar.Get(EmployeeFilter) then
            Error(EmployeeNotFoundErr, EmployeeFilter);
        LastEntryNo := TEMP_ENTRY_NO_START;
        EmployeePayrollOpen.Reset();
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeFilter);
        if EmployeePayrollOpen.FindLast() then
            if TaxSetupHdr.Get(EmpVar."Tax Code") then;
        // Determine starting period and remaining months for projection
        RemainingMonth := CalculateRemainingMonths(LastEntryNo);
        CopyExistingLedgerEntriesToTemp();
        CalculateAnnualTotals();
        CalculateTaxSlabs(j, TempTax, AnnualTax, SocialSecurityTax);
        ProjectRemainingMonthsTax(RemainingMonth, LastEntryNo);
    end;
    // Calculate remaining months for projection
    local procedure CalculateRemainingMonths(var LastEntryNo: Integer): Integer
    var
        PostedPayrollHeader: Record "Posted Payroll Header";
        EmpRec: Record Employee;
        RemainingMonth: Integer;
        LastActualPeriod: Integer;
        FinalPeriod: Integer;
        StartProjectionFrom: Integer;
        HasActualEntries: Boolean;
    begin
        RemainingMonth := 0;
        LastActualPeriod := 0;
        FinalPeriod := 0;
        StartProjectionFrom := 0;
        HasActualEntries := false;
        // Get the final period when employee leaves
        FinalPeriod := GetLastPayCycle(EmployeeFilter);
        // Get employee record for additional checks
        if not EmpRec.Get(EmployeeFilter) then
            exit(0);
        // Also check posted payroll headers to find the latest processed period
        PostedPayrollHeader.Reset();
        PostedPayrollHeader.SetCurrentKey("Pay Cycle Period");
        PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTerm);
        //No to see if issue arises
        PostedPayrollHeader.SetRange(Reversed, false);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.type::Payroll);
        PostedPayrollHeader.SetAscending("Pay Cycle Period", true);
        if PostedPayrollHeader.FindLast() then begin
            LastActualPeriod := PostedPayrollHeader."Pay Cycle Period";
            HasActualEntries := true;
        end;
        // DECISION LOGIC: When to start projection
        if HasActualEntries then begin
            // We have actual entries - project only FUTURE periods
            if LastActualPeriod < FinalPeriod then begin
                StartProjectionFrom := LastActualPeriod + 1; // Start from NEXT period after last actual
                CreateTempDetailedLedgerFromPAttrUsage(StartProjectionFrom, LastEntryNo);
                RemainingMonth := FinalPeriod - LastActualPeriod;
            end
            else begin
                // Employee already left in last actual period - no projection needed
                RemainingMonth := 0;
            end;
        end
        else begin
            // No actual entries found - project full period if employee is active
            if FinalPeriod > 0 then begin
                CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
                RemainingMonth := FinalPeriod;
            end
            else begin
                // Regular employee with no end date - project full year
                CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
                RemainingMonth := MONTHS_PER_YEAR;
            end;
        end;
        exit(RemainingMonth);
    end;

    local procedure CopyExistingLedgerEntriesToTemp()
    begin
        Clear(DetailedEmpLedgerEntry);
        DetailedEmpLedgerEntry.Reset();
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeFilter);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindSet() then
            repeat
                TempDetailedEmpLedgerEntry.Init();
                TempDetailedEmpLedgerEntry := DetailedEmpLedgerEntry;
                // Ensure deductions are positive for calculation purposes
                if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                    TempDetailedEmpLedgerEntry.Amount := Abs(DetailedEmpLedgerEntry.Amount);
                if TempDetailedEmpLedgerEntry.Insert() then;
            until DetailedEmpLedgerEntry.Next() = 0;
    end;
    // Calculates all annual totals including earnings, retirement, insurance, donations, etc.
    local procedure CalculateAnnualTotals()
    var
        Employee: Record Employee;
    begin
        // Initialize calculation variables
        InitializeAnnualTotalsVariables();
        // Set up employee record with fiscal year filter
        SetupEmployeeForCalculation(Employee);
        // Calculate Total Annual Earning (Basic + Other Earnings, Non-taxable excluded)
        CalculateTotalAnnualEarning();
        CalculateNonPaymentAndNonTaxable();
        CalculateInsuranceAmounts();
        TotalDonation := GetDonationAmount(EmployeeFilter);
        CalculateTotalRetirement();
        CalculateTaxExemptions();
        GetDisabilityDiscount(EmployeeFilter, DisabilityDiscount);
        GetRemoteAreaDeduction("EmployeeFilter", RemoteAreaDeductionAmount);
        CalculateFinalTaxableAmount();
    end;

    local procedure InitializeAnnualTotalsVariables()
    begin
        TotalAnnualEarning := 0;
        TotalRetirement := 0;
        Minvaluededuction := 0;
        TotalNonPayment := 0;
        NonTaxable := 0;
        OneThird := 0;
        MedicalInsuranceAmount := 0;
        HouseInsuranceAmount := 0;
        LifeInsuranceAmount := 0;
        TotalDonation := 0;
    end;
    // Setup employee record for calculations with fiscal year filter
    local procedure SetupEmployeeForCalculation(var Employee: Record Employee)
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        Employee.Reset();
        Employee.SetRange("No.", EmployeeFilter);
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        if Employee.FindFirst() then begin
            Employee.CalcFields("Total Earning", "Total Retirement Contribution", "Total Donation Contribution",
                    "Total Medical Re-Imbursement", "Social Security Tax", "Remuneration & Benefits Tax", "PF Contribution");
        end;
    end;
    // Calculate total annual earning excluding non-taxable items
    local procedure CalculateTotalAnnualEarning()
    var
        AnnualEarning: Decimal;
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2',
            TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning",
            TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        AnnualEarning := 0;
        EmployeePayrollOpen.Reset();
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeFilter);
        EmployeePayrollOpen.SetRange("Fiscal Year", PayCycleTerm);
        if EmployeePayrollOpen.FindFirst() then
            AnnualEarning := EmployeePayrollOpen."Total Benefit Opening";
        TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + AnnualEarning;
    end;
    // Calculate total retirement contributions
    local procedure CalculateTotalRetirement()
    var
        EmpPayrollOpening: Record "Employee Payroll Opening";
        PastRetirementAmount: Decimal;
        RetirementAmount, GratuityAmount : Decimal;
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::Deduction);
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2|%3|%4|%5',
            TempDetailedEmpLedgerEntry."Attribute Sub Type"::CIT,
            TempDetailedEmpLedgerEntry."Attribute Sub Type"::RF,
            TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Lump Sum Contribution",
            TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employee Contribution",
            TempDetailedEmpLedgerEntry."Attribute Sub Type"::"Employer Contribution");
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        RetirementAmount := TempDetailedEmpLedgerEntry.Amount;
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::"Non-Payment");
        TempDetailedEmpLedgerEntry.SetRange("Attribute Sub Type", TempDetailedEmpLedgerEntry."Attribute Sub Type"::Gratuity);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        GratuityAmount := TempDetailedEmpLedgerEntry.Amount;
        PastRetirementAmount := 0;
        EmpPayrollOpening.Reset();
        EmpPayrollOpening.SetRange("Employee No.", EmployeeFilter);
        EmpPayrollOpening.SetRange("Fiscal Year", PayCycleTerm);
        if EmpPayrollOpening.FindFirst() then
            PastRetirementAmount := EmpPayrollOpening."Total RF Opening";
        EmpVar.CalcFields("Lump Sum CIT");
        TotalRetirement := RetirementAmount + PastRetirementAmount + GratuityAmount + EmpVar."Lump Sum CIT";
        OnAfterTotalRetirementFund(EmpVar, TotalRetirement);
    end;
    // Calculate final taxable amount after all deductions
    local procedure CalculateFinalTaxableAmount()
    begin
        TaxableAmount := TotalAnnualEarning + TotalNonPayment - Minvaluededuction -
                        LifeInsuranceAmount - MedicalInsuranceAmount - HouseInsuranceAmount - TotalDonation - DisabilityDiscount - RemoteAreaDeductionAmount;
        RemainingTaxableAmount := TaxableAmount;
    end;
    // Calculates tax exemption limits and minimum deduction values
    local procedure CalculateTaxExemptions()
    var
        Math: Codeunit Math;
    begin
        // Calculate one third of gross income
        if PgSetup."Tax Ex. Amt Divsion" <> 0 then
            OneThird := (TotalAnnualEarning + TotalNonPayment) / PgSetup."Tax Ex. Amt Divsion";
        // Get Tax Exemption Limit from Payroll Setup Line filtered by Pay Cycle Term
        TaxExemptionLimit := GetTaxExemptionLimitFromSetupLine();
        // Calculate minimum value among total retirement contribution, one third of gross income, and tax exemption limit
        if OptimumDeduction then begin
            MinValueDeduction := Math.Min(OneThird, TaxExemptionLimit);
        end else begin
            MinValueDeduction := TotalRetirement;
            if OneThird < MinValueDeduction then
                MinValueDeduction := OneThird;
            if TaxExemptionLimit < MinValueDeduction then
                MinValueDeduction := TaxExemptionLimit;
        end;
    end;

    local procedure GetTaxExemptionLimitFromSetupLine(): Decimal
    begin
        PayrollSetupLine.Reset();
        if PayrollSetupLine.Get(PayCycleTerm) then
            // PayrollSetupLine.SetRange("Pay Cycle Term", PayCycleTerm);
            // if PayrollSetupLine.FindFirst() then
            exit(PayrollSetupLine."Tax Ex. Amt. not Exceeding");
    end;
    // Calculates all insurance amounts (Life, Medical, Property/House)
    local procedure CalculateInsuranceAmounts()
    var
        MaxLifeInsurance: Decimal;
        MaxMedicalInsurance: Decimal;
        MaxHouseInsurance: Decimal;
    begin
        // Get maximum insurance limits from Payroll Setup Lines
        GetInsuranceLimitFromSetupLine(MaxLifeInsurance, MaxMedicalInsurance, MaxHouseInsurance);
        // Calculate Life Insurance amount and apply limit
        LifeInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Life Insurance");
        if LifeInsuranceAmount > MaxLifeInsurance then
            LifeInsuranceAmount := MaxLifeInsurance;
        // Calculate Medical Insurance amount and apply limit
        MedicalInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Medical Insurance");
        if MedicalInsuranceAmount > MaxMedicalInsurance then
            MedicalInsuranceAmount := MaxMedicalInsurance;
        // Calculate House Insurance amount and apply limit
        HouseInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Property Insurance");
        if HouseInsuranceAmount > MaxHouseInsurance then
            HouseInsuranceAmount := MaxHouseInsurance;
    end;

    local procedure GetInsuranceLimitFromSetupLine(var LifeInsLimit: Decimal; var MedicalInsLimit: Decimal; var HouseInsLimit: Decimal)
    begin
        LifeInsLimit := PgSetup."Tax Ex. Life Insurance Amt.";
        MedicalInsLimit := 0;
        HouseInsLimit := 0;
        // Get values from Payroll Setup Lines if record exists for this Pay Cycle Term
        PayrollSetupLine.Reset();
        if PayrollSetupLine.Get(PayCycleTerm) then begin
            LifeInsLimit := PayrollSetupLine."Tax Ex. Insurance Amt.";
            MedicalInsLimit := PayrollSetupLine."Tax Ex. Medical Insurance Amt.";
            HouseInsLimit := PayrollSetupLine."Tax Ex. House Insurance Amt.";
        end;
    end;
    // Calculates non-payment and non-taxable amounts
    local procedure CalculateNonPaymentAndNonTaxable()
    begin
        // Calculate Total Non-Payment (exclude non-taxable non-payments)
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::"Non-Payment");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalNonPayment := TempDetailedEmpLedgerEntry.Amount;
        // Calculate Non-Taxable Amounts (all non-taxable items regardless of type)
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", true);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        NonTaxable := TempDetailedEmpLedgerEntry.Amount;
    end;
    // Calculates tax amounts for each slab based on tax setup
    local procedure CalculateTaxSlabs(var j: Integer; var TempTax: Decimal; var AnnualTax: Decimal; var SocialSecurityTax: Decimal)
    var
        TaxSetupLine: Record "Tax Setup Line";
        SlabTaxableAmount: Decimal;
        PreviousSlabEndAmount: Decimal;
    begin
        TempTax := 0;
        AnnualTax := 0;
        SocialSecurityTax := 0;
        j := 1;
        PreviousSlabEndAmount := 0;
        // Process each tax slab in order
        TaxSetupLine.Reset();
        TaxSetupLine.SetRange(Code, EmpVar."Tax Code");
        TaxSetupLine.SetRange("Pay Cycle Term", PayCycleTerm);
        TaxSetupLine.SetCurrentKey("Line No.");
        TaxSetupLine.SetAscending("Line No.", true);
        if TaxSetupLine.FindSet() then
            repeat
                Clear(SlabTaxableAmount);
                // Calculate taxable amount for this slab based on the logic provided
                case j of
                    1: // First slab - Line No. 10,000
                        begin
                            if TaxableAmount <= TaxSetupLine."End Amount" then
                                SlabTaxableAmount := TaxableAmount
                            else
                                SlabTaxableAmount := TaxSetupLine."End Amount";
                        end;
                    2, 3, 4, 5:
                        begin
                            if TaxableAmount < (TaxSetupLine."Start Amount" - 1) then
                                SlabTaxableAmount := 0
                            else if TaxableAmount <= TaxSetupLine."End Amount" then
                                SlabTaxableAmount := TaxableAmount - PreviousSlabEndAmount
                            // Step 3: If taxable amount > end amount
                            else
                                SlabTaxableAmount := TaxSetupLine."End Amount" - PreviousSlabEndAmount;
                        end;
                    6:
                        begin
                            if TaxableAmount < (TaxSetupLine."Start Amount" - 1) then
                                SlabTaxableAmount := 0
                            else
                                SlabTaxableAmount := TaxableAmount - PreviousSlabEndAmount;
                        end;
                end;
                if SlabTaxableAmount < 0 then
                    SlabTaxableAmount := 0;
                if SlabTaxableAmount > 0 then
                    TempTax := SlabTaxableAmount * TaxSetupLine."Tax Rate" / 100.0
                else
                    TempTax := 0;
                AnnualTax += TempTax;
                if (SocialSecurityTax = 0) and (TaxSetupLine."Tax Rate" = 1) then
                    SocialSecurityTax := TempTax;
                TaxAmts[j] := TempTax;
                TaxAmtsSlabs[j] := SlabTaxableAmount;
                TaxRates[j] := TaxSetupLine."Tax Rate";
                PreviousSlabEndAmount := TaxSetupLine."End Amount";
                j += 1;
            until (TaxSetupLine.Next() = 0) or (j > 6);
        // Calculate total tax from all slabs
        TotalTax := TaxAmts[1] + TaxAmts[2] + TaxAmts[3] + TaxAmts[4] + TaxAmts[5] + TaxAmts[6];
        CalculateTaxRebate();
    end;
    // Calculates tax rebate based on special tax exemption percentage
    local procedure CalculateTaxRebate()
    var
        TaxSetupHdr: Record "Tax Setup Header";
    begin
        TaxRebate := 0;
        TaxSetupHdr.Reset();
        TaxSetupHdr.SetRange(Code, EmpVar."Tax Code");
        if TaxSetupHdr.FindFirst() then begin
            if TaxSetupHdr."Special Tax Exempt %" > 0 then
                TaxRebate := Round((TaxSetupHdr."Special Tax Exempt %" / 100) * TotalTax, 0.01, '=');
        end;
    end;
    // Projects tax deductions for remaining months in the fiscal year
    local procedure ProjectRemainingMonthsTax(RemainingMonth: Integer; var LastEntryNo: Integer)
    var
        i: Integer;
        PayrollAttrUsage: Record "Payroll Attributes Usage";
    begin
        MonthlyProjectedTax := MonthlyProjectedTax - MonthlySST;
        // Project tax for remaining months
        for i := MONTHS_PER_YEAR - RemainingMonth + 1 to GetLastPayCycle(EmployeeFilter) do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmployeeFilter);
            PayrollAttrUsage.SetFilter(Subtype, '%1|%2',
                PayrollAttributes.Subtype::"Social Security Tax",
                PayrollAttrUsage.Subtype::"Tax on Remuneration & Benefits");
            if PayrollAttrUsage.FindSet() then
                repeat
                    PayrollAttrUsage.CalcFields(Type, Subtype);
                    // Create projected tax entry
                    TempDetailedEmpLedgerEntry.Init();
                    TempDetailedEmpLedgerEntry."Entry No." := LastEntryNo;
                    TempDetailedEmpLedgerEntry."Employee No." := EmployeeFilter;
                    TempDetailedEmpLedgerEntry.Validate("Payroll Attribute Code", PayrollAttrUsage.Code);
                    TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                    TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                    TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;
                    // Set appropriate tax amount
                    if PayrollAttrUsage.Subtype = PayrollAttrUsage.Subtype::"Social Security Tax" then
                        TempDetailedEmpLedgerEntry.Amount := MonthlySST
                    else
                        TempDetailedEmpLedgerEntry.Amount := MonthlyProjectedTax;
                    if TempDetailedEmpLedgerEntry.Insert() then
                        LastEntryNo += 1;
                until PayrollAttrUsage.Next() = 0
        end;
    end;
    // Clears calculation variables for fresh processing
    local procedure ClearVariables()
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(PayrollAmts) do
            Clear(PayrollAmts[i]);
        for i := 1 to ArrayLen(TaxAmts) do
            Clear(TaxAmts[i]);
        Clear(RemainingTaxableAmount);
    end;
    // EMPLOYEE AND PAYROLL INFORMATION PROCEDURES
    // Gets the frequency count for a specific payroll attribute
    procedure GetPaidFrequency(AttrCode: Code[20]): Integer
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", AttrCode);
        exit(TempDetailedEmpLedgerEntry.Count);
    end;
    // Determines the last pay cycle for an employee based on termination or contract expiry
    procedure GetLastPayCycle(EmpCode: Code[20]): Integer
    var
        PGSetup: Record "Payroll General Setup";
        EmpRec: Record Employee;
        PayrollRepMgt: Codeunit "Payroll Report Mgt.";
        RemainingMonth: Integer;
        FinalPeriod: Integer;
        ContractPeriod: Integer;
    begin
        RemainingMonth := MONTHS_PER_YEAR;
        FinalPeriod := 0;
        ContractPeriod := 0;
        if not EmpRec.Get(EmpCode) then
            exit(RemainingMonth);
        if not PGSetup.Get() then
            exit(RemainingMonth);
        // SCENARIO 1: ALREADY TERMINATED EMPLOYEES
        if EmpRec.Status = EmpRec.Status::Terminated then begin
            if (EmpRec."Termination Date" <> 0D) then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Termination Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Termination Date") then
                    FinalPeriod := PayrollRepMgt.GetPayPeriod(EmpRec."Termination Date", PGSetup."Pay Cycle Code", PGSetup."Pay Cycle Term");
        end
        // SCENARIO 2: ALREADY RESIGNED/INACTIVE EMPLOYEES
        else if EmpRec.Status = EmpRec.Status::Inactive then begin
            if (EmpRec."Resignation Date" <> 0D) then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Resignation Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Resignation Date") then
                    FinalPeriod := PayrollRepMgt.GetPayPeriod(EmpRec."Resignation Date", PGSetup."Pay Cycle Code", PGSetup."Pay Cycle Term");
        end;
        // SCENARIO 3: ACTIVE EMPLOYEES WITH FUTURE RESIGNATION DATE (Notice Period)
        if EmpRec.Status = EmpRec.Status::Active then begin
            if (EmpRec."Resignation Date" <> 0D) then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Resignation Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Resignation Date") then
                    FinalPeriod := PayrollRepMgt.GetPayPeriod(EmpRec."Resignation Date", PGSetup."Pay Cycle Code", PGSetup."Pay Cycle Term");
        end;
        // SCENARIO 4: CONTRACT EMPLOYEES (Separate check that applies to all statuses)
        if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then begin
            if EmpRec."Contract Expiry Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Contract Expiry Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Contract Expiry Date") then begin
                    ContractPeriod := PayrollRepMgt.GetPayPeriod(EmpRec."Contract Expiry Date", PGSetup."Pay Cycle Code", PGSetup."Pay Cycle Term");
                    // Take the earliest end date between contract and termination/resignation
                    if (FinalPeriod = 0) then
                        FinalPeriod := ContractPeriod
                    else if (ContractPeriod < FinalPeriod) then
                        FinalPeriod := ContractPeriod;
                end;
        end;
        // Return the appropriate final period
        if FinalPeriod > 0 then
            exit(FinalPeriod)
        else
            exit(RemainingMonth);
    end;
    // Gets insurance amount for specific insurance type with validation
    local procedure GetInsuranceAmount(EmployeeNo: Code[20]; InsuranceType: Enum "Employee Insurance Type"): Decimal
    Var
        HomeLoanInsurance: Record "Employee Loan/Advance";
    begin
        if (OptimumDeduction) and (InsuranceType = InsuranceType::"Life Insurance") then
            exit(PgSetup."Tax Ex. Life Insurance Amt.");
        EmployeeInsuranceInfo.Reset();
        EmployeeInsuranceInfo.SetRange("Employee No.", EmployeeNo);
        EmployeeInsuranceInfo.SetRange(Type, EmployeeInsuranceInfo.Type::Insurance);
        EmployeeInsuranceInfo.SetRange("Approval Status", EmployeeInsuranceInfo."Approval Status"::Approved);
        EmployeeInsuranceInfo.SetRange(Expired, false);
        EmployeeInsuranceInfo.SetRange("Insurance Type", InsuranceType);
        if EmployeeInsuranceInfo.FindSet() then begin
            EmployeeInsuranceInfo.CalcSums("Annual Premium Amount");
            if InsuranceType = InsuranceType::"Life Insurance" then begin
                HomeLoanInsurance.Reset();
                HomeLoanInsurance.SetRange("Employee No.", EmployeeNo);
                HomeLoanInsurance.SetRange("Loan Type", HomeLoanInsurance."Loan Type"::"Home Loan Insurance Tieup");
                HomeLoanInsurance.SetRange("Approval Status", HomeLoanInsurance."Approval Status"::Approved);
                HomeLoanInsurance.SetRange(Settled, false);
                HomeLoanInsurance.CalcSums("Yearly Premium Amount");
                exit(EmployeeInsuranceInfo."Annual Premium Amount" + HomeLoanInsurance."Yearly Premium Amount");
            end;
            exit(EmployeeInsuranceInfo."Annual Premium Amount");
        end;
        exit(0);

    end;
    // Gets total donation amount for the employee within the fiscal year
    local procedure GetDonationAmount(EmployeeNo: Code[20]): Decimal
    var
        Emp: Record Employee;
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        if Emp.Get(EmployeeNo) then begin
            PayCyclePeriod.Reset();
            PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
            if PayCyclePeriod.FindFirst() and PayCyclePeriod.FindLast() then
                Emp.SetRange("Date Filter", PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
            Emp.CalcFields("Total Donation Contribution");
            exit(Emp."Total Donation Contribution");
        end;
        exit(0);
    end;
    // Retrieves employee payroll opening balances for the fiscal year
    local procedure GetEmployeePayrollOpeningValues(EmployeeNo: Code[20])
    begin
        // Initialize opening values
        PastBenefit := 0;
        PastRetirementFund := 0;
        PastSSTPaid := 0;
        PastTaxPaid := 0;
        EmployeePayrollOpen.Reset();
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeNo);
        EmployeePayrollOpen.SetRange("Fiscal Year", PayCycleTerm);
        if EmployeePayrollOpen.FindLast() then begin
            PastBenefit := EmployeePayrollOpen."Total Benefit Opening";
            PastRetirementFund := EmployeePayrollOpen."Total RF Opening";
            PastSSTPaid := EmployeePayrollOpen."Total Social Security Opening";
            PastTaxPaid := EmployeePayrollOpen."Total Tax Remuneration Opening";
        end;
    end;
    // Calculates total tax paid (SST + Tax on Remuneration) from past and current fiscal year
    local procedure CalculateTotalTaxPaid(EmployeeNo: Code[20])
    begin
        TotalTaxPaid := 0;
        TotalTaxPaid := PastSSTPaid + PastTaxPaid;
        // Add current fiscal year tax payments
        DetailedEmpLedgerEntry.Reset();
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeNo);
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Document Type", DetailedEmpLedgerEntry."Document Type"::Invoice);
        DetailedEmpLedgerEntry.SetFilter("Attribute Sub Type", '%1|%2',
            DetailedEmpLedgerEntry."Attribute Sub Type"::"Social Security Tax",
            DetailedEmpLedgerEntry."Attribute Sub Type"::"Tax on Remuneration & Benefits");
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindSet() then
            repeat
                TotalTaxPaid += Abs(DetailedEmpLedgerEntry.Amount);
            until DetailedEmpLedgerEntry.Next() = 0;
    end;
    // PROJECTION LOGIC PROCEDURES
    // Determines if a payroll attribute should be included in projection
    local procedure CheckIfProjectable(AttrCode: Code[20]): Boolean
    var
        PayrollAtr: Record "Payroll Attributes";
    begin
        if not PayrollAtr.Get(AttrCode) then
            exit(false);
        // Skip non-taxable attributes
        if PayrollAtr."Non-Taxable" then
            exit(false);
        // Include monthly recurring attributes
        if PayrollAtr."Apply Every Month" then
            exit(true);
        // Check pay frequency constraints
        if PayrollAtr."Pay Frequency" <> 0 then
            if GetPaidFrequency(PayrollAtr.Code) < PayrollAtr."Pay Frequency" then
                exit(true);
        // Include tax deductions
        if PayrollAtr.Type = PayrollAtr.Type::Deduction then begin
            if PayrollAtr.Subtype in [PayrollAtr.Subtype::"Social Security Tax",
                                     PayrollAtr.Subtype::"Tax on Remuneration & Benefits"] then
                exit(true);
            exit(false);
        end;
        exit(false);
    end;
    // Improved procedure to get pay cycle period date range
    local procedure GetPayCyclePeriodDates(Period: Integer; var StartDate: Date; var EndDate: Date): Boolean
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        PayCyclePeriod.Reset();
        PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
        PayCyclePeriod.SetRange(Period, Period);
        if PayCyclePeriod.FindFirst() then begin
            StartDate := PayCyclePeriod."Start Date";
            EndDate := PayCyclePeriod."End Date";
            exit(true);
        end;
        exit(false);
    end;
    // Improved procedure to check if projection should include this period
    local procedure ShouldIncludePeriod(PayPeriod: Integer; AttrStartDate: Date; AttrEndDate: Date): Boolean
    var
        PeriodStartDate: Date;
        PeriodEndDate: Date;
    begin
        // Get the actual dates for this pay period
        if not GetPayCyclePeriodDates(PayPeriod, PeriodStartDate, PeriodEndDate) then
            exit(false);
        // Case 1: Both dates are blank - include all periods
        if (AttrStartDate = 0D) and (AttrEndDate = 0D) then
            exit(true);
        // Case 2: Only start date specified - include from start date onwards
        if (AttrStartDate <> 0D) and (AttrEndDate = 0D) then
            exit(PeriodEndDate >= AttrStartDate);
        // Case 3: Only end date specified - include up to end date
        if (AttrStartDate = 0D) and (AttrEndDate <> 0D) then
            exit(PeriodStartDate <= AttrEndDate);
        // Case 4: Both dates specified - include if period overlaps with date range
        if (AttrStartDate <> 0D) and (AttrEndDate <> 0D) then
            exit((PeriodStartDate <= AttrEndDate) and (PeriodEndDate >= AttrStartDate));
        exit(false);
    end;
    // Improved pro-rata calculation using actual pay cycle period dates
    local procedure CalculateProRataAmount(BaseAmount: Decimal; PayPeriod: Integer; AttrStartDate: Date; AttrEndDate: Date): Decimal
    var
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
        TotalDaysInPeriod: Integer;
        EffectiveDays: Integer;
    begin
        if BaseAmount = 0 then
            exit(0);
        // Get actual period dates from pay cycle period table
        if not GetPayCyclePeriodDates(PayPeriod, PeriodStartDate, PeriodEndDate) then
            exit(0);
        TotalDaysInPeriod := PeriodEndDate - PeriodStartDate + 1;
        // Case 1: No date restrictions - full amount
        if (AttrStartDate = 0D) and (AttrEndDate = 0D) then
            exit(BaseAmount);
        // Determine effective start/end date
        EffectiveStartDate := PeriodStartDate;
        if (AttrStartDate <> 0D) and (AttrStartDate > PeriodStartDate) then
            EffectiveStartDate := AttrStartDate;
        EffectiveEndDate := PeriodEndDate;
        if (AttrEndDate <> 0D) and (AttrEndDate < PeriodEndDate) then
            EffectiveEndDate := AttrEndDate;
        // Calculate effective days
        if EffectiveStartDate > EffectiveEndDate then
            exit(0);
        EffectiveDays := EffectiveEndDate - EffectiveStartDate + 1;
        // Return pro-rata amount
        if TotalDaysInPeriod > 0 then
            exit(Round(BaseAmount * EffectiveDays / TotalDaysInPeriod, GlSetup."Amount Rounding Precision"))
        else
            exit(0);
    end;
    // Updated main projection procedure
    procedure CreateTempDetailedLedgerFromPAttrUsage(StartPeriod: Integer; var TempEntryNo: Integer)
    var
        i: Integer;
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        PayAttr: Record "Payroll Attributes";
        InsertData: Boolean;
        CalculatedAmount: Decimal;
        ProRataAmount: Decimal;
        LastValidPeriod: Integer;
        EmpRec: Record Employee;
        RetirementFundHdr: Record "Retirement Fund";
        RFContributionLines: Record "RF Contribution";
    begin
        if not PgSetup.Get() then
            exit;
        if not EmpVar.Get(EmployeeFilter) then
            exit;
        // Get employee record for validation
        if not EmpRec.Get(EmployeeFilter) then
            exit;
        // Determine the last valid period for projection
        LastValidPeriod := GetLastPayCycle(EmployeeFilter);
        // CRITICAL VALIDATION: Only project valid future periods
        if (StartPeriod > LastValidPeriod) or (StartPeriod < 1) then
            exit;
        // Ensure we don't project beyond the valid period
        if LastValidPeriod > MONTHS_PER_YEAR then
            LastValidPeriod := MONTHS_PER_YEAR;
        // Loop only through valid future periods up to the final period
        for i := StartPeriod to LastValidPeriod do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmployeeFilter);
            if PayrollAttrUsage.FindSet() then begin
                repeat
                    InsertData := false;
                    CalculatedAmount := 0;
                    ProRataAmount := 0;
                    PayrollAttrUsage.CalcFields(Type, Subtype, "Formula Exists");
                    // Check if this attribute should be projected for FUTURE periods
                    if CheckIfProjectable(PayrollAttrUsage.Code) then begin
                        // Check if this FUTURE period should be included based on date ranges
                        if ShouldIncludePeriod(i, PayrollAttrUsage."Start Date", PayrollAttrUsage."End Date") then
                            InsertData := true;
                    end;
                    // Additional attribute-specific checks
                    if InsertData and PayAttr.Get(PayrollAttrUsage.Code) then begin
                        // Check pay cycle period restriction
                        if PayAttr."Pay Cycle Period" <> 0 then
                            if PayAttr."Pay Cycle Period" <> i then
                                InsertData := false;
                        // Check pay frequency restriction
                        if (PayAttr."Pay Frequency" <> 0) and (GetPaidFrequency(PayAttr.Code) >= PayAttr."Pay Frequency") then
                            InsertData := false;
                    end;
                    // Create projection entry if all conditions are met
                    if InsertData then begin
                        TempDetailedEmpLedgerEntry.Init();
                        TempDetailedEmpLedgerEntry."Entry No." := TempEntryNo;
                        TempDetailedEmpLedgerEntry."Employee No." := EmployeeFilter;
                        TempDetailedEmpLedgerEntry.Validate("Payroll Attribute Code", PayrollAttrUsage.Code);
                        // Set appropriate attribute type
                        if PayAttr.Type = PayAttr.Type::Benefits then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings";
                        if PayAttr.Type = PayAttr.Type::Deduction then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::Deduction;
                        if PayAttr.Type = PayAttr.Type::"Non-Payment" then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Non-Payment";
                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;
                        // Calculate base amount with formula if exists
                        if PayrollAttrUsage."Formula Exists" then begin
                            PayrollReportMgt.SetEmployeeCode(EmployeeFilter);
                            CalculatedAmount := PayrollReportMgt.getAttributeAmount(EmployeeFilter, PayrollAttrUsage.Code);
                        end
                        else
                            CalculatedAmount := PayrollAttrUsage.Amount;

                        if PayrollAttrUsage."RF Contribution Type" = PayrollAttrUsage."RF Contribution Type"::Manual then begin
                            RetirementFundHdr.SetRange("Employee No.", PayrollAttrUsage."Employee Code");
                            RetirementFundHdr.SetRange("Attribute Code", PayrollAttrUsage.Code);
                            RetirementFundHdr.SetRange("Approval Status", RetirementFundHdr."Approval Status"::Approved);
                            if RetirementFundHdr.FindLast() then;

                            RFContributionLines.SetRange("Document No.", RetirementFundHdr."No.");
                            RFContributionLines.SetRange("Pay Cycle Period", i);
                            if RFContributionLines.FindFirst() then
                                CalculatedAmount := RFContributionLines.Amount;
                        end;
                        // Apply pro-rata calculation using actual pay cycle period dates
                        ProRataAmount := CalculateProRataAmount(CalculatedAmount, i,
                                                               PayrollAttrUsage."Start Date",
                                                               PayrollAttrUsage."End Date");
                        TempDetailedEmpLedgerEntry.Amount := ProRataAmount;
                        // Only insert if amount is greater than zero
                        if TempDetailedEmpLedgerEntry.Amount <> 0 then begin
                            if TempDetailedEmpLedgerEntry.Insert() then
                                TempEntryNo += 1;
                        end;
                    end;
                until PayrollAttrUsage.Next() = 0;
            end;
        end;
    end;

    local procedure GetDisabilityDiscount(EmployeeNo: Code[20]; var DisabilityDiscount: Decimal)
    var
        Employee: Record Employee;
        TaxSetupLine: Record "Tax Setup Line";
        TaxCode: Code[20];
    begin
        DisabilityDiscount := 0;
        // Check if employee exists and is disabled
        if Employee.Get(EmployeeNo) then begin
            if Employee.Disabled then begin
                TaxCode := Employee."Tax Code";
                // Find the tax setup for the employee's tax code
                TaxSetupLine.Reset();
                TaxSetupLine.SetRange(Code, TaxCode);
                TaxSetupLine.SetFilter("Tax Rate", '%1|%2', 0, 1);
                TaxSetupLine.SetAscending("Line No.", true);
                if TaxSetupLine.FindFirst() then begin
                    DisabilityDiscount := TaxSetupLine."End Amount" * 0.5;
                end;
            end;
        end;
    end;

    local procedure GetRemoteAreaDeduction(EmployeeNo: Code[20]; var RemoteAreaDeduction: Decimal)
    var
        Employee: Record Employee;
        OrganizationStructureList: Record "Organization Structure list";
        RemoteAreaCategory: Record "Remote Area Category";
        RemoteAreaReductionCode: Code[20];
    begin
        RemoteAreaDeduction := 0;
        if Employee.Get(EmployeeNo) then begin
            OrganizationStructureList.reset();
            if OrganizationStructureList.Get(Employee."Deputation on", Employee."Deputation On Code") then begin
                if RemoteAreaCategory.Get(OrganizationStructureList."Remote Area Reduction") then
                    RemoteAreaDeduction := RemoteAreaCategory."Remote Area Deduction";
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTotalRetirementFund(Employee: Record Employee; Var TotalRetirement: Decimal)
    begin
    end;
}