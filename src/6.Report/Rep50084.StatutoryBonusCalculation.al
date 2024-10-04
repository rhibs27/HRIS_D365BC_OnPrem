report 50084 "Statutory Bonus Calculation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019885.StatutoryBonusCalculation.rdl';
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin

                LWPDays := 0;
                AbsentDays := 0;
                Employee.TestField("Employment Date");

                InitialBonusDays := 0;
                AverageMonthlyEarning := 0;
                TotalEarning := 0;

                if Employee.Status = Employee.Status::Active then begin
                    if Employee."Employment Date" < PayCycleStartDate then
                        InitialBonusDays := PayCycleEndDate - PayCycleStartDate + 1
                    else
                        InitialBonusDays := PayCycleEndDate - Employee."Employment Date" + 1;
                end else begin
                    Employee.TestField("Resignation Date");
                    if Employee."Employment Date" < PayCycleStartDate then
                        InitialBonusDays := Employee."Resignation Date" - PayCycleStartDate + 1
                    else
                        InitialBonusDays := Employee."Resignation Date" - Employee."Employment Date" + 1;
                end;

                LWPDays := GetLWPDays(Employee."No.");
                AbsentDays := GetAbsentDays(Employee."No.");
                InitialBonusDays -= (LWPDays + AbsentDays);

                TotalEarning := CalculateTotalEarning(Employee."No.");
                AverageMonthlyEarning := CalculateAverageMonthlyEarning;
                TotalAverageMonthlyEarning += AverageMonthlyEarning;

                TempPayrollLine.Init;
                TempPayrollLine."Line No." := LineNo;
                TempPayrollLine."Employee No." := Employee."No.";
                TempPayrollLine."Employee Name" := Employee."Full Name";
                TempPayrollLine."Current Benefit" := InitialBonusDays;
                TempPayrollLine."Basic Salary" := TotalEarning;
                TempPayrollLine."Variable Field 50490" := AverageMonthlyEarning;
                TempPayrollLine."Present Days" := LWPDays;
                TempPayrollLine."Absent Days" := AbsentDays;
                TempPayrollLine."Net Pay" := TotalEarning / 12;
                if InitialBonusDays >= 182.5 then
                    TempPayrollLine."Functional Title" := 'Eligible'
                else
                    TempPayrollLine."Functional Title" := 'Ineligible';

                if Employee.Status = Employee.Status::Active then
                    TempPayrollLine."Bank Name" := 'Active'
                else
                    TempPayrollLine."Bank Name" := 'Inactive';
                TempPayrollLine."Employee Type" := Employee."Employment Type";
                TempPayrollLine."Late Days" := LWPDays + AbsentDays + InitialBonusDays;
                SalaryLevel.Reset;
                SalaryLevel.SetRange(Code, Employee."Salary Level");
                if SalaryLevel.FindFirst then
                    TempPayrollLine.Remarks := SalaryLevel.Description;
                TempPayrollLine.Insert;
                LineNo += 10000;
            end;

            trigger OnPreDataItem()
            begin
                Employee.SetFilter("Employment Date", '<=%1', PayCycleEndDate);
                LineNo := 10000;
                TotalAverageMonthlyEarning := 0;
            end;
        }
        dataitem(TempPayrollLine; "Payroll Line")
        {
            UseTemporary = true;
            column(TotalAverageMonthlyEarning; PayrollGeneralSetup."Distributable Amt. for Statuto") { }
            column(AverageMonthlyEarning; AverageMonthlyEarning) { }
            column(EmployeeName_TempPayrollLine; TempPayrollLine."Employee Name") { }
            column(EmployeeNo_TempPayrollLine; TempPayrollLine."Employee No.") { }
            column(TotalEarning; TempPayrollLine."Basic Salary") { }
            column(AvgMonthlyEarn; TotalAverageMonthlyEarning) { }
            column(eligiblebonus; TempPayrollLine."Variable Field 50491") { }
            column(eligibleDays; TempPayrollLine."Current Benefit") { }
            column(LWPDays; TempPayrollLine."Present Days") { }
            column(AbsentDays; TempPayrollLine."Absent Days") { }
            column(bal; TempPayrollLine."Net Pay") { }
            column(EmployeeType_TempPayrollLine; TempPayrollLine."Employee Type") { }
            column(BankName_TempPayrollLine; TempPayrollLine."Bank Name") { }
            column(FunctionalTitle_TempPayrollLine; TempPayrollLine."Functional Title") { }
            column(SalaryLevel_TempPayrollLine; TempPayrollLine.Remarks) { }
            column(LateDays_TempPayrollLine; TempPayrollLine."Late Days") { }

            trigger OnAfterGetRecord()
            begin
                TempPayrollLine."Variable Field 50491" := TempPayrollLine."Variable Field 50490" / TotalAverageMonthlyEarning * PayrollGeneralSetup."Distributable Amt. for Statuto";
                TempPayrollLine.Modify;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(FiscalYear; FiscalYear)
                {
                    Caption = 'Fiscal Year';
                    TableRelation = "Pay Cycle";
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        PayrollGeneralSetup.Get;

        PayCyclePeriod.Reset;
        PayCyclePeriod.SetRange("Pay Cycle Code", FiscalYear);
        PayCyclePeriod.FindFirst;
        PayCycleStartDate := PayCyclePeriod."Start Date";

        PayCyclePeriod.FindLast;
        PayCycleEndDate := PayCyclePeriod."End Date";
    end;

    var
        PayrollGeneralSetup: Record "Payroll General Setup";
        FiscalYear: Code[20];
        PayCyclePeriod: Record "Pay Cycle Period";
        PayCycleStartDate: Date;
        PayCycleEndDate: Date;
        InitialBonusDays: Decimal;
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        TotalEarning: Decimal;
        AverageMonthlyEarning: Decimal;
        TotalAverageMonthlyEarning: Decimal;
        LineNo: Integer;
        LWPDays: Decimal;
        AbsentDays: Decimal;
        SalaryLevel: Record "Salary Level";

    local procedure GetLWPDays(EmployeeNo: Code[20]): Decimal
    begin
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeNo);
        EmployeeAttendanceActivity.SetRange("Attendance Date", PayCycleStartDate, PayCycleEndDate);
        EmployeeAttendanceActivity.SetRange("Pay Type", EmployeeAttendanceActivity."Pay Type"::Unpaid);
        exit(EmployeeAttendanceActivity.Count);
    end;

    local procedure GetAbsentDays(EmployeeNo: Code[20]): Decimal
    begin
        EmployeeAttendanceActivity.Reset;
        EmployeeAttendanceActivity.SetRange("Employee No.", EmployeeNo);
        EmployeeAttendanceActivity.SetRange("Attendance Date", PayCycleStartDate, PayCycleEndDate);
        EmployeeAttendanceActivity.SetRange("Absent Day", 1);
        exit(EmployeeAttendanceActivity.Count);
    end;

    local procedure CalculateTotalEarning(EmployeeNo: Code[20]): Decimal
    begin
        DetailedEmployeeLedgerEntry.Reset;
        DetailedEmployeeLedgerEntry.SetRange("Employee No.", EmployeeNo);
        DetailedEmployeeLedgerEntry.SetRange("Posting Date", PayCycleStartDate, PayCycleEndDate);
        DetailedEmployeeLedgerEntry.SetFilter("Payroll Attribute Code", 'BASIC|DASHAIN BONUS|LFA|GRADE|ALLOWANCE');
        DetailedEmployeeLedgerEntry.CalcSums(Amount);
        exit(DetailedEmployeeLedgerEntry.Amount);
    end;

    local procedure CalculateAverageMonthlyEarning(): Decimal
    begin
        exit(TotalEarning / 12);
    end;
}
