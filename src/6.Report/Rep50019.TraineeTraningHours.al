report 50019 "Trainee Traning Hours"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019820.TraineeTraningHours.rdl';
    Caption = 'Trainee Traning Hours';
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            PrintOnlyIfDetail = true;
            dataitem("Training Attendance"; "Training Attendance")
            {
                DataItemLink = "Employee No." = field("No.");
                column(TrainingNo_TrainingAttendance; "Training Attendance"."Training No") { }
                column(EmployeeNo_TrainingAttendance; "Training Attendance"."Employee No.") { }
                column(AttendedDate_TrainingAttendance; "Training Attendance"."Attended Date") { }
                column(LineNo_TrainingAttendance; "Training Attendance"."Line No.") { }
                column(Hours; Hours) { }
                column(TrainingType; TrainingType) { }
                column(EmployeeName; EmployeeName) { }
                column(TotalHours; TotalHours) { }

                trigger OnAfterGetRecord()
                begin
                    Hours := 0;
                    TrainingType := '';
                    EmployeeName := '';
                    TotalHours := 0;
                    TrainingLine.Reset;
                    TrainingLine.SetRange("Training No.", "Training Attendance"."Training No");
                    TrainingLine.SetRange("Employee Code", "Training Attendance"."Employee No.");
                    if TrainingLine.FindFirst then begin
                        TrainingType := Format(TrainingLine."Training Type");
                        EmployeeName := TrainingLine."Employee Name";
                    end;

                    TrainingLine.Reset;
                    TrainingLine.SetRange("Training No.", "Training Attendance"."Training No");
                    if TrainingLine.FindFirst then
                        repeat
                            Hours += (TrainingLine."Total Hours") / 3600000;
                        until TrainingLine.Next = 0;

                    TrainingLine.Reset;
                    if TrainingLine.FindFirst then
                        repeat
                            TotalHours += (TrainingLine."Total Hours") / 3600000;
                        until TrainingLine.Next = 0;
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

    var
        TrainingLine: Record "Training Line";
        Hours: Decimal;
        TrainingType: Text;
        EmployeeName: Text;
        TotalHours: Decimal;
}
