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
            // column(CompanyInfoAddress; CompanyInfo.GetCompanyPhysicalAddr()) { }
            // column(CompanyCommunicationAddress; CompanyInfo.GetCompanyCommunicationAddr()) { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(Code; Code) { }
            column(Description; PayrollAttributes.Description) { }
            column(Type; Type) { }
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
            column(PaidTDS; Round(TotalTaxPaid, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TDSCalcMonth; TDSCalcMonth)
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(InsurranceAmount; Round(LifeInsuranceAmount, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
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
            column(TaxRebate; Round(TaxRebate, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            // column(MinDeduction_; Round(MinDeduction, GlSetup."Amount Rounding Precision"))
            // {
            //     AutoFormatExpression = 'NPR';
            //     AutoFormatType = 1;
            // }
            column(Minvaluededuction; Round(Minvaluededuction, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TotalTax; Round(TotalTax, GlSetup."Amount Rounding Precision"))
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
            column(TotalDonation; Round(TotalDonation, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TaxExemptionLimit; Round(TaxExemptionLimit, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TaxRate1_; Round(TaxRates[1], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate2_; Round(TaxRates[2], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate3_; Round(TaxRates[3], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate4_; Round(TaxRates[4], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate5_; Round(TaxRates[5], GlSetup."Amount Rounding Precision")) { }
            column(TaxRate6_; Round(TaxRates[6], GlSetup."Amount Rounding Precision")) { }
            column(OneThird; Round(OneThird, GlSetup."Amount Rounding Precision")) { }
            column(TotalAnualEarning; Round(TotalAnnualEarning, GlSetup."Amount Rounding Precision")) { }
            column(MedicalInsuranceAmount; Round(MedicalInsuranceAmount, GlSetup."Amount Rounding Precision")) { }
            column(HouseInsuranceAmount; Round(HouseInsuranceAmount, GlSetup."Amount Rounding Precision")) { }
            column(TaxCode; EmpVar."Tax Code") { }

            dataitem("Pay Cycle Period"; "Pay Cycle Period")
            {
                DataItemTableView = sorting("Pay Cycle Code", "Pay Cycle Term", Period);
                column(PayCycleTerm_PayCyclePeriod; "Pay Cycle Period"."Pay Cycle Term") { }
                column(Period; "Pay Cycle Period".Period) { }
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
                column(NepaliMonth_PayCyclePeriod; "Pay Cycle Period"."Nepali Month") { }

                trigger OnPreDataItem()
                var
                    Employee: Record Employee;
                    PayCyclePeriod1, PayCyclePeriod2 : Record "Pay Cycle Period";
                    StartDate: Date;
                begin
                    SetRange("Pay Cycle Term", PayCycleTerm);
                    PayCyclePeriod1.SetRange("Pay Cycle Term", PayCycleTerm);
                    if PayCyclePeriod1.FindFirst() then;
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
                    TempDetailedEmpLedgerEntry.Reset;
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Period", Period);
                    TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", PayrollAttributes.Code);
                    if TempDetailedEmpLedgerEntry.FindFirst then
                        repeat
                            if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                                Amount := Amount + Abs(TempDetailedEmpLedgerEntry.Amount)
                            else
                                Amount := Amount + TempDetailedEmpLedgerEntry.Amount;
                        until TempDetailedEmpLedgerEntry.Next = 0;

                    if Amount = 0 then
                        CurrReport.Skip();
                    if "Pay Cycle Period".Period = 0 then
                        CurrReport.Skip();

                    if (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Social Security Tax") or (PayrollAttributes.Subtype = PayrollAttributes.Subtype::"Tax on Remuneration & Benefits") then
                        if Amount < 0 then
                            Amount := 0;

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
                ClearVariables;
                InsertColumn;
            end;

            trigger OnAfterGetRecord()
            begin
                if EmpVar.Get(EmployeeFilter) then;
                EmployeePayrollOpen.Reset();
                EmployeePayrollOpen.SetRange("Employee No.", EmployeeFilter);
                if EmployeePayrollOpen.FindLast() then
                    SortingNo := 0;
                PayrollColumnConfig.Reset;
                PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                PayrollColumnConfig.SetRange("Variable Field Code", PayrollAttributes.Code);
                if PayrollColumnConfig.FindFirst then
                    SortingNo := PayrollColumnConfig."Field No.";

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
                group(GroupName)
                {
                    field("Pay Cycle Term"; PayCycleTerm)
                    {
                        ApplicationArea = All;
                        TableRelation = "Pay Cycle Term".Term;
                        ToolTip = 'Specifies the value of the PayCycleTerm field.';
                    }
                    field("Employee No"; EmployeeFilter)
                    {
                        ApplicationArea = All;
                        TableRelation = Employee."No.";
                        ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    }
                }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }

    trigger OnInitReport()
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        if GuiAllowed then begin
            PayCyclePeriod.Reset();
            PayCyclePeriod.SetFilter("End Date", '>=%1', Today);
            PayCyclePeriod.SetFilter("Start Date", '<=%1', Today);
            if PayCyclePeriod.FindFirst() then
                PayCycleTerm := PayCyclePeriod."Pay Cycle Term";
        end;
    end;

    trigger OnPreReport()
    var
        PayPeriod: Record "Pay Cycle Period";
        HRMSPayrollPermission: Codeunit "Payroll Engine";
    begin
        GlSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        if PayCycleTerm = '' then
            Error('Specify pay cycle term');
        PgSetup.Get();
        PayPeriod.Reset();
        PayPeriod.SetRange("Pay Cycle Term", PayCycleTerm);
        if PayPeriod.FindFirst() then
            if PayPeriod."Start Date" < PgSetup."Payroll Fiscal Year Start Date" then
                Error('yearly projection report is for current year only');

        TempDetailedEmpLedgerEntry.Reset;
        TempDetailedEmpLedgerEntry.DeleteAll;
    end;

    trigger OnPostReport()
    begin
        TempDetailedEmpLedgerEntry.Reset;
        TempDetailedEmpLedgerEntry.DeleteAll;
    end;

    var
        PgSetup: Record "Payroll General Setup";
        GlSetup: Record "General Ledger Setup";
        Amount: Decimal;
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        PayCycleTerm: Code[10];
        EmployeeFilter: Code[20];
        EmpVar: Record Employee;
        CompanyInfo: Record "Company Information";
        BenefitAmount: Decimal;
        DeductionAmount: Decimal;
        ReportName: Text;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        SortingNo: Integer;

        //projection
        PayrollAmts: array[10] of Decimal;
        TDSCalcMonth: Enum "Nepali Month";
        TaxAmts: array[10] of Decimal;
        TaxAmtsSlabs: array[10] of Decimal;
        TaxRates: array[10] of Decimal;
        TaxRebate: Decimal;
        TotalRetirement: Decimal;
        TotalTax: Decimal;
        TempDetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry" temporary;
        TotalAnnualEarning: Decimal;
        TotalTaxPaid: Decimal;
        MonthlyProjectedTax: Decimal;
        RemainingTaxable: Decimal;
        MonthlySST: Decimal;
        PayrollReportMgt: Codeunit "Payroll Report Mgt.";
        EmployeePayrollOpen: Record "Employee Payroll Opening";
        RemainingTaxableAmount: Decimal;
        TaxableAmount: Decimal;
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        // MinDeduction: Decimal;
        Minvaluededuction: Decimal;
        LifeInsuranceAmount: Decimal;
        TotalNonPayment: Decimal;
        NonTaxable: Decimal;
        TaxExemptionLimit: Decimal;
        OneThird: Decimal;
        MedicalInsuranceAmount: Decimal;
        HouseInsuranceAmount: Decimal;
        EmployeeInsuranceInfo: Record "Employee Insurance Information";
        TotalDonation: Decimal;

    local procedure InsertColumn()
    var
        LastEntryNo: Integer;
        i: Integer;
        Employee: Record Employee;
        TempTax: Decimal;
        AnnualTax: Decimal;
        SocialSecurityTax: Decimal;
        TaxSetupHdr: Record "Tax Setup Header";
        RemainingMonth: Integer;
        TaxSetupLine: Record "Tax Setup Line";
        //MinDeduction_: Decimal;
        j: Integer;
        EmployerContribution: Decimal;
        RF: Decimal;
        LumpSumCIT: Decimal;
        EmployeeLumpsum: Decimal;
        ProjectionEarning: Decimal;
        CITContribution: Decimal;
        EmpPayOpen: Record "Employee Payroll Opening";
    begin
        EmpVar.Get(EmployeeFilter);
        LastEntryNo := 90000000;
        EmployeePayrollOpen.Reset;
        EmployeePayrollOpen.SetRange("Employee No.", EmployeeFilter);
        if EmployeePayrollOpen.FindLast then
            TaxSetupHdr.Get(EmpVar."Tax Code");
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetFilter("Employee No.", EmployeeFilter);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindLast then begin
            CreateTempDetailedLedgerFromPAttrUsage(DetailedEmpLedgerEntry."Pay Cycle Period" + 1, LastEntryNo);
            RemainingMonth := GetLastPayCycle(EmployeeFilter) - DetailedEmpLedgerEntry."Pay Cycle Period"
        end
        else begin
            CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
            RemainingMonth := GetLastPayCycle(EmployeeFilter);
        end;

        Clear(DetailedEmpLedgerEntry);
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeFilter);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindFirst then
            repeat
                TempDetailedEmpLedgerEntry.Init;
                TempDetailedEmpLedgerEntry := DetailedEmpLedgerEntry;
                if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                    TempDetailedEmpLedgerEntry.Amount := Abs(DetailedEmpLedgerEntry.Amount);
                TempDetailedEmpLedgerEntry.Insert;
            until DetailedEmpLedgerEntry.Next = 0;

        TotalAnnualEarning := 0;
        TotalRetirement := 0;
        //MinDeduction := 0;
        Minvaluededuction := 0;
        TempTax := 0;
        AnnualTax := 0;
        SocialSecurityTax := 0;
        TotalTaxPaid := 0;
        TotalNonPayment := 0;
        NonTaxable := 0;
        OneThird := 0;
        MedicalInsuranceAmount := 0;
        HouseInsuranceAmount := 0;

        PgSetup.Get();
        Employee.Reset;
        Employee.SetRange("No.", EmployeeFilter);
        Employee.SetFilter("Date Filter", '%1..%2', PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        Employee.FindFirst;
        Employee.CalcFields("Total Earning", "Total Retirement Contribution", "Total Donation Contribution",
                "Total Medical Re-Imbursement", "Social Security Tax", "Remuneration & Benefits Tax", "PF Contribution");

        // Calculate Total Annual Earning
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2', TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning", TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total Benefit Opening";

        // Calculate Total Retirement
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


        PgSetup.Get();
        //calculate one third of gross income
        OneThird := TotalAnnualEarning / PgSetup."Tax Ex. Amt Divsion";
        // Calculate Min Deduction (1/3 rule)
        //OneThird := MinDeduction_;
        // MinDeduction_ := (PgSetup."Tax Ex. Amt. (%) on Retirement" * TotalAnnualEarning) / 100;
        // if MinDeduction_ > TotalRetirement then
        //     MinDeduction_ := TotalRetirement;
        // if MinDeduction_ > TaxExemptionLimit then
        //     MinDeduction_ := TaxExemptionLimit;
        // MinDeduction := MinDeduction_;
        //Tax exemptionlimit value
        TaxExemptionLimit := PgSetup."Tax Ex. Amt. not Exceeding";
        //calculate min value among total contribution on retirement fund , One third of gross income and tax Exemption Limit
        MinValueDeduction := TotalRetirement;
        if OneThird < MinValueDeduction then
            MinValueDeduction := OneThird;
        if TaxExemptionLimit < MinValueDeduction then
            MinValueDeduction := TaxExemptionLimit;
        // Get Insurance Amounts
        LifeInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Life Insurance");
        if LifeInsuranceAmount > PgSetup."Tax Ex. Life Insurance Amt." then
            LifeInsuranceAmount := PgSetup."Tax Ex. Life Insurance Amt.";

        MedicalInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Medical Insurance");
        HouseInsuranceAmount := GetInsuranceAmount(EmployeeFilter, EmployeeInsuranceInfo."Insurance Type"::"Property Insurance");

        // Get Donation Amount
        TotalDonation := GetDonationAmount(EmployeeFilter);

        // Calculate Total Non-Payment
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Attribute Type", TempDetailedEmpLedgerEntry."Attribute Type"::"Non-Payment");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false); // Exclude non-taxable non-payments
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalNonPayment := TempDetailedEmpLedgerEntry.Amount;

        // Calculate Non-Taxable Amounts
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", true);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        NonTaxable := TempDetailedEmpLedgerEntry.Amount;

        // Calculate Taxable Amount
        TaxableAmount := TotalAnnualEarning + TotalNonPayment - Minvaluededuction - LifeInsuranceAmount - MedicalInsuranceAmount - HouseInsuranceAmount - TotalDonation;
        RemainingTaxableAmount := TaxableAmount;

        // Calculate Tax Slabs
        j := 1;
        TaxSetupLine.Reset;
        TaxSetupLine.SetRange(Code, EmpVar."Tax Code");
        if TaxSetupLine.FindSet then
            repeat
                if RemainingTaxableAmount > 0 then begin
                    if TaxSetupLine."Tax Rate" = 0 then
                        TempTax := 0
                    else
                        TempTax := GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount") * TaxSetupLine."Tax Rate" / 100.0;

                    AnnualTax += TempTax;
                    if (SocialSecurityTax = 0) and (TaxSetupLine."Tax Rate" = 1) then
                        SocialSecurityTax := AnnualTax;

                    TaxAmts[j] := TempTax;
                    TaxAmtsSlabs[j] := GetTax2(TaxSetupLine."Start Amount", TaxSetupLine."End Amount", RemainingTaxableAmount, TempTax, TaxSetupLine);
                    TaxRates[j] := TaxSetupLine."Tax Rate";

                    j += 1;
                end;
            until (TaxSetupLine.Next = 0);

        TotalTax := TaxAmts[1] + TaxAmts[2] + TaxAmts[3] + TaxAmts[4] + TaxAmts[5] + TaxAmts[6];

        // Calculate Tax Rebate

        TaxRebate := 0;

        TaxSetupHdr.Reset();
        TaxSetupHdr.SetRange(Code, EmpVar."Tax Code");
        if TaxSetupHdr.FindFirst() then begin
            if TaxSetupHdr."Special Tax Exempt %" > 0 then
                TaxRebate := Round((TaxSetupHdr."Special Tax Exempt %" / 100) * TotalTax, 0.01, '=');
        end;
        //TaxRebate := Round((TaxSetupHdr."Special Tax Exempt %" / 100) * AnnualTax, 0.01, '=');
        MonthlyProjectedTax := MonthlyProjectedTax - MonthlySST;

        // Project remaining months
        for i := 12 - RemainingMonth + 1 to GetLastPayCycle(EmployeeFilter) do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmployeeFilter);
            PayrollAttrUsage.SetFilter(Subtype, '%1|%2', PayrollAttributes.Subtype::"Social Security Tax", PayrollAttrUsage.Subtype::"Tax on Remuneration & Benefits");
            if PayrollAttrUsage.FindSet() then
                repeat
                    PayrollAttrUsage.CalcFields(Type, Subtype);
                    TempDetailedEmpLedgerEntry.Init();
                    TempDetailedEmpLedgerEntry."Entry No." := LastEntryNo;
                    TempDetailedEmpLedgerEntry."Employee No." := EmployeeFilter;
                    TempDetailedEmpLedgerEntry.Validate("Payroll Attribute Code", PayrollAttrUsage.Code);
                    TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                    TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                    TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;

                    if PayrollAttrUsage.Subtype = PayrollAttrUsage.Subtype::"Social Security Tax" then
                        TempDetailedEmpLedgerEntry.Amount := MonthlySST
                    else
                        TempDetailedEmpLedgerEntry.Amount := MonthlyProjectedTax;

                    TempDetailedEmpLedgerEntry.Insert();
                    LastEntryNo += 1;
                until PayrollAttrUsage.Next() = 0
        end;
    end;

    local procedure CheckIfProjectable(AttrCode: Code[20]): Boolean
    var
        PayrollAtr: Record "Payroll Attributes";
    begin
        if PayrollAtr.Get(AttrCode) then begin
            if PayrollAtr.Irregular then
                if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
                    exit(true)
                else
                    exit(false);
            if PayrollAtr."Non-Taxable" then
                exit(false);

            if PayrollAtr.Type = PayrollAtr.Type::"Non-Payment" then
                exit(true);

            if PayrollAtr."Apply Every Month" then
                exit(true);

            if (PayrollAtr.Type = PayrollAtr.Type::Deduction) then begin

                if PayrollAtr.Subtype in [PayrollAtr.Subtype::"Social Security Tax", PayrollAtr.Subtype::"Tax on Remuneration & Benefits"] then
                    exit(true);

                exit(false);
            end;
        end;
        exit(false);
    end;

    local procedure ClearVariables()
    begin
        Clear(PayrollAmts[1]);
        Clear(PayrollAmts[2]);
        Clear(PayrollAmts[3]);
        Clear(PayrollAmts[4]);
        Clear(PayrollAmts[5]);
        Clear(PayrollAmts[6]);
        Clear(PayrollAmts[7]);

        Clear(TaxAmts[1]);
        Clear(TaxAmts[2]);
        Clear(TaxAmts[3]);
        Clear(TaxAmts[4]);
        Clear(RemainingTaxable);
    end;

    procedure GetTax(StartAmount: Decimal; endAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
    begin
        if (endAmount - StartAmount) <= RemainingTaxableAmount then begin
            RemainingTaxableAmount := RemainingTaxableAmount - (endAmount - StartAmount + 1);
            exit(endAmount - StartAmount + 1)
        end
        else begin
            RemainingAmountCopy := RemainingTaxableAmount;
            RemainingTaxableAmount := 0;
            exit(RemainingAmountCopy);
        end;
    end;

    local procedure GetTax2(StartAmount: Decimal; endAmount: Decimal; RemainTaxable: Decimal; TempTax: Decimal; TaxSetupLine: Record "Tax Setup Line"): Decimal
    begin

        if RemainTaxable > 0 then
            exit(endAmount - StartAmount + 1)
        else
            if TaxSetupLine."Tax Rate" > 1 then
                exit(Round(TempTax * 100 / TaxSetupLine."Tax Rate", 0.01, '='))
            else
                exit(Round(TempTax * 100, 0.01, '='));
    end;

    procedure CreateTempDetailedLedgerFromPAttrUsage(StartPeriod: Integer; var TempEntryNo: Integer)
    var
        i: Integer;
        PayrollAttrUsage: Record "Payroll Attributes Usage";
        PayAttr: Record "Payroll Attributes";
        InsertData: Boolean;

        FirstIteration: Boolean;
    begin

        FirstIteration := true;
        PgSetup.Get();
        EmpVar.Get(EmployeeFilter);
        for i := StartPeriod to GetLastPayCycle(EmployeeFilter) do begin
            PayrollAttrUsage.Reset();
            PayrollAttrUsage.SetRange("Employee Code", EmployeeFilter);
            if PayrollAttrUsage.FindSet() then
                repeat
                    InsertData := false;
                    PayrollAttrUsage.CalcFields(Type, Subtype, "Formula Exists");
                    if CheckIfProjectable(PayrollAttrUsage.Code) then
                        InsertData := true;
                    PayAttr.Get(PayrollAttrUsage.Code);
                    if (PayAttr."Pay Frequency" <> 0) and (getPaidFrequency(PayAttr.Code) >= PayAttr."Pay Frequency") then
                        InsertData := false;
                    if InsertData then begin
                        TempDetailedEmpLedgerEntry.Init();
                        TempDetailedEmpLedgerEntry."Entry No." := TempEntryNo;
                        TempDetailedEmpLedgerEntry."Employee No." := EmployeeFilter;
                        TempDetailedEmpLedgerEntry.Validate("Payroll Attribute Code", PayrollAttrUsage.Code);


                        if PayAttr.Type = PayAttr.Type::Benefits then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings";
                        if PayAttr.Type = PayAttr.Type::Deduction then
                            TempDetailedEmpLedgerEntry."Attribute Type" := TempDetailedEmpLedgerEntry."Attribute Type"::Deduction;
                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;
                        TempDetailedEmpLedgerEntry.Amount := PayrollAttrUsage.Amount;
                        if PayrollAttrUsage."Formula Exists" then begin
                            PayrollReportMgt.SetEmployeeCode(EmployeeFilter);
                            TempDetailedEmpLedgerEntry.Amount := PayrollReportMgt.getAttributeAmount(EmployeeFilter, PayrollAttrUsage.Code);
                        end;
                        TempDetailedEmpLedgerEntry.Insert();
                        TempEntryNo += 1;
                    end;
                until PayrollAttrUsage.Next() = 0;

            FirstIteration := false;
        end;
    end;

    procedure getPaidFrequency(attrCode: Code[20]): Integer
    begin
        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetRange("Payroll Attribute Code", attrCode);
        exit(TempDetailedEmpLedgerEntry.Count);
    end;

    procedure GetLastPayCycle(empCode: Code[20]): Integer
    var
        PGSetup: Record "Payroll General Setup";
        EmpRec: Record Employee;
        PayrollRepMgt: Codeunit "Payroll Report Mgt.";
        RemainingMonth: Integer;
    begin
        RemainingMonth := 12;
        EmpRec.Get(empCode);
        PGSetup.Get();

        //terminated employee
        if EmpRec.Status = EmpRec.Status::Terminated then
            if EmpRec."Termination Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Termination Date") and
                (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Termination Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForTermination(EmpRec, 'MONTHLY', PayCycleTerm);

        //contract expiry EmpRec
        if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then
            if EmpRec."Contract Expiry Date" <> 0D then
                if (PGSetup."Payroll Fiscal Year Start Date" < EmpRec."Contract Expiry Date") and
                        (PGSetup."Payroll Fiscal Year End Date" > EmpRec."Contract Expiry Date") then
                    RemainingMonth := PayrollRepMgt.GetPayPeriodForContractExp(EmpRec, 'MONTHLY', PayCycleTerm);

        exit(RemainingMonth);
    end;

    procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[20])
    begin
        EmployeeFilter := empCode;
        PayCycleTerm := FiscalYear;
    end;

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

    local procedure GetDonationAmount(EmployeeNo: Code[20]): Decimal
    var
        Emp: Record Employee;
    begin
        Emp.Get(EmployeeNo);
        Emp.SetRange("Date Filter", PgSetup."Payroll Fiscal Year Start Date", PgSetup."Payroll Fiscal Year End Date");
        Emp.CalcFields("Total Donation Contribution");
        exit(Emp."Total Donation Contribution");
    end;
}
