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
            // Company Information Columns
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(PANNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyAddress; companyInfo.Address) { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            // Payroll Attribute Information
            column(Code; Code) { }
            column(Description; PayrollAttributes.Description) { }
            column(Type; Type) { }
            column(ReportName; ReportName) { }
            column(SortinNo; SortingNo) { }
            column(FiscalYear; PayCycleTerm) { }
            // Employee Information
            column(EmpFullName; EmpVar."Full Name") { }
            column(PANNo_Employee; EmpVar."PAN No.") { }
            column(BankName; EmpVar."Bank Name") { }
            column(BankAccountNo; EmpVar."Bank Account No.") { }
            column(EmployeeSalaryLevel; EmpVar."Salary Level") { }
            column(EmpDesignation; EmpVar."Functional Title Desc") { }
            column(SSFNo; EmpVar."Social Security No.") { }
            column(EmployeeNo; EmpVar."No.") { }
            column(TaxCode; EmpVar."Tax Code") { }
            column(Office; Empvar."Branch Name") { }
            column(Grade; Empvar."Salary Grade") { }

            // Tax Calculation Results - Main Amounts
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
            // Insurance and Deduction Amounts
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
            // Additional Tax and Benefit Information
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
            column(TotalAnualEarning; Round(TotalAnnualEarning, GlSetup."Amount Rounding Precision")) { }
            // Past/Opening Balance Information
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
                // Pay Cycle Period Information
                column(PayCycleTerm_PayCyclePeriod; "Pay Cycle Period"."Pay Cycle Term") { }
                column(Period; "Pay Cycle Period".Period) { }
                column(NepaliMonth_PayCyclePeriod; "Pay Cycle Period"."Nepali Month") { }
                // Period Amounts
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
                    // Filter by pay cycle term
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
                    // Initialize amount
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
                    // Skip if no amount or invalid period
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
                // Validate required parameters before processing
                ValidateParameters();
                // Initialize payroll calculations for the selected employee
                InitializeEmployeeData();
                InsertColumn();

            end;

            trigger OnAfterGetRecord()
            var
                LocalDisabilityDiscount: Decimal;
                RemoteAreaDeduction: Decimal;
            begin
                // Get employee information
                if not EmpVar.Get(EmployeeFilter) then
                    Error('Employee %1 not found.', EmployeeFilter);
                // Call the procedure to get remote area deduction
                GetRemoteAreaDeduction("Employeefilter", RemoteAreaDeduction);
                RemoteAreaDeductionAmount := RemoteAreaDeduction;

                // Call the function with proper parameters
                GetDisabilityDiscount(EmployeeFilter, LocalDisabilityDiscount);
                DisabilityDiscount := LocalDisabilityDiscount; // Assign to the global variable

                // Initialize sorting number
                SortingNo := GetAttributeSortingNumber(PayrollAttributes.Code);

                // Skip if no sorting configuration found
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
    // REPORT TRIGGERS
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
        // Initialize setup records
        InitializeSetupRecords();
        // Validate parameters
        ValidateParameters();
        // Initialize temporary table
        InitializeTempTables();
    end;

    trigger OnPostReport()
    begin
        // Clean up temporary data
        CleanupTempTables();
    end;
    // VARIABLE DECLARATIONS
    var
        // Setup Records
        PgSetup: Record "Payroll General Setup";
        GlSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        // Working Records
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry" temporary;
        EmpVar: Record Employee;
        EmployeePayrollOpen: Record "Employee Payroll Opening";
        PayrollColumnConfig: Record "Payroll Column Configuration";
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        EmployeeInsuranceInfo: Record "Employee Insurance Information";
        // Parameters
        PayCycleTerm: Code[10];
        EmployeeFilter: Code[20];
        // Calculation Variables
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
        // Tax Calculation Arrays
        PayrollAmts: array[10] of Decimal;
        TaxAmts: array[10] of Decimal;
        TaxAmtsSlabs: array[10] of Decimal;
        TaxRates: array[10] of Decimal;
        // Deduction and Exemption Variables
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
        // Opening Balance Variables
        PastBenefit: Decimal;
        PastRetirementFund: Decimal;
        PastSSTPaid: Decimal;
        PastTaxPaid: Decimal;
        // Display Variables
        ReportName: Text;
        SortingNo: Integer;
        TDSCalcMonth: Enum "Nepali Month";
        // Constants
        TEMP_ENTRY_NO_START: Integer;
        MONTHS_PER_YEAR: Integer;
        // Codeunit
        PayrollReportMgt: Codeunit "Payroll Report Mgt.";
        // Error Messages
        PayCycleTermMissingErr: Label 'Please specify a pay cycle term.';
        EmployeeNotFoundErr: Label 'Employee %1 not found.';
        FiscalYearMismatchErr: Label 'Yearly projection report is for current year only.';
        InvalidParametersErr: Label 'Invalid parameters specified.';
    // PUBLIC PROCEDURES
    //External procedure to set parameters for portal integration
    procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[20])
    begin
        EmployeeFilter := empCode;
        PayCycleTerm := FiscalYear;
    end;
    // INITIALIZATION AND VALIDATION PROCEDURES
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
    // Initialize temporary tables
    local procedure InitializeTempTables()
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.DeleteAll();
    end;
    // Clean up temporary tables
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
    // MAIN CALCULATION PROCEDURES
    // Main procedure that plan the tax and payroll projection calculations
    // Creates temporary detailed ledger entries for all projected periods
    local procedure InsertColumn()
    var
        LastEntryNo: Integer;
        Employee: Record Employee;
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
        // Copy existing detailed ledger entries to temporary table
        CopyExistingLedgerEntriesToTemp();
        // Calculate all earning and deduction totals
        CalculateAnnualTotals();
        // Calculate tax slab amounts and rates
        CalculateTaxSlabs(j, TempTax, AnnualTax, SocialSecurityTax);
        // Project tax for remaining months
        ProjectRemainingMonthsTax(RemainingMonth, LastEntryNo);
    end;
    // Calculate remaining months for projection
    local procedure CalculateRemainingMonths(var LastEntryNo: Integer): Integer
    var
        PostedPayrollHeader: Record "Posted Payroll Header";
        RemainingMonth: Integer;
    begin
        DetailedEmpLedgerEntry.Reset();
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetFilter("Employee No.", EmployeeFilter);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        // if DetailedEmpLedgerEntry.FindLast() then begin

        //     // Start from next period after last processed
        //     CreateTempDetailedLedgerFromPAttrUsage(DetailedEmpLedgerEntry."Pay Cycle Period" + 1, LastEntryNo);
        //     RemainingMonth := GetLastPayCycle(EmployeeFilter) - DetailedEmpLedgerEntry."Pay Cycle Period";
        // end else begin
        //     // Start from period 1
        //     CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
        //     RemainingMonth := GetLastPayCycle(EmployeeFilter);
        // end;
        PostedPayrollHeader.Reset();
        PostedPayrollHeader.SetRange("Pay Cycle Term", PayCycleTerm);
        PostedPayrollHeader.SetRange(Reversed, false);
        PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.type::Payroll);
        if PostedPayrollHeader.FindLast() then begin
            DetailedEmpLedgerEntry.SetRange("Document No.", PostedPayrollHeader."No.");
            DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeFilter);
            if DetailedEmpLedgerEntry.FindLast() then begin
                CreateTempDetailedLedgerFromPAttrUsage(DetailedEmpLedgerEntry."Pay Cycle Period" + 1, LastEntryNo);
                RemainingMonth := GetLastPayCycle(EmployeeFilter) - DetailedEmpLedgerEntry."Pay Cycle Period";
            end else begin
                CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
                RemainingMonth := GetLastPayCycle(EmployeeFilter);
            end;
        end;
        exit(RemainingMonth);
    end;



    // Copies existing detailed employee ledger entries to temporary table for processing
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
        // Calculate Total Retirement Contributions
        CalculateTotalRetirement();
        // Calculate tax exemption values
        CalculateTaxExemptions();
        // Calculate insurance amounts
        CalculateInsuranceAmounts();
        // Get donation amount
        TotalDonation := GetDonationAmount(EmployeeFilter);
        // error

        // Calculate Non-Payment and Non-Taxable amounts
        CalculateNonPaymentAndNonTaxable();
        // Calculate final taxable amount
        CalculateFinalTaxableAmount();
    end;
    // Initialize variables for annual totals calculation

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
    begin
        Employee.Reset();
        Employee.SetRange("No.", EmployeeFilter);
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        if Employee.FindFirst() then begin
            Employee.CalcFields("Total Earning", "Total Retirement Contribution", "Total Donation Contribution",
                    "Total Medical Re-Imbursement", "Social Security Tax", "Remuneration & Benefits Tax", "PF Contribution");
        end;
    end;
    // Calculate total annual earning excluding non-taxable items
    local procedure CalculateTotalAnnualEarning()
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2',
            TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning",
            TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total Benefit Opening";
    end;
    // Calculate total retirement contributions
    local procedure CalculateTotalRetirement()
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
        TotalRetirement := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total RF Opening";
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
    begin
        // Calculate one third of gross income
        if PgSetup."Tax Ex. Amt Divsion" <> 0 then
            OneThird := TotalAnnualEarning / PgSetup."Tax Ex. Amt Divsion";
        // Tax exemption limit value
        TaxExemptionLimit := PgSetup."Tax Ex. Amt. not Exceeding";
        // Calculate minimum value among total retirement contribution, one third of gross income, and tax exemption limit
        MinValueDeduction := TotalRetirement;
        if OneThird < MinValueDeduction then
            MinValueDeduction := OneThird;
        if TaxExemptionLimit < MinValueDeduction then
            MinValueDeduction := TaxExemptionLimit;
    end;

    // Calculates all insurance amounts (Life, Medical, Property) with limits
    local procedure CalculateInsuranceAmounts()
    begin
        // Get Life Insurance Amount with limit
        LifeInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Life Insurance");
        if LifeInsuranceAmount > PgSetup."Tax Ex. Life Insurance Amt." then
            LifeInsuranceAmount := PgSetup."Tax Ex. Life Insurance Amt.";
        // Get Medical and House Insurance Amounts
        MedicalInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Medical Insurance");
        HouseInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Property Insurance");
    end;

    // Calculates non-payment and non-taxable amounts
    local procedure CalculateNonPaymentAndNonTaxable()
    begin
        // Calculate Total Non-Payment (exclude non-taxable non-payments)
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::"Non-Payment");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalNonPayment := TempDetailedEmpLedgerEntry.Amount;
        // Calculate Non-Taxable Amounts (all non-taxable items regardless of type)
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", true);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        NonTaxable := TempDetailedEmpLedgerEntry.Amount;
    end;

    // Calculates tax amounts for each slab based on tax setup
    local procedure CalculateTaxSlabs(var j: Integer; var TempTax: Decimal; var AnnualTax: Decimal; var SocialSecurityTax: Decimal)
    var
        TaxSetupLine: Record "Tax Setup Line";
        TaxSetupHdr: Record "Tax Setup Header";
    begin
        // Initialize tax calculation variables
        TempTax := 0;
        AnnualTax := 0;
        SocialSecurityTax := 0;
        j := 1;
        // Process each tax slab
        TaxSetupLine.Reset();
        TaxSetupLine.SetRange(Code, EmpVar."Tax Code");
        if TaxSetupLine.FindSet() then
            repeat
                if RemainingTaxableAmount > 0 then begin
                    // Calculate tax for this slab
                    if TaxSetupLine."Tax Rate" = 0 then
                        TempTax := 0
                    else
                        TempTax := GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount") * TaxSetupLine."Tax Rate" / 100.0;
                    AnnualTax += TempTax;
                    // Track Social Security Tax (1% rate)
                    if (SocialSecurityTax = 0) and (TaxSetupLine."Tax Rate" = 1) then
                        SocialSecurityTax := AnnualTax;
                    // Store slab calculations
                    TaxAmts[j] := TempTax;
                    TaxAmtsSlabs[j] := GetTax2(TaxSetupLine."Start Amount", TaxSetupLine."End Amount",
                                              RemainingTaxableAmount, TempTax, TaxSetupLine);
                    TaxRates[j] := TaxSetupLine."Tax Rate";
                    j += 1;
                end;
            until (TaxSetupLine.Next() = 0);
        // Calculate total tax from all slabs
        TotalTax := TaxAmts[1] + TaxAmts[2] + TaxAmts[3] + TaxAmts[4] + TaxAmts[5] + TaxAmts[6];
        // Calculate Tax Rebate (special tax exemption percentage)
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
        // Clear PayrollAmts array
        for i := 1 to ArrayLen(PayrollAmts) do
            Clear(PayrollAmts[i]);
        // Clear TaxAmts array
        for i := 1 to ArrayLen(TaxAmts) do
            Clear(TaxAmts[i]);
        // Clear remaining taxable amount
        Clear(RemainingTaxableAmount);
    end;

    // TAX CALCULATION HELPER PROCEDURES
    // Calculates tax amount for a specific slab range
    // <param name="StartAmount">Start amount of tax slab</param>
    // <param name="EndAmount">End amount of tax slab</param>
    // <returns>Taxable amount for this slab</returns>
    procedure GetTax(StartAmount: Decimal; EndAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
        SlabRange: Decimal;
    begin
        SlabRange := EndAmount - StartAmount;
        if SlabRange <= RemainingTaxableAmount then begin
            RemainingTaxableAmount := RemainingTaxableAmount - (SlabRange + 1);
            exit(SlabRange + 1)
        end else begin
            RemainingAmountCopy := RemainingTaxableAmount;
            RemainingTaxableAmount := 0;
            exit(RemainingAmountCopy);
        end;
    end;

    // Calculates slab amount for display purposes
    local procedure GetTax2(StartAmount: Decimal; EndAmount: Decimal; RemainTaxable: Decimal; TempTax: Decimal; TaxSetupLine: Record "Tax Setup Line"): Decimal
    begin
        if RemainTaxable > 0 then
            exit(EndAmount - StartAmount + 1)
        else
            if TaxSetupLine."Tax Rate" > 1 then
                exit(Round(TempTax * 100 / TaxSetupLine."Tax Rate", 0.01, '='))
            else
                if TaxSetupLine."Tax Rate" > 0 then
                    exit(Round(TempTax * 100, 0.01, '='))
                else
                    exit(0);
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
    begin
        RemainingMonth := MONTHS_PER_YEAR;
        if not EmpRec.Get(EmpCode) then
            exit(RemainingMonth);
        if not PGSetup.Get() then
            exit(RemainingMonth);
        // Handle terminated employees
        if EmpRec.Status = EmpRec.Status::Terminated then
            if EmpRec."Termination Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Termination Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Termination Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForTermination(EmpRec, 'MONTHLY', PayCycleTerm);
        // Handle contract employees with expiry dates
        if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then
            if EmpRec."Contract Expiry Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Contract Expiry Date") and
                   (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Contract Expiry Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForContractExp(EmpRec, 'MONTHLY', PayCycleTerm);
        exit(RemainingMonth);
    end;

    // Gets insurance amount for specific insurance type with validation
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
        exit(0);
    end;

    // Gets total donation amount for the employee within the fiscal year
    local procedure GetDonationAmount(EmployeeNo: Code[20]): Decimal
    var
        Emp: Record Employee;
    begin
        if Emp.Get(EmployeeNo) then begin
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
        DetailedEmpLedgerEntry.SetRange("Fiscal Year", PayCycleTerm);
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
        // Skip irregular attributes except non-payments
        if PayrollAtr.Irregular then
            if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
                exit(true)
            else
                exit(false);
        // Skip non-taxable attributes
        if PayrollAtr."Non-Taxable" then
            exit(false);
        // Include non-payments
        if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
            exit(true);
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

        // Determine effective start date
        EffectiveStartDate := PeriodStartDate;
        if (AttrStartDate <> 0D) and (AttrStartDate > PeriodStartDate) then
            EffectiveStartDate := AttrStartDate;

        // Determine effective end date
        EffectiveEndDate := PeriodEndDate;
        if (AttrEndDate <> 0D) and (AttrEndDate < PeriodEndDate) then
            EffectiveEndDate := AttrEndDate;

        // Calculate effective days
        if EffectiveStartDate > EffectiveEndDate then
            exit(0); // No overlap

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
    begin
        if not PgSetup.Get() then
            exit;
        if not EmpVar.Get(EmployeeFilter) then
            exit;

        // Loop through each remaining pay period
        for i := StartPeriod to GetLastPayCycle(EmployeeFilter) do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmployeeFilter);
            if PayrollAttrUsage.FindSet() then
                repeat
                    InsertData := false;
                    PayrollAttrUsage.CalcFields(Type, Subtype, "Formula Exists");

                    // Check if this attribute should be projected
                    if CheckIfProjectable(PayrollAttrUsage.Code) then begin
                        // Check if this period should be included based on start/end dates
                        if ShouldIncludePeriod(i, PayrollAttrUsage."Start Date", PayrollAttrUsage."End Date") then
                            InsertData := true;
                    end;

                    if PayAttr.Get(PayrollAttrUsage.Code) then begin
                        // Check pay cycle period constraints
                        if PayAttr."Pay Cycle Period" <> 0 then
                            if PayAttr."Pay Cycle Period" <> i then
                                InsertData := false;

                        // Check pay frequency constraints
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

                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;

                        // Calculate base amount with formula if exists
                        if PayrollAttrUsage."Formula Exists" then begin
                            PayrollReportMgt.SetEmployeeCode(EmployeeFilter);
                            CalculatedAmount := PayrollReportMgt.getAttributeAmount(EmployeeFilter, PayrollAttrUsage.Code);
                        end else
                            CalculatedAmount := PayrollAttrUsage.Amount;

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

    local procedure GetDisabilityDiscount(EmployeeNo: Code[20]; var DisabilityDiscount: Decimal)
    var
        Employee: Record Employee;
        TaxSetupHeader: Record "Tax Setup Header";
        TaxSetupLine: Record "Tax Setup Line";
        TaxCode: Code[20];
    begin
        // Initialize
        DisabilityDiscount := 0;

        // Check if employee exists and is disabled
        if Employee.Get(EmployeeNo) then begin
            if Employee.Disabled then begin
                TaxCode := Employee."Tax Code";

                // Find the tax setup for the employee's tax code
                TaxSetupLine.Reset();
                TaxSetupLine.SetRange(Code, TaxCode);
                TaxSetupLine.SetFilter("Tax Rate", '%1|%2', 0, 1); // Find tax rate either 0 or 1
                TaxSetupLine.SetAscending("Line No.", true); // Get the first line

                if TaxSetupLine.FindFirst() then begin
                    // Calculate 50% of the end amount
                    DisabilityDiscount := TaxSetupLine."End Amount" * 0.5;
                end;
            end;
        end;
    end;


    local procedure GetRemoteAreaDeduction(EmployeeNo: Code[20]; var RemoteAreaDeduction: Decimal)
    var
        Employee: Record Employee;
        OrganizationStructurelist: Record "Organization Structure list";
        RemoteAreaCategory: Record "Remote Area Category";
        BranchCode: Code[20];
        RemoteAreaReductionCode: Code[20];
    begin
        // Initialize
        RemoteAreaDeduction := 0;
        if Employee.Get(EmployeeNo) then begin
            BranchCode := Employee."Branch Code";
            OrganizationStructurelist.reset();
            OrganizationStructurelist.SetRange(Code, BranchCode);
            if OrganizationStructurelist.FindFirst() then begin
                RemoteAreaReductionCode := OrganizationStructurelist."Remote Area Category";
                RemoteAreaCategory.Reset();
                RemoteAreaCategory.SetRange("Category", RemoteAreaReductionCode);
                if RemoteAreaCategory.FindFirst() then begin
                    // Get the remote area deduction amount
                    RemoteAreaDeduction := RemoteAreaCategory."Remote Area Deduction";
                end;
            end;
        end;
    end;
}