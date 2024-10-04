report 50075 "Tax Audit Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019876.TaxAuditSheet.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            dataitem(Employee; Employee)
            {
                DataItemTableView = sorting("No.") order(ascending) where(Status = const(Active));
                RequestFilterFields = "No.", "Employment Type";
                column(SNo; SNo) { }
                column(EmployeeNo; "No.") { }
                column(EmployeeName; "Full Name") { }
                column(PANNo; "PAN No.") { }
                column(BankAccountNo; "Bank Account No.") { }
                column(Position; "Salary Level Description") { }
                column(Gender; Gender) { }
                column(MaritalStatus; "Marital Status") { }
                column(JobType; "Employment Type") { }
                column(FirstSlab; FirstSlab) { }
                column(SecondSlab; SecondSlab) { }
                column(ThirdSlab; ThirdSlab) { }
                column(FourthSlab; FourthSlab) { }
                column(FifthSlab; FifthSlab) { }
                column(CITAmount; CITAmount) { }
                column(PFAmount; PFAmount) { }
                column(LumpSum; LumpSum) { }
                column(RFAmount; RFAmount) { }
                column(TotalDeduction; TotalDeduction) { }
                column(LifeInsuranceAmount; LifeInsuranceAmount) { }
                column(HealthInsuranceAmount; HealthInsuranceAmount) { }
                column(SSTax; SSTax) { }
                column(TaxonRenum; TaxonRenum) { }
                column(AsonDate; AsonDate) { }
                column(RemoteAreaDeduction; RemoteAreaDeduction) { }
                column(FemaleTaxCredit; FemaleTaxCredit) { }
                column(BenefitOpen; EmployeeOpen."Total Benefit Opening") { }
                column(RFOpen; EmployeeOpen."Total RF Opening") { }
                dataitem("Payroll Attributes"; "Payroll Attributes")
                {
                    DataItemTableView = where("Non-Taxable" = const(false), Type = const(Benefits));
                    column(PayrollCode; Code) { }
                    column(Type; Type) { }
                    column(Amount; Amt) { }
                    column(BenefitAmt; BenefitAmt) { }
                    column(SortingOrder; "Column Id") { }

                    trigger OnAfterGetRecord()
                    begin
                        Amt := 0;
                        DetailedEmpLedger.Reset;
                        DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                        DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);
                        DetailedEmpLedger.SetRange("Payroll Attribute Code", Code);
                        DetailedEmpLedger.CalcSums(Amount);
                        Amt := DetailedEmpLedger.Amount;
                        BenefitAmt += Amt;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(CITAmount);
                    Clear(PFAmount);
                    Clear(LumpSum);
                    Clear(RFAmount);
                    Clear(HealthInsuranceAmount);
                    Clear(LifeInsuranceAmount);
                    Clear(TotalDeduction);
                    Clear(TaxonRenum);
                    Clear(SSTax);
                    Clear(RemoteAreaDeduction);
                    Clear(FemaleTaxCredit);

                    Clear(FirstSlab);
                    Clear(SecondSlab);
                    Clear(ThirdSlab);
                    Clear(FourthSlab);
                    Clear(FifthSlab);
                    Clear(TotalTax);

                    Clear(EmployeeOpen);
                    Clear(PostedPayrollHeader);
                    Clear(PostedPayrollLine);
                    EmployeeOpen.Reset;
                    EmployeeOpen.SetRange("Employee No.", "No.");
                    EmployeeOpen.SetRange("Fiscal Year", HRMgt.ReturnFiscalYear(AsonDate));
                    if EmployeeOpen.FindFirst then;
                    PostedPayrollHeader.Reset;
                    PostedPayrollHeader.SetRange("From Date", StartDate, AsonDate);
                    PostedPayrollHeader.SetRange(Type, PostedPayrollHeader.Type::Payroll);
                    PostedPayrollHeader.SetRange(Reversed, false);
                    if PostedPayrollHeader.FindLast then
                        repeat
                            PostedPayrollLine.Reset;
                            PostedPayrollLine.SetRange("Document No.", PostedPayrollHeader."No.");
                            PostedPayrollLine.SetRange("Employee No.", Employee."No.");
                            if PostedPayrollLine.FindFirst then begin
                                FirstSlab := Round(PostedPayrollLine."1% Slab");
                                SecondSlab := Round(PostedPayrollLine."10% Slab");
                                ThirdSlab := Round(PostedPayrollLine."20% Slab");
                                FourthSlab := Round(PostedPayrollLine."30% Slab");
                                FifthSlab := Round(PostedPayrollLine."36% Slab");
                                TotalTax := Round(PostedPayrollLine."Tax for Period");
                                RemoteAreaDeduction := Round(PostedPayrollLine."Remote Area Deduction", 0.01, '=');
                                FemaleTaxCredit := Round(PostedPayrollLine."Female Tax Credit", 0.01, '=');
                            end;
                            if FirstSlab <> 0 then
                                break;
                        until PostedPayrollHeader.Next(-1) = 0;
                    SNo += 1;
                    BenefitAmt := 0;

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                    DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);
                    DetailedEmpLedger.SetRange("Attribute Type", DetailedEmpLedger."Attribute Type"::Deduction);
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::CIT);
                    DetailedEmpLedger.SetRange(Reversed, false);
                    DetailedEmpLedger.SetRange(Disabled, false);
                    DetailedEmpLedger.CalcSums(Amount);
                    CITAmount := Abs(DetailedEmpLedger.Amount);

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                    DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);
                    DetailedEmpLedger.SetRange("Attribute Type", DetailedEmpLedger."Attribute Type"::Deduction);
                    DetailedEmpLedger.SetFilter("Attribute Sub Type", '%1|%2', DetailedEmpLedger."Attribute Sub Type"::"Employee Contribution",
                                                DetailedEmpLedger."Attribute Sub Type"::"Employer Contribution");
                    DetailedEmpLedger.SetRange(Reversed, false);
                    DetailedEmpLedger.SetRange(Disabled, false);
                    DetailedEmpLedger.CalcSums(Amount);
                    PFAmount := Abs(DetailedEmpLedger.Amount);

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                    DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);
                    DetailedEmpLedger.SetRange("Attribute Type", DetailedEmpLedger."Attribute Type"::Deduction);
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Lump Sum Contribution");
                    DetailedEmpLedger.SetRange(Reversed, false);
                    DetailedEmpLedger.SetRange(Disabled, false);
                    DetailedEmpLedger.CalcSums(Amount);
                    //LumpSum := ABS(DetailedEmpLedger.Amount);

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                    DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);
                    DetailedEmpLedger.SetRange("Attribute Type", DetailedEmpLedger."Attribute Type"::Deduction);
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::RF);
                    DetailedEmpLedger.SetRange(Reversed, false);
                    DetailedEmpLedger.SetRange(Disabled, false);
                    DetailedEmpLedger.CalcSums(Amount);
                    RFAmount := Abs(DetailedEmpLedger.Amount);

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                    DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);
                    DetailedEmpLedger.SetRange("Attribute Type", DetailedEmpLedger."Attribute Type"::Deduction);
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Social Security Tax");
                    DetailedEmpLedger.SetRange(Reversed, false);
                    DetailedEmpLedger.SetRange(Disabled, false);
                    DetailedEmpLedger.CalcSums(Amount);

                    SSTax := Abs(DetailedEmpLedger.Amount) + EmployeeOpen."Total Social Security Opening";

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", Employee."No.");
                    DetailedEmpLedger.SetRange("Pay Period Start Date", StartDate, AsonDate);

                    DetailedEmpLedger.SetRange("Attribute Type", DetailedEmpLedger."Attribute Type"::Deduction);
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Tax on Remuneration & Benefits");
                    DetailedEmpLedger.SetRange(Reversed, false);
                    DetailedEmpLedger.SetRange(Disabled, false);
                    DetailedEmpLedger.CalcSums(Amount);
                    TaxonRenum := Abs(DetailedEmpLedger.Amount) + EmployeeOpen."Total Tax Remuneration Opening";

                    if (CITAmount + RFAmount + LumpSum + PFAmount + EmployeeOpen."Total RF Opening") > PGSetup."Tax Ex. Amt. not Exceeding" then
                        TotalDeduction := PGSetup."Tax Ex. Amt. not Exceeding"
                    else
                        TotalDeduction := CITAmount + RFAmount + LumpSum + PFAmount + EmployeeOpen."Total RF Opening";

                    if Employee."Premium of Life Insurance" > PGSetup."Tax Ex. Life Insurance Amt." then
                        LifeInsuranceAmount := PGSetup."Tax Ex. Life Insurance Amt."
                    else
                        LifeInsuranceAmount := Employee."Premium of Life Insurance";

                    if Employee."Premium of Health Insurance" > PGSetup."Tax Ex. Health Insur. Amount" then
                        HealthInsuranceAmount := PGSetup."Tax Ex. Health Insur. Amount"
                    else
                        HealthInsuranceAmount := Employee."Premium of Health Insurance";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PGSetup.Get;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(AsonDate; AsonDate)
                {
                    Caption = 'As on date';
                    ToolTip = 'Specifies the value of the As on date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        EngNepDate.Reset;
                        EngNepDate.SetRange("English Date", AsonDate);
                        if EngNepDate.FindFirst then
                            FiscalYear := EngNepDate."Fiscal Year";

                        EngNepDate.Reset;
                        EngNepDate.SetRange("Fiscal Year", FiscalYear);
                        EngNepDate.SetCurrentKey("English Date");
                        if EngNepDate.FindFirst then
                            StartDate := EngNepDate."English Date";
                    end;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        SNo := 0;
        if AsonDate = 0D then
            Error('As on date must have value.');
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", AsonDate);
        if EngNepDate.FindFirst then
            FiscalYear := EngNepDate."Fiscal Year";

        EngNepDate.Reset;
        EngNepDate.SetRange("Fiscal Year", FiscalYear);
        EngNepDate.SetCurrentKey("English Date");
        if EngNepDate.FindFirst then
            StartDate := EngNepDate."English Date";
    end;

    var
        AsonDate: Date;
        PostedPayrollHeader: Record "Posted Payroll Header";
        SNo: Integer;
        Amt: Decimal;
        EngNepDate: Record "English-Nepali Date";
        FiscalYear: Text;
        StartDate: Date;
        PostedPayrollLine: Record "Posted Payroll Line";
        BenefitAmt: Decimal;
        FirstSlab: Decimal;
        SecondSlab: Decimal;
        ThirdSlab: Decimal;
        FourthSlab: Decimal;
        FifthSlab: Decimal;
        TotalTax: Decimal;
        DetailedEmpLedger: Record "Detailed Employee Ledger Entry";
        CITAmount: Decimal;
        PFAmount: Decimal;
        LumpSum: Decimal;
        RFAmount: Decimal;
        PGSetup: Record "Payroll General Setup";
        TotalDeduction: Decimal;
        LifeInsuranceAmount: Decimal;
        HealthInsuranceAmount: Decimal;
        SSTax: Decimal;
        TaxonRenum: Decimal;
        RemoteAreaDeduction: Decimal;
        FemaleTaxCredit: Decimal;
        EmployeeOpen: Record "Employee Payroll Opening";
        HRMgt: Codeunit "HR Mgt.";
}
