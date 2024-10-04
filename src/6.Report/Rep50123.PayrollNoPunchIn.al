report 50123 "Payroll No Punch In"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019924.PayrollNoPunchIn.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(ReportName; ReportName) { }
            dataitem(Employee; Employee)
            {
                column(No_; Employee."No.") { }
                column(FullName_; Employee."Full Name") { }
                column(SalaryLevel_; Employee."Salary Level Description") { }
                column(FunctionalTitle_; Employee."Functional Title Desc") { }
                column(AbsentDayCount; AbsentDayCount) { }
                column(AbsentDate; AbsentDate) { }

                trigger OnAfterGetRecord()
                begin
                    AbsentDayCount := 0;
                    EmployeeAttendActivity.Reset();
                    EmployeeAttendActivity.SetRange("Employee No.", Employee."No.");
                    EmployeeAttendActivity.SetRange("Leave Day", 0);
                    EmployeeAttendActivity.SetRange("Present Day", 0);
                    EmployeeAttendActivity.SetRange("Absent Day", 1);
                    AbsentDayCount := EmployeeAttendActivity.Count;
                    AbsentDate := '';
                    if EmployeeAttendActivity.FindFirst then
                        repeat
                            if AbsentDate = '' then
                                AbsentDate := Format(EmployeeAttendActivity."Attendance Date")
                            else
                                AbsentDate := ', ' + Format(EmployeeAttendActivity."Attendance Date");
                        until EmployeeAttendActivity.Next = 0;
                end;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ReportName: Integer;
        CompanyInfo: Record "Company Information";
        EmployeeAttendActivity: Record "Employee Attendance & Activity";
        AbsentDayCount: Integer;
        AbsentDate: Text;
}
