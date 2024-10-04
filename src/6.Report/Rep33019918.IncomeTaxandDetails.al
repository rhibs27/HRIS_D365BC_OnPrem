report 33019918 "Income Tax and Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019918.IncomeTaxandDetails.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }
            column(FiscalYear; EngNepDate."Fiscal Year") { }
            dataitem(Employee; Employee)
            {
                column(EmployeeNo; "No.") { }
                column(EmployeeName; "Full Name") { }
                column(PanNo; "PAN No.") { }
                column(InsuranceAmount; "Premium Property Insurance") { }
                column(TaxOnRenum; TaxOnRenum) { }
                column(SSTAmt; SSTAmt) { }
                dataitem("Detailed Employee Ledger Entry"; "Detailed Employee Ledger Entry")
                {
                    DataItemLink = "Employee No." = field("No.");
                    DataItemTableView = where("Attribute Type" = filter("Basic Earning" | "Other Earnings" | Deduction));
                    column(AttributeCode; "Payroll Attribute Code") { }
                    column(AttributeAmount; Amt) { }
                    column(AttributeType; AttributeType) { }
                    column(Description; Description) { }
                    column(TotalRetirementFund; TotalRetirementFund) { }
                    column(TotalTaxable; TotalTaxable) { }

                    trigger OnAfterGetRecord()
                    var
                        PostedPayrollHead: Record "Posted Payroll Header";
                    begin
                        Clear(AttributeType);
                        Clear(Amt);
                        if "Attribute Type" = "Attribute Type"::Deduction then
                            if not ("Attribute Sub Type" in ["Attribute Sub Type"::CIT, "Attribute Sub Type"::"Lump Sum Contribution", "Attribute Sub Type"::RF,
                                                  "Attribute Sub Type"::"Employee Contribution", "Attribute Sub Type"::"Employer Contribution"]) then
                                CurrReport.Skip;

                        if "Attribute Sub Type" = "Attribute Sub Type"::"Lump Sum Contribution" then begin
                            if PostedPayrollHead.Get("Document No.") then
                                if PostedPayrollHead.Type in [PostedPayrollHead.Type::Payroll, PostedPayrollHead.Type::Resignation] then
                                    CurrReport.Skip;
                        end;

                        if "Attribute Type" = "Attribute Type"::Deduction then begin
                            AttributeType := 'Total Deductions';
                            Amt := -Amount;
                            TotalRetirementFund += Amt;
                            if TotalRetirementFund > 300000 then
                                TotalRetirementFund := 300000;
                        end else begin
                            AttributeType := 'Total Benefits';
                            Amt := Amount;
                            TotalTaxable += Amount;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Pay Cycle Term", PayCycleTerm);
                        SetFilter("Pay Period End Date", '<=%1', EndDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalRetirementFund);
                    Clear(TaxOnRenum);
                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", "No.");
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Tax on Remuneration & Benefits");
                    DetailedEmpLedger.SetFilter("Pay Period End Date", '<=%1', EndDate);
                    DetailedEmpLedger.SetRange("Pay Cycle Term", PayCycleTerm);
                    DetailedEmpLedger.CalcSums(Amount);
                    TaxOnRenum := -DetailedEmpLedger.Amount;

                    DetailedEmpLedger.Reset;
                    DetailedEmpLedger.SetRange("Employee No.", "No.");
                    DetailedEmpLedger.SetRange("Attribute Sub Type", DetailedEmpLedger."Attribute Sub Type"::"Social Security Tax");
                    DetailedEmpLedger.SetFilter("Pay Period End Date", '<=%1', EndDate);
                    DetailedEmpLedger.SetRange("Pay Cycle Term", PayCycleTerm);
                    DetailedEmpLedger.CalcSums(Amount);
                    SSTAmt := -DetailedEmpLedger.Amount;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("No.", EmployeeFilter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PayCycleTerm = '' then
                    Error('Please fill pay cycle term.');

                if EmployeeFilter = '' then
                    Error('Please fill employee filter.');

                PGSetup.Get;
                PayCyclePeriod.Reset;
                PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                if PayCyclePeriod.FindFirst then begin
                    EngNepDate.Reset;
                    EngNepDate.SetRange("English Date", PayCyclePeriod."Start Date");
                    if EngNepDate.FindFirst then;
                    FiscalYearStartDate := PayCyclePeriod."Start Date";
                end;

                if FiscalYearStartDate < PGSetup."Payroll Fiscal Year Start Date" then
                    EndDate := PGSetup."Payroll Fiscal Year End Date"
                else begin
                    PayCyclePeriod.Reset;
                    PayCyclePeriod.SetRange("Pay Cycle Term", PayCycleTerm);
                    PayCyclePeriod.SetRange("Nepali Month", PGSetup."HRMS Month");
                    PayCyclePeriod.SetCurrentKey("Start Date");
                    if PayCyclePeriod.FindFirst then
                        EndDate := PayCyclePeriod."End Date";
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Pay Cycle Term"; PayCycleTerm)
                {
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the PayCycleTerm field.';
                    ApplicationArea = All;
                }
                field("Employee Filter"; EmployeeFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        Title: Label 'Inome and Tax Calculation Detail for';
        PayCycleTerm: Code[20];
        EmployeeFilter: Code[20];
        AttributeType: Text;
        TotalRetirementFund: Decimal;
        DetailedEmpLedger: Record "Detailed Employee Ledger Entry";
        TaxOnRenum: Decimal;
        SSTAmt: Decimal;
        TotalTaxable: Decimal;
        Amt: Decimal;
        EngNepDate: Record "English-Nepali Date";
        PayCyclePeriod: Record "Pay Cycle Period";
        FiscalYearStartDate: Date;
        PGSetup: Record "Payroll General Setup";
        EndDate: Date;
}
