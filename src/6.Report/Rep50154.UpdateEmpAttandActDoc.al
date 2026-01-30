report 50154 "Update Emp Att. and Act Doc."
{
    ApplicationArea = All;
    Caption = 'Update Emp Att. and Act Doc.';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                Leave: Record Leave;
                EmpAttAndActLeave: Record "Employee Attendance & Activity";
                EmpAttAndActAttendance: Record "Employee Attendance & Activity";
                AttendanceMissed: Record "Attendance Missed";
            begin
                Leave.SetRange("Approval Status", Leave."Approval Status"::Pending);
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                    Leave.SetFilter("Start Date", '>=%1', StartDate);
                    Leave.SetFilter("End Date", '<=%1', EndDate);
                end;
                IF Leave.FindSet() then
                    repeat
                        EmpAttAndActLeave.Reset();
                        EmpAttAndActLeave.SetRange("Employee No.", Leave."Employee No.");
                        EmpAttAndActLeave.SetRange("Attendance Date", Leave."Start Date", Leave."End Date");
                        if EmpAttAndActLeave.FindSet() then
                            repeat
                                EmpAttAndActLeave."Pending Leave Request Doc No." := Leave."No.";
                                EmpAttAndActLeave.Modify();
                            until EmpAttAndActLeave.Next() = 0;
                    until Leave.Next() = 0;

                AttendanceMissed.SetRange("Approval Status", AttendanceMissed."Approval Status"::Pending);
                if StartDate <> 0D then
                    AttendanceMissed.SetRange("Start Date", StartDate);
                IF AttendanceMissed.FindSet() then begin
                    repeat
                        EmpAttAndActAttendance.Reset();
                        EmpAttAndActAttendance.SetRange("Employee No.", AttendanceMissed."Employee No.");
                        EmpAttAndActAttendance.SetRange("Attendance Date", AttendanceMissed."Start Date");
                        EmpAttAndActAttendance.ModifyAll("Pending Update Atten. Doc No.", AttendanceMissed."No.");
                    until AttendanceMissed.Next() = 0;
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
                group(Paramaters)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the StartDate field.';
                        Caption = 'Start Date';

                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EndDate field.';
                        Caption = 'End Date';

                    }
                    field(UpdatePendingDocNo; UpdatePendingDocNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the UpdatePendingDocNo field.';
                        Caption = 'Update Pending Document No.';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {

            }
        }
    }
    trigger OnPreReport()
    var
        EmpAttAndAct: Record "Employee Attendance & Activity";
    begin
        if (StartDate <> 0D) and (EndDate <> 0D) then
            EmpAttAndAct.SetRange("Attendance Date", StartDate, EndDate);
        EmpAttAndAct.ModifyAll("Pending Leave Request Doc No.", '');
        EmpAttAndAct.ModifyAll("Pending Leave Request Doc No.", '');
    end;

    var
        StartDate: Date;
        EndDate: Date;
        UpdatePendingDocNo: Boolean;
}
