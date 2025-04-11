report 50118 "Salary Sheet Doc Monthwise"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019919.SalarySheetDocMonthwise.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(PANNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyPhNo; CompanyInfo."Phone No.") { }
            column(EmployeeDesignation; EmpDes.Description) { }
            column(CITNo; EmpVar."CIT No.") { }
            column(PFNo; EmpVar."PF No.") { }
            column(EmpFullName; EmpVar."Full Name") { }
            column(PANNo_Employee; EmpVar."PAN No.") { }
            column(BankName; EmpVar."Bank Name") { }
            column(BankAccountNo; EmpVar."Bank Account No.") { }
            column(EmployeeBranch; EmpVar."Insurance Name") { }
            column(EmployeeSalaryLevel; EmpVar."Salary Level Description") { }
            column(TodayFormatted; TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('d')) { }
            column(EmployeeCode; EmpVar."No.") { }
            column(FilterText; FilterText) { }
            column(MultipleEmloyee; MultipleEmloyee) { }
            column(NepaliMonthText; NepaliMonth) { }
            dataitem("Payroll Attributes"; "Payroll Attributes")
            {
                column("Code"; Code) { }
                column(Description; Description) { }
                column(Types; Type) { }
                column(ReportName; ReportName) { }
                column(SortinNo; "Column Id") { }
                dataitem("Posted Payroll Header"; "Posted Payroll Header")
                {
                    DataItemTableView = where(Reversed = const(false));
                    column(PayCycleTerm_PayCyclePeriodvy; "Pay Cycle Term") { }
                    column(Period; "Pay Cycle Period") { }
                    column(NepaliMonth; "Nepali Month") { }
                    column(Amount; Amount) { }
                    column(BenefitAmount; BenefitAmount) { }
                    column(DeductionAmount; DeductionAmount) { }
                    column(DocNo; "No.") { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(Amount);
                        PostedPayrollLine.Reset;
                        PostedPayrollLine.SetFilter("Employee No.", EmployeeFilter);
                        PostedPayrollLine.SetRange("Document No.", "No.");
                        if not PostedPayrollLine.FindFirst then
                            CurrReport.Skip;
                        DetaliedEmpLedgerPRM.Reset;
                        DetaliedEmpLedgerPRM.SetRange("Pay Cycle Term", PayCycleTerm);
                        DetaliedEmpLedgerPRM.SetFilter("Employee No.", EmployeeFilter);
                        DetaliedEmpLedgerPRM.SetRange("Document No.", "No.");
                        DetaliedEmpLedgerPRM.SetFilter("Attribute Sub Type", '<>%1&<>%2', DetaliedEmpLedgerPRM."Attribute Sub Type"::"Lump Sum Contribution", DetaliedEmpLedgerPRM."Attribute Sub Type"::"Tax on Interest");
                        DetaliedEmpLedgerPRM.SetRange("Payroll Attribute Code", "Payroll Attributes".Code);
                        DetaliedEmpLedgerPRM.CalcSums(Amount);
                        Amount := (DetaliedEmpLedgerPRM.Amount);

                        BenefitAmount := 0;
                        DeductionAmount := 0;
                        if "Payroll Attributes".Type = "Payroll Attributes".Type::Benefits then
                            BenefitAmount := Amount
                        else if "Payroll Attributes".Type = "Payroll Attributes".Type::Deduction then
                            DeductionAmount := -1 * Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Pay Cycle Term", PayCycleTerm);
                        if NepaliMonth <> NepaliMonth::" " then
                            SetFilter("Nepali Month", '%1', NepaliMonth);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Subtype in [Subtype::"Lump Sum Contribution", Subtype::"Tax on Interest"] then
                        CurrReport.Skip;
                    SortinNo := 0;
                    PayrollColumnConfig.Reset;
                    PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                    PayrollColumnConfig.SetRange("Variable Field Code", Code);
                    if PayrollColumnConfig.FindFirst then
                        SortinNo := PayrollColumnConfig."Field No.";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // EmpVar.Reset;
                // EmpVar.SetFilter("No.", EmployeeFilter);
                // if EmpVar.FindFirst() then;
                // if EmpDes.Get(EmpVar.Office) then;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
                field(Employee; EmployeeFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; NepaliMonth)
                {
                    ToolTip = 'Specifies the value of the NepaliMonth field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        //IF EmployeeFilter = '' THEN
        //ERROR('Employee Filter cannot be blank');
        if PayCycleTerm = '' then
            Error('Pay cycle term cannot be blank');
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        ReportName := StrSubstNo(ReportCaption, PayCycleTerm);

        if (EmployeeFilter = '') or (StrPos(EmployeeFilter, '|') <> 0) then
            MultipleEmloyee := true
        else
            MultipleEmloyee := false;

        FilterText := 'Pay Cycle Term: ' + PayCycleTerm;
        if NepaliMonth <> NepaliMonth::" " then
            FilterText += '   Month: ' + Format(NepaliMonth);
    end;

    var
        Amount: Decimal;
        DetaliedEmpLedgerPRM: Record "Detailed Employee Ledger Entry";
        PayCycleTerm: Code[10];
        EmployeeFilter: Code[10];
        EmpVar: Record Employee;
        CompanyInfo: Record "Company Information";
        TypeHelper: Codeunit "Type Helper";
        BenefitAmount: Decimal;
        DeductionAmount: Decimal;
        ReportCaption: Label 'Yearly Payroll Report - %1';
        ReportName: Text;
        EmpDes: Record "Functional Title";
        PayrollColumnConfig: Record "Payroll Column Configuration";
        SortinNo: Integer;
        DepartmentCode: Code[20];
        SalaryLevel: Code[20];
        FunctionalTitle: Code[20];
        PostedPayHeader: Record "Posted Payroll Header";
        NepaliMonth: Enum "Nepali Month";
        MultipleEmloyee: Boolean;
        FilterText: Text;
        PostedPayrollLine: Record "Posted Payroll Line";

    procedure PassParPortal(empCode: Code[20]; FiscalYear: Code[10])
    begin
        EmployeeFilter := empCode;
        PayCycleTerm := FiscalYear;
    end;
}
