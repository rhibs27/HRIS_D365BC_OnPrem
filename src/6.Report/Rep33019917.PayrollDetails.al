report 33019917 "Payroll Details"
{
    // //Min 3 feb 2022 (1.1) -- for add condition in months filter.
    // //Min 3 feb 2022 (1.2) -- Commented for skip months request page control.
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019917.PayrollDetails.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            dataitem("Posted Payroll Header"; "Posted Payroll Header")
            {
                DataItemTableView = where(Reversed = const(false));
                dataitem("Posted Payroll Line"; "Posted Payroll Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    column(EmployeeNo; "Employee No.") { }
                    column(EmployeeName; "Employee Name") { }
                    column(SalaryLevel; "Salary Level") { }
                    column(SalaryGrade; "Salary Grade") { }
                    column(PanNo; "Pan No.") { }
                    column(FunctionalTitle; "Functional Title") { }
                    column(BankAccountNo; "Bank Account No.") { }
                    column(DeputationOn; "Deputation On") { }
                    column(DeputationCode; "Deputation Code") { }
                    column(SalaryLevelDescription; SalaryLevel.Description) { }
                    column(FunctionalTitleVarDescription; FunctionalTitleVar.Description) { }
                    column(DepartmentVarName; DepartmentVar.Name) { }
                    column(CurrentDeduction; CurrentDeduction) { }
                    column(DepartmentVarCode; DepartmentVar.Code) { }
                    column(NetPay; NetPay) { }
                    column(MaritalStatus_PostedPayrollLine; "Posted Payroll Line"."Marital Status") { }
                    column(Gender_PostedPayrollLine; "Posted Payroll Line".Gender) { }
                    column(PayCycleTerm; PayCycleTerm) { }
                    column(Months; Months) { }
                    column(EmployeeSalaryLevel; EmployeeSalaryLevel) { }
                    column(EmployeePanNo; EmployeePanNo) { }
                    column(EmployeeSalaryLevelDesc; EmployeeSalaryLevelDesc) { }
                    dataitem("Payroll Attributes"; "Payroll Attributes")
                    {
                        column(Amount; Amt) { }
                        column(PayrollDescription; Description) { }
                        column(PayrollCode; Code) { }
                        column(SortingOrder; "Column Id") { }
                        column(Type_PayrollAttributes; "Payroll Attributes".Type) { }

                        trigger OnAfterGetRecord()
                        begin
                            Clear(Amt);
                            if FirstTime then begin
                                NetPay := "Posted Payroll Line"."Net Pay";
                                CurrentDeduction := "Posted Payroll Line"."Current Deduction";
                            end else begin
                                NetPay := 0;
                                CurrentDeduction := 0;
                            end;
                            FirstTime := false;
                            RecRefs.Open(Database::"Posted Payroll Line");
                            PayrollColumnConfig.Reset;
                            PayrollColumnConfig.SetRange("Table No.", Database::"Payroll Line");
                            PayrollColumnConfig.SetRange("Variable Field Code", Code);
                            if PayrollColumnConfig.FindFirst then begin
                                FieldRefs := RecRefs.Field(1);
                                FieldRefs.SetRange("Posted Payroll Line"."Document No.");
                                FieldRefs := RecRefs.Field(3);
                                FieldRefs.SetRange("Posted Payroll Line"."Employee No.");
                                RecRefs.FindFirst;
                                FieldRefs := RecRefs.Field(PayrollColumnConfig."Field No.");
                                Evaluate(Amt, Format(FieldRefs.Value));
                                Amt := Round(Amt, 0.01, '=');
                            end;
                            RecRefs.Close;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetFilter(Code, PayrollAttributeFilter); //Min
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(SalaryLevel);
                        Clear(FunctionalTitleVar);
                        Clear(DepartmentVar);

                        if DepartmentFilter <> '' then begin
                            if not ("Deputation On" in ["Deputation On"::Department, "Deputation On"::Unit]) then
                                CurrReport.Skip;
                            if "Deputation On" = "Deputation On"::Unit then begin
                                EmpHie.Reset;
                                EmpHie.SetRange(Type, EmpHie.Type::Unit);
                                EmpHie.SetRange(Code, "Deputation Code");
                                if EmpHie.FindFirst then
                                    if DepartmentVar.Get(EmpHie."Department Code") then;
                                if DepartmentVar.Code <> DepartmentFilter then
                                    CurrReport.Skip;
                            end;
                            if "Deputation On" = "Deputation On"::Department then begin
                                if DepartmentFilter <> "Posted Payroll Line"."Deputation Code" then
                                    CurrReport.Skip;
                            end;
                        end;
                        Clear(DepartmentVar);

                        if SalaryLevel.Get("Posted Payroll Line"."Salary Level") then;
                        if FunctionalTitleVar.Get("Posted Payroll Line"."Functional Title") then;

                        if "Deputation On" = "Deputation On"::Department then
                            if DepartmentVar.Get("Deputation Code") then;

                        if "Deputation On" = "Deputation On"::Unit then begin
                            EmpHie.Reset;
                            EmpHie.SetRange(Type, EmpHie.Type::Unit);
                            EmpHie.SetRange(Code, "Deputation Code");
                            if EmpHie.FindFirst then
                                if DepartmentVar.Get(EmpHie."Department Code") then;
                        end;
                        Clear(NetPay);
                        Clear(CurrentDeduction);
                        FirstTime := true;
                        if Employee.Get("Posted Payroll Line"."Employee No.") then begin //Min
                            EmployeeSalaryLevel := Employee."Salary Level";
                            EmployeePanNo := Employee."PAN No.";
                            EmployeeSalaryLevelDesc := Employee."Salary Level Description";
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Employee No.", EmployeeFilter);
                        SetFilter("Salary Level", SalaryLevelFilter);
                        SetFilter("Functional Title", FunctionalTitleFilter);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Pay Cycle Term", PayCycleTerm);
                    if Months <> Months::" " then //Min 3 feb 2022 (1.1)
                        SetRange("Nepali Month", Months);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*IF Months = Months::" " THEN //Min 3 feb 2022 (1.2)
                  ERROR('Please select a month.');*/
                if PayCycleTerm = '' then
                    Error('Please select a pay cycle term.');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(Employee; EmployeeFilter)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeFilter field.';
                    ApplicationArea = All;
                }
                field(Department; DepartmentFilter)
                {
                    TableRelation = Department;
                    ToolTip = 'Specifies the value of the DepartmentFilter field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; SalaryLevelFilter)
                {
                    TableRelation = "Salary Level";
                    ToolTip = 'Specifies the value of the SalaryLevelFilter field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; FunctionalTitleFilter)
                {
                    TableRelation = "Functional Title";
                    ToolTip = 'Specifies the value of the FunctionalTitleFilter field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; PayCycleTerm)
                {
                    TableRelation = "Pay Cycle Term".Term;
                    ToolTip = 'Specifies the value of the PayCycleTerm field.';
                    ApplicationArea = All;
                }
                field(Month; Months)
                {
                    ToolTip = 'Specifies the value of the Months field.';
                    ApplicationArea = All;
                }
                field("Payroll Attribute"; PayrollAttributeFilter)
                {
                    TableRelation = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the PayrollAttributeFilter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        FunctionalTitleVar: Record "Functional Title";
        SalaryLevel: Record "Salary Level";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        Amt: Decimal;
        DepartmentVar: Record Department;
        EmpHie: Record "Employee Hierarchy Master";
        DepartmentFilter: Text;
        SalaryLevelFilter: Text;
        FunctionalTitleFilter: Text;
        PayCycleTerm: Text;
        Months: Enum "Nepali Month";
        EmployeeFilter: Text;
        Employee: Record Employee;
        NetPay: Decimal;
        CurrentDeduction: Decimal;
        FirstTime: Boolean;
        EmployeeSalaryLevel: Code[20];
        EmployeePanNo: Code[20];
        EmployeeSalaryLevelDesc: Text;
        PayrollAttributeFilter: Code[20];
}
