report 50132 "Payroll Details Yearly"
{

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019933.PayrollDetailsYearly.rdl';
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
                    column(DeputationOn; "Deputation On") { }
                    column(DeputationCode; "Deputation Code") { }
                    column(SalaryLevelDescription; SalaryLevel.Description) { }
                    column(CurrentDeduction; CurrentDeduction) { }
                    column(NetPay; NetPay) { }
                    column(PayCycleTerm; PayCycleTerm) { }
                    column(Months; Months) { }
                    column(EmployeeSalaryLevel; EmployeeSalaryLevel) { }
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
                        /*CLEAR(FunctionalTitleVar);
                        CLEAR(DepartmentVar);*/

                        if DepartmentFilter <> '' then begin
                            if not ("Deputation On" in ["Deputation On"::Department, "Deputation On"::Unit]) then
                                CurrReport.Skip;
                            if "Deputation On" = "Deputation On"::Unit then begin
                                OrganizationStructureList.Reset;
                                // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                                // EmpHie.SetRange(Code, "Deputation Code");
                                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Deputation Code") then
                                    // if EmpHie.FindFirst then
                                    // if DepartmentVar.Get(EmpHie."Department Code") then;
                                    if OrganizationStructureList.Code <> DepartmentFilter then
                                        CurrReport.Skip;
                            end;
                            if "Deputation On" = "Deputation On"::Department then begin
                                if DepartmentFilter <> "Posted Payroll Line"."Deputation Code" then
                                    CurrReport.Skip;
                            end;
                        end;
                        // Clear(DepartmentVar);

                        /*IF SalaryLevel.GET("Posted Payroll Line"."Salary Level") THEN;
                        IF FunctionalTitleVar.GET("Posted Payroll Line"."Functional Title") THEN;

                        IF "Deputation On" = "Deputation On"::Department THEN
                          IF DepartmentVar.GET("Deputation Code") THEN;

                        IF "Deputation On" = "Deputation On"::Unit THEN BEGIN
                          EmpHie.RESET;
                          EmpHie.SETRANGE(Type,EmpHie.Type::Unit);
                          EmpHie.SETRANGE(Code,"Deputation Code");
                          IF EmpHie.FINDFIRST THEN
                            IF DepartmentVar.GET(EmpHie."Department Code") THEN;
                        END;*/
                        Clear(NetPay);
                        Clear(CurrentDeduction);
                        FirstTime := true;
                        if Employee.Get("Posted Payroll Line"."Employee No.") then begin //Min
                            EmployeeSalaryLevel := Employee."Salary Level";
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
                    if Months <> Months::" " then
                        SetRange("Nepali Month", Months);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*IF Months = Months::" " THEN
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
                    TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department));
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
        SalaryLevel: Record "Salary Level";
        RecRefs: RecordRef;
        FieldRefs: FieldRef;
        PayrollColumnConfig: Record "Payroll Column Configuration";
        Amt: Decimal;
        // DepartmentVar: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        OrganizationStructureList: Record "Organization Structure List";
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
        PayrollAttributeFilter: Code[20];
}
