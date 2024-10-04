report 50083 "Leave Report for employ. type"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019884.LeaveReportforemploytype.rdl';
    UsageCategory = Lists;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }
            dataitem(Employee; Employee)
            {
                column(EmployeeNo; "No.") { }
                column(EmployeeName; "Full Name") { }
                column(AbsentDays; AbsentDays) { }
                dataitem("Leave Type Setup"; "Leave Type Setup")
                {
                    column(LeaveCode; Code) { }
                    column(LeaveDescription; Description) { }
                    column(RemainingDays_LeaveTypeSetup; "Leave Type Setup"."Remaining Days") { }
                    column(DocNo; DocNo) { }
                    column(ApprovalStatus; EmpActivity."Approval Status") { }

                    trigger OnAfterGetRecord()
                    begin
                        CalcFields("Remaining Days");
                        Clear(DocNo);
                        Clear(EmpActivity);

                        EmpActivity.Reset;
                        EmpActivity.SetRange("Employee No.", Employee."No.");
                        EmpActivity.SetRange("Leave Code", "Leave Type Setup".Code);
                        EmpActivity.SetRange(Cancelled, false);
                        EmpActivity.SetRange("Cancelled Document No.", '');
                        EmpActivity.SetRange("Cancelled No.", '');
                        EmpActivity.SetRange(Type, EmpActivity.Type::"Leave Request");
                        EmpActivity.SetFilter("Approval Status", '<>%1&<>%2', EmpActivity."Approval Status"::Approved, EmpActivity."Approval Status"::Rejected);
                        if EmpActivity.FindLast then
                            DocNo := EmpActivity."No."
                        else
                            DocNo := StrSubstNo('No pending document for leave type %1', Description);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Employee No. Filter", Employee."No.");
                        SetFilter("Leave For Employee Type", '%1|%2', Employee."Employment Type", "Leave For Employee Type"::" ");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(AbsentDays);
                    Clear(EmpAttendActivity);
                    EmpAttendActivity.Reset;
                    EmpAttendActivity.SetRange("Employee No.", Employee."No.");
                    EmpAttendActivity.SetRange("Absent Day", 1);
                    EmpAttendActivity.SetRange("Leave Day", 0);
                    AbsentDays := EmpAttendActivity.Count;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("No.", EmpNo);
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
                field(EmpNo; EmpNo)
                {
                    Caption = 'Employee Filter';
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the Employee Filter field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    var
        EmpActivity: Record "Employee Activity";
        DocNo: Text;
        EmpAttendActivity: Record "Employee Attendance & Activity";
        AbsentDays: Integer;
        Title: Label 'Leave Report for Employment Type changed';
        EmpNo: Text;
}
