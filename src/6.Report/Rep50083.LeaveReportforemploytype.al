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
                    column(ApprovalStatus; Leave."Approval Status") { }

                    trigger OnAfterGetRecord()
                    begin
                        CalcFields("Remaining Days");
                        Clear(DocNo);
                        Clear(Leave);

                        Leave.Reset;
                        Leave.SetRange("Employee No.", Employee."No.");
                        Leave.SetRange("Leave Code", "Leave Type Setup".Code);
                        Leave.SetRange(Cancelled, false);

                        Leave.SetRange(Type, Leave.Type::"Leave Request");
                        Leave.SetFilter("Approval Status", '<>%1&<>%2', Leave."Approval Status"::Approved, Leave."Approval Status"::Rejected);
                        if Leave.FindLast then
                            DocNo := Leave."No."
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
        Leave: Record "Leave";
        DocNo: Text;
        EmpAttendActivity: Record "Employee Attendance & Activity";
        AbsentDays: Integer;
        Title: Label 'Leave Report for Employment Type changed';
        EmpNo: Text;
}
