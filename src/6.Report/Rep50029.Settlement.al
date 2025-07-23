report 50029 Settlement
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019830.Settlement.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Activity"; "Employee Activity")
        {
            column(EmployeeNo_EmployeeActivity; "Employee Activity"."Employee No.") { }
            column(EmployeeName_EmployeeActivity; "Employee Activity"."Employee Name") { }
            column(AppointmentDate; EmpRec."Employment Date") { }
            column(JobType; EmpRec."Employment Type") { }
            column(Gender; EmpRec.Gender) { }
            column(TaxCode; EmpRec."Tax Code") { }
            column(ProposedDateofResignation_EmployeeActivity; "Employee Activity"."Proposed Date of Resignation") { }
            column(ReasonforResignation_EmployeeActivity; "Employee Activity"."Reason for Resignation") { }
            column(WaiverCase_EmployeeActivity; "Employee Activity"."Waiver Case") { }
            column(SupervisorProposedDate_EmployeeActivity; "Employee Activity"."Supervisor Proposed Date") { }
            column(HRProposedDate_EmployeeActivity; "Employee Activity"."HR Proposed Date") { }
            column(PositionTxt; PositionTxt) { }
            column(BasicSalary; SalaryLevelRec."Basic Salary") { }
            column(Allowance; SalaryLevelRec.Allowance) { }
            column(FiscalYear; FiscalYear) { }
            column(NoticePeriod; NoticePeriod) { }
            column(GivenNoticePeriod; GivenNoticePeriod) { }
            column(TotalAnnualLeave; TotalAnnualLeave) { }
            column(TotalSickLeave; TotalSickLeave) { }
            column(ProrataAnnualLeave; ProrataAnnualLeave) { }
            column(ProrataSickLeave; ProrataSickLeave) { }
            column(LessAnnualLeave; LessAnnualLeave) { }
            column(LessSickLeave; LessSickLeave) { }
            column(TotalSalaryPerDay; TotalSalaryPerDay) { }
            column(TotalWorkedDaysinCurrMonth; TotalWorkedDaysinCurrMonth) { }

            trigger OnAfterGetRecord()
            begin
                EmpRec.Get("Employee No.");

                SalaryLevelRec.Get(EmpRec."Salary Level");
                if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, EmpRec."Department Code") then;
                PositionTxt := SalaryLevelRec.Description + OrganizationStructureList.Name + ' (' + HRMgt.WorkStationFunction(EmpRec) + ')';

                EngNep.Reset;
                EngNep.SetRange("English Date", "Supervisor Proposed Date");
                //EngNep.SETRANGE("Opening Fiscal Year", TRUE);
                if EngNep.FindFirst then
                    FiscalYear := EngNep."Fiscal Year";

                HRSetup.Get;
                if EmpRec."Employment Type" = EmpRec."Employment Type"::Contract then
                    NoticePeriod := HRSetup."Resignation Period Contract"
                else if EmpRec."Employment Type" = EmpRec."Employment Type"::Permanent then
                    NoticePeriod := HRSetup."Resignation Period Permanent"
                else if EmpRec."Employment Type" = EmpRec."Employment Type"::Probation then
                    NoticePeriod := HRSetup."Resignation Period Probation"
                else
                    NoticePeriod := 0;

                if ("Employee Activity"."Supervisor Proposed Date" <> 0D) and
                  ("Employee Activity"."Requested Date" <> 0D) then
                    GivenNoticePeriod := "Supervisor Proposed Date" - "Requested Date";

                LeaveEarn.Reset;
                LeaveEarn.SetRange("Employee No.", "Employee No.");
                LeaveEarn.SetFilter("Fiscal year", '<>%1', FiscalYear);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if LeaveEarn.FindFirst then
                    repeat
                        if LeaveEarn."Leave Code" = 'ANNUALL' then
                            TotalAnnualLeave += LeaveEarn."Balancing Days"
                        else if LeaveEarn."Leave Code" = 'SICK' then
                            TotalSickLeave += LeaveEarn."Balancing Days";
                    until LeaveEarn.Next = 0;

                LeaveEarn.Reset;
                LeaveEarn.SetRange("Employee No.", "Employee No.");
                LeaveEarn.SetRange("Fiscal year", FiscalYear);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Earned);
                if LeaveEarn.FindFirst then
                    repeat
                        if LeaveEarn."Leave Code" = 'ANNUALL' then
                            ProrataAnnualLeave += LeaveEarn."Balancing Days"
                        else if LeaveEarn."Leave Code" = 'SICK' then
                            ProrataSickLeave += LeaveEarn."Balancing Days";
                    until LeaveEarn.Next = 0;

                LeaveEarn.Reset;
                LeaveEarn.SetRange("Employee No.", "Employee Activity"."Employee No.");
                LeaveEarn.SetRange("Fiscal year", FiscalYear);
                LeaveEarn.SetRange(Type, LeaveEarn.Type::Used);
                if LeaveEarn.FindFirst then
                    repeat
                        if LeaveEarn."Leave Code" = 'ANNUALL' then
                            LessAnnualLeave += LeaveEarn."Balancing Days"
                        else if LeaveEarn."Leave Code" = 'SICK' then
                            LessSickLeave += LeaveEarn."Balancing Days";
                    until LeaveEarn.Next = 0;

                TotalSalaryPerDay := (SalaryLevelRec."Basic Salary" + SalaryLevelRec.Allowance) / 30;

                EngNep.Reset;
                EngNep.SetRange("English Date", "Supervisor Proposed Date");
                EngNep.SetRange("Fiscal Year", FiscalYear);
                if EngNep.FindFirst then begin
                    EffectiveDateNepali := Format(EngNep."Nepali Date");
                    CurrMonth := Format(EngNep."Nepali Month");
                end;

                EngNep.Reset;
                EngNep.SetCurrentKey("Nepali Date");
                EngNep.SetRange("Fiscal Year", FiscalYear);
                EngNep.SetFilter("Nepali Month", CurrMonth);
                if EngNep.FindFirst then
                    MonthStartDate := EngNep."English Date";

                if (MonthStartDate <> 0D) and ("Supervisor Proposed Date" <> 0D) then
                    TotalWorkedDaysinCurrMonth := "Supervisor Proposed Date" - MonthStartDate;

                EngNep.Reset;
                EngNep.SetCurrentKey("English Date");
                EngNep.SetRange("Fiscal Year", FiscalYear);
                if EngNep.FindFirst then
                    StartDate := EngNep."English Date";

                EngNep.Reset;
                EngNep.SetCurrentKey("English Date");
                EngNep.SetRange("Fiscal Year", FiscalYear);
                if EngNep.FindLast then
                    EndDate := EngNep."English Date";

                EmployeeLedgerEntries.Reset;
                EmployeeLedgerEntries.SetRange("Employee No.", "Employee No.");
                EmployeeLedgerEntries.SetFilter("Posting Date", '>=%1', StartDate);
                EmployeeLedgerEntries.SetFilter("Posting Date", '<=%1', EndDate);
                //EmployeeLedgerEntries.SETRANGE("Payroll Attribute Code", );
                if EmployeeLedgerEntries.FindFirst then;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        EmpRec: Record Employee;
        SalaryLevelRec: Record "Salary Level";
        PositionTxt: Text;
        HRMgt: Codeunit "HR Mgt.";
        // DeptRec: Record Department;
        OrganizationStructureList: Record "Organization Structure List";
        EngNep: Record "English-Nepali Date";
        FiscalYear: Text;
        HRSetup: Record "Human Resources Setup";
        NoticePeriod: Integer;
        GivenNoticePeriod: Integer;
        LeaveEarn: Record "Leave Earn";
        TotalAnnualLeave: Integer;
        TotalSickLeave: Integer;
        ProrataAnnualLeave: Integer;
        ProrataSickLeave: Integer;
        LessAnnualLeave: Integer;
        LessSickLeave: Integer;
        TotalSalaryPerDay: Decimal;
        EffectiveDateNepali: Text;
        CurrMonth: Text;
        MonthStartDate: Date;
        TotalWorkedDaysinCurrMonth: Integer;
        EmployeeLedgerEntries: Record "Employee Ledger Entry";
        StartDate: Date;
        EndDate: Date;
}
