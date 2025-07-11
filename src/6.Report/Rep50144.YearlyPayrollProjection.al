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
            // column(EmployeeBranch; EmpVar."Office Name") { }
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
            column(MinDeduction_; Round(MinDeduction, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            column(TotalTax; Round(TotalTax, GlSetup."Amount Rounding Precision"))
            {
                AutoFormatExpression = 'NPR';
                AutoFormatType = 1;
            }
            // column(PastBenifit; EmployeePayrollOpen."Past Benefit")
            // {
            //     AutoFormatExpression = 'NPR';
            //     AutoFormatType = 1;
            // }
            // column(PastRetirement; EmployeePayrollOpen."Past Retirement Fund")
            // {
            //     AutoFormatExpression = 'NPR';
            //     AutoFormatType = 1;
            // }
            // column(PastSStPaid; EmployeePayrollOpen."Past SST Paid")
            // {
            //     AutoFormatExpression = 'NPR';
            //     AutoFormatType = 1;
            // }
            // column(PastTaxRenPaid; EmployeePayrollOpen."Past Tax on RIT Paid")
            // {
            //     AutoFormatExpression = 'NPR';
            //     AutoFormatType = 1;
            // }
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
            dataitem("Pay Cycle Period";
            "Pay Cycle Period")
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
                    // TempDetailedEmpLedgerPRM.SetRange("Employee No.", EmployeeFilter);
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Term", "Pay Cycle Term");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Code", "Pay Cycle Code");
                    TempDetailedEmpLedgerEntry.SetRange("Pay Cycle Period", Period);
                    // TempDetailedEmpLedgerPRM.SetRange("Payroll Attribute Code", PayrollAttributes.Code);
                    // TempDetailedEmpLedgerPRM.SetRange(Reversed, false);
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
                if EmployeePayrollOpen.Get(EmployeeFilter, PayCycleTerm) then;
                // if not PAU.Get(Code, EmployeeFilter) then
                //     CurrReport.Skip();
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
                        // TableRelation = Employee where(Nominee = const(false));
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
        // HRMSPayrollPermission.PayrollPermission();
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
        MinDeduction: Decimal;
        LifeInsuranceAmount: Decimal;
        TotalNonPayment: Decimal;
        NonTaxable: Decimal;
        TaxExemptionLimit: Decimal;
        OneThird: Decimal;
        MedicalInsuranceAmount: Decimal;
        HouseInsuranceAmount: Decimal;

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
        MinDeduction_: Decimal;
        TotalRetirement_: Decimal;
        j: Integer;
    begin
        EmpVar.Get(EmployeeFilter);
        LastEntryNo := 90000000;
        if EmployeePayrollOpen.Get(EmployeeFilter, PayCycleTerm) then;
        TaxSetupHdr.Get(EmpVar."Tax Code");

        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetFilter("Employee No.", EmployeeFilter);
        // DetailedEmpLedgerPRM.SetRange("Irregular Payroll", false);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindLast then begin
            CreateTempDetailedLedgerFromPAttrUsage(DetailedEmpLedgerEntry."Pay Cycle Period" + 1, LastEntryNo);
            // RemainingMonth := 12 - DetaliedEmpLedgerPRM."Pay Cycle Period"
            RemainingMonth := GetLastPayCycle(EmployeeFilter) - DetailedEmpLedgerEntry."Pay Cycle Period"
        end
        else begin
            CreateTempDetailedLedgerFromPAttrUsage(1, LastEntryNo);
            // RemainingMonth := 12
            RemainingMonth := GetLastPayCycle(EmployeeFilter);
        end;
        // if RemainingMonth = 0 then
        //     Error('projection can not be done as payroll has been posted for all month.');

        Clear(DetailedEmpLedgerEntry);
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.SetRange("Pay Cycle Term", PayCycleTerm);
        DetailedEmpLedgerEntry.SetRange("Employee No.", EmployeeFilter);
        // DetaliedEmpLedgerPRM.SetRange("Irregular Payroll", false);
        DetailedEmpLedgerEntry.SetRange(Reversed, false);
        if DetailedEmpLedgerEntry.FindFirst then
            repeat
                TempDetailedEmpLedgerEntry.Init;
                TempDetailedEmpLedgerEntry := DetailedEmpLedgerEntry;
                if TempDetailedEmpLedgerEntry."Attribute Type" = TempDetailedEmpLedgerEntry."Attribute Type"::Deduction then
                    TempDetailedEmpLedgerEntry.Amount := Abs(DetailedEmpLedgerEntry.Amount);
                TempDetailedEmpLedgerEntry.Insert;
            until DetailedEmpLedgerEntry.Next = 0;

        // PayrollAmts[3]  taxable income
        //payroll opening
        //insurrance
        //donation
        //reduction
        TotalAnnualEarning := 0;
        TotalRetirement := 0;
        TotalRetirement_ := 0;

        MinDeduction := 0;
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

        TempDetailedEmpLedgerEntry.Reset();
        TempDetailedEmpLedgerEntry.SetFilter("Attribute Type", '%1|%2', TempDetailedEmpLedgerEntry."Attribute Type"::"Basic Earning", TempDetailedEmpLedgerEntry."Attribute Type"::"Other Earnings");
        TempDetailedEmpLedgerEntry.SetRange("Non-Taxable", false);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalAnnualEarning := TempDetailedEmpLedgerEntry.Amount + EmployeePayrollOpen."Total Benefit Opening";

        TempDetailedEmpLedgerEntry.Reset();
        // TempDetailedEmpLedgerPRM.SetRange("Attribute Type", TempDetailedEmpLedgerPRM."Attribute Type"::Deduction);
        // TempDetailedEmpLedgerPRM.SetFilter("Attribute Sub Type", '%1|%2|%3', TempDetailedEmpLedgerPRM."Attribute Sub Type"::"PF Contribution", TempDetailedEmpLedgerPRM."Attribute Sub Type"::CIT,

        // TempDetailedEmpLedgerPRM."Attribute Sub Type"::"SSF Deposit");

        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        // TotalRetirement_ := TempDetailedEmpLedgerPRM.Amount + EmployeePayrollOpen."Past Retirement Fund";
        TotalRetirement := TotalRetirement_;

        PgSetup.Get();
        MinDeduction_ := (PgSetup."Tax Ex. Amt. (%) on Retirement" * TotalAnnualEarning) / 100;  //one third
        OneThird := MinDeduction_;

        if MinDeduction_ > TotalRetirement then  //total retirement deductio
            MinDeduction_ := TotalRetirement;

        // if MinDeduction_ > PgSetup."Tax Ex. Amt. not Exceeding" then  //3 lakh limit
        //     MinDeduction_ := PgSetup."Tax Ex. Amt. not Exceeding";

        // if TaxSetupHdr.SSF then
        //     TaxExemptionLimit := PgSetup."Tax Ex. Amt. not Exceeding SSF"
        // else
        TaxExemptionLimit := PgSetup."Tax Ex. Amt. not Exceeding";

        if MinDeduction_ > TaxExemptionLimit then  //3 lakh limit //5 lakh limit
            MinDeduction_ := TaxExemptionLimit;

        MinDeduction := MinDeduction_;

        LifeInsuranceAmount := Employee."Premium of Life Insurance";
        if LifeInsuranceAmount > PgSetup."Tax Ex. Life Insurance Amt." then
            LifeInsuranceAmount := PgSetup."Tax Ex. Life Insurance Amt.";

        MedicalInsuranceAmount := Employee."Premium of Health Insurance";
        // if MedicalInsuranceAmount > PgSetup."Tax Ex. Med Insurance Amt." then
        //     MedicalInsuranceAmount := PgSetup."Tax Ex. Med Insurance Amt.";

        // HouseInsuranceAmount := Employee."Premium of House Insurance";
        // if HouseInsuranceAmount > PgSetup."Tax Ex. House Insurance Amt." then
        //     HouseInsuranceAmount := PgSetup."Tax Ex. House Insurance Amt.";

        TempDetailedEmpLedgerEntry.Reset();
        // TempDetailedEmpLedgerPRM.SetRange("Attribute Type", TempDetailedEmpLedgerPRM."Attribute Type"::"Non-Payment");
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        TotalNonPayment := TempDetailedEmpLedgerEntry.Amount;

        TempDetailedEmpLedgerEntry.Reset();
        // TempDetailedEmpLedgerPRM.SetRange("Non-Taxable", true);
        // TempDetailedEmpLedgerPRM.SetRange("Attribute Type", TempDetailedEmpLedgerPRM."Attribute Type"::Benefits);
        TempDetailedEmpLedgerEntry.CalcSums(Amount);
        NonTaxable := TempDetailedEmpLedgerEntry.Amount;

        TaxableAmount := TotalAnnualEarning + TotalNonPayment - MinDeduction - LifeInsuranceAmount - MedicalInsuranceAmount - HouseInsuranceAmount;  //taxableamount
        RemainingTaxableAmount := TaxableAmount;

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

        TotalTax := TaxAmts[1] +
                    TaxAmts[2] +
                    TaxAmts[3] +
                    TaxAmts[4] +
                    TaxAmts[5] +
                    TaxAmts[6];

        TaxRebate := Round((TaxSetupHdr."Special Tax Exempt %" / 100) * AnnualTax, 0.01, '=');

        // TotalTaxPaid := Employee."Remuneration & Benefits Tax" + Employee."Social Security Tax" + EmployeePayrollOpen."Past SST Paid" + EmployeePayrollOpen."Past Tax on RIT Paid";

        // if RemainingMonth > 0 then begin
        //     MonthlySST := Round((SocialSecurityTax - EmployeePayrollOpen."Past SST Paid" - Employee."Social Security Tax") / RemainingMonth, 0.01, '=');
        //     MonthlyProjectedTax := Round((AnnualTax - TaxRebate - TotalTaxPaid) / RemainingMonth, 0.01, '=');
        // end;

        MonthlyProjectedTax := MonthlyProjectedTax - MonthlySST; //tax renumeration

        //tax
        // for i := 12 - RemainingMonth to 12 do begin
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

        // for i := StartPeriod to 12 do begin
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
                        TempDetailedEmpLedgerEntry."Attribute Sub Type" := PayAttr.Subtype;

                        // TempDetailedEmpLedgerPRM."Specific Component" := PayAttr."Specific Component";
                        // TempDetailedEmpLedgerPRM."Pension Specific" := PayAttr."Pension Specific";
                        // TempDetailedEmpLedgerPRM."Settlement Specific" := PayAttr."Settlement Specific";
                        TempDetailedEmpLedgerEntry."Non-Taxable" := PayAttr."Non-Taxable";
                        TempDetailedEmpLedgerEntry.Validate("Pay Cycle Code", 'MONTHLY');
                        TempDetailedEmpLedgerEntry."Pay Cycle Term" := PayCycleTerm;
                        TempDetailedEmpLedgerEntry."Pay Cycle Period" := i;
                        TempDetailedEmpLedgerEntry.Amount := PayrollAttrUsage.Amount;
                        if PayrollAttrUsage."Formula Exists" then begin
                            PayrollReportMgt.SetEmployeeCode(EmployeeFilter);
                            TempDetailedEmpLedgerEntry.Amount := PayrollReportMgt.getAttributeAmount(EmployeeFilter, PayrollAttrUsage.Code);
                        end;

                        // if PayAttr.Subtype = PayAttr.Subtype::Grade then
                        //     TempDetailedEmpLedgerPRM.Amount := GetGradeAmt(EmpVar, TempDetailedEmpLedgerPRM.Amount, TempDetailedEmpLedgerPRM."Pay Cycle Period");  //update according to grade plan

                        //tempcode non payment as 12 month>>
                        // if PayAttr.Type = PayAttr.Type::"Non-Payment" then
                        //     if not FirstIteration then
                        //         TempDetailedEmpLedgerPRM.Amount := 0;

                        //get interest income amt
                        // if PayAttr."Specific Component" = PayAttr."Specific Component"::"Interest Income" then
                        //     TempDetailedEmpLedgerPRM.Amount := getInterestIncome(TempDetailedEmpLedgerPRM."Employee No.",
                        //                                                         PayAttr.Code,
                        //                                                         TempDetailedEmpLedgerPRM."Pay Cycle Term",
                        //                                                         TempDetailedEmpLedgerPRM."Pay Cycle Period"
                        //                                                         );

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

        //force retired EmpRec
        // if EmpRec."Force Retirement Date" <> 0D then
        //     if (EmpRec."Force Retirement Date" < PGSetup."Payroll Fiscal Year End Date") then
        //         RemainingMonth := PayrollRepMgt.GetPayPeriodForForceRetirement(EmpRec, 'MONTHLY', PayCycleTerm);

        exit(RemainingMonth);
    end;

    // procedure GetGradeAmt(Emp: Record Employee; var GradeAmt: Decimal; payPeriod: Integer): Decimal
    // var
    //     GradePlan: Record "Grade Plan";
    //     levelwiseAttr: Record "Level Wise Attributes";
    // begin
    //     GradePlan.Reset();
    //     GradePlan.SetRange("Employee No.", Emp."No.");
    //     GradePlan.SetRange("Salary Level", Emp."Salary Level");
    //     GradePlan.SetRange(Verified, true);
    //     GradePlan.SetRange(Applied, false);
    //     GradePlan.SetFilter("Salary Grade", '<>%1', Emp."Salary Grade");
    //     GradePlan.SetFilter("Pay Cycle Period", '<>%1&<=%2', 0, payPeriod);
    //     if GradePlan.FindLast() then
    //         //get the applied month
    //         if levelwiseAttr.Get(GradePlan."Salary Grade", Emp."Salary Level") then
    //             GradeAmt := levelwiseAttr."Level Rate";

    //     exit(GradeAmt);
    // end;

    // procedure getInterestIncome(empCode: Code[20]; PattrCode: Code[20]; PayCycleTerm: Code[20]; payCycleperiod: Integer): Decimal
    // var
    //     InterestIncome: Record "Payroll Interest Income";
    // begin
    //     InterestIncome.Reset();
    //     InterestIncome.SetRange("Employee Code", empCode);
    //     InterestIncome.SetRange("Payroll Attribute", PattrCode);
    //     InterestIncome.SetRange("Pay Cycle Term", PayCycleTerm);
    //     InterestIncome.SetRange("Pay Cycle Period", payCycleperiod);
    //     InterestIncome.CalcSums("Interest Perquisite");
    //     exit(InterestIncome."Interest Perquisite")
    // end;

    procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[20])
    begin
        EmployeeFilter := empCode;
        PayCycleTerm := FiscalYear;
    end;
}
