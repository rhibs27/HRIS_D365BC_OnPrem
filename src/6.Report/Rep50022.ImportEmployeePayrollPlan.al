report 50022 "Import Employee Payroll Plan"
{
    Caption = 'Import Employee Payroll Plan';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where("Do not Calculate Salary" = const(false),
                                      Settled = const(false));
            RequestFilterFields = "Employment Type";
            trigger OnPreDataItem()
            begin
                PGSetup.Get;
                AttendanceSetup.Get;
                PayrollLine.Reset;
                PayrollLine.SetRange("Document No.", PayrollHeader."No.");
                PayrollLine.DeleteAll(true);
                case PayrollHeader.Type of
                    PayrollHeader.Type::Resignation:
                        Employee.SetRange("Resignation Date", PayrollHeader."From Date", PayrollHeader."To Date");
                    PayrollHeader.Type::Settlement:
                        begin
                            Employee.SetRange(Status, Employee.Status::Inactive);
                            Employee.SetFilter("Contract Expiry Date", '>%1|%2', PGSetup."Payroll Fiscal Year Start Date", 0D);
                        end;
                    else begin
                        Employee.SetRange(Status, Employee.Status::Active);
                        Employee.SetFilter("Resignation Date", '%1|>%2', 0D, PayrollHeader."To Date");
                    end;
                end;

                if PayCyclePeriod.Get(PayrollHeader."Pay Cycle Code", PayrollHeader."Pay Cycle Term", PayrollHeader."Pay Cycle Period") then
                    Employee.SetFilter("Employment Date", '<%1', PayCyclePeriod."Pay Date");
                Employee.SetCurrentKey(Seniority);
                Employee.Ascending(false);
            end;

            trigger OnAfterGetRecord()
            begin
                if PayrollEngine.IsValidEmployee(Employee, PayrollHeader."From Date", PayrollHeader."To Date") then begin
                    PayrollLine.Init;
                    PayrollLine."Document No." := PayrollHeader."No.";
                    PayrollLine."Line No." := LineNo + 10000;
                    PayrollLine.Validate("Employee No.", Employee."No.");
                    PayrollLine.Validate("Functional Title", Employee."Functional Title");
                    PayrollLine.Validate("Employee Type", Employee."Employment Type");
                    PayrollLine.Validate("Bank Account No.", Employee."Bank Account No.");
                    PayrollLine.Validate("Resignation Date", Employee."Resignation Date");
                    if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::Attendance then begin
                        PayrollEngine.GetAttendanceForPayroll(PayrollLine, PayrollHeader);
                    end
                    else if AttendanceSetup."Type of Integration" = AttendanceSetup."Type of Integration"::"Time Sheet" then begin
                        // PayrollEngine.GetTimeSheetForPayroll(PayrollLine, Rec);
                    end;
                    PayrollLine.Insert(true);
                    LineNo += 10000;
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
                group(GroupName) { }
            }
        }
        actions
        {
            area(Processing) { }
        }
    }
    trigger OnPostReport()
    begin
        if PayrollHeader.IsEmpty() then
            Error('No Payroll Header is set. Please run the report from Payroll Plan page.');
    end;

    procedure SetPayrollHeader(PayrollPlanRec: Record "Payroll Header")
    begin
        PayrollHeader := PayrollPlanRec;
    end;

    var
        PGSetup: Record "Payroll General Setup";
        PayrollHeader: Record "Payroll Header";
        PayCyclePeriod: Record "Pay Cycle Period";
        AttendanceSetup: Record "Attendance Setup";
        PayrollLine: Record "Payroll Line";
        PayrollEngine: Codeunit "Payroll Engine";
        LineNo: Integer;
}