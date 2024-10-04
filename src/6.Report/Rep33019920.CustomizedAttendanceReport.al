report 33019920 "Customized Attendance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019920.CustomizedAttendanceReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(Title; Title) { }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            dataitem(Employee; Employee)
            {
                column(No; "No.") { }
                column(FullName; "Full Name") { }
                dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
                {
                    DataItemLink = "Employee No." = field("No.");
                    column(AttendanceDate; "Attendance Date") { }
                    column(CheckInTime; "Check In Time") { }
                    column(CheckOutTime; "Check Out Time") { }
                    column(HolidayRemarks; "Holiday Remarks") { }
                    column(AttendanceText; AttendanceText) { }
                    column(Day; EnglishNepDate.Week) { }
                    column(PunchOutRemarks; AttendanceLog."Punch out Remarks") { }
                    column(LateRemarks; AttendanceLog."Late Remarks") { }
                    column(AttendanceRemarks; AttendanceRemarks) { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(EnglishNepDate);
                        Clear(AttendanceText);
                        Clear(AttendanceRemarks);
                        EnglishNepDate.SetRange("English Date", "Attendance Date");
                        if EnglishNepDate.FindFirst then;

                        Clear(AttendanceLog);
                        AttendanceLog.SetRange(Date, "Attendance Date");
                        AttendanceLog.SetRange("Employee ID", "Employee No.");
                        if AttendanceLog.FindFirst then;

                        if "Leave Day" = 1 then
                            AttendanceText := 'Leave'
                        else if "Present Day" = 1 then
                            AttendanceText := 'Present'
                        else if "Week Off Day" = 1 then
                            AttendanceText := 'Holiday'
                        else
                            AttendanceText := 'Absent';

                        if "Week Off Day" = 1 then
                            AttendanceRemarks := "Holiday Remarks"
                        else if "Leave Day" = 1 then
                            AttendanceRemarks := StrSubstNo('%1 (%2)', "Leave Description", "Source No.")
                        else if "Source No." <> '' then
                            AttendanceRemarks := "Source No.";
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Attendance Date", StartDate, EndDate);
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetRange("No.", EmployeeNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if StartDate > EndDate then
                    Error('Start date cannnot be greater than end date.');
                if EndDate = 0D then
                    EndDate := Today;
                if EmployeeNo = '' then
                    Error('Employee must have value.');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(EmployeeNo; EmployeeNo)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmployeeNo field.';
                    ApplicationArea = All;
                }
                field("Start Date"; StartDate)
                {
                    ToolTip = 'Specifies the value of the StartDate field.';
                    ApplicationArea = All;
                }
                field("End Date"; EndDate)
                {
                    ToolTip = 'Specifies the value of the EndDate field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels
    {
        In_Time = 'In Time';
        OutTime = 'Out Time';
    }

    var
        AttendanceText: Text;
        AttendanceRemarks: Text;
        EnglishNepDate: Record "English-Nepali Date";
        AttendanceLog: Record "Attendance Log";
        StartDate: Date;
        EndDate: Date;
        EmployeeNo: Text;
        Title: Label 'Customized Detailed Attendance Report';
}
