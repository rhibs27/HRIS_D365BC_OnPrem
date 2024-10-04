report 33019879 "Leave With Dates"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019879.LeaveWithDates.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }
            column(FilterText; Filter) { }
            dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
            {
                DataItemTableView = where("Leave Day" = const(1));
                RequestFilterFields = "Employee No.";
                column(EmployeeNo; "Employee No.") { }
                column(AttendanceDate; "Attendance Date") { }
                column(SourceNo; "Source No.") { }
                column(FullName; Employee."Full Name") { }
                column(LeaveCode; EmpActivity."Leave Code") { }
                column(LeaveDescription; EmpActivity."Leave Description") { }

                trigger OnAfterGetRecord()
                begin
                    Employee.Get("Employee No.");
                    Clear(EmpActivity);
                    if EmpActivity.Get("Source No.") then;
                end;

                trigger OnPreDataItem()
                begin
                    if (FromDate <> 0D) and (ToDate <> 0D) then begin
                        if FromDate > ToDate then
                            Error('From Date cannot be greater than to date');
                        SetFilter("Attendance Date", '%1..%2', FromDate, ToDate)
                    end else if ToDate <> 0D then
                            SetFilter("Attendance Date", '..%1', ToDate)
                    else if FromDate <> 0D then
                        SetFilter("Attendance Date", '%1..', FromDate);
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("From Date"; FromDate)
                {
                    ToolTip = 'Specifies the value of the FromDate field.';
                    ApplicationArea = All;
                }
                field("To Date"; ToDate)
                {
                    ToolTip = 'Specifies the value of the ToDate field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        Filter := StrSubstNo('"Filter Date": %1 to %2', FromDate, ToDate);
    end;

    var
        Employee: Record Employee;
        EmpActivity: Record "Employee Activity";
        "Filter": Text;
        Title: Label 'Leave with Dates';
        FromDate: Date;
        ToDate: Date;
}
